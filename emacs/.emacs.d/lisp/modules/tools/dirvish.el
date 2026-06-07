(use-package dired-ranger)

(require 'dired-x)

(setq dired-omit-files (concat dired-omit-files "\\|^\\..+$")
      dired-listing-switches "-lAGh1v --group-directories-first"
      dired-recursive-deletes 'always
      dired-recursive-copies 'always
      dired-deletion-confirmer (lambda (x) t)
      dired-clean-confirm-killing-deleted-buffers nil)
(add-hook 'dired-mode-hook #'dired-omit-mode)

(use-package dirvish
  :after evil
  :hook (dired-mode . auto-revert-mode)
  :init
  (dirvish-override-dired-mode)
  :config
  (dirvish-define-preview eza (file)
    "Use `eza' to generate directory preview."
    (when (file-directory-p file)
      `(shell . ("eza" "-a" "--color=always" "--icons" ,file))))

  (add-to-list 'dirvish-preview-dispatchers 'eza)

  (setq dirvish-default-layout '(0 0.6 0.4)
        dirvish-use-mode-line nil
        dirvish-use-header-line nil
        dirvish-reuse-session nil
        dirvish-attributes '(nerd-icons
                             file-size
                             git-msg
                             file-time)))
