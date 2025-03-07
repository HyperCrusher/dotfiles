(general-create-definer leader
  :prefix "SPC")

(general-define-key
 :states 'motion
 "C-S" 'save-buffer
 "C-L" 'evil-window-right
 "C-h" 'evil-window-left
 "C-k" 'evil-window-up
 "C-j" 'evil-window-down
 "C-y" 'org-rich-yank
 ":" 'execute-extended-command)

(leader
  :keymaps 'normal
  "SPC" (lambda ()
          (interactive)
          (dirvish)
          (revert-buffer))

  "s"  'consult-ripgrep
  "m"  'magit
  "p"  'consult-projectile-switch-project
  "c"  'evil-window-delete
  "v"  'split-window-right
  "f"  'consult-buffer
  "h a" 'harpoon-add-file
  "h c" 'harpoon-clear
  "h h" 'harpoon-go-to-next)

;; Number operations
(general-define-key
 :states 'motion
 "C-x" 'evil-numbers/dec-at-pt
 "C-a" 'evil-numbers/inc-at-pt
 "g C-x" 'evil-numbers/dec-at-pt-incremental
 "g C-a" 'evil-numbers/inc-at-pt-incremental)

;; Paste screenshots/clipboard images
(defun paste-clipboard (&optional use-default-filename)
  (interactive "P")
  (require 'org-download)
  (let ((file
         (if (not use-default-filename)
             (read-string (format "Filename [%s]: " org-download-screenshot-basename)
                          nil nil org-download-screenshot-basename)
           nil)))
    (org-download-clipboard file)))

;; Custom shortcuts, some are vimlike due to my removal of the evil buffer
(defun qa ()
  "Quit."
  (interactive)
  (save-buffers-kill-terminal))

(defun q! ()
  "Quit all (forced). Kills the server"
  (interactive)
  (kill-emacs))

(defun w ()
  "Save."
  (interactive)
  (save-buffer))

(defun wa ()
  "Save all."
  (interactive)
  (save-some-buffers t))

(defun wq ()
  "Save and quit."
  (interactive)
  (save-some-buffers t)
  (save-buffers-kill-terminal t))

(defun vsplit ()
  "Split Vertically"
  (interactive)
  (evil-window-vsplit))

(defun split ()
  "Split Horizontally"
  (interactive)
  (evil-window-split))

(defun only ()
  "Make the current window the only one"
  (interactive)
  (delete-other-windows))
