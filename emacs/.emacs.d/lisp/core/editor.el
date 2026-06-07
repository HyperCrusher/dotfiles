;; Core editor behavior
(setq-default
 indent-tabs-mode nil
 cursor-in-non-selected-windows nil
 truncate-lines t
 tab-width 2
 confirm-kill-processes nil
 require-final-newline t
 vc-follow-symlinks t)

;; Line numbers
(setq display-line-numbers-type 'relative)
(setopt display-line-numbers-width-start t)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Visual aids
(global-prettify-symbols-mode)
(electric-pair-mode t)
(show-paren-mode 1)
(set-display-table-slot standard-display-table 'truncation ?\ )

;; Search behavior
(setq-default case-fold-search t)

;; Better defaults
(fset 'yes-or-no-p 'y-or-n-p)
(setq echo-keystrokes 0.1
      use-dialog-box nil
      visible-bell nil
      ring-bell-function 'ignore)
(setf (cdr (assq 'truncation fringe-indicator-alist)) '(nil nil))
