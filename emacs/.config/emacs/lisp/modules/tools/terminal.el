(use-package vterm
  :commands vterm
  :hook (vterm-mode . (lambda ()
                        (centered-cursor-mode -1)))
  :config
  (evil-set-initial-state 'vterm-mode 'insert)
  (setq vterm-shell "zsh"
        vterm-max-scrollback 10000))

(use-package vterm-toggle)

;; Keep term on bottom
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
  (if (not (boundp 'vterm-buffer-name)) ;; Check if vterm is properly initialized
      (get-buffer-create "*scratch*")
    ;; Always create a new vterm buffer
    (with-current-buffer (generate-new-buffer "*vterm*")
      (vterm-mode)
      (current-buffer))))
(defun setup-term ()
  (let ((buf (make-terminal)))
    (when (boundp 'vterm-buffer-name) ;; Only proceed with vterm operations if vterm is initialized
      (with-current-buffer buf
        (when (fboundp 'evil-insert-state)
          (evil-insert-state)
          ;; Clear the terminal before presenting
          (vterm-send-string "clear")
          (vterm-send-return))))
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
