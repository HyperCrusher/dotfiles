(use-package general
  :after evil)

;; Global escape behavior
(defun minibuffer-keyboard-quit ()
  (interactive)
  (if (and delete-selection-mode transient-mark-mode mark-active)
      (setq deactivate-mark t)
    (when (get-buffer "*Completions*")
      (delete-windows-on "*Completions*"))
    (abort-recursive-edit)))

(general-def
  [escape] (lambda ()
             (interactive)
             (cond ((minibuffer-window-active-p (minibuffer-window))
                    (abort-recursive-edit))
                   (t (keyboard-quit)))))

(general-define-key
 :states '(normal visual)
 :keymaps 'override
 "<escape>" 'keyboard-quit)

(general-define-key
 :keymaps '(minibuffer-local-map
            minibuffer-local-ns-map
            minibuffer-local-completion-map
            minibuffer-local-must-match-map
            vertico-map
            minibuffer-local-isearch-map)
 "<escape>" 'minibuffer-keyboard-quit)

(general-define-key
 :keymaps 'transient-map
 "<escape>" 'transient-quit-one)

(general-define-key
 "<escape>" 'evil-exit-emacs-state)

