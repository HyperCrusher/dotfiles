(use-package evil
  :init
  (setq evil-want-integration t
        evil-vsplit-window-right t
        evil-split-window-below t
        evil-undo-system 'undo-fu
        evil-kill-on-visual-paste nil
        evil-want-keybinding nil)
  :config
  (add-hook 'minibuffer-setup-hook 'evil-insert-state)
  (evil-mode 1))


(use-package evil-collection
  :after evil)

(use-package evil-numbers
  :after evil)

(use-package centered-cursor-mode
  :config
  (setq ccm-step-size 1
        scroll-margin 8))

(use-package evil-quickscope)

(use-package drag-stuff)
