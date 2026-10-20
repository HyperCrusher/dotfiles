;;; -*- lexical-binding: t; -*-

(with-eval-after-load 'gptel
  (general-define-key
   :states 'normal
   :keymaps 'gptel-mode-map
   :prefix "g"
   "m" 'ai-mode))

(with-eval-after-load 'gptel
  (general-define-key
   :states 'normal
   :keymaps 'gptel-mode-map
   "S-<return>" #'gptel-send))

(with-eval-after-load 'aidermacs
  (general-define-key
   :states 'normal
   :prefix "SPC"
   "a" 'aidermacs-transient-menu))
