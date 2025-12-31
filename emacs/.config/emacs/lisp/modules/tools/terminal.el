(use-package vterm
  :commands vterm
  :hook (vterm-mode . (lambda ()
                        (compilation-shell-minor-mode 1)
                        (centered-cursor-mode -1)))
  :config
  (define-key vterm-mode-map (kbd "M-n") 'compilation-next-error)
  (define-key vterm-mode-map (kbd "M-p") 'compilation-previous-error)
  (evil-set-initial-state 'vterm-mode 'insert)
  (setq vterm-shell "zsh"
        vterm-max-scrollback 10000))

(use-package vterm-toggle)

(setq vterm-toggle-fullscreen-p nil)
(add-to-list 'display-buffer-alist
             '((lambda (buffer-or-name _)
                 (let ((buffer (get-buffer buffer-or-name)))
                   (with-current-buffer buffer
                     (and (boundp 'vterm-buffer-name) ;; Only proceed if vterm-buffer-name is defined
                          (or (equal major-mode 'vterm-mode)
                              (string-prefix-p vterm-buffer-name (buffer-name buffer)))))))
               (display-buffer-reuse-window display-buffer-at-bottom)
               (reusable-frames . visible)
               (window-height . 0.3)))
;; Replace scratch buffer with terminal
(defun make-terminal ()
  (require 'vterm nil t) ;; Try to load vterm but don't error
  (if (not (boundp 'vterm-buffer-name))
      (get-buffer-create "*scratch*")
    ;; Always create a new vterm buffer
    (with-current-buffer (generate-new-buffer "*vterm*")
      (vterm-mode)
      (current-buffer))))
(defun setup-term ()
  (let ((buf (make-terminal)))
    (when (boundp 'vterm-buffer-name)
      (with-current-buffer buf
        (when (fboundp 'evil-insert-state)
          (evil-insert-state)
          (vterm-clear))))
    buf))
(if (daemonp)
    (progn
      (add-hook 'after-make-frame-functions
                (lambda (frame)
                  (when (eq (frame-parameter frame 'client) nil)
                    (switch-to-buffer (setup-term))))
                t)
      (add-hook 'server-after-make-frame-hook
                (lambda () (switch-to-buffer (setup-term)))))
  (setq initial-buffer-choice 'setup-term))

(defun vterm-compile (command)
  "Run a compilation COMMAND in a dedicated vterm buffer."
  (interactive (list (compilation-read-command (or compile-command "make -k "))))
  (let ((buffer (get-buffer-create "*vterm-compilation*")))
    ;; Display the buffer first
    (pop-to-buffer buffer)
    (unless (derived-mode-p 'vterm-mode)
      (vterm-mode))
    
    ;; Ensure the process is ready before sending the string
    (let ((proc (get-buffer-process buffer)))
      (if (and proc (process-live-p proc))
          (vterm-send-string (concat command "\n"))
        ;; Fallback: if process just started, wait a tiny bit
        (run-at-time "0.1 sec" nil 
                     (lambda (b c) 
                       (with-current-buffer b 
                         (vterm-send-string (concat c "\n"))))
                     buffer command)))))

;; Redirect all compilation (including Rust) to this function
(advice-add 'compilation-start :override (lambda (command &rest _) (vterm-compile command)))
