;; Hotkeys (C = ctrl, M = alt, S = shift):
;; C-h k - see commant binded to hotkey.
;; C-h v - info about variable.
;; C-h f - info about function.
;; C-h a - search by all variables.
;; C-x b - switch buffer.
;; C-x o - switch frame.
;; C-x k - kill buffer.
;; C-x 0 - close buffer.
;; C-x C-e - run lisp command.
;; C-home - go to beginning of buffer.
;; C-end - go to ending of buffer.
;; C-f C-w - find the word after cursor.

;; ========== Configure emacs ==========

;; Remove gap in maximized window mode.
(setq frame-resize-pixelwise t)
;; Start in maximized window mode.
(toggle-frame-maximized)
;; Disable tool bar.
(tool-bar-mode -1)
;; Don't do backup files.
(setq make-backup-files nil)
;; Don't save discarded files.
(setq auto-save-default nil)
;; Inhibit startup/splash screen.
(setq inhibit-splash-screen t)
;; Cursor as line.
(setq-default cursor-type 'bar)
;; Turn on auto tabing.
(electric-indent-mode t)
;; Don't use tabs for tabing.
(setq-default indent-tabs-mode nil)
;; Turn on parens auto closing.
(electric-pair-mode 1)
;; Cua mode.
(cua-mode t)
;; Disable dialog boxes.
(setq use-dialog-box nil)
;; Show clock.
(display-time-mode t)
;; 24 hours time format.
(setq display-time-24hr-format t)
;; Minimum shown number of lines before and after cursor.
(setq scroll-margin 2)
;; Don't jump when scrolling.
(setq scroll-conservatively 10000)
;; Select expression between parens.
(show-paren-mode t)
(setq show-paren-style 'expression)
;; Don't show scratch message.
(setq initial-scratch-message nil)
;; File size in percents.
(size-indication-mode t)
;; Short messages.
(defalias 'yes-or-no-p 'y-or-n-p)
;; Add new line at the end of file if it doesn't exist.
(setq require-final-newline t)
;; Easy transition between buffers: M-arrow-keys.
(windmove-default-keybindings 'meta)
;; Don't show cursor in inactive buffers.
(setq-default cursor-in-non-selected-windows nil)
;; Lisp indent - 2 spaces.
(setq lisp-indent-offset 2)
;; JS indent - 2 spaces.
(setq js-indent-level 2)
;; Enable scroll while searching.
(setq isearch-allow-scroll t)
;; File to write custom-set-variables. TODO: create if it doesn't exist.
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;; ========== Install packages ==========

;; List of necessary packages.
(setq package-list '(use-package
                      projectile
                      haskell-mode
                      undo-tree
                      sr-speedbar
                      projectile-speedbar
                      yasnippet
                      jdee
                      rust-mode
                      racer
                      company
                      magit
                      helm
                      ghc))
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
;; Activate all the packages (in particular autoloads).
(package-initialize)
;; Fetch the list of packages available.
(unless package-archive-contents
  (package-refresh-contents))
;; Install the missing packages.
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

;; ========== Configure plugins ==========

;; Use package - lazy plugins loading.
(require 'use-package)
(setq use-package-always-ensure t)

;; Dark theme.
;; (use-package darcula-theme)
(use-package atom-one-dark-theme)

;; Linum - line numbers (default).
(use-package linum
  :config
  (line-number-mode t)
  (column-number-mode t)
  (global-linum-mode t))

;; Ido - smart file chosing (default).
(use-package ido
  :bind ("C-o" . ido-find-file)
  :config
  (ido-mode t)
  (setq ido-everywhere t)
  (setq ido-enable-flex-matching t))

;; Buffer switcher (default).
(use-package bs
  :bind ("<f2>" . bs-show))

;; Speedbar (default).
(use-package speedbar
  :defer t
  :config
  (setq speedbar-show-unknown-files t))

;; Cedet (default).
(require 'cedet)
(require 'semantic/ia)
(require 'semantic/bovine/gcc)
(require 'ede/generic)
(add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-mru-bookmark-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-highlight-func-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-decoration-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-local-symbol-highlight-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-completions-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode)
(semantic-mode t)
(global-ede-mode t)

;; Tramp (default).
(use-package tramp
  :defer t
  :config
  (setq tramp-default-method "ssh"))

;; Smex - smart M-x command line.
(use-package smex
  :bind (("M-x" . smex)
          ("M-X" . smex-major-mode-commands)
          ("C-c M-x" . execute-extended-command)) ;; This is old M-x. TODO: to init
  :config
  (smex-initialize))

(use-package ag
  :defer t)

;; Anzu - smart find.
(use-package anzu
  :demand t
  :bind (([remap query-replace] . anzu-query-replace)
          ([remap query-replace-regexp] . anzu-query-replace-regexp))
  :config
  (global-anzu-mode t))

;; Smart mode line.
(use-package smart-mode-line
  :config
  (setq sml/no-confirm-load-theme t)
  (sml/setup))

;; Projectile - project management.
(require 'projectile)
(projectile-global-mode)
(define-key projectile-mode-map (kbd "C-p f") 'projectile-find-file)
(define-key projectile-mode-map (kbd "C-p o") 'projectile-find-file)
(define-key projectile-mode-map (kbd "C-p g") 'projectile-ag)
(define-key projectile-mode-map (kbd "C-p G") 'projectile-grep)

;; Autocomplete.
(use-package auto-complete
  :config
  (ac-config-default)
  (ac-linum-workaround))

;; Multiple cursors.
(use-package multiple-cursors-core
  :ensure multiple-cursors
  :bind (("C-S-b" . mc/edit-lines)
          ("C-S-<mouse-1>" . mc/add-cursor-on-click)
          :map mc/keymap
          ("C-S-b" . mc/keyboard-quit)))

;; Undo tree.
(use-package undo-tree
  :demand t
  :bind (:map undo-tree-map
          ([remap undo] . undo-tree-undo)
          ([remap undo-only] . undo-tree-undo)
          ("C-S-z" . undo-tree-redo)
          ("C-y" . undo-tree-redo))
  :init
  (setq undo-tree-map (make-sparse-keymap))
  :config
  (global-undo-tree-mode)
  (setq undo-tree-enable-undo-in-region nil)
  (defun undo-tree-overridden-undo-bindings-p () nil))
;; (define-key undo-tree-map (kbd "\C-x u") 'undo-tree-visualize)

;; Sr speedbar - speedbar in the current frame.
(require 'helm)
(require 'sr-speedbar)
(setq sr-speedbar-right-side t)
(setq sr-speedbar-auto-refresh nil)
(global-set-key (kbd "M-S-<f2>") 'sr-speedbar-close)

;; Projectile speedbar.
(use-package projectile-speedbar
  :bind ("M-<f2>" . projectile-speedbar-open-current-buffer-in-tree))

;; Yasnippet.
(require 'yasnippet)

;; Magit.
(require 'magit)

;; Scala mode.
(use-package scala-mode
  :mode ("\\.scala\\'" . scala-mode)
  :interpreter ("scala" . scala-mode)
  :config
  (defun right-arrow ()
    (interactive)
    (cond ((looking-back "=")
            (backward-delete-char 1) (insert "⇒"))
      ((looking-back "-")
        (backward-delete-char 1) (insert "→"))
      (t (insert ">"))))
  (defun left-arrow ()
    (interactive)
    (if (looking-back "<") 
      (progn (backward-delete-char 1)
        (insert "←"))
      (insert "-")))
  (add-hook 'scala-mode-hook '(lambda ()
                                (local-set-key (kbd "-") 'left-arrow)
                                (local-set-key (kbd ">") 'right-arrow))))

;; Sbt mode.
(use-package sbt-mode
  :commands sbt-start sbt-command
  :config
  ;; WORKAROUND: https://github.com/ensime/emacs-sbt-mode/issues/31
  ;; allows using SPACE when in the minibuffer
  (substitute-key-definition
    'minibuffer-complete-word
    'self-insert-command
    minibuffer-local-completion-map))

;; Ensime.
(use-package ensime
  :bind (:map ensime-mode-map
          ("C-l e" . ensime-print-errors-at-point)
          ("C-l t" . ensime-inspect-type-at-point)
          ("C-l u" . ensime-show-uses-of-symbol-at-point)
          ("C-l f" . ensime-search)
          ("C-l b" . ensime-sbt-do-compile)
          ("C-l r" . ensime-sbt-do-run)
          ("C-l i" . ensime-import-type-at-point))
  :config
  (setq ensime-ac-enable-argument-placeholders -1)
  (setq ensime-ac-override-settings -1)
  (add-hook 'ensime-mode-hook (lambda () (auto-complete-mode -1))))

;; Haskell mode.
(require 'haskell-mode)
(add-hook 'haskell-mode-hook 'haskell-indentation-mode)

(require 'ghc)
(add-hook 'haskell-mode-hook 'ghc-init)

;; Jdee - java mode.
(require 'jdee)

;; Company mode.
(require 'company)
(setq company-tooltip-align-annotations t)
(define-key company-mode-map (kbd "TAB") 'company-indent-or-complete-common)

(require 'eldoc)
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)

;; Rust mode.
(require 'rust-mode)
(setq rust-indent-offset 2)

;; Racer.
(require 'racer)
(setq racer-cmd "/bin/racer")
(setq racer-rust-src-path "~/rust-nightly-src/src")
(add-hook 'rust-mode-hook 'racer-mode)
(add-hook 'racer-mode-hook 'eldoc-mode)
(add-hook 'racer-mode-hook 'company-mode)

;; Agda.
(when (executable-find "agda-mode")
  (load-file (let ((coding-system-for-read 'utf-8))
               (shell-command-to-string "agda-mode locate")))
  (custom-set-faces
    '(agda2-highlight-bound-variable-face ((t (:foreground "violet"))))
    '(agda2-highlight-coinductive-constructor-face ((t (:foreground "green"))))
    '(agda2-highlight-datatype-face ((t (:foreground "#0087ff"))))
    '(agda2-highlight-dotted-face ((t (:foreground "violet"))))
    '(agda2-highlight-field-face ((t (:foreground "orange red"))))
    '(agda2-highlight-function-face ((t (:foreground "orange red"))))
    '(agda2-highlight-inductive-constructor-face ((t (:foreground "green"))))
    '(agda2-highlight-keyword-face ((t (:foreground "orange"))))
    '(agda2-highlight-module-face ((t (:foreground "brightgreen"))))
    '(agda2-highlight-number-face ((t (:foreground "brightgreen"))))
    '(agda2-highlight-postulate-face ((t (:foreground "cyan"))))
    '(agda2-highlight-primitive-face ((t (:foreground "#0087ff"))))
    '(agda2-highlight-primitive-type-face ((t (:foreground "#0087ff"))))
    '(agda2-highlight-record-face ((t (:foreground "#0087ff"))))
    '(agda2-highlight-string-face ((t (:foreground "brightred"))))
    '(agda2-highlight-symbol-face ((t (:foreground "brightblue"))))
    '(custom-themed ((t (:background "blue1" :foreground "white"))))))

;; ========== Key bindings ==========

;; Function for create new empty buffer.
(defun new-empty-buffer ()
  "Create a new empty buffer."
  (interactive)
  (let ((buffer (generate-new-buffer "untitled")))
    (switch-to-buffer buffer)
    (funcall (and initial-major-mode))
    (setq buffer-offer-save t)))
;; Functions for pane switching.
(defun move-cursor-next-pane ()
  "Move cursor to the next pane."
  (interactive)
  (other-window 1))
(defun move-cursor-previous-pane ()
  "Move cursor to the previous pane."
  (interactive)
  (other-window -1))
;; Search from beginning of document.
(defun isearch-forward-from-begin ()
  "Search from beginning of document."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (isearch-forward)))
;; Go to line beginning.
(defun back-to-indentation-or-beginning ()
  (interactive "^")
  (if (= (point) (progn (back-to-indentation) (point)))
    (beginning-of-line)))
;; Go to line ending.
(defun point-in-comment ()
  "Determine if the point is inside a comment"
  (interactive)
  (let ((syn (syntax-ppss)))
    (and (nth 8 syn)
      (not (nth 3 syn)))))
(defun end-of-code-or-line (arg)
  "Move to end of line, or before start of comments depending on situation.
Toggle back and forth positions if we are already at one.
Comments are recognized in any mode that sets syntax-ppss
properly."
  (interactive "^P")
  (when (catch 'bol 
          (let ((start (point))
                 (bol (save-excursion
                        (beginning-of-line)
                        (point)))
                 (eol (progn (move-end-of-line arg) (point))))
            (while (point-in-comment)
              (backward-char)
              (when (= (point) bol)
                (throw 'bol t)))
            (skip-chars-backward " \t")
            (throw 'bol (and (not (= eol start)) (>= start (point))))))
    (move-end-of-line arg)))
;; Comment block or line.
(defun comment-or-uncomment-region-or-line ()
  "Comments or uncomments the region or the current line if there's no active region."
  (interactive)
  (let (beg end)
    (if (region-active-p)
      (setq beg (region-beginning) end (region-end))
      (setq beg (line-beginning-position) end (line-end-position)))
    (comment-or-uncomment-region beg end)
    (next-line)))
;; Key bindings.
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "C-f") 'isearch-forward)
(define-key isearch-mode-map (kbd "C-f") 'isearch-repeat-forward)
(global-set-key (kbd "C-S-f") 'isearch-backward)
(define-key isearch-mode-map (kbd "C-S-f") 'isearch-repeat-backward)
(global-set-key (kbd "C-r") 'query-replace)
(global-set-key (kbd "C-n") 'new-empty-buffer)
(global-set-key (kbd "C-s") 'save-buffer)
(global-set-key (kbd "C-z") 'undo)
(global-set-key (kbd "C-a") 'mark-whole-buffer)
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-,") 'move-cursor-previous-pane)
(global-set-key (kbd "C-.") 'move-cursor-next-pane)
(global-set-key (kbd "<home>") 'back-to-indentation-or-beginning)
(global-set-key (kbd "<end>") 'end-of-code-or-line)
(global-set-key (kbd "C-/") 'comment-or-uncomment-region-or-line)
(global-set-key (kbd "C-k") 'kill-buffer)

;; Cx0 = ???, C|-
;; clone-indirect-buffer
;; C-g magit blame
;; undo tree show

;;https://stackoverflow.com/questions/4918707/in-emacs-how-to-go-back-to-previous-line-position-after-using-semantic-jump-to
;; pop-global-mark
;; C-x C-x (exchange-point-and-mark)

;; shell-command
;; shell

;; ========== Startup actions ==========

;; Kill scratch buffer.
(kill-buffer "*scratch*")