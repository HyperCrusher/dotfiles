;; Reset GC threshold
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024))))

;; Initialize modes that need all packages loaded
(evil-collection-init)
(vertico-posframe-mode)
(global-ligature-mode)
(global-evil-quickscope-mode)
(global-centered-cursor-mode)
