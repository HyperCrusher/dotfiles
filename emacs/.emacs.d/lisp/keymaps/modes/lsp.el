(defun smart-rename ()
  (interactive)
  (if (and (boundp 'lsp-bridge-mode) lsp-bridge-mode
           (fboundp 'lsp-bridge-rename))
      (call-interactively #'lsp-bridge-rename)
    (let* ((symbol (thing-at-point 'symbol t))
           (new-name (read-string (format "Rename '%s' to: " symbol) symbol)))
      (when (and symbol new-name (not (string= symbol new-name)))
        (let ((search-regexp (concat "\\_<" (regexp-quote symbol) "\\_>")))
          (save-excursion
            (goto-char (point-min))
            (perform-replace search-regexp new-name nil t nil)))))))

(with-eval-after-load 'lsp-bridge
  (general-create-definer native-leader
    :prefix "g")
  (native-leader
    :states '(normal visual)
    "d" (lambda ()
          (interactive)
          (evil-set-jump)
          (lsp-bridge-find-def))
    "k" #'lsp-bridge-popup-documentation
    "f" #'apheleia-format-buffer))

(with-eval-after-load 'evil
  (define-key evil-motion-state-map (kbd "K") nil)
  (define-key evil-normal-state-map (kbd "R") nil)
  (define-key evil-visual-state-map (kbd "R") nil)
  (define-key evil-normal-state-map (kbd "R") #'smart-rename)
  (define-key evil-visual-state-map (kbd "R") #'smart-rename))
