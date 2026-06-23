;; Reset GC threshold
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024))))

;; Initialize modes that need all packages loaded
(evil-collection-init)
(vertico-posframe-mode)
(global-ligature-mode 1)
(global-evil-quickscope-mode 1)
(global-evil-surround-mode 1)
(global-centered-cursor-mode 1)
(global-git-gutter-mode 1)
