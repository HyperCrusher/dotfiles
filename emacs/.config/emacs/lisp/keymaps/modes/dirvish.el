(with-eval-after-load 'dirvish

  (defun create-file-or-dir ()
    (interactive)
    (let ((name (read-string "Create: ")))
      (if (string-suffix-p "/" name)
          (dired-create-directory (substring name 0 -1))
        (shell-command (concat "touch " name))
        (revert-buffer))))

(defun dired-toggle-mark ()
  "Toggle the current file's mark in dired.
If the file is marked, unmark it. If unmarked, mark it.
Does not move point after toggling."
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
  "Return non-nil if the current line's file is marked."
  (save-excursion
    (beginning-of-line)
    (not (looking-at-p " "))))

  (general-define-key
   :states 'normal
   :keymaps 'dirvish-mode-map
   "h"       'dired-up-directory
   "<return>" 'dired-find-file
   "l"       'dired-find-file
   "j"       'dired-next-line
   "k"       'dired-previous-line
   "."       'dired-omit-mode
   "v"       'dirvish-split-right
   "c"       'dired-do-chmod
   "s"       'dired-do-shell-command
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
