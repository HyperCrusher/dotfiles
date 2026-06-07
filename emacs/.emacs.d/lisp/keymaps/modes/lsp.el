(defun symbol-rename ()
  (interactive)
  (let* ((symbol (thing-at-point 'symbol t))
         (new-name (read-string (format "Rename '%s' to: " symbol) symbol)))
    (when (and symbol new-name (not (string= symbol new-name)))
      (let ((search-regexp (concat "\\_<" (regexp-quote symbol) "\\_>")))
        (save-excursion
          (goto-char (point-min))
          (perform-replace search-regexp new-name nil t nil))))))

(general-create-definer native-leader
  :prefix "g"
  :states '(normal visual))

(native-leader
  "d" (lambda ()
        (interactive)
        (evil-set-jump)
        (call-interactively #'xref-find-definitions))
  "i" (lambda ()
        (interactive)
        (evil-set-jump)
        (call-interactively #'xref-find-references))
  "f" #'apheleia-format-buffer)

(with-eval-after-load 'evil
  (define-key evil-motion-state-map (kbd "K") nil)
  (define-key evil-normal-state-map (kbd "R") nil)
  (define-key evil-visual-state-map (kbd "R") nil)

  ;; For some reason general.el doesnt correctly deal with these keybinds 
  (define-key evil-insert-state-map (kbd "C-SPC") #'completion-at-point)
  
  (define-key evil-normal-state-map (kbd "R") #'symbol-rename)
  (define-key evil-visual-state-map (kbd "R") #'symbol-rename))
