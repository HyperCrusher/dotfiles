(use-package gptel
  :init
  (let* ((key-path (expand-file-name "deepseek-key.txt" user-emacs-directory))
         (key (when (file-exists-p key-path)
                (with-temp-buffer
                  (insert-file-contents key-path)
                  (string-trim (buffer-string))))))
    (setq
     gptel-default-mode 'org-mode
     gptel-model 'deepseek-v4-flash
     gptel-backend (gptel-make-deepseek "DeepSeek Flash"
                     :key key
                     :stream t
                     :models '("deepseek-v4-flash")
                     :request-params '(:thinking (:type "disabled")))
     gptel-pro-backend (gptel-make-deepseek "DeepSeek Pro"
                         :key key
                         :stream t
                         :models '("deepseek-v4-pro")
                         :request-params '(:thinking (:type "enabled")))))
  :config
  (setq gptel-hide-reasoning t)
  (add-hook 'gptel-post-response-functions #'gptel-end-of-response))

(defun gpt-chat ()
  (interactive)
  (setq-local gptel-model 'deepseek-v4-flash)
  (call-interactively #'gptel))

(defun gpt-mode ()
  (interactive)
  (if (eq gptel-model 'deepseek-v4-flash)
      (progn
        (setq-local gptel-model 'deepseek-v4-pro)
        (setq-local gptel-backend gptel-pro-backend))
    (setq-local gptel-model 'deepseek-v4-flash)
    (setq-local gptel-backend gptel-backend)))

(defun gpt-add (file)
  (interactive "fAdd file to gptel context: ")
  (gptel-add-file file))

(defun gpt-clear ()
  (interactive)
  (let ((gptel-context--confirm-remove nil))
    (gptel-context-remove-all)))

(defun gpt-commit ()
  (interactive)
  (call-interactively #'gptel-commit))

(use-package gptel-commit
  :after (gptel magit)
  :config
  (setq gptel-commit-stream nil
        gptel-commit-model 'deepseek-v4-flash)
  :init
  (setq gptel-commit-prompt
        "Generate a Git commit message following conventional style rules.

OUTPUT FORMAT:
- Subject line only (if changes are trivial/single purpose)
- Or subject + blank line + bullet point body (for multiple changes)

SUBJECT RULES:
- Past tense, imperative mood (e.g., 'Fix bug' not 'Fixes bug' or 'Fixed bug')
- Max 50 characters
- Capitalize first letter
- No trailing period
- Single specific change per subject

BODY RULES (when needed):
- Only include if changes need explanation beyond subject
- Wrap at 72 characters
- One bullet point per logical change
- No redundant restatement of subject

EXAMPLES:

Fix memory leak in cache cleanup

- Add null check before freeing pointer
- Reset reference count to zero

Add validation for email input

Update README formatting

DO NOT:
- Include explanatory text, commentary, or the diff
- Repeat the subject in the body
- Use markdown or code blocks
- Write multi-paragraph prose"))

(defun gptel-complete-function ()
  (interactive)
  (if (use-region-p)
      (let ((gptel-system-message "You are a professional systems programmer. Complete the provided function signature. Return ONLY the code for the function body and signature. No explanations, no markdown blocks, and no commentary."))
        (gptel-rewrite (region-beginning) (region-end) 
                       :directive "Complete the function using the provided signature"))
    (user-error "Please highlight a function signature first")))
