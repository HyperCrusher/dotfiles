;;; -*- lexical-binding: t; -*-

(require 'ai-shared)
(require 'json)
(require 'subr-x)

(defcustom aidermacs-use-cecli t
  "When non-nil, run cecli instead of aider."
  :type 'boolean
  :group 'aidermacs)

(defcustom aidermacs-cecli-tui-colors
  '((primary . "#95C561")
    (secondary . "#787C99")
    (accent . "#A485DD")
    (foreground . "#A0A8CD")
    (background . "#11121D")
    (success . "#95C561")
    (warning . "#D7A65F")
    (error . "#EE6D85")
    (surface . "transparent")
    (panel . "transparent")
    (input-cursor-foreground . "#7199EE"))
  "Alist of cecli TUI colors for `aidermacs-use-cecli'."
  :type '(alist :key-type symbol :value-type string)
  :group 'aidermacs)

(defconst aidermacs--model-strong "deepseek/deepseek-v4-pro")
(defconst aidermacs--model-weak "deepseek/deepseek-flash")
;; 
(defconst aidermacs--aider-extra-args
  '("--user-input-color" "95c561"
    "--tool-error-color" "ee6d85"
    "--tool-warning-color" "d7a65f"
    "--assistant-output-color" "7199ee"
    "--completion-menu-color" "a0a8cd"
    "--completion-menu-bg-color" "171826"
    "--code-theme" "github-dark"))

(defconst aidermacs--cecli-extra-args
  (list "--model" aidermacs--model-strong
        "--weak-model" aidermacs--model-weak
        "--editor-model" aidermacs--model-weak
        "--ask"
        "--tui"))

(defconst aidermacs--cecli-tui-color-keys
  '(primary secondary accent foreground background
            success warning error surface panel input-cursor-foreground))

(defun aidermacs--add-extra-args (args)
  "Append ARGS to `aidermacs-extra-args'."
  (setq aidermacs-extra-args (append aidermacs-extra-args args)))

(defun aidermacs--cecli-tui-config-json ()
  "Return cecli TUI config JSON."
  (let* ((color (lambda (key) (alist-get key aidermacs-cecli-tui-colors)))
         (config
          (list
           (cons "colors"
                 (mapcar
                  (lambda (key)
                    (cons (symbol-name key) (funcall color key)))
                  aidermacs--cecli-tui-color-keys))
           (cons "other"
                 (list
                  (cons "dark" t)
                  (cons "use_terminal_background" nil)))
           (cons "key_bindings"
                 (list
                  (cons "paste" "ctrl+v")
                  (cons "output_up" "alt+k")
                  (cons "output_down" "alt+j")
                  (cons "cancel" "alt+c"))))))
    (json-encode config)))

(defun aidermacs--configure-aider ()
  "Configure aidermacs for standard Aider."
  (setq aidermacs-default-chat-mode 'ask
        aidermacs-default-model aidermacs--model-strong
        aidermacs-weak-model aidermacs--model-weak
        aidermacs-editor-model aidermacs--model-weak
        aidermacs-architect-model aidermacs--model-strong)
  (aidermacs--add-extra-args aidermacs--aider-extra-args))

(defun aidermacs--configure-cecli ()
  "Configure aidermacs for cecli."
  (setq aidermacs-program "cecli"
        aidermacs-default-model nil
        aidermacs-weak-model nil
        aidermacs-editor-model nil
        aidermacs-architect-model nil
        aidermacs-default-chat-mode nil)
  (aidermacs--add-extra-args aidermacs--cecli-extra-args)
  (setenv "CECLI_TUI_CONFIG" (aidermacs--cecli-tui-config-json)))

(use-package aidermacs
  :straight (aidermacs :type git :host github :repo "MatthewZMD/aidermacs")
  :custom
  (aidermacs-backend 'vterm)
  (aidermacs-vterm-multiline-newline-key "S-<return>")
  (aidermacs-vterm-use-theme-colors 'off)
  :config
  (when-let ((key (ai-deepseek-key)))
    (setenv "DEEPSEEK_API_KEY" key))

  (if aidermacs-use-cecli
      (aidermacs--configure-cecli)
    (aidermacs--configure-aider)))
