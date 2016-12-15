{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, OverloadedStrings #-}

import Data.Monoid
import Control.Monad
import Control.Applicative
import qualified Data.Map as M
import System.Exit
import System.Posix.Signals
import XMonad hiding ((|||))
import XMonad.Layout.Spacing
import qualified XMonad.StackSet as W
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Actions.GridSelect
import XMonad.Layout.NoBorders
import XMonad.Hooks.UrgencyHook hiding (Never)
import System.Taffybar.Hooks.PagerHints (pagerHints)
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.ConfirmPrompt
import XMonad.Hooks.PerWindowKbdLayout
import XMonad.Util.NamedWindows
import XMonad.Actions.CopyWindow
import XMonad.Actions.Plane
import XMonad.Actions.SwapWorkspaces
import XMonad.Actions.WindowMenu
import Graphics.X11.ExtraTypes.XF86
import XMonad.Layout.DwmStyle
import XMonad.Layout.Minimize
import XMonad.Layout.Maximize
import XMonad.Layout.LayoutModifier
import XMonad.Actions.UpdatePointer
import XMonad.Layout.Grid
import XMonad.Layout.Named
import XMonad.Layout.LayoutCombinators
import XMonad.Util.Compton
import XMonad.Layout.Fullscreen
import XMonad.Hooks.InsertPosition
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.TrackFloating
import XMonad.Hooks.FadeInactive

myTerminal = "urxvt -e tmux"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myClickJustFocuses :: Bool
myClickJustFocuses = False

myBorderWidth = 1

myModMask = mod4Mask

myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

myNormalBorderColor = "gray"

myFocusedBorderColor = "black"

myXPConfig = def
  { position = Top
  , height = 25
  , bgColor = "black"
  , promptBorderWidth = 0
  , alwaysHighlight = True
  }

-- kill9 = spawn "kill -9 $(xdotool getactivewindow getwindowpid)"
kill9 = withFocused $ \w ->
  do p <- runQuery pid w
     whenJust p $ io . signalProcess 9

kill9Window w = spawn $ "kill -9 $(xdotool getwindowpid " ++ show w ++ ")"

decorateName' :: Window -> X String
decorateName' w = show <$> getName w

goToSelectedOnWorkspace gsConfig = do
  let keyValuePair w = flip (,) w `fmap` decorateName' w
  wins <- gets (W.index . windowset)
  when (length wins > 1) $ do
    namedWindows <- mapM keyValuePair wins
    maybeWindow <- gridselect gsConfig namedWindows
    case maybeWindow of
      Just window -> windows $ W.focusWindow window
      Nothing     -> return ()

myKeys conf@(XConfig { XMonad.modMask = modm }) = M.union (planeKeys modm (Lines 3) Linear) $ M.fromList $
  -- Launch terminal.
  [ ((modm, xK_r), spawn $ XMonad.terminal conf)
  -- Launch terminal.
  , ((modm .|. shiftMask, xK_r), spawn "urxvt")
  -- Launch mc.
  , ((modm, xK_e), spawn "urxvt -e tmux new-session mc")
  -- Launch application.
  , ((modm, xK_F2), shellPrompt myXPConfig)
  -- Close the focused window.
  , ((modm, xK_c), kill)
  -- Kill the focused window.
  , ((modm .|. shiftMask, xK_c), kill9)
  -- Rotate through the available layout algorithms.
  , ((modm, xK_space), sendMessage NextLayout)
  -- Reset the layouts on the current workspace to default.
  , ((modm .|. shiftMask, xK_space), (setLayout $ XMonad.layoutHook conf) >> docksStartupHook)
  -- Resize viewed windows to the correct size.
  , ((modm, xK_n), refresh)
  -- Move focus to the next window.
  , ((modm, xK_Tab), windows W.focusDown)
  -- Move focus to the previous window.
  , ((modm .|. shiftMask, xK_Tab), windows W.focusUp)
  -- Move focus to the master window.
  , ((modm, xK_Return), windows W.focusMaster)
  -- Swap the focused window and the master window.
  , ((modm .|. shiftMask, xK_Return), windows W.swapMaster)
  -- Swap the focused window with the previous window.
  , ((modm .|. controlMask, xK_comma), windows W.swapUp)
  -- Swap the focused window with the next window.
  , ((modm .|. controlMask, xK_period), windows W.swapDown)
  -- Shrink the master area.
  , ((modm, xK_comma), sendMessage Shrink)
  -- Expand the master area.
  , ((modm, xK_period), sendMessage Expand)
  -- Push window back into tiling.
  , ((modm, xK_t), withFocused $ windows . W.sink)
  -- Increment the number of windows in the master area.
  , ((modm .|. shiftMask, xK_comma), sendMessage (IncMasterN (-1)))
  -- Decrement the number of windows in the master area.
  , ((modm .|. shiftMask, xK_period), sendMessage (IncMasterN 1))
  -- Toggle the status bar gap.
  , ((modm, xK_b), sendMessage ToggleStruts)
  -- Select workspace.
  , ((modm, xK_z), gridselectWorkspace myGSConfig W.greedyView)
  -- Select window on current workspace.
  , ((modm, xK_x), goToSelectedOnWorkspace myGSConfig)
  -- Quit xmonad.
  , ((modm .|. shiftMask, xK_q), confirmPrompt myXPConfig "exit" $ io exitSuccess)
  -- Restart xmonad.
  , ((modm, xK_q), spawn "for pid in $(pgrep -u $(whoami) taffybar); do kill $pid; done; xmonad --recompile; xmonad --restart")
  -- Turn off screen.
  , ((modm, xK_F6), spawn "sleep 0.5; xset dpms force off")
  -- Focus urgent window (window with notification).
  , ((modm, xK_u), focusUrgent)
  -- Make focused window always visible.
  , ((modm, xK_v), windows copyToAll)
  -- Toggle window state back.
  , ((modm .|. shiftMask, xK_v), killAllOtherCopies)
  -- Increase monitor backlight level.
  , ((0, xF86XK_MonBrightnessUp), spawn "xbacklight -inc 10")
  -- Decrease monitor backlight level.
  , ((0, xF86XK_MonBrightnessDown), spawn "xbacklight -dec 10")
  -- Set monitor backlight level to maximum value.
  , ((shiftMask, xF86XK_MonBrightnessUp), spawn "xbacklight = 100")
  -- Set monitor backlight level to minimum value.
  , ((shiftMask, xF86XK_MonBrightnessDown), spawn "xbacklight = 1")
  -- dbus-send --dest=com.github.chjj.compton._0 / com.github.chjj.compton.win_set uint32:0x5a0000a string:invert_color_force uint16:1
  , ((modm, xK_i), withDisplay $ \dpy -> withFocused $ \w -> inversionStatus dpy w >>= invert dpy w . not)
  -- Invert colors.
  , ((modm .|. shiftMask, xK_i), spawn "xcalib -i -a")
  -- Clear invertions.
  , ((modm .|. controlMask .|. shiftMask, xK_i), spawn "xcalib -c")
  -- Open window menu.
  , ((modm, xK_o), windowMenu)
  -- Minimize focused window.
  , ((modm, xK_m), withFocused minimizeWindow)
  , ((modm .|. shiftMask, xK_m), sendMessage RestoreNextMinimizedWin)
  , ((modm, xK_w), withDisplay $ \dpy -> withFocused $ io . raiseWindow dpy)
  , ((modm, xK_f), sendMessage $ JumpToLayout "Full")
  , ((modm, xK_g), sendMessage $ JumpToLayout "Grid")
  , ((modm, xK_h), sendMessage $ JumpToLayout "Tiled")
  , ((modm, xK_j), sendMessage $ JumpToLayout "Mirror")
  , ((modm, xK_Escape), spawn "xscreensaver-command -lock")
  , ((0, xK_Print), spawn "maim ~/screenshot-$(date +%F-%T).png")
  , ((shiftMask, xK_Print), spawn "maim -i $(xdotool getactivewindow) ~/screenshot-$(date +%F-%T).png")
  , ((controlMask, xK_Print), spawn "maim -s -c 1,0,0,0.6 -p 10 ~/screenshot-$(date +%F-%T).png")
  ]
  ++
  [ ((m .|. modm, k), windows $ f i)
  | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
  , (f, m) <- -- mod-[1..9], Switch to workspace N.
              [ (W.greedyView, 0)
              -- mod-shift-[1..9], Move client to workspace N.
              , (W.shift, shiftMask)
              -- mod-ctrl-[1..9], Copy client to workspace N.
              , (copy, controlMask)
              -- mod-ctrl-shift-[1..9], Swap workspace with workspace N.
              , (swapWithCurrent, controlMask .|. shiftMask)
              ]
  ]
  ++
  [ ((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
  | (key, sc) <- zip [xK_a, xK_s, xK_d] [0..]
  , (f, m) <- -- mod-{a,s,d}, Switch to physical/Xinerama screens 1, 2, or 3.
              [ (W.view, 0)
              -- mod-shift-{a,s,d}, Move client to screen 1, 2, or 3.
              , (W.shift, shiftMask)
              ]
  ]

myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList
  -- Set the window to floating mode and move by dragging.
  [ ((modm, button1), \w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster)
  -- Close window.
  , ((modm, button2), killWindow)
  -- Kill window.
  , ((modm .|. shiftMask, button2), kill9Window)
  -- Set the window to floating mode and resize by dragging.
  , ((modm, button3), \w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster)
  -- Close window.
  , ((0, 8), killWindow)
  -- Open window menu.
  , ((0, 9), \w -> windows (W.focusWindow w) >> windowMenu)
  ]

data MyLayout a = MyLayout deriving (Read, Show)

instance LayoutModifier MyLayout a where
  modifyDescription _ l = drop 42 $ description l

myLayout = ModifiedLayout MyLayout $
  dwmStyle shrinkText defaultTheme $
  smartBorders $
  fullscreenFocus $
  smartSpacing 2 $
  avoidStruts $
  maximize $
  minimize $
  named "Tiled" tiled |||
  named "Mirror" (Mirror tiled) |||
  named "Grid" Grid |||
  named "Full" (trackFloating Full) where
    tiled   = Tall nmaster delta ratio
    nmaster = 1 -- The default number of windows in the master pane.
    ratio   = 1 / 2 -- Default proportion of screen occupied by master pane.
    delta   = 3 / 100 -- Percent of screen to increment by when resizing panes.

myManageHook = fullscreenManageHook <> manageDocks <> (fmap not isDialog --> insertPosition Master Newer) <> composeAll -- To find the property name associated with a program, use > xprop | grep WM_CLASS.
  [ className =? "kcalc" --> doFloat
  ]

myEventHook e = perWindowKbdLayout e <> fullscreenEventHook e <> docksEventHook e

myLogHook = do
  fadeInactiveLogHook 0.9
  updatePointer (0.5, 0.5) (0, 0)

myGSConfig :: HasColorizer a => GSConfig a
myGSConfig = defaultGSConfig
  { gs_cellheight = 200
  , gs_cellwidth = 400
  , gs_font = "xft:Sans-16"
  }

myStartupHook = do
  docksStartupHook
  spawn "setxkbmap -model pc101 -layout us,ru -option grp:caps_toggle -option grp:switch -option grp_led:caps -option lv3:ralt_switch"
  spawn "sleep 1; xmodmap ~/.Xmodmap"
  spawn "compton -b -f -I 0.10 -O 0.10 --backend glx --vsync opengl --dbus"
  spawn "feh --bg-fill ~/Images/pic-3909-1920x1200.jpg"
  spawn "taffybar"
  spawn "sleep 1; xscreensaver -no-splash"
  spawn "pgrep volumeicon; if [ $? -ne 0 ]; then volumeicon; fi"
  spawn "pgrep gnome-keyring; if [ $? -ne 0 ]; then gnome-keyring-daemon; fi"
  spawn "pgrep nm-applet; if [ $? -ne 0 ]; then nm-applet; fi"
  spawn "pgrep parcellite; if [ $? -ne 0 ]; then parcellite; fi"

myConfig = withUrgencyHook NoUrgencyHook $ ewmh $ pagerHints defaultConfig
  { terminal           = myTerminal
  , focusFollowsMouse  = myFocusFollowsMouse
  , clickJustFocuses   = myClickJustFocuses
  , borderWidth        = myBorderWidth
  , modMask            = myModMask
  , workspaces         = myWorkspaces
  , normalBorderColor  = myNormalBorderColor
  , focusedBorderColor = myFocusedBorderColor
  , keys               = myKeys
  , mouseBindings      = myMouseBindings
  , layoutHook         = myLayout
  , manageHook         = myManageHook
  , handleEventHook    = myEventHook
  , logHook            = myLogHook
  , startupHook        = myStartupHook
  }

main = xmonad myConfig
