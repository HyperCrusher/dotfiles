(use-package envrc
  :config
  (envrc-global-mode))

(use-package yasnippet)
(yas-global-mode 1)

(use-package fasm-mode :mode ("\\.asm\\'" . fasm-mode))
(use-package glsl-mode)
(use-package haskell-mode)
(use-package hyprlang-ts-mode)
(use-package kotlin-mode)
(use-package markdown-mode)
(use-package rust-mode
  :init
  (setq rust-mode-treesitter-derive t))
(use-package svelte-mode)
(use-package wgsl-mode)
(use-package yuck-mode)
(use-package zig-mode)

(use-package lsp-bridge
  :straight '(lsp-bridge :type git :host github :repo "manateelazycat/lsp-bridge"
                         :files (:defaults "*.el" "*.py" "acm" "core" "langserver" "multiserver" "resources")
                         :build (:not compile))
  :init
  (global-lsp-bridge-mode)
  :config
  (setq lsp-bridge-complete-manually t
        lsp-bridge-enable-hover-diagnostic t
        lsp-bridge-signature-show-function 'lsp-bridge-signature-show-with-frame
        lsp-bridge-signature-show-with-frame-position "point"
        lsp-bridge-enable-document-highlight t
        acm-enable-doc t
        lsp-bridge-enable-inlay-hint nil))

(use-package apheleia
  :init
  (apheleia-global-mode)
  :config
  (setf (alist-get 'bash-ts-mode apheleia-mode-alist) '(shfmt))
  (setf (alist-get 'css-ts-mode apheleia-mode-alist) '(prettier))
  (setf (alist-get 'glsl-mode apheleia-mode-alist) '(clang-format))
  (setf (alist-get 'glsl-ts-mode apheleia-mode-alist) '(clang-format))
  (setf (alist-get 'go-ts-mode apheleia-mode-alist) '(gofmt))
  (setf (alist-get 'hlsl-ts-mode apheleia-mode-alist) '(clang-format))
  (setf (alist-get 'html-ts-mode apheleia-mode-alist) '(prettier))
  (setf (alist-get 'java-ts-mode apheleia-mode-alist) '(google-java-format))
  (setf (alist-get 'js-ts-mode apheleia-mode-alist) '(prettier))
  (setf (alist-get 'json-ts-mode apheleia-mode-alist) '(prettier))
  (setf (alist-get 'kotlin-ts-mode apheleia-mode-alist) '(ktlint))
  (setf (alist-get 'prettier-svelte apheleia-formatters)
        '("npx" "prettier" "--stdin-filepath" filepath "--parser" "svelte"))
  (setf (alist-get 'python-ts-mode apheleia-mode-alist) '(black))
  (setf (alist-get 'rust-ts-mode apheleia-mode-alist) '(rustfmt))
  (setf (alist-get 'tsx-ts-mode apheleia-mode-alist) '(prettier))
  (setf (alist-get 'typescript-ts-mode apheleia-mode-alist) '(prettier))
  (setf (alist-get 'wgsl-ts-mode apheleia-mode-alist) '(clang-format))
  (add-to-list 'apheleia-mode-alist '(svelte-mode . prettier-svelte)))
