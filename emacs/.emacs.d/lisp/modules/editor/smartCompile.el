(defgroup smart-compile nil
  "Smart compile with per-project command persistence."
  :group 'tools)

(defcustom smart-compile-commands nil
  "Alist mapping directory paths to compile commands."
  :type '(alist :key-type directory :value-type string)
  :risky t
  :group 'smart-compile)

(defun smart-compile--get-key ()
  (expand-file-name
   (or (when-let ((proj (project-current)))
         (project-root proj))
       default-directory)))

(defun smart-compile--save ()
  (customize-save-variable 'smart-compile-commands smart-compile-commands))

(defun smart-compile (arg)
  (interactive "P")
  (let* ((key (smart-compile--get-key))
         (existing (assoc key smart-compile-commands))
         (command (if arg nil (cdr existing))))
    (unless command
      (setq command (read-from-minibuffer "Compile command: "
                                          (or (cdr existing) compile-command "make -j")))
      (if existing
          (setcdr existing command)
        (push (cons key command) smart-compile-commands))
      (smart-compile--save))
    (compile command)))

(defun smart-compile-clear ()
  (interactive)
  (let* ((key (smart-compile--get-key))
         (existing (assoc key smart-compile-commands)))
    (when existing
      (setq smart-compile-commands (delete existing smart-compile-commands))
      (smart-compile--save)
      (message "Cleared compile command for %s" key))))

(defun smart-compile-edit ()
  (interactive)
  (customize-variable 'smart-compile-commands))
