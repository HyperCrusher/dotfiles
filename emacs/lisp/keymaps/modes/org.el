(defun org-smart-enter ()
  (interactive)
  (cond
   ;; If on a checkbox, toggle it
   ((org-at-item-checkbox-p)
    (org-toggle-checkbox))
   ;; If on a headline, toggle TODO state
   ((org-at-heading-p)
    (org-todo))
   ;; If on a footnote reference, jump to its definition using org-open-at-point
   ((and (fboundp 'org-element-context)
         (let ((context (org-element-context)))
           (eq (org-element-type context) 'footnote-reference)))
    (org-open-at-point))
   ;; If on a link, follow it (also using org-open-at-point)
   ((org-in-regexp org-link-any-re 1)
    (org-open-at-point))
   ;; Otherwise do nothing special
   (t nil)))

(defun org-check ()
  "Transform checkbox at point by prompting for a character.
Possible states:
- ' ' (space): Empty checkbox [ ]
- 'X': Checked checkbox [X]
- '?': Uncertain checkbox [?]
- '>': Cancelled/Forwarded checkbox [>]
- 'i': Info checkbox [i]
- '!': Urgent checkbox [!]
- 'q': Quick-win checkbox [q]
- 'd': Depends checkbox [d]
- 'b': Blocked checkbox [b]
- 'a': Archived checkbox [a]"
  (interactive)
  (save-excursion
    (beginning-of-line)
    (when (re-search-forward "\\(\\[.\\]\\)" (line-end-position) t)
      (let ((new-state (read-char "Enter checkbox state (space/X/?/>/!/iqdba): ")))
        (when (= new-state ?\s)
          (setq new-state ? ))
        (backward-char 2)
        (delete-char 1)
        (insert-char new-state)))))

(with-eval-after-load 'org
  (general-define-key
   :keymaps 'org-mode-map
   :states 'normal
   "C-k" 'evil-window-up
   "C-j" 'evil-window-down
   "<return>" 'org-smart-enter
   ">" 'org-do-demote
   "<" 'org-do-promote
   )
  (general-define-key
   :states 'normal
   :keymaps 'org-mode-map
   "C-c" 'org-check
   "SPC h" 'org-toggle-heading))
