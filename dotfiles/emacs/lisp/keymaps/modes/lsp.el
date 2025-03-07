(with-eval-after-load 'lsp-mode
  ;; LSP specific leader key
  (general-create-definer lsp-leader
    :prefix "g"
    :states '(normal visual)
    :keymaps 'lsp-mode-map)

  (lsp-leader
    "d" 'lsp-find-definition
    "D" 'lsp-find-declaration
    "i" 'lsp-find-implementation
    "k" 'lsp-describe-thing-at-point
    "f" 'lsp-format-buffer
    "r" 'lsp-rename))
