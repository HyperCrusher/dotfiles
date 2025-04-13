(use-package smartparens
  :hook (prog-mode)
  :config
  (require 'smartparens-config))

(use-package evil-smartparens
  :after smartparens
  :init
  (add-hook 'smartparens-enabled-hook #'evil-smartparens-mode))

(use-package evil-surround
  :config
  (global-evil-surround-mode 1))
