(defvar ml-font-scale-factor 1.1
  "The factor by which font in the modeline is scaled (matches your theme setting).")

(defvar ml-special-modes '(vterm-mode magit-mode magit-status-mode magit-log-mode magit-diff-mode magit-process-mode)
  "List of modes where minimal mode-line should be used.")

(defun ml-scaled-spaces (count)
  "Return COUNT spaces compensated for font scaling."
  (make-string (ceiling (/ count ml-font-scale-factor)) ? ))

(defvar ml-element-spacing (ml-scaled-spaces 2)
  "Spacing string to use between mode-line elements.")

(defvar ml-section-spacing (ml-scaled-spaces 4)
  "Larger spacing string to use between mode-line sections.")

(defun ml-use-minimal-mode-line-p ()
  "Return t if current buffer should use the minimal mode-line."
  (apply #'derived-mode-p ml-special-modes))

(defun mode-line-fill (reserve)
  "Return empty space leaving RESERVE space on the right, with extra buffer for scaled fonts."
  (let ((extra-space 1)) ; Add extra buffer space to prevent cutoff
    (propertize " "
                'display `((space :align-to (- (+ right right-fringe right-margin) 
                                               ,(+ reserve extra-space)))))))

(defun ml-word-count ()
  "Count the number of words in the current buffer."
  (if (or (derived-mode-p 'org-mode)
          (derived-mode-p 'markdown-mode))
      (let ((wc (count-words (point-min) (point-max))))
        (format "%d word%s" wc (if (= wc 1) "" "s")))
    ""))

(defun ml-format-time ()
  "Format time in 12-hour format with lowercase am/pm."
  (let ((hour (string-to-number (format-time-string "%I")))
        (min (format-time-string "%M"))
        (am-pm (downcase (format-time-string "%p"))))
    (format "%d:%s %s" hour min am-pm)))

(defface ml-gptel-face
  '((t (:foreground "blue" :weight bold)))
  "Face for gptel model display in mode line.")

(defvar ml-gptel-model
  '(:eval (when (and (bound-and-true-p gptel-mode)
                     (bound-and-true-p gptel-model))
            (propertize (format "  %s  " gptel-model)
                        'face 'ml-gptel-face)))
  "Mode-line element showing the current gptel model.")

(defface ml-git-face
  '((t (:foreground "green" :weight normal)))
  "Face for Git branch indicator when a branch exists.")

(defface ml-git-none-face
  '((t (:foreground "gray50")))
  "Face for Git branch indicator when no branch exists.")

(defface ml-buffer-face
  '((t (:inherit mode-line-buffer-id)))
  "Face for buffer name in mode line when buffer is unmodified.")

(defface ml-buffer-modified-face
  '((t (:inherit mode-line-buffer-id :foreground "orange red")))
  "Face for buffer name in mode line when buffer has unsaved changes.")

(defface ml-readonly-face
  '((t (:foreground "orange" :weight normal)))
  "Face for read-only indicator in mode line.")

(defface ml-flycheck-error-face
  '((t (:foreground "red")))
  "Face for flycheck error count in mode line.")

(defface ml-flycheck-warning-face
  '((t (:foreground "orange")))
  "Face for flycheck warning count in mode line.")

(defface ml-flycheck-default-face
  '((t (:foreground "gray60")))
  "Face for flycheck counts when zero in mode line.")

(defface ml-word-count-face
  '((t (:foreground "cyan")))
  "Face for word count in mode line.")

(defface ml-major-mode-face
  '((t (:foreground "medium sea green")))
  "Face for major mode indicator in mode line.")

(defface ml-time-face
  '((t (:foreground "gray70")))
  "Face for time display in mode line.")

;; Git indicator
(defvar ml-git
  '(:eval (if vc-mode
              (let* ((branch-name (replace-regexp-in-string
                                   "^\\s-*\\(Git\\|SVN\\|HG\\):?-?"
                                   ""
                                   vc-mode)))
                (propertize (format " %s " branch-name) 'face 'ml-git-face))
            (propertize " NONE " 'face 'ml-git-none-face)))
  "Version control for the mode line.")

;; Buffer name
(defvar ml-buffer
  '(:eval (propertize (format "  %s  " (buffer-name))
                      'face (if (buffer-modified-p)
                                'ml-buffer-modified-face
                              'ml-buffer-face)))
  "Buffer name with different faces for modified/unmodified states.")

;; Read-only indicator (separate from buffer name)
(defvar ml-readonly
  '(:eval (if buffer-read-only
              (propertize "[Read only]" 'face 'ml-readonly-face)
            ""))
  "Read-only status indicator.")

;; Flycheck indicators
(defvar ml-flycheck
  '(:eval (let ((counts (ml-flycheck-counts)))
            (if (not (string= counts ""))
                (format "%s%s"
                        ml-element-spacing
                        counts)
              "")))
  "Flycheck errors/warnings.")

(defun ml-flycheck-counts ()
  "Get flycheck error/warning counts for current buffer only."
  (if (and (derived-mode-p 'prog-mode) (boundp 'flycheck-mode) flycheck-mode)
      (let ((error-count 0)
            (warning-count 0))
        (when (boundp 'flycheck-current-errors)
          (dolist (err flycheck-current-errors)
            (pcase (flycheck-error-level err)
              ('error (setq error-count (1+ error-count)))
              ('warning (setq warning-count (1+ warning-count))))))
        (format "%s%s"
                (propertize (format "%s %d%s" ml-element-spacing error-count ml-element-spacing)
                            'face 'ml-flycheck-error-face)
                (propertize (format " %d%s" warning-count ml-element-spacing)
                            'face 'ml-flycheck-warning-face)))
    ""))

;; Word count
(defvar ml-word-count
  '(:eval (let ((count (ml-word-count)))
            (if (not (string= count ""))
                (propertize (format "%s " count) 'face 'ml-word-count-face)
              "")))
  "Word count element for mode line.")

;; Major mode
(defvar ml-major-mode
  '(:eval
    (let ((mode-name-str (if (listp mode-name)
                             (format-mode-line mode-name)
                           (format "%s" mode-name))))
      (setq mode-name-str (substring-no-properties mode-name-str))
      (setq mode-name-str (replace-regexp-in-string " .*$" "" mode-name-str))
      (setq mode-name-str (replace-regexp-in-string "[^a-zA-Z0-9 -]" "" mode-name-str))
      (setq mode-name-str (format "  %s  " mode-name-str))
      (propertize mode-name-str 'face 'ml-major-mode-face)))
  "Major mode element for mode line.")

;; Time display
(defvar ml-time
  '(:eval (propertize (format " %s" (ml-format-time)) 'face 'ml-time-face))
  "Time element for mode line.")

(defvar ml-standard-left
  (list "%e"
        mode-line-front-space
        ml-git
        " "
        ml-buffer
        ml-readonly
        ml-flycheck
        ml-section-spacing)
  "Left side components for standard mode line.")

(defvar ml-standard-right
  (list ml-major-mode
        ml-gptel-model
        " "
        ml-word-count
        ml-time)
  "Right side components for standard mode line.")

(defvar ml-minimal-left
  (list "%e"
        mode-line-front-space
        ml-git)
  "Left side components for minimal mode line.")

(defvar ml-minimal-right
  (list ml-major-mode
        ml-time)
  "Right side components for minimal mode line.")

(defun ml-format-right-side (components)
  "Format the right side of the mode line from COMPONENTS."
  (let ((result ""))
    (dolist (component components)
      (setq result (concat result (format-mode-line component))))
    result))

(defun ml-make-mode-line (left-components right-components)
  "Construct a mode line with LEFT-COMPONENTS and RIGHT-COMPONENTS."
  `(,@left-components
    (:eval
     (let* ((right-content (ml-format-right-side ',right-components))
            (right-length (+ (length right-content) 2)))
       (list (mode-line-fill right-length)
             right-content)))))

(defvar ml-standard-mode-line
  (ml-make-mode-line ml-standard-left ml-standard-right)
  "Complete standard mode line format.")

(defvar ml-minimal-mode-line
  (ml-make-mode-line ml-minimal-left ml-minimal-right)
  "Complete minimal mode line format.")

(defun ml-update-mode-lines ()
  "Update the mode line formats from their components."
  (setq ml-standard-mode-line (ml-make-mode-line ml-standard-left ml-standard-right))
  (setq ml-minimal-mode-line (ml-make-mode-line ml-minimal-left ml-minimal-right))
  (force-mode-line-update t))

(defun ml-set-appropriate-mode-line ()
  "Set the appropriate mode line based on the current buffer's mode."
  (setq mode-line-format
        (if (ml-use-minimal-mode-line-p)
            ml-minimal-mode-line
          ml-standard-mode-line)))

(defun ml-standard-left-add (component &optional position)
  "Add COMPONENT to ml-standard-left at POSITION (or end if nil)."
  (if position
      (setq ml-standard-left
            (append (seq-take ml-standard-left position)
                    (list component)
                    (seq-drop ml-standard-left position)))
    (setq ml-standard-left (append ml-standard-left (list component))))
  (ml-update-mode-lines))

(defun ml-standard-right-add (component &optional position)
  "Add COMPONENT to ml-standard-right at POSITION (or end if nil)."
  (if position
      (setq ml-standard-right
            (append (seq-take ml-standard-right position)
                    (list component)
                    (seq-drop ml-standard-right position)))
    (setq ml-standard-right (append ml-standard-right (list component))))
  (ml-update-mode-lines))

(defun ml-minimal-left-add (component &optional position)
  "Add COMPONENT to ml-minimal-left at POSITION (or end if nil)."
  (if position
      (setq ml-minimal-left
            (append (seq-take ml-minimal-left position)
                    (list component)
                    (seq-drop ml-minimal-left position)))
    (setq ml-minimal-left (append ml-minimal-left (list component))))
  (ml-update-mode-lines))

(defun ml-minimal-right-add (component &optional position)
  "Add COMPONENT to ml-minimal-right at POSITION (or end if nil)."
  (if position
      (setq ml-minimal-right
            (append (seq-take ml-minimal-right position)
                    (list component)
                    (seq-drop ml-minimal-right position)))
    (setq ml-minimal-right (append ml-minimal-right (list component))))
  (ml-update-mode-lines))

(add-hook 'buffer-list-update-hook 'ml-set-appropriate-mode-line)
(add-hook 'after-change-major-mode-hook 'ml-set-appropriate-mode-line)

;; Initialize the mode line
(ml-set-appropriate-mode-line)

(defvar ml-update-timer nil
  "Timer for updating the mode line.")

(when (timerp ml-update-timer)
  (cancel-timer ml-update-timer)
  (setq ml-update-timer nil))

(defun update-mode-line ()
  "Force update of the mode line."
  (ml-update-mode-lines))

(setq ml-update-timer (run-with-timer 0 60 'update-mode-line))
