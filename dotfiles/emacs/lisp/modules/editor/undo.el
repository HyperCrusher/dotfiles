(use-package undo-fu)

(use-package undo-fu-session
  :config
  (setq undo-fu-session-linear t
        undo-fu-session-incompatible-files '("/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'"))
  :init
  (undo-fu-session-global-mode))
