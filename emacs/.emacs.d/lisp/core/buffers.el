;; Buffer names
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward
      uniquify-separator "/"
      uniquify-after-kill-buffer-p t)

;; Buffer behavior
(setq global-auto-revert-non-file-buffers t
      auto-revert-verbose nil
      kill-buffer-query-functions nil)

;; Scratch buffer
(setq initial-scratch-message ""
      initial-major-mode 'fundamental-mode)
