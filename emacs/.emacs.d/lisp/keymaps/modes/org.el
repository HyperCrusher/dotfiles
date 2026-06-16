(defun hyper/insert-block (type &optional extra-meta)
  (interactive (list (read-string "Block type: ")))
  (if (use-region-p)
      (let ((beg (region-beginning))
            (end (region-end)))
        (save-excursion
          (goto-char end)
          (unless (bolp) (insert "\n"))
          (insert (format "#+end_%s\n" type))
          (goto-char beg)
          (insert (format "#+begin_%s%s\n" type (or extra-meta ""))))
        (deactivate-mark))
    (progn
      (insert (format "\n#+begin_%s%s\n\n#+end_%s" type (or extra-meta "") type))
      (forward-line -1)
      (when (featurep 'evil) (evil-insert-state))))
  (org-mode-restart))

(defun hyper/insert-src-block ()
  (interactive)
  (let* ((lang (read-string "Language: "))
         (tangle (completing-read "Tangle? " '("yes" "no")))
         (tangle-file (when (string= tangle "yes") (read-string "Tangle to file: ")))
         (meta (concat " " lang (when tangle-file (format " :tangle %s" tangle-file)))))
    (hyper/insert-block "src" meta)))

(defun hyper/insert-quote ()   (interactive) (hyper/insert-block "quote"))
(defun hyper/insert-comment () (interactive) (hyper/insert-block "comment"))
(defun hyper/insert-example () (interactive) (hyper/insert-block "example"))

(defun hyper/insert-inline ()
  (interactive)
  (if (use-region-p)
      (let ((beg (region-beginning))
            (end (region-end)))
        (save-excursion
          (goto-char end) (insert "~")
          (goto-char beg) (insert "~"))
        (deactivate-mark))
    (progn
      (insert "~~")
      (backward-char 1)
      (when (featurep 'evil) (evil-insert-state))))
  (org-mode-restart))

(defun hyper/remove-block ()
  (interactive)
  (save-excursion
    (let ((case-fold-search t)
          (beg-re "^[ \t]*#\\+begin_\\(?1:[a-z]+\\)"))
      (if (re-search-backward beg-re nil t)
          (let ((type (match-string 1))
                (beg-pos (line-beginning-position)))
            (if (re-search-forward (format "^[ \t]*#\\+end_%s" type) nil t)
                (progn
                  (delete-region (line-beginning-position) (line-beginning-position 2))
                  (goto-char beg-pos)
                  (delete-region (line-beginning-position) (line-beginning-position 2))
                  (org-mode-restart))
              (message "No matching end tag found.")))
        (message "Not inside an org block.")))))

(defun hyper/link-file ()
  (interactive)
  (let* ((file (read-file-name "File: "))
         (default-desc (file-name-nondirectory file))
         (desc (read-string (format "Description (default %s): " default-desc))))
    (if (string-empty-p desc)
        (insert (format "[[file:%s][%s]]" file default-desc))
      (insert (format "[[file:%s][%s]]" file desc)))))

(defun hyper/link-site ()
  "Prompt for a URL and insert an org link, auto-prepending https://."
  (interactive)
  (let* ((user-input (read-string "URL: "))
         (url (if (string-match-p "^http" user-input)
                  user-input
                (concat "https://" user-input)))
         (desc (read-string (format "Description (default %s): " user-input))))
    (if (string-empty-p desc)
        (insert (format "[[%s][%s]]" url user-input))
      (insert (format "[[%s][%s]]" url desc)))))

(defun hyper/link-mail ()
  (interactive)
  (let* ((mail (read-string "Email: "))
         (desc (read-string (format "Description (default %s): " mail))))
    (if (string-empty-p desc)
        (insert (format "[[mailto:%s][%s]]" mail mail))
      (insert (format "[[mailto:%s][%s]]" mail desc)))))

(defun org-smart-enter ()
  (interactive)
  (cond
   ((org-at-item-checkbox-p) (org-toggle-checkbox))
   ((org-at-heading-p) (org-todo))
   ((and (fboundp 'org-element-context)
         (let ((context (org-element-context)))
           (eq (org-element-type context) 'footnote-reference)))
    (org-open-at-point))
   ((org-in-regexp org-link-any-re 1) (org-open-at-point))
   (t nil)))

(setq org-link-frame-setup
      '((vm . vm-visit-folder-other-frame)
        (vm-imap . vm-visit-imap-folder-other-frame)
        (gnus . org-gnus-no-new-news)
        (file . find-file) 
        (wl . wl-other-frame)))

(defun org-check ()
  (interactive)
  (save-excursion
    (beginning-of-line)
    (when (re-search-forward "\\(\\[.\\]\\)" (line-end-position) t)
      (let ((new-state (read-char "Enter checkbox state (space/X/?/>/!/iqdba): ")))
        (when (= new-state ?\s) (setq new-state ? ))
        (backward-char 2) (delete-char 1) (insert-char new-state)))))

(with-eval-after-load 'org
  (general-define-key
   :keymaps 'org-mode-map
   :states 'normal
   "C-k" 'evil-window-up
   "C-j" 'evil-window-down
   "<return>" 'org-smart-enter
   ">" 'org-do-demote
   "<" 'org-do-promote)

  (general-define-key
   :states 'normal
   :keymaps 'org-mode-map
   "SPC h" 'org-toggle-heading))

(with-eval-after-load 'gptel
  (general-define-key
   :keymaps 'gptel-mode-map
   :states 'insert
   (kbd "<return>") 'gptel-send))

(general-define-key
 :states '(normal visual)
 :keymaps 'org-mode-map
 :prefix "SPC"
 "u c" 'org-check
 "i q" 'hyper/insert-quote
 "i s" 'hyper/insert-src-block
 "i c" 'hyper/insert-comment
 "i e" 'hyper/insert-example
 "i i" 'hyper/insert-inline
 "i r" 'hyper/remove-block)

(general-define-key
 :states 'normal
 :keymaps 'org-mode-map
 :prefix "SPC"
 "l f" 'hyper/link-file
 "l w" 'hyper/link-site
 "l m" 'hyper/link-mail)
