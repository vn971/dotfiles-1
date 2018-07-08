quiet

name mpv

caps.drop all
net none
netfilter
nogroups
nonewprivs
noroot
protocol unix
seccomp
shell none

private-bin mpv,xdg-screensaver,sh,bash,sed,hostname,echo,grep,xset,xscreensaver-command
private-dev
private-etc mpv,fonts,pulse
private-tmp

include ~/.config/firejail/mem/1G.inc

blacklist ~/.ssh
read-only ~
