(use-package magit
  :after evil-collection)

(use-package magit-file-icons
  :after magit
  :init (magit-file-icons-mode 1))

(use-package git-gutter
  :hook (prog-mode . git-gutter-mode)
  :config
  (setq git-gutter:update-interval 0.02)
  (custom-set-variables
   '(git-gutter:modified-sign "┃")
   '(git-gutter:added-sign "┃")
   '(git-gutter:deleted-sign "┆")))

(use-package transient-posframe)
