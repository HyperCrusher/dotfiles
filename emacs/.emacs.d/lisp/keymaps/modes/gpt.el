(with-eval-after-load 'gptel
  (add-hook 'gptel-mode-hook
            (lambda ()
              (define-key evil-insert-state-local-map (kbd "<return>") #'gptel-send)))

  (general-define-key
   :prefix "g"
   :states '(normal visual motion)
   "m" #'gpt-mode
   "s" #'gptel-system-prompt
   "p" #'gptel-org-set-properties))
