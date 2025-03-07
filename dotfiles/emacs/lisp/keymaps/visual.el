;; Helper functions for visual mode
(defun evil-shift-left-visual ()
  (interactive)
  (evil-shift-left (region-beginning) (region-end))
  (evil-normal-state)
  (evil-visual-restore))

(defun evil-shift-right-visual ()
  (interactive)
  (evil-shift-right (region-beginning) (region-end))
  (evil-normal-state)
  (evil-visual-restore))

;; Visual mode bindings
(general-define-key
 :states 'visual
 :keymaps 'global
 ">"        'evil-shift-right-visual
 "<"        'evil-shift-left-visual
 "J"        'drag-stuff-down
 "K"        'drag-stuff-up
 [tab]      'evil-shift-right-visual
 [S-tab]    'evil-shift-left-visual)

;;; Clipboard isolation for delete and visual paste only
(fset 'evil-visual-update-x-selection 'ignore)
