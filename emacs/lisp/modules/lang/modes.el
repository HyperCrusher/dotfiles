(use-package cmake-mode)
(use-package dockerfile-mode)
(use-package fasm-mode)
(use-package gdscript-mode)
(use-package glsl-mode)
(use-package go-mode)
(use-package hyprlang-ts-mode)
(use-package js2-mode)
(use-package json-mode)
(use-package kotlin-mode)
(use-package lua-mode)
(use-package markdown-mode)
(use-package nix-mode)
(use-package rust-mode)
(use-package toml-mode)
(use-package typescript-mode)
(use-package yaml-mode)
(use-package zig-mode)

(use-package auto-rename-tag)

(use-package web-mode
  :after smartparens
  :hook (mhtml-mode . web-mode))

(add-to-list 'auto-mode-alist '("\\.mts\\'" . typescript-mode))
