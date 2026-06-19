(defgroup smart-compile nil
  "Smart compile with per-project command persistence."
  :group 'tools)

(defun scompile-root ()
  (expand-file-name
   (or (and (fboundp 'projectile-project-root)
            (projectile-project-root))
       (and (fboundp 'project-current)
            (when-let ((proj (project-current)))
              (project-root proj)))
       default-directory)))

(defun scompile-file (root)
  (expand-file-name ".scompile" root))

(defun scompile-read-command (root)
  (let ((file (scompile-file root)))
    (when (file-exists-p file)
      (with-temp-buffer
        (insert-file-contents file)
        (let ((cmd (string-trim (buffer-string))))
          (unless (string-empty-p cmd) cmd))))))

(defun scompile-write-command (root command)
  (let ((file (scompile-file root)))
    (with-temp-file file
      (insert command))))

(defun scompile-delete-command (root)
  (let ((file (scompile-file root)))
    (when (file-exists-p file)
      (delete-file file))))

(defun scompile (arg)
  (interactive "P")
  (let* ((root (scompile-root))
         (existing (unless arg (scompile-read-command root)))
         (raw-command (or existing
                          (read-from-minibuffer
                           "Compile command: "
                           (or existing compile-command "make -j")))))
    (unless (equal raw-command existing)
      (scompile-write-command root raw-command))
    (let ((default-directory root)
          (full-command (format "cd %s && %s" (shell-quote-argument root) raw-command)))
      (compile full-command))))

(defun scompile-clear ()
  (interactive)
  (let* ((root (scompile-root))
         (file (scompile-file root)))
    (if (file-exists-p file)
        (progn
          (delete-file file)
          (message "Removed compile command from %s" root))
      (message "No saved compile command in %s" root))))

(defun scompile-edit ()
  (interactive)
  (let* ((root (scompile-root))
         (file (scompile-file root)))
    (unless (file-exists-p file)
      (scompile-write-command root (or compile-command "make -j")))
    (find-file file)))
