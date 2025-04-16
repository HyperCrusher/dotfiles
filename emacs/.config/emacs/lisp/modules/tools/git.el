(use-package magit
  :after evil-collection
  :config
  (setopt magit-format-file-function #'magit-format-file-nerd-icons)  
  ;; Save window configuration before commit
  (add-hook 'server-switch-hook #'magit-save-window-configuration)
  ;; Restore window configuration after commit
  (add-hook 'with-editor-post-finish-hook #'magit-restore-window-configuration)
  ;; Prevent vterm auto-display after commit
  (defun magit-restore-window-configuration--prevent-vterm (&optional _)
    (let ((buf (get-buffer "*vterm*")))
      (when (and buf (get-buffer-window buf))
        (delete-window (get-buffer-window buf)))))
  (advice-add 'magit-restore-window-configuration :after 
              #'magit-restore-window-configuration--prevent-vterm))

(use-package git-gutter
  :hook (prog-mode . git-gutter-mode)
  :config
  (setq git-gutter:update-interval 0.02
        git-gutter:window-width 1)
  (custom-set-variables
   '(git-gutter:modified-sign "┃")
   '(git-gutter:added-sign "┃")
   '(git-gutter:deleted-sign "┆")))

(use-package transient-posframe)
