(with-eval-after-load 'dirvish

  (defun create-file-or-dir ()
    (interactive)
    (let ((name (read-string "Create: ")))
      (if (string-suffix-p "/" name)
          (dired-create-directory (substring name 0 -1))
        (shell-command (concat "touch " name))
        (revert-buffer))))

  (defun shell-command-here ()
    (interactive)
    (let ((command (read-string "Run: ")))
      (shell-command command)
      (revert-buffer)))

  (defun dired-toggle-mark ()
    (interactive)
    (let ((inhibit-read-only t)
          (current-position (point)))
      (if (dired-file-marker-p)
          (progn
            (dired-unmark 1)
            (goto-char current-position))
        (progn
          (dired-mark 1)
          (goto-char current-position)))))

  (defun dired-file-marker-p ()
    (save-excursion
      (beginning-of-line)
      (not (looking-at-p " "))))

  (defun open-vterm ()
    (interactive)
    (require 'vterm)
    (let ((target-dir (expand-file-name default-directory))
          (vterm-buffer (get-buffer "*vterm*")))
      (dirvish-quit)
      (if (buffer-live-p vterm-buffer)
          (progn
            (switch-to-buffer vterm-buffer)
            (vterm-send-string (concat "cd " (shell-quote-argument target-dir) "\n"))
            (vterm-send-string "clear\n"))
        (let ((default-directory target-dir))
          (vterm)))))

  (general-define-key
   :states 'normal
   :keymaps 'dirvish-mode-map
   "h"       'dired-up-directory
   "o"       'open-vterm
   "<return>" 'dired-find-file
   "l"       'dired-find-file
   "j"       'dired-next-line
   "k"       'dired-previous-line
   "."       'dired-omit-mode
   "v"       'dirvish-split-right
   "c"       'dired-do-chmod
   "s"       'dired-do-shell-command
   "S"       'shell-command-here
   "SPC"     'dired-toggle-mark
   "U"       'dired-unmark-all-marks
   "y"       'dired-ranger-copy
   "p"       'dired-ranger-paste
   "m"       'dired-ranger-move
   "r"       'dired-do-rename
   "Y"       'dirvish-yank-paths
   "a"       'create-file-or-dir
   "d"       'dired-do-delete
   "/"       'evil-search-forward
   "?"       'evil-search-backward
   "n"       'evil-search-next
   "N"       'evil-search-previous
   "q"       'dirvish-quit
   [tab]     'dirvish-subtree-toggle))

(defun dired-check (orig &rest args)
  (if (derived-mode-p 'dired-mode)
      nil
    (apply orig args)))

(advice-add 'evil-set-jump :around #'dired-check)

(defun trigger-jump (&rest args)
  (evil-set-jump))

(advice-add 'find-file :before #'trigger-jump)
(advice-add 'switch-to-buffer :before #'trigger-jump)

(defun silent-kill ()
  (when (buffer-modified-p)
    (let ((inhibit-message t))
      (set-buffer-modified-p nil)))
  t)

(add-hook 'kill-buffer-query-functions #'silent-kill)
