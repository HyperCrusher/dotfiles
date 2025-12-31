;; Due to the high amount of customizations we will be splitting
;; Up the org-modern config

;; Define neutral faces for theme customization
(defface org-checkbox-cancelled-face
  '((t ()))
  "Face for cancelled checkboxes [>].")

(defface org-checkbox-info-face
  '((t ()))
  "Face for info checkboxes [i].")

(defface org-checkbox-urgent-face
  '((t ()))
  "Face for urgent checkboxes [!].")

(defface org-checkbox-quickwin-face
  '((t ()))
  "Face for quick win checkboxes [q].")

(defface org-checkbox-depends-face
  '((t ()))
  "Face for dependent checkboxes [d].")

(defface org-checkbox-blocked-face
  '((t ()))
  "Face for blocked checkboxes [b].")

(defface org-checkbox-archived-face
  '((t ()))
  "Face for archived checkboxes [a].")

(defface org-checkbox-uncertain-face
  '((t ()))
  "Face for uncertain checkboxes [?].")

(defun org-modern-special-checkboxes ()
  (font-lock-add-keywords
   nil
   '(("\\(\\[\\(>\\)\\]\\)" ;; [>]
      (0 (progn
           (compose-region (match-beginning 0) (match-end 0) "")
           'org-checkbox-cancelled-face)))

     ("\\(\\[\\(i\\)\\]\\)" ;; [i]
      (0 (progn
           (compose-region (match-beginning 0) (match-end 0) "")
           'org-checkbox-info-face)))

     ("\\(\\[\\(!\\)\\]\\)" ;; [!]
      (0 (progn
           (compose-region (match-beginning 0) (match-end 0) "")
           'org-checkbox-urgent-face)))

     ("\\(\\[\\(q\\)\\]\\)" ;; [q]
      (0 (progn
           (compose-region (match-beginning 0) (match-end 0) "")
           'org-checkbox-quickwin-face)))

     ("\\(\\[\\(d\\)\\]\\)" ;; [d]
      (0 (progn
           (compose-region (match-beginning 0) (match-end 0) "")
           'org-checkbox-depends-face)))

     ("\\(\\[\\(b\\)\\]\\)" ;; [b]
      (0 (progn
           (compose-region (match-beginning 0) (match-end 0) "")
           'org-checkbox-blocked-face)))

     ("\\(\\[\\(a\\)\\]\\)" ;; [a]
      (0 (progn
           (compose-region (match-beginning 0) (match-end 0) "󱉟")
           'org-checkbox-archived-face)))

     ("\\(\\[\\(\\?\\)\\]\\)" ;; [?]
      (0 (progn
           (compose-region (match-beginning 0) (match-end 0) "")
           'org-checkbox-uncertain-face))))))


(use-package org-modern
  :after org
  :hook ((org-mode . org-modern-mode)
         (org-mode . org-modern-special-checkboxes))
  :config
  (setq org-modern-hide-stars nil
        org-modern-star nil
        org-modern-block-name nil
        org-modern-list '((?+ . "")
                          (?- . " ")
                          (?* . " "))
        org-modern-checkbox '((?X . "")
                              (?- . "")
                              (?\s . ""))))
