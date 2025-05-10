(with-eval-after-load 'eglot
  (general-create-definer lsp-leader
    :prefix "g"
    :states '(normal visual)
    :keymaps 'override)

  (lsp-leader
    "d" (lambda ()
          (interactive)
          (evil-set-jump)
          (condition-case nil
              (call-interactively #'eglot-find-definition)
            (error
             (call-interactively #'xref-find-definitions))))
    "D" (lambda ()
          (interactive)
          (evil-set-jump)
          (condition-case nil
              (call-interactively #'eglot-find-declaration)
            (error
             (call-interactively #'xref-find-definitions))))
    "i" (lambda ()
          (interactive)
          (evil-set-jump)
          (condition-case nil
              (call-interactively #'eglot-find-implementation)
            (error
             (call-interactively #'xref-find-references))))
    "k" #'eglot-describe-thing-at-point
    "f" #'eglot-format-buffer
    "r" (lambda ()
          (interactive)
          (evil-set-jump)
          (call-interactively #'xref-find-references))
    "n" #'eglot-rename))
