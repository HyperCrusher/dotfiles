(use-package devdocs)
(use-package tldr)

(use-package fancy-compilation)
(use-package git-modes)

(with-eval-after-load 'compile
  (fancy-compilation-mode))

(use-package envrc
  :hook (after-init . envrc-global-mode))
