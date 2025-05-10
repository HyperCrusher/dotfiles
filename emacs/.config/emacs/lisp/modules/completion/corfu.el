(use-package corfu
  :config
  (setq corfu-auto-delay 0.4
        corfu-auto-prefix 3
        corfu-min-width 35
        corfu-quit-no-match 'separator)
  :init
  (global-corfu-mode))

(use-package nerd-icons-corfu)
(add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter)
