;;; -*- lexical-binding: t -*-

;; Optimization
(setq idle-update-delay 1.0)

(setq-default cursor-in-non-selected-windows nil)
(setq highlight-nonselected-windows nil)

(setq fast-but-imprecise-scrolling t)
(setq redisplay-skip-fontification-on-input t)

;; Suppress GUI features and more
(setq use-file-dialog nil
      use-dialog-box nil
      inhibit-splash-screen t
      inhibit-x-resources t
      inhibit-default-init t
      inhibit-startup-screen t
      inhibit-startup-message t
      inhibit-startup-buffer-menu t)

;; Pixelwise resize
(setq window-resize-pixelwise t
      frame-resize-pixelwise t)

(with-no-warnings
  (when sys/macp
    ;; Render thinner fonts
    (setq ns-use-thin-smoothing t)
    ;; Don't open a file in a new frame
    (setq ns-pop-up-frames nil)))

;; Don't use GTK+ tooltip
(when (boundp 'x-gtk-use-system-tooltips)
  (setq x-gtk-use-system-tooltips nil))

;; Linux specific
(setq x-underline-at-descent-line t)

(eat-package less-theme
  :straight (less-theme :type git :host github :repo "nobiot/less-theme"))

(eat-package rainbow-mode
  :straight t
  :commands rainbow-mode)

(eat-package nano-theme
  :init
  (setq nano-theme-light/dark 'light
        nano-theme-comment-italic nil
        nano-theme-keyword-italic nil
        nano-theme-system-appearance t))

(eat-package doom-themes
  :straight t
  :init
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t
        doom-themes-padded-modeline t
        doom-spacegrey-brighter-comments t
        doom-spacegrey-brighter-modeline t
        doom-spacegrey-comment-bg t)
  :config
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

(eat-package spacemacs-theme
  :straight t
  :init
  (setq spacemacs-theme-comment-italic t
        spacemacs-theme-keyword-italic t
        spacemacs-theme-org-agenda-height t
        spacemacs-theme-org-bold t
        spacemacs-theme-org-height t
        spacemacs-theme-org-highlight t
        spacemacs-theme-org-priority-bold t
        spacemacs-theme-org-bold t
        spacemacs-theme-underline-parens t))

(eat-package modus-themes
  :straight t
  :init
  (setq modus-themes-slanted-constructs t
        modus-themes-bold-constructs t
        modus-themes-syntax 'green-strings
        modus-themes-no-mixed-fonts t
        modus-themes-paren-match 'intense-bold))

(eat-package kaolin-themes
  :straight t
  :init
  (setq kaolin-themes-underline-wave nil
        kaolin-themes-modeline-border nil
        kaolin-themes-modeline-padded 4))

;; Nice window divider
(set-display-table-slot standard-display-table
                        'vertical-border
                        (make-glyph-code ?┃))

;; TODO different state use different face
(defface +modeline-meow-face
  '((((background light))
     :foreground "#00aca9" :bold t)
    (t
     :foreground "#00ced1" :bold t))
  "Face for meow state.")

(defface +modeline-path-face
  '((((background light))
     :foreground "#ac00ac" :italic t)
    (t
     :foreground "#cd96cd" :italic t))
  "Face for file path.")

(defface +modeline-vc-face
  '((((background light))
     :foreground "#de0279" :bold t)
    (t
     :foreground "#ee6aa7" :bold t))
  "Face for VCS info.")

(defface +modeline-location-face
  '((((background light))
     :foreground "#767676" :bold t)
    (t
     :foreground "#999999" :bold t))
  "Face for location.")

(defface +modeline-mode-face
  '((((background light))
     :foreground "#4a7600")
    (t
     :foreground "#96d21e"))
  "Face for major mode info.")

;; TODO show window message or eyebrowse, change all other to right side
;; TODO add paded to :eval
;; TODO use diff face in active modeline and deactive modeline
(defun +format-mode-line ()
  ;; TODO use -*-FZSuXinShiLiuKaiS-R-GB-normal-normal-normal-*-*-*-*-*-p-0-iso10646-1
  ;; to show flymake or flycheck errors count in mode line
  (let* ((lhs '((:eval (meow-indicator))
                (:eval (rime-lighter))
                " Row %l Col %C %%p"
                ;; use 危
                ;; (:eval (when (bound-and-true-p flymake-mode)
                ;;          flymake-mode-line-format))
                ))
         (rhs '((:eval (+smart-file-name-cached))
                " "
                (:eval mode-name)
                (vc-mode vc-mode)))
         (ww (window-width))
         (lhs-str (format-mode-line lhs))
         (rhs-str (format-mode-line rhs))
         (rhs-w (string-width rhs-str)))
    (format "%s%s%s"
            lhs-str
            (propertize " " 'display `((space :align-to (- (+ right right-fringe right-margin) (+ 1 ,rhs-w)))))
            rhs-str)))

(setq-default header-line-format nil)

(defun +init-ui (&optional frame)
  (if +use-header-line
      (setq-default
       mode-line-format nil
       header-line-format '(:eval (+format-mode-line)))
    (setq-default mode-line-format '(:eval (+format-mode-line))))

  (when (not (display-graphic-p))
    (load-theme +theme-tui t))

  (when (display-graphic-p)
    (load-theme +theme t)

    (eat-package cnfonts
      :straight t
      :init
      (setq cnfonts-use-face-font-rescale t)
      (setq cnfonts-personal-fontnames '(("Monaco")("FZSuXinShiLiuKaiS-R-GB")()))
      ;; Auto generated by cnfonts
      ;; <https://github.com/tumashu/cnfonts>
      (set-face-attribute
       'default nil
       :font (font-spec :name "-*-Monaco-normal-normal-normal-*-*-*-*-*-m-0-iso10646-1"
                        :weight 'normal
                        :slant 'normal
                        :size 14.0))
      (dolist (charset '(kana han symbol cjk-misc bopomofo))
        (set-fontset-font
         (frame-parameter nil 'font)
         charset
         (font-spec :name "FZSuXinShiLiuKaiS-R-GB"
                    :weight 'normal
                    :slant 'normal
                    :size 16.5))))
    (set-fontset-font t 'unicode +font-unicode nil 'prepend)
    (set-fontset-font t 'symbol (font-spec :family +font-unicode) frame 'prepend)
    (set-face-attribute 'variable-pitch frame :font +font-variable-pitch :height +font-height)
    ;; HACK use cnfongs
    ;; (set-face-attribute 'default frame :font +font :height +font-height)
    ;; (set-fontset-font t '(#x4e00 . #x9fff) +font-cn)
    ;; (set-frame-font +font nil (if frame (list frame) t))
    ;; (set-face-attribute 'fixed-pitch frame :font +font :height +font-height)

    (eat-package ligature
      :straight (ligature :type git :host github :repo "mickeynp/ligature.el")
      :require t
      :config
      (global-ligature-mode)
      ;; https://htmlpreview.github.io/?https://github.com/kiliman/operator-mono-lig/blob/master/images/preview/normal/index.html
      (ligature-set-ligatures 'prog-mode
                              '("&&" "||" "|>" ":=" "==" "===" "==>" "=>"
                                "=<<" "!=" "!==" ">=" ">=>" ">>=" "->" "--"
                                "-->" "<|" "<=" "<==" "<=>" "<=<" "<!--" "<-"
                                "<->" "<--" "</" "+=" "++" "??" "/>" "__" "WWW")))))

(defun +reload-ui-in-daemon (frame)
  "Reload the modeline and font in an daemon frame."
  (with-selected-frame frame
    (+init-ui frame)))

;; Load the modeline and fonts
(if (daemonp)
    (add-hook 'after-make-frame-functions #'+reload-ui-in-daemon)
  (+init-ui))

(provide 'init-ui)
