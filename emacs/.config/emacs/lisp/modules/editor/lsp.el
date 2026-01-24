(setq treesit-language-source-alist
      '((bash "https://github.com/tree-sitter/tree-sitter-bash")
        (c "https://github.com/tree-sitter/tree-sitter-c")
        (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
        (css "https://github.com/tree-sitter/tree-sitter-css")
        (go "https://github.com/tree-sitter/tree-sitter-go")
        (html "https://github.com/tree-sitter/tree-sitter-html")
        (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
        (json "https://github.com/tree-sitter/tree-sitter-json")
        (make "https://github.com/tree-sitter/tree-sitter-make")
        (markdown "https://github.com/ikatyang/tree-sitter-markdown")
        (python "https://github.com/tree-sitter/tree-sitter-python")
        (rust "https://github.com/tree-sitter/tree-sitter-rust")
        (toml "https://github.com/tree-sitter/tree-sitter-toml")
        (zig "https://github.com/maxxnino/tree-sitter-zig")
        (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
        (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
        (hyprlang "https://github.com/hyprland-community/tree-sitter-hyprlang")))

(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (setq treesit-auto-langs '(rust bash toml json javascript typescript html css zig go python c cpp yaml java kotlin))
  (global-treesit-auto-mode))

(mapc (lambda (pair)
        (add-to-list 'auto-mode-alist pair))
      '(("\\.rs\\'" . rust-ts-mode)
        ("\\.py\\'" . python-ts-mode)
        ("\\.go\\'" . go-ts-mode)
        ("\\.js\\'" . js-ts-mode)
        ("\\.mjs\\'" . js-ts-mode)
        ("\\.ts\\'" . typescript-ts-mode)
        ("\\.tsx\\'" . tsx-ts-mode)
        ("\\.json\\'" . json-ts-mode)
        ("\\.toml\\'" . toml-ts-mode)
        ("\\.sh\\'" . bash-ts-mode)
        ("\\.c\\'" . c-ts-mode)
        ("\\.cpp\\'" . c++-ts-mode)
        ("\\.h\\'" . c-or-c++-ts-mode)
        ("\\.css\\'" . css-ts-mode)
        ("\\.html\\'" . html-ts-mode)
        ("\\.zig\\'" . zig-mode)))

(use-package envrc
  :config
  (envrc-global-mode))

(use-package apheleia
  :init
  (apheleia-global-mode))

(use-package markdown-mode)

(use-package yasnippet)
(yas-global-mode 1)

(use-package rust-mode
  :init
  (setq rust-mode-treesitter-derive t))
(use-package fasm-mode :mode ("\\.asm\\'" . fasm-mode))
(use-package hyprlang-ts-mode :mode ("hyprland\\.conf\\'" . hyprlang-ts-mode))
(use-package zig-mode)
(use-package kotlin-mode)

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
        lsp-bridge-enable-auto-format-code t
        acm-enable-doc t
        lsp-bridge-enable-inlay-hint nil))
