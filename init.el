;; Speed up startup
(setq auto-mode-case-fold nil)

;; Use a hook so the message doesn't get clobbered by other messages.
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Emacs ready in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)

            ;; GC automatically while unfocusing the frame
            ;; `focus-out-hook' is obsolete since 27.1
            (if (boundp 'after-focus-change-function)
                (add-function :after after-focus-change-function
                              (lambda ()
                                (unless (frame-focus-state)
                                  (garbage-collect))))
              (add-hook 'focus-out-hook 'garbage-collect))

            ;; Recover GC values after startup
            (setq gc-cons-threshold 800000
                  gc-cons-percentage 0.1)))

(add-hook 'after-init-hook
          (lambda ()
            (save-excursion
              (switch-to-buffer "*scratch*")
              (goto-char (point-min))
              (insert ";; \t\t\tE M A C S\n")
              (insert (format ";; %s\n" (make-string 58 ?-)))
              (insert (format ";; Welcome to GNU Emacs %s. "
                              emacs-version))
              (insert (format "Today is %s .\n"
                              (format-time-string "%A %Y.%-m.%-d")))
              (insert ";;\n")
              (lisp-interaction-mode)
              (goto-char (point-max)))))

;; Load `custom-file'
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (and (file-exists-p custom-file)
           (file-readable-p custom-file))
  (load custom-file))

(require 'init-straight)
(require 'init-basic)
(require 'init-hydra)
(require 'init-editor)
(require 'init-dired)
(require 'init-ibuffer)
(require 'init-meow)
(require 'init-rime)
(require 'init-ui)
(require 'init-completion)
(require 'init-git)
(require 'init-org)
(require 'init-window)
(require 'init-telega)
(require 'init-spcfile)
(require 'init-lisp)
(require 'init-mole)
(require 'init-mail)
(require 'init-xterm)
(require 'init-dev)
(require 'init-fun)
