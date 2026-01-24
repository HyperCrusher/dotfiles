(with-eval-after-load 'lsp-bridge
  (general-create-definer lsp-leader
    :prefix "g"
    :states '(normal visual))
  (lsp-leader
    "d" (lambda ()
          (interactive)
          (evil-set-jump)
          (condition-case nil
              (call-interactively #'lsp-bridge-find-def)
            (error
             (call-interactively #'xref-find-definitions))))
    "i" (lambda ()
          (interactive)
          (evil-set-jump)
          (condition-case nil
              (call-interactively #'lsp-bridge-find-references)
            (error
             (call-interactively #'xref-find-references))))
    "f" #'lsp-bridge-code-format))

(with-eval-after-load 'evil
  (define-key evil-motion-state-map (kbd "K") nil)
  (define-key evil-normal-state-map (kbd "R") nil)
  (define-key evil-visual-state-map (kbd "R") nil)

  ;; For some reason general.el doesnt correctly deal with these keybinds 
  (define-key evil-insert-state-map (kbd "C-SPC") 'lsp-bridge-popup-complete-menu)
  
  (with-eval-after-load 'lsp-bridge
    (define-key evil-motion-state-map (kbd "K") 'lsp-bridge-popup-documentation)
    (define-key evil-normal-state-map (kbd "R") 'lsp-bridge-rename)
    (define-key evil-visual-state-map (kbd "R") 'lsp-bridge-rename)))
