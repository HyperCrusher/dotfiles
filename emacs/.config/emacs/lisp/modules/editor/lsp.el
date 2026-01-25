(setq treesit-language-source-alist
      '((bash "https://github.com/tree-sitter/tree-sitter-bash")
        (c "https://github.com/tree-sitter/tree-sitter-c")
        (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
        (css "https://github.com/tree-sitter/tree-sitter-css")
        (go "https://github.com/tree-sitter/tree-sitter-go")
        (glsl "https://github.com/tree-sitter-grammars/tree-sitter-glsl")
        (gpg-config "https://github.com/tree-sitter-grammars/tree-sitter-gpg-config")
        (haskell "https://github.com/tree-sitter-grammars/tree-sitter-haskell")
        (hlsl "https://github.com/tree-sitter-grammars/tree-sitter-hlsl")
        (html "https://github.com/tree-sitter/tree-sitter-html")
        (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
        (json "https://github.com/tree-sitter/tree-sitter-json")
        (kotlin "https://github.com/tree-sitter-grammars/tree-sitter-kotlin")
        (make "https://github.com/tree-sitter-grammars/tree-sitter-make")
        (markdown "https://github.com/ikatyang/tree-sitter-markdown")
        (python "https://github.com/tree-sitter/tree-sitter-python")
        (rust "https://github.com/tree-sitter/tree-sitter-rust")
        (scss "https://github.com/tree-sitter-grammars/tree-sitter-scss")
        (ssh-config "https://github.com/tree-sitter-grammars/tree-sitter-ssh-config")
        (svelte "https://github.com/tree-sitter-grammars/tree-sitter-svelte")
        (toml "https://github.com/tree-sitter-grammars/tree-sitter-toml")
        (zig "https://github.com/tree-sitter-grammars/tree-sitter-zig")
        (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
        (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
        (hyprlang "https://github.com/tree-sitter-grammars/tree-sitter-hyprlang")
        (wgsl "https://github.com/tree-sitter-grammars/tree-sitter-wgsl-bevy")
        (yuck "https://github.com/tree-sitter-grammars/tree-sitter-yuck")))

(setq treesit-load-name-override-list
      '((wgsl "libtree-sitter-wgsl" "tree_sitter_wgsl_bevy")
        (gpg-config "libtree-sitter-gpg-config" "tree_sitter_gpg")))

;; (dolist (lang treesit-language-source-alist) (treesit-install-language-grammar (car lang)))

(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (setq treesit-auto-langs '(rust bash toml json javascript typescript html css zig go python c cpp yaml java kotlin haskell make markdown svelte))
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
        ("\\.scss\\'" . scss-ts-mode)
        ("\\.html\\'" . html-ts-mode)
        ("\\.zig\\'" . zig-ts-mode)
        ("\\.kt\\'" . kotlin-ts-mode)
        ("\\.kts\\'" . kotlin-ts-mode)
        ("\\.hs\\'" . haskell-ts-mode)
        ("\\.md\\'" . markdown-ts-mode)
        ("\\.svelte\\'" . svelte-ts-mode)
        ("\\.wgsl\\'" . wgsl-ts-mode)
        ("\\.glsl\\'" . glsl-ts-mode)
        ("\\.vert\\'" . glsl-ts-mode)
        ("\\.frag\\'" . glsl-ts-mode)
        ("\\.hlsl\\'" . hlsl-ts-mode)
        ("\\.yuck\\'" . yuck-ts-mode)
        ("hyprland\\.conf\\'" . hyprlang-ts-mode)
        ("Makefile\\'" . makefile-ts-mode)
        ("\\.mk\\'" . makefile-ts-mode)
        ("/\\.ssh/config\\'" . ssh-config-ts-mode)
        ("/\\.gnupg/.*\\.conf\\'" . gpg-config-ts-mode)))

(use-package envrc
  :config
  (envrc-global-mode))

(use-package yasnippet)
(yas-global-mode 1)

(use-package markdown-mode)
(use-package svelte-mode)
(use-package haskell-mode)
(use-package yuck-mode)
(use-package wgsl-mode)
(use-package glsl-mode)
(use-package rust-mode
  :init
  (setq rust-mode-treesitter-derive t))
(use-package fasm-mode :mode ("\\.asm\\'" . fasm-mode))
(use-package hyprlang-ts-mode)
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
        acm-enable-doc t
        lsp-bridge-enable-inlay-hint nil))


(use-package apheleia
  :init
  (apheleia-global-mode)
  :config
  (setf (alist-get 'python-ts-mode apheleia-mode-alist) '(black))
  (setf (alist-get 'rust-ts-mode apheleia-mode-alist) '(rustfmt))
  (setf (alist-get 'bash-ts-mode apheleia-mode-alist) '(shfmt))
  (setf (alist-get 'go-ts-mode apheleia-mode-alist) '(gofmt))
  (setf (alist-get 'js-ts-mode apheleia-mode-alist) '(prettier))
  (setf (alist-get 'typescript-ts-mode apheleia-mode-alist) '(prettier))
  (setf (alist-get 'tsx-ts-mode apheleia-mode-alist) '(prettier))
  (setf (alist-get 'json-ts-mode apheleia-mode-alist) '(prettier))
  (setf (alist-get 'html-ts-mode apheleia-mode-alist) '(prettier))
  (setf (alist-get 'css-ts-mode apheleia-mode-alist) '(prettier))
  (setf (alist-get 'kotlin-ts-mode apheleia-mode-alist) '(ktlint))
  (setf (alist-get 'java-ts-mode apheleia-mode-alist) '(google-java-format))
  (setf (alist-get 'prettier-svelte apheleia-formatters)
        '("npx" "prettier" "--stdin-filepath" filepath "--parser" "svelte"))
  (add-to-list 'apheleia-mode-alist '(svelte-mode . prettier-svelte))
  (add-to-list 'apheleia-mode-alist '(glsl-mode . clang-format))
  (add-to-list 'apheleia-mode-alist '(glsl-ts-mode . clang-format))
  (add-to-list 'apheleia-mode-alist '(wgsl-ts-mode . clang-format))
  (add-to-list 'apheleia-mode-alist '(hlsl-ts-mode . clang-format)))


