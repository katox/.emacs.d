(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

;; Install these packages if missing in current installation
(defvar my-packages '(
               starter-kit
               starter-kit-bindings
               starter-kit-lisp
               starter-kit-eshell
               starter-kit-js
               clojure-mode
               clojure-test-mode
               cider
               cider-decompile
               clojure-cheatsheet
               clj-refactor
               datomic-snippets
               dash
               auto-complete
               ac-nrepl
               rainbow-delimiters
               buffer-move
               magit
               session
               markdown-mode
               ess
               yasnippet
               undo-tree
               projectile
               ack-and-a-half
               ))

; activate all the packages (in particular autoloads)
(package-initialize)

; fetch the list of packages available 
(unless package-archive-contents
  (package-refresh-contents))

; install the missing packages
(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;; Reset to terminal font
(setq terminal-font "Inconsolata-10")
(when window-system
  (add-to-list 'default-frame-alist (cons 'font terminal-font)))

;; display line numbers in buffers
(setq linum-format "%3d")
(global-linum-mode t)
(line-number-mode 1)
(column-number-mode 1)

;; Emacs prompts should accept "y" or "n" instead of the full word
(fset 'yes-or-no-p 'y-or-n-p)

;; Tab just 2 spaces
(setq-default tab-width 2)

;; No more Mr. Visual Bell Guy.
(setq visible-bell nil)

;; current line highlighting
;(global-hl-line-mode t)
(remove-hook 'prog-mode-hook 'esk-turn-on-hl-line-mode)                    ; Disable emacs-starter-kits line highlighting

;;(add-to-list 'ac-dictionary-directories "~/.emacs.d/dict")
(require 'auto-complete-config)
(ac-config-default)

;; Autocomplete after tab only
(setq ac-auto-start nil)
(ac-set-trigger-key "TAB")

;; Setup cider autocomplete via ac-nrepl (on tab autocompletion)
(require 'ac-nrepl)
(defun set-auto-complete-as-completion-at-point-function ()
  (setq completion-at-point-functions '(auto-complete)))
(add-hook 'auto-complete-mode-hook 'set-auto-complete-as-completion-at-point-function)
(add-hook 'cider-repl-mode-hook 'set-auto-complete-as-completion-at-point-function)
(add-hook 'cider-mode-hook 'set-auto-complete-as-completion-at-point-function)

;; Enable eldoc for cider
(add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)

;; Enable yasnippet
(require 'yasnippet)
(yas/global-mode 1)
(yas/load-directory "~/.emacs.d/snippets")


;; No cider popup to new buffers and display stacktraces inline
;(setq cider-popup-on-error nil)
;(setq cider-popup-stacktraces-in-repl t)

;; clojure mode addons
(require 'clj-refactor)
(add-hook 'clojure-mode-hook (lambda ()
                               (clj-refactor-mode 1)
                               ;; insert keybinding setup here
                               (cljr-add-keybindings-with-prefix "C-c C-o")))

;; Hide *nrepl-connection* and *nrepl-server* from switch-buffer
(setq nrepl-hide-special-buffers t)

;; Remap C-z to repl switch
(eval-after-load "cider"
  '(define-key cider-mode-map (kbd "C-z") 'cider-switch-to-relevant-repl-buffer))

;; Associate ClojureScript, cljx and edn files with clojure-mode
(add-to-list 'auto-mode-alist '("\.edn$" . clojure-mode))
(add-to-list 'auto-mode-alist '("\.cljx$" . clojure-mode))
(add-to-list 'auto-mode-alist '("\.cljs$" . clojure-mode))

;; Enable rainbow parens
(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; Winner mode and buffer-move
(when (fboundp 'winner-mode)
  (winner-mode 1))
(global-set-key (kbd "<C-S-up>")     'buf-move-up)
(global-set-key (kbd "<C-S-down>")   'buf-move-down)
(global-set-key (kbd "<C-S-left>")   'buf-move-left)
(global-set-key (kbd "<C-S-right>")  'buf-move-right)

;; Quickly navigate projects using Projectile (C-c p C-h for available commands)
(projectile-global-mode)                                                   
(setq projectile-show-paths-function 'projectile-hashify-with-relative-paths)

;; Persistent session
(require 'session)
(add-hook 'after-init-hook 'session-initialize)

;; Zap spaces (C-M-z)
(defun delete-horizontal-space-forward () ; adapted from `delete-horizontal-space'
  "*Delete all spaces and tabs after point."
  (interactive "*")
  (delete-region (point) (progn (skip-chars-forward " \t") (point))))
(define-key (current-global-map) (kbd "C-M-z") 'delete-horizontal-space-forward)

;; Join lines (C-S-j)
(defun join-lines (arg)
  (interactive "p")
  (end-of-line)
  (delete-char 1)
  (delete-horizontal-space)
  (insert " "))
(define-key (current-global-map) (kbd "C-S-j") 'join-lines)

;; Set *scratch* to empty and turn on Clojure mode
(setq initial-scratch-message nil)
(when (locate-library "clojure-mode")
  (setq initial-major-mode 'clojure-mode))

;; Enable ESS
(require 'ess-site)

;; Dark colors
(load-theme 'deeper-blue)

;; Remap suspend/iconify key binding to undo
(global-set-key (kbd "C-z") nil)

;; reload files from disk
(global-auto-revert-mode t)

;; i3 wm integration
;(require 'i3)
;(require 'i3-integration)
;(i3-one-window-per-frame-mode-on)
;(i3-advise-visible-frame-list-on)

;; Emacs server for emacsclient
(server-start)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("1f3304214265481c56341bcee387ef1abb684e4efbccebca0e120be7b1a13589" default)))
 '(session-use-package t nil (session)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
