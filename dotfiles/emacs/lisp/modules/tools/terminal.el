(use-package vterm
  :commands vterm
  :config
  (evil-set-initial-state 'vterm-mode 'insert)
  (setq vterm-shell "zsh"
        vterm-max-scrollback 10000))
