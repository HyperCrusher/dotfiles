(use-package tree-sitter)
(use-package tree-sitter-langs)
(global-tree-sitter-mode)
(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)

(use-package flycheck
  :config
  (define-fringe-bitmap 'my-vertical-bar
    [255 255 255 255 255 255 255 255
         255 255 255 255 255 255 255 255
         255 255 255 255 255 255 255 255
         255 255 255 255 255 255 255 255]
    32 8 'center)

  (setq flycheck-indication-mode 'left-fringe)

  (flycheck-define-error-level 'error
    :severity 100
    :compilation-level 2
    :overlay-category 'flycheck-error-overlay
    :fringe-bitmap 'my-vertical-bar
    :fringe-face 'flycheck-fringe-error
    :error-list-face 'flycheck-error-list-error)

  (flycheck-define-error-level 'warning
    :severity 10
    :compilation-level 1
    :overlay-category 'flycheck-warning-overlay
    :fringe-bitmap 'my-vertical-bar
    :fringe-face 'flycheck-fringe-warning
    :error-list-face 'flycheck-error-list-warning)

  (flycheck-define-error-level 'info
    :severity -10
    :compilation-level 0
    :overlay-category 'flycheck-info-overlay
    :fringe-bitmap 'my-vertical-bar
    :fringe-face 'flycheck-fringe-info
    :error-list-face 'flycheck-error-list-info))

(use-package flycheck-posframe
  :ensure t
  :after flycheck
  :config
  (setq flycheck-posframe-border-width 2
        flycheck-posframe-warning-prefix ""
        flycheck-posframe-error-prefix ""
        flycheck-posframe-info-prefix ""))

(use-package flycheck-eglot
  :ensure t
  :after (flycheck eglot))

(use-package eglot
  :ensure t
  :config
  (with-eval-after-load 'eglot
    (dolist (mode '((nix-mode . ("nil" :initializationOptions
                                 (:formatting (:command [ "nixfmt" ]))))))
      (add-to-list 'eglot-server-programs mode)))
  (setq eglot-sync-connect nil
        eglot-autoshutdown t
        eglot-send-changes-idle-time 0.5
        eglot-ignored-server-capabilities '(:documentHighlightProvider
                                            :documentOnTypeFormattingProvider
                                            :colorProvider)
        eglot-stay-out-of '(eldoc flymake)
        eglot-extend-to-xref nil)


  (add-hook 'eglot-managed-mode-hook (lambda ()
                                       (flymake-mode -1)
                                       (flycheck-mode +1)
                                       (flycheck-eglot-mode +1)
                                       (flycheck-posframe-mode)
                                       ))

  :hook ((bash-mode c-mode c++-mode cmake-mode css-mode dockerfile-mode
                    fasm-mode gdscript-mode glsl-mode go-mode haskell-mode
                    hyprlang-ts-mode java-mode js-mode js2-mode jtsx-jsx-mode jtsx-tsx-mode 
                    jtsx-typescript-mode kotlin-mode lua-mode markdown-mode json-mode nix-mode rust-mode
                    toml-mode typescript-mode yaml-mode zig-mode) . eglot-ensure)

  (eglot-managed-mode . (lambda ()
                          (add-hook 'before-save-hook (lambda () (ignore-errors (eglot-format)))))))

(use-package apheleia)

