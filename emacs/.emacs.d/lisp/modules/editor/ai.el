(use-package gptel
  :init
  (let ((key-path (expand-file-name "gemini-key.txt" user-emacs-directory)))
    (setq
     gptel-model 'gemini-pro-latest
     gptel-backend (gptel-make-gemini "Gemini"
                     :key (when (file-exists-p key-path)
                            (with-temp-buffer
                              (insert-file-contents key-path)
                              (string-trim (buffer-string))))
                     :stream t))))
(use-package gptel-commit
  :after (gptel magit)
  :custom
  (gptel-commit-stream nil)
  (gptel-commit-model 'gemini-flash-latest)
  (add-hook 'gptel-post-stream-hook 'gptel-auto-scroll)
  (add-hook 'gptel-post-response-functions 'gptel-end-of-response)
  :init
  (setq gptel-commit-prompt
        "You are an expert at writing Git commits. Your job is to write a short clear commit message that summarizes the changes.
Don't repeat information from the subject line in the message body.
Only return the commit message in your response. Do not include any additional meta-commentary about the task. Do not include the raw diff output in the commit message.

Follow good Git style:

- Separate the subject from the body with a blank line
- Use Past tense to describe changes
- Try to limit the subject line to 50 characters
- Capitalize the subject line
- Do not end the subject line with any punctuation
- Wrap the body at 72 characters
- Keep the body short and concise (omit it entirely if not useful)"))

(defun gptel-complete-function ()
  "Take the selected function signature and ask gptel to complete it in-place."
  (interactive)
  (if (use-region-p)
      (let ((gptel-system-message "You are a professional systems programmer. Complete the provided function signature. Return ONLY the code for the function body and signature. No explanations, no markdown blocks, and no commentary."))
        (gptel-rewrite (region-beginning) (region-end) 
                       :directive "Complete the function using the provided signature."))
    (message "Please highlight a function signature first.")))
