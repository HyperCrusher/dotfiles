(defvar my/org-special-checkbox-alist
  '((">" "" org-checkbox-cancelled-face)
    ("i" "" org-checkbox-info-face)
    ("!" "" org-checkbox-urgent-face)
    ("q" "" org-checkbox-quickwin-face)
    ("d" "" org-checkbox-depends-face)
    ("b" "" org-checkbox-blocked-face)
    ("a" "󱉟" org-checkbox-archived-face)
    ("?" "" org-checkbox-uncertain-face)))

(defun org-modern-special-checkboxes ()
  (let ((rules
         `(("^\\s-*\\([-+*][ \t]+\\)\\[[^]]*\\]"
            (1 '(face nil display "") prepend)))))
    (dolist (item my/org-special-checkbox-alist)
      (let ((char (nth 0 item))
            (icon (nth 1 item))
            (face (nth 2 item)))
        (push `(,(format "^\\s-*\\([-+*][ \t]+\\)\\(\\[\\(%s\\)\\]\\)" (regexp-quote char))
                (2 (progn (compose-region (match-beginning 2) (match-end 2) ,icon) ',face) append))
              rules)))
    (font-lock-add-keywords nil (reverse rules) t)))

(use-package org-modern
  :after org
  :hook ((org-mode . org-modern-mode)
         (org-mode . org-modern-special-checkboxes))
  :config
  (setq org-modern-hide-stars nil
        org-modern-star nil
        org-modern-block-name nil
        org-modern-list '((?+ . " ") (?- . " ") (?* . " "))
        org-modern-checkbox '((?X . "") (?- . "") (?\s . ""))))
