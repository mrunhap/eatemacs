;;; -*- lexical-binding: t -*-

;; for customize
(setq-default
  ;; font
 *font* "Operator Mono SSm Lig"
 *font-cn* "WenQuanYi Micro Hei"
 *font-unicode* "Apple Color Emoji"
 *font-height* (cond ((eq system-type 'darwin) 130)
                     (t 110))
 ;; nano-light nano-dark etc
 footheme 'nano-light)

;; (add-hook 'prog-mode-hook 'display-line-numbers-mode)
;; (add-hook 'conf-mode-hook 'display-line-numbers-mode)
(add-hook 'prog-mode-hook 'hl-line-mode)
(add-hook 'conf-mode-hook 'hl-line-mode)
(add-hook 'prog-mode-hook 'subword-mode)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'after-init-hook 'save-place-mode)
(add-hook 'prog-mode-hook 'hs-minor-mode)
(add-hook 'after-init-hook 'global-auto-revert-mode)
(add-hook 'after-init-hook 'global-so-long-mode)
(add-hook 'after-init-hook 'winner-mode)
(add-hook 'after-init-hook 'electric-pair-mode)
(add-hook 'after-init-hook 'show-paren-mode)
(add-hook 'after-init-hook 'repeat-mode)

(defun +reopen-file-with-sudo ()
  (interactive)
  (find-alternate-file (format "/sudo::%s" (buffer-file-name))))

(global-set-key (kbd "C-x C-z") #'+reopen-file-with-sudo)
;; use mouse left click to find definitions
(global-unset-key (kbd "C-<down-mouse-1>"))
(global-set-key (kbd "C-<mouse-1>") #'xref-find-definitions-at-mouse)
;; ibuffer
(global-unset-key (kbd "C-x C-b"))
(global-set-key (kbd "C-x C-b") 'ibuffer)
;;; project.el use C-x p
(global-unset-key (kbd "C-x C-p"))
(global-set-key (kbd "C-x C-d") #'dired)

(setq-default
 ;; Close up of MacOs
 ring-bell-function 'ignore
 ;; no start messages
 inhibit-startup-message t
 ;; don't read x resource file
 inhibit-x-resources t
 ;; no welcome screen
 inhibit-splash-screen t
 inhibit-startup-screen t
 ;; no startup messages
 inhibit-startup-echo-area-message t
 frame-inhibit-implied-resize t
 initial-scratch-message ""
 hl-line-sticky-flag nil
 ;; Don't create lockfiles
 create-lockfiles nil
 ;; UTF-8
 buffer-file-coding-system 'utf-8-unix
 default-file-name-coding-system 'utf-8-unix
 default-keyboard-coding-system 'utf-8-unix
 default-process-coding-system '(utf-8-unix . utf-8-unix)
 default-sendmail-coding-system 'utf-8-unix
 default-terminal-coding-system 'utf-8-unix
 ;; add final newline
 require-final-newline t
 ;; Disable auto save and backup
 make-backup-files nil
 auto-save-default nil
 auto-save-list-file-prefix nil
 ;; Xref no prompt
 xref-prompt-for-identifier nil
 ;; Mouse yank at point instead of click position.
 mouse-yank-at-point t
 ;; This fix the cursor movement lag
 auto-window-vscroll nil
 tab-width 4
 ;; Don't show cursor in non selected window.
 cursor-in-non-selected-windows nil
 comment-empty-lines t
 visible-cursor t
 ;; Window divider setup
 window-divider-default-right-width 1
 window-divider-default-bottom-width 0
 window-divider-default-places t
 ;; allow resize by pixels
 frame-resize-pixelwise t
 x-gtk-resize-child-frames nil
 x-underline-at-descent-line t
 ;; Improve long line display performance
 bidi-inhibit-bpa t
 bidi-paragraph-direction 'left-to-right
 ;; don't wait for keystrokes display
 echo-keystrokes 0.01
 show-paren-style 'parenthese
 ;; indent with whitespace by default
 indent-tabs-mode nil
 read-process-output-max (* 1024 1024)
 ;; Default line number width.
 display-line-numbers-width 3
 ;; Don't use Fcitx5 in Emacs in PGTK build
 pgtk-use-im-context-on-new-connection nil
 ;; Don't display compile warnings
 warning-suppress-log-types '((comp))
 ;; Don't truncate lines in a window narrower than 65 chars.
 truncate-partial-width-windows 65
 ;; always follow link
 vc-follow-symlinks t
 ;; tab bar
 tab-bar-show nil
 tab-bar-new-tab-choice "*scratch*"
 ;; Vertical Scroll
 scroll-step 1
 scroll-margin 15
 scroll-conservatively 101
 scroll-up-aggressively 0.01
 scroll-down-aggressively 0.01
 auto-window-vscroll nil
 fast-but-imprecise-scrolling nil
 mouse-wheel-scroll-amount '(1 ((shift) . 1))
 mouse-wheel-progressive-speed nil
 ;; Horizontal Scroll
 hscroll-step 1
 hscroll-margin 10
 ;; no client startup messages
 server-client-instructions nil
 ;; install hunspell and hunspell-en_US
 ispell-dictionary "en_US"
 ispell-program-name "hunspell"
 ispell-personal-dictionary (expand-file-name ".hunspell_dict.txt" user-emacs-directory)
 ;; custom file
 custom-file (expand-file-name "custom.el" user-emacs-directory)
 ;; electric-pair-mode
 electric-pair-inhibit-predicate 'electric-pair-conservative-inhibit
 ;; show-paren-mode
 show-paren-when-point-in-periphery t
 show-paren-when-point-inside-paren t
 ;; yse-or-no -> y-or-n
 use-short-answers t
 ;; prefer horizental split
 split-height-threshold nil
 split-width-threshold 120)

(provide 'init-core)