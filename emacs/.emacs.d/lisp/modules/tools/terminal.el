;;; -*- lexical-binding: t; -*-

(use-package vterm
  :commands vterm
  :custom
  (vterm-shell "zsh")
  (vterm-max-scrollback 10000)
  :hook
  (vterm-mode . (lambda ()
                  (compilation-shell-minor-mode 1)
                  (centered-cursor-mode -1)))
  :config
  (setenv "COLORTERM" "truecolor")
  (define-key vterm-mode-map (kbd "M-n") #'compilation-next-error)
  (define-key vterm-mode-map (kbd "M-p") #'compilation-previous-error)
  (evil-set-initial-state 'vterm-mode 'insert))

(use-package vterm-toggle
  :commands (vterm-toggle vterm-toggle-cd)
  :custom
  (vterm-toggle-fullscreen-p nil))

;; Display vterm popups at the bottom
(add-to-list 'display-buffer-alist
             '((lambda (buf _)
                 (when-let ((b (get-buffer buf)))
                   (with-current-buffer b
                     (derived-mode-p 'vterm-mode))))
               (display-buffer-reuse-window display-buffer-at-bottom)
               (reusable-frames . visible)
               (window-height . 0.3)))

(defun make-terminal ()
  "Return the main vterm buffer, creating it if necessary."
  (require 'vterm)
  (let ((buffer (get-buffer-create "*vterm*")))
    (with-current-buffer buffer
      (unless (derived-mode-p 'vterm-mode)
        (vterm-mode)))
    buffer))

(defun setup-term ()
  "Return an initial vterm buffer for startup."
  (let ((buffer (make-terminal)))
    (with-current-buffer buffer
      (when (fboundp 'evil-insert-state)
        (evil-insert-state)))
    buffer))

(if (daemonp)
    (progn
      (add-hook 'after-make-frame-functions
                (lambda (frame)
                  (when (eq (frame-parameter frame 'client) nil)
                    (switch-to-buffer (setup-term))))
                t)
      (add-hook 'server-after-make-frame-hook
                (lambda () (switch-to-buffer (setup-term)))))
  (setq initial-buffer-choice #'setup-term))

;; Optional: explicit compile-in-vterm command
(defun vterm-compile (command)
  "Run COMMAND in a dedicated vterm buffer."
  (interactive (list (compilation-read-command (or compile-command "make -k "))))
  (let ((buffer (get-buffer-create "*vterm-compilation*"))
        (default-directory (or (and (fboundp 'projectile-project-root)
                                    (projectile-project-root))
                               default-directory)))
    (pop-to-buffer buffer)
    (with-current-buffer buffer
      (unless (derived-mode-p 'vterm-mode)
        (vterm-mode))
      (vterm-send-string (concat command "\n")))))

(defun vterm-cd (&optional dir)
  (interactive)
  (let ((explicit-dir (and dir t)))
    (if (and (not explicit-dir) (derived-mode-p 'vterm-mode))
        (if (fboundp 'vterm-toggle)
            (vterm-toggle)
          (switch-to-prev-buffer))
      (let* ((dir (expand-file-name (or dir default-directory)))
             (buffer (get-buffer "*vterm*")))
        (if (and buffer (get-buffer-process buffer))
            (progn
              (with-current-buffer buffer
                (setq default-directory dir))
              (pop-to-buffer buffer)
              (with-current-buffer buffer
                (vterm-send-string
                 (concat "builtin cd " (shell-quote-argument dir)
                         " && clear"))
                (vterm-send-return)))
          (let ((default-directory dir))
            (vterm)))))))
