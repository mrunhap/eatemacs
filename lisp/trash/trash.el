;; `consult-imenu' + `embark-export' can replace this
(eat-package imenu-list
  :straight t
  :hook
  (imenu-list-major-mode-hook . (lambda ()
                                  (setq-local header-line-format nil)))
  :init
  (defun +imenu-scale-font-size ()
    (face-remap-add-relative 'default :height 0.8))
  (add-hook 'imenu-list-major-mode-hook #'+imenu-scale-font-size)
  (setq imenu-list-auto-resize t
        imenu-list-mode-line-format nil)

  (global-set-key (kbd "C-.") #'imenu-list-smart-toggle))

;; some times it's just not work
(eat-package insert-translated-name
  :straight (insert-translated-name :type git
                                    :host github
                                    :repo "manateelazycat/insert-translated-name")
  :commands insert-translated-name-insert
  :init
  (global-set-key (kbd "C-c i") 'insert-translated-name-insert))

;; maybe it will return to my config
(eat-package elisp-demos
  :straight t
  :init
  (advice-add 'describe-function-1 :after #'elisp-demos-advice-describe-function-1)
  (advice-add 'helpful-update :after #'elisp-demos-advice-helpful-update))

;; for now, `fanyi' works well, maybe need this where there is no network
(eat-package sdcv
  :straight (sdcv :type git :host github :repo "manateelazycat/sdcv")
  :commands
  sdcv-search-pointer
  sdcv-search-pointer+
  sdcv-search-input
  sdcv-search-input+
  :init
  (setq sdcv-dictionary-data-dir (file-truename "~/.sdcv-dict")
        sdcv-dictionary-simple-list
        '("懒虫简明英汉词典"
          "懒虫简明汉英词典"
          "KDic11万英汉词典")
        sdcv-dictionary-complete-list
        '("懒虫简明英汉词典"
          "英汉汉英专业词典"
          "XDICT英汉辞典"
          "stardict1.3英汉辞典"
          "WordNet"
          "XDICT汉英辞典"
          "懒虫简明汉英词典"
          "新世纪英汉科技大词典"
          "KDic11万英汉词典"
          "朗道汉英字典5.0"
          "CDICT5英汉辞典"
          "新世纪汉英科技大词典"
          "牛津英汉双解美化版"
          "21世纪双语科技词典"
          "quick_eng-zh_CN"))
  (defun sdcv-dwim (word)
    "Translate WORD."
    (interactive (let* ((default (if (use-region-p)
                                     (buffer-substring-no-properties (region-beginning) (region-end))
                                   (thing-at-point 'word t)))
                        (prompt (if (stringp default)
                                    (format "Search Word (default \"%s\"): " default)
                                  "Search Word: ")))
                   (list (read-string prompt nil nil default))))
    (sdcv-search-input word))
  (global-set-key (kbd "C-c Y") #'sdcv-dwim))

;; limit eldoc line num
(eat-package eldoc-overlay :straight t)

(eat-package turbo-log
  :straight (turbo-log :host github :repo "artawower/turbo-log.el")
  :init
  (global-set-key (kbd "C-s-h") #'turbo-log-print-immediately)
  (global-set-key (kbd "C-s-g") #'turbo-log-delete-all-logs))

(eat-package ibuffer-project
  :straight t
  :init
  ;; use `ibuffer-project-clear-cache' to clear cache
  (setq ibuffer-project-use-cache t)
  (custom-set-variables
   '(ibuffer-formats
     '((mark modified read-only locked " "
             (name 18 18 :left :elide)
             " "
             (size 9 -1 :right)
             " "
             (mode 16 16 :left :elide)
             " " project-file-relative))))
  (add-hook 'ibuffer-hook
            (lambda ()
              (setq ibuffer-filter-groups (ibuffer-project-generate-filter-groups))
              (unless (eq ibuffer-sorting-mode 'project-file-relative)
                (ibuffer-do-sort-by-project-file-relative))))
  :config
  ;; In this case all remote buffers will be grouped by a string identifying the remote connection.
  (add-to-list 'ibuffer-project-root-functions '(file-remote-p . "Remote")))

(straight-use-package '(dired-hacks :type git :host github :repo "Fuco1/dired-hacks"))

(eat-package dired-filter
  :hook (dired-mode-hook . dired-filter-group-mode)
  :init
  (setq dired-filter-revert 'never
        dired-filter-group-saved-groups
        '(("default"
           ("Git"
            (directory . ".git")
            (file . ".gitignore"))
           ("Directory"
            (directory))
           ("PDF"
            (extension . "pdf"))
           ("LaTeX"
            (extension "tex" "bib"))
           ("Source"
            (extension "c" "cpp" "hs" "rb" "py" "r" "cs" "el" "lisp" "html" "js" "css"))
           ("Doc"
            (extension "md" "rst" "txt"))
           ("Org"
            (extension . "org"))
           ("Archives"
            (extension "zip" "rar" "gz" "bz2" "tar"))
           ("Images"
            (extension "jpg" "JPG" "webp" "png" "PNG" "jpeg" "JPEG" "bmp" "BMP" "TIFF" "tiff" "gif" "GIF")))))
  :config
  (define-key dired-filter-map (kbd "p") 'dired-filter-pop-all)
  (define-key dired-filter-map (kbd "/") 'dired-filter-mark-map))

(eat-package dired-collapse
  :hook (dired-mode-hook . dired-collapse-mode))


(eat-package pretty-hydra
  :straight t
  :init
  (with-eval-after-load 'org
    (defun hot-expand (str &optional mod)
      "Expand org template.

STR is a structure template string recognised by org like <s. MOD is a
string with additional parameters to add the begin line of the
structure element. HEADER string includes more parameters that are
prepended to the element after the #+HEADER: tag."
      (let (text)
        (when (region-active-p)
          (setq text (buffer-substring (region-beginning) (region-end)))
          (delete-region (region-beginning) (region-end)))
        (insert str)
        (if (fboundp 'org-try-structure-completion)
            (org-try-structure-completion) ; < org 9
          (progn
            ;; New template expansion since org 9
            (require 'org-tempo nil t)
            (org-tempo-complete-tag)))
        (when mod (insert mod) (forward-line))
        (when text (insert text))))

    (pretty-hydra-define org-hydra (:title "Org Template" :quit-key "q")
      ("Basic"
       (("a" (hot-expand "<a") "ascii")
        ("c" (hot-expand "<c") "center")
        ("C" (hot-expand "<C") "comment")
        ("e" (hot-expand "<e") "example")
        ("E" (hot-expand "<E") "export")
        ("h" (hot-expand "<h") "html")
        ("l" (hot-expand "<l") "latex")
        ("n" (hot-expand "<n") "note")
        ("o" (hot-expand "<q") "quote")
        ("v" (hot-expand "<v") "verse"))
       "Head"
       (("i" (hot-expand "<i") "index")
        ("A" (hot-expand "<A") "ASCII")
        ("I" (hot-expand "<I") "INCLUDE")
        ("H" (hot-expand "<H") "HTML")
        ("L" (hot-expand "<L") "LaTeX"))
       "Source"
       (("s" (hot-expand "<s") "src")
        ("m" (hot-expand "<s" "emacs-lisp") "emacs-lisp")
        ("y" (hot-expand "<s" "python :results output") "python")
        ("p" (hot-expand "<s" "perl") "perl")
        ("r" (hot-expand "<s" "ruby") "ruby")
        ("S" (hot-expand "<s" "sh") "sh")
        ("j" (hot-expand "<s" "js") "javescript")
        ("g" (hot-expand "<s" "go :imports '\(\"fmt\"\)") "golang"))
       "Misc"
       (("u" (hot-expand "<s" "plantuml :file CHANGE.png") "plantuml")
        ("Y" (hot-expand "<s" "ipython :session :exports both :results raw drawer\n$0") "ipython")
        ("P" (progn
               (insert "#+HEADERS: :results output :exports both :shebang \"#!/usr/bin/env perl\"\n")
               (hot-expand "<s" "perl")) "Perl tangled")
        ("<" self-insert-command "ins"))))

    (define-key org-mode-map (kbd "<")
                (lambda ()
                  "Insert org template."
                  (interactive)
                  (if (or (region-active-p) (looking-back "^\s*" 1))
                      (org-hydra/body)
                    (self-insert-command 1))))))

(eat-package auctex :straight t)

(eat-package citar
  :straight (citar :type git :host github :repo "bdarcus/citar")
  :init
  (setq citar-bibliography '("~/Dropbox/bib/references.bib")))
