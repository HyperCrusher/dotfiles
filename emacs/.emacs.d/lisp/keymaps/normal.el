(defun smart-dirvish ()
  (interactive)
  (if (eq major-mode 'vterm-mode)
      (dirvish default-directory)
    (dired-jump)
    (dirvish-layout-switch)))



(general-create-definer leader
  :prefix "SPC")

(general-define-key
 :states 'motion
 "j" 'evil-next-visual-line
 "k" 'evil-previous-visual-line
 "C-S" 'save-buffer
 "C-L" 'evil-window-right
 "C-h" 'evil-window-left
 "C-k" 'evil-window-up
 "C-j" 'evil-window-down
 "C-y" 'org-rich-yank
 ":" 'execute-extended-command)

(leader
  :keymaps 'normal
  "SPC" 'smart-dirvish
  "h" 'evil-first-non-blank
  "l" 'evil-last-non-blank
  "s"  'consult-ripgrep
  "g"  'magit
  "t"  'vterm-toggle
  "o"  'only
  "p"  'consult-projectile-switch-project
  "c"  'evil-window-delete
  "v"  'split-window-right
  "f"  'consult-buffer)

;; Window resizing with Alt + movement keys
(general-define-key
 :states 'motion
 "M-l" (lambda () (interactive) (enlarge-window-horizontally 5))
 "M-h" (lambda () (interactive) (shrink-window-horizontally 5))
 "M-k" (lambda () (interactive) (shrink-window 5))
 "M-j" (lambda () (interactive) (enlarge-window 5))
 "M-<up>" (lambda () (interactive) (shrink-window 5))
 "M-<down>" (lambda () (interactive) (enlarge-window 5))
 "M-<left>" (lambda () (interactive) (shrink-window-horizontally 5))
 "M-<right>" (lambda () (interactive) (enlarge-window-horizontally 5)))

;; Number operations
(general-define-key
 :states 'motion
 "C-x" 'evil-numbers/dec-at-pt
 "C-a" 'evil-numbers/inc-at-pt
 "g C-x" 'evil-numbers/dec-at-pt-incremental)

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
(defun nvterm ()
  "Start a new separate vterbuffer and display it in the current window"
  (interactive)
  (let ((buffer-name (generate-new-buffer-name "*vterm*")))
    (switch-to-buffer buffer-name)
    (vterm-mode)))

(defun kill-terms ()
  "Kill all vterm buffers except the original '*vterm*' buffer.
Returns to the original buffer after killing."
  (interactive)
  (let ((original-buffer (current-buffer))
        (original-vterm "*vterm*"))
    (dolist (buffer (buffer-list))
      (let ((buffer-name (buffer-name buffer)))
        (when (and (string-match "\\*vterm\\*<[0-9]+>" buffer-name)
                   (not (string= buffer-name original-vterm)))
          (kill-buffer buffer))))
    (switch-to-buffer original-buffer)))

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
