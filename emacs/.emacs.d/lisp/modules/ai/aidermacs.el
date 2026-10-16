;;; -*- lexical-binding: t; -*-

(require 'ai-shared)

(use-package aidermacs
  :straight t
  :custom
  (aidermacs-backend 'vterm)
  (aidermacs-default-chat-mode 'ask)
  (aidermacs-default-model "deepseek/deepseek-v4-pro")
  (aidermacs-weak-model "deepseek/deepseek-flash")
  (aidermacs-editor-model "deepseek/deepseek-flash")
  (aidermacs-architect-model "deepseek/deepseek-v4-pro")
  (aidermacs-vterm-multiline-newline-key "S-<return>")
  (aidermacs-vterm-use-theme-colors 'off)
  :config
  (when-let ((key (ai-deepseek-key)))
    (setenv "DEEPSEEK_API_KEY" key))
  (dolist (arg '("--user-input-color" "95c561"
                 "--tool-error-color" "ee6d85"
                 "--tool-warning-color" "d7a65f"
                 "--assistant-output-color" "7199ee"
                 "--completion-menu-color" "a0a8cd"
                 "--completion-menu-bg-color" "171826"
                 "--code-theme" "github-dark"))  
    (add-to-list 'aidermacs-extra-args arg t)))
