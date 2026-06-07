(defun load-directory (dir)
  "Load all Emacs Lisp files in DIR and its subdirectories."
  (let* ((dir-path (expand-file-name dir user-emacs-directory))
         (default-directory dir-path)) ;; Bind default-directory locally
    (when (file-directory-p dir-path)
      (normal-top-level-add-to-load-path (list dir-path))
      ;; This now only scans subdirs of dir-path
      (normal-top-level-add-subdirs-to-load-path) 
      (dolist (file (directory-files-recursively dir-path "\\.el$"))
        (load (file-name-sans-extension file))))))

;; Load config in order
(load-directory "lisp/core")
(load-directory "lisp/modules")

;; Load keymaps in specific order
(load (expand-file-name "lisp/keymaps/base.el" user-emacs-directory))
(load-directory "lisp/keymaps")

;; Run post-init steps
(load (expand-file-name "lisp/post-init.el" user-emacs-directory))
