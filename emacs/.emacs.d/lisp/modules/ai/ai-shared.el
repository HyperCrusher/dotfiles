;;; -*- lexical-binding: t; -*-

(defvar ai-env-file (expand-file-name ".env" user-emacs-directory))

(defun ai-env-value (key)
  (when (file-exists-p ai-env-file)
    (with-temp-buffer
      (insert-file-contents ai-env-file)
      (let ((case-fold-search t))
        (when (re-search-forward
               (format "^%s[ \t]*=[ \t]*\\(.*\\)$" (regexp-quote key))
               nil t)
          (let ((value (string-trim (match-string 1))))
            (cond
             ((string-match "\\`\"\\(.*\\)\"\\'" value)
              (match-string 1 value))
             ((string-match "\\`'\\(.*\\)'\\'" value)
              (match-string 1 value))
             (t value))))))))

(defun ai-deepseek-key ()
  (or (getenv "DEEPSEEK_API_KEY")
      (ai-env-value "DEEPSEEK_API_KEY")))

(provide 'ai-shared)
