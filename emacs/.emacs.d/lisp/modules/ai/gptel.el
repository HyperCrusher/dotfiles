;;; -*- lexical-binding: t; -*-

(require 'ai-shared)

(defvar ai-lite-backend nil)
(defvar ai-flash-backend nil)
(defvar ai-pro-backend nil)
(defvar ai-max-backend nil)

(defun ai-init-backends ()
  (require 'gptel)
  (unless ai-lite-backend
    (let ((key (or (ai-deepseek-key)
                   (user-error "DEEPSEEK_API_KEY not found in %s or environment"
                               ai-env-file))))
      (setq ai-lite-backend
            (gptel-make-deepseek "Lite"
                                 :key key
                                 :stream t
                                 :models '("deepseek-v4-flash")
                                 :request-params '(:thinking (:type "disabled")))

            ai-flash-backend
            (gptel-make-deepseek "Flash"
                                 :key key
                                 :stream t
                                 :models '("deepseek-v4-flash")
                                 :request-params nil)

            ai-pro-backend
            (gptel-make-deepseek "Pro"
                                 :key key
                                 :stream t
                                 :models '("deepseek-v4-pro")
                                 :request-params nil)

            ai-max-backend
            (gptel-make-deepseek "Max"
                                 :key key
                                 :stream t
                                 :models '("deepseek-v4-pro")
                                 :request-params '(:thinking (:type "enabled")
                                                            :reasoning_effort "max"))))))

(defun ai-mode (mode-key)
  (interactive
   (list (completing-read "AI mode: "
                          '("lite" "flash" "pro" "max")
                          nil t)))
  (ai-init-backends)
  (pcase mode-key
    ("lite"
     (setq gptel-backend ai-lite-backend
           gptel-model 'deepseek-v4-flash))
    ("flash"
     (setq gptel-backend ai-flash-backend
           gptel-model 'deepseek-v4-flash))
    ("pro"
     (setq gptel-backend ai-pro-backend
           gptel-model 'deepseek-v4-pro))
    ("max"
     (setq gptel-backend ai-max-backend
           gptel-model 'deepseek-v4-pro))
    (_
     (user-error "Unknown AI mode: %s" mode-key))))

(use-package gptel
  :straight (gptel :build (:not compile))
  :custom
  (gptel-default-mode 'org-mode)
  (gptel-max-entries 30)
  :config
  (ai-mode "flash")

  (defun ai-add (&optional file)
    (interactive
     (list (or buffer-file-name
               (when (derived-mode-p 'dired-mode)
                 (dired-get-filename))
               (read-file-name "Add file to gptel context: "))))
    (unless file
      (user-error "No file selected"))
    (gptel-add-file file))

  (defun ai-clear ()
    (interactive)
    (let ((gptel-context--confirm-remove nil))
      (gptel-context-remove-all)))

  (setq gptel-include-reasoning nil)

  (setq gptel-system-prompt
        "You are a large language model living in Emacs and a helpful assistant. Respond concisely.
Follow these rules strictly:

- Never include comments in any code you produce.
- When answering questions, explain without code whenever possible. Provide code only if strictly necessary or explicitly requested.
- When giving feedback, be direct and unbiased. Avoid empty praise or flattery. Offer honest, constructive, down-to-earth suggestions for improvement.")

  (add-hook 'gptel-post-response-functions #'gptel-end-of-response)

  (with-eval-after-load 'evil
    (evil-set-initial-state 'gptel-mode 'insert)))

(use-package gptel-commit
  :straight t
  :after (gptel magit)
  :init
  (setq gptel-commit-prompt
        "Generate a conventional Git commit message for the current diff.

Rules:
- Use conventional commit type prefix when appropriate: feat, fix, refactor, docs, chore, test, style, perf, ci, build.
- If the change is trivial or single-purpose, output only a subject line.
- If the change contains multiple logical changes, output a subject line, blank line, then one bullet point per logical change.

Subject rules:
- Imperative present tense (e.g., 'Add feature' not 'Added feature' or 'Adds feature')
- Max 72 characters
- Capitalize first letter after type prefix
- No trailing period
- Be specific and concise

Body rules:
- Wrap at 72 characters
- Explain why/what, not how
- Do not repeat the subject
- Use hyphen bullet points, not markdown

Output only the commit message. Do not include explanations, commentary, or code fences.")
  :config
  (setq gptel-commit-stream nil
        gptel-commit-model 'deepseek-v4-flash)

  (defun ai-commit-lite ()
    (let ((gptel-backend ai-lite-backend)
          (gptel-model 'deepseek-v4-flash)
          (gptel-commit-model 'deepseek-v4-flash))
      (call-interactively #'gptel-commit)))

  (defun ai-commit-max ()
    (let ((gptel-backend ai-max-backend)
          (gptel-model 'deepseek-v4-pro)
          (gptel-commit-model 'deepseek-v4-pro))
      (call-interactively #'gptel-commit)))

  (defun ai-commit (mode)
    (interactive
     (list (completing-read "AI commit: " '("lite" "max") nil t nil nil "lite")))
    (pcase mode
      ("lite" (ai-commit-lite))
      ("max" (ai-commit-max))
      (_ (user-error "Unknown AI commit mode: %s" mode))))

  (with-eval-after-load 'evil
    (add-hook 'git-commit-mode-hook
              (lambda ()
                (evil-local-set-key 'normal (kbd "SPC g") #'ai-commit)))))
