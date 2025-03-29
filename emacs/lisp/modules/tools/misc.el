(use-package devdocs)
(use-package tldr)

(use-package fancy-compilation)
(use-package git-modes)

(with-eval-after-load 'compile
  (fancy-compilation-mode))

(use-package envrc
  :hook (after-init . envrc-global-mode)
  :config
  (defvar last-buffer nil
    "Tracks the last buffer's directory to detect meaningful directory changes")
  (add-hook 'window-buffer-change-functions
            (lambda (&rest _)
              (let ((current-dir (and buffer-file-name (file-name-directory buffer-file-name))))
                (when (and current-dir
                           (not (equal current-dir last-buffer))
                           (envrc--locate-up ".envrc"))
                  (setq last-buffer current-dir)
                  (envrc-reload))))))
