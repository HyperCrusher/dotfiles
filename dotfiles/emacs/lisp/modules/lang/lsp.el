(use-package tree-sitter)
(use-package tree-sitter-langs)
(global-tree-sitter-mode)
(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(use-package lsp-mode
  :config
  (setq lsp-idle-delay 0.500
        lsp-log-io nil
        lsp-enable-semantic-highlighting nil
        lsp-headerline-breadcrumb-enable nil
        lsp-enable-suggest-server-download nil
        lsp-ui-sideline-show-code-actions nil
        lsp-modeline-code-actions-enable nil
        lsp-eldoc-enable-hover nil
        eldoc-mode nil)
  :hook ((bash-mode c-mode c++-mode cmake-mode css-mode dockerfile-mode
          fasm-mode gdscript-mode glsl-mode go-mode haskell-mode
          hyprlang-ts-mode java-mode js-mode js2-mode json-mode
          kotlin-mode lua-mode markdown-mode nix-mode rust-mode
          toml-mode typescript-mode web-mode yaml-mode zig-mode) . lsp-deferred)
        (lsp-mode . (lambda ()
                      (add-hook 'before-save-hook #'lsp-format-buffer nil t))))

(use-package lsp-ui)
(use-package consult-lsp)
(use-package flycheck)
(use-package lsp-haskell)

(use-package apheleia
  :config
  (apheleia-global-mode +1))
