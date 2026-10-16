;;; -*- lexical-binding: t; -*-

(defun gptel-smart-enter ()
  (interactive)
  (if (save-excursion
        (beginning-of-line)
        (looking-at-p "^\\*+ "))
      (call-interactively #'gptel-send)
    (newline)))

(with-eval-after-load 'gptel
  (general-define-key
   :states 'normal
   :keymaps 'gptel-mode-map
   "gm" 'ai-mode)

  (general-define-key
   :states 'insert
   :keymaps 'gptel-mode-map
   "<return>" 'gptel-smart-enter))
