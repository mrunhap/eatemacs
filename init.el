;; Use a hook so the message doesn't get clobbered by other messages.
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Emacs ready in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))

;;; Personal configuration may override some variables
(let ((private-conf (expand-file-name "private.el" user-emacs-directory)))
  (when (file-exists-p private-conf)
    (load-file private-conf)))

(require 'init-core)
(require 'init-editor)
(require 'init-meow)
(require 'init-rime)
(require 'init-ui)
(require 'init-completion)
(require 'init-git)
(require 'init-org)
(require 'init-window)
(require 'init-telega)
(require 'init-spcfile)
(require 'init-flycheck)
(require 'init-lisp)
(require 'init-mole)

(require 'init-lsp)
(require 'init-go)
(require 'init-python)

(require 'init-fun)
