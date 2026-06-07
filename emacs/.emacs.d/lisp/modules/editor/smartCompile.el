(defgroup smart-compile nil
  "Smart compile with per-project command persistence."
  :group 'tools)

(defcustom smart-compile-commands nil
  "Alist mapping directory paths to compile commands.
Each element is (DIRECTORY . COMMAND) where DIRECTORY is the
project root or file directory, and COMMAND is the compile command."
  :type '(alist :key-type directory :value-type string)
  :group 'smart-compile)

(defun smart-compile--get-key ()
  "Return the key for storing the compile command.
Uses project root if in a project, otherwise the buffer's default directory."
  (expand-file-name
   (or (when (fboundp 'project-current)
         (when-let ((proj (project-current)))
           (project-root proj)))
       default-directory)))

(defun smart-compile (arg)
  "Compile with persistent per-project command.
With prefix ARG, force prompt for new command."
  (interactive "P")
  (let* ((key (smart-compile--get-key))
         (existing (assoc key smart-compile-commands))
         (command (unless arg (cdr existing))))
    (unless command
      (setq command (read-from-minibuffer 
                     "Compile command: "
                     (or command compile-command "make")))
      (when existing
        (setq smart-compile-commands 
              (delete existing smart-compile-commands)))
      (push (cons key command) smart-compile-commands)
      (customize-save-variable 'smart-compile-commands 
                               smart-compile-commands))
    (compile command)))

(defun smart-compile-clear ()
  "Clear the stored compile command for current project/directory.
Next run will prompt for a new command."
  (interactive)
  (let* ((key (smart-compile--get-key))
         (existing (assoc key smart-compile-commands)))
    (when existing
      (setq smart-compile-commands 
            (delete existing smart-compile-commands))
      (customize-save-variable 'smart-compile-commands 
                               smart-compile-commands)
      (message "Cleared compile command for %s" key))))

(defun smart-compile-edit ()
  "Edit all stored compile commands."
  (interactive)
  (customize-variable 'smart-compile-commands))
