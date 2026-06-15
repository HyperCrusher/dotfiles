(use-package gptel
  :init
  (let ((key-path (expand-file-name "deepseek-key.txt" user-emacs-directory)))
    (setq
     gptel-model 'deepseek-chat
     gptel-backend (gptel-make-deepseek "DeepSeek"
                     :key (when (file-exists-p key-path)
                            (with-temp-buffer
                              (insert-file-contents key-path)
                              (string-trim (buffer-string))))
                     :stream t
                     :models '("deepseek-chat" "deepseek-reasoner"))))
  :config
  (setq gptel-hide-reasoning t)
  (add-hook 'gptel-post-response-functions #'gptel-end-of-response))

(defun gpt-chat ()
  (interactive)
  (setq-local gptel-model 'deepseek-chat)
  (call-interactively #'gptel))

(defun gpt-mode-flash ()
  (interactive)
  (setq-local gptel-model 'deepseek-chat))

(defun gpt-mode-thinking ()
  (interactive)
  (setq-local gptel-model 'deepseek-reasoner))

(defun gpt-commit ()
  (interactive)
  (call-interactively #'gptel-commit))

(use-package gptel-commit
  :after (gptel magit)
  :config
  (setq gptel-commit-stream nil
        gptel-commit-model 'deepseek-chat)
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
