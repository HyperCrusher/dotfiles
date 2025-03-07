;; File handling
(global-auto-revert-mode t)
(recentf-mode t)
(save-place-mode t)

;; File backups and saves
(setq make-backup-files nil
      auto-save-default nil
      auto-save-list-file-name nil
      auto-save-list-file-prefix nil
      create-lockfiles nil)

;; File behavior
(setq large-file-warning-threshold (* 100 1024 1024)
      recentf-max-saved-items 100
      recentf-exclude '("/tmp/" "/ssh:"))

;; File coding
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
