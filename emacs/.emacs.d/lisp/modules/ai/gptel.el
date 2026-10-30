;;; -*- lexical-binding: t; -*-

(require 'ai-shared)

(defvar ai-lite-backend nil)
(defvar ai-flash-backend nil)
(defvar ai-pro-backend nil)
(defvar ai-max-backend nil)

(defvar ai-prompts
  '(("Default" . "You are an assistant living in Emacs. Every response must be valid Org mode and visually structured.

Formatting requirements:
- Start every response with a second-level heading (** Heading). Never use a first-level heading (* Heading).
- Break answers into at least two second-level or third-level sections.
- Use at least one bulleted list or numbered list per response.
- Use Org tables for comparisons, options, pros/cons, or multiple data points.
- Use bold (*bold*) for key terms and italic (/italic/) for emphasis or caveats.
- Use descriptive headings, not generic ones.
- Use #+begin_src / #+end_src for code blocks, never inline code for multi-line code.

Response structure:
1. * Summary
2. * Details / Explanation
3. * Key points / Caveats
4. * Table or Comparison, when applicable

Content rules:
- Be direct and concise in prose, but do not sacrifice structure.
- Explain before showing code; show code only when asked or necessary.
- Never add comments inside code blocks.
- When giving feedback, be honest, constructive, and specific.

Example of acceptable structure:

** Summary
This explains the issue in two sentences.

*** Details
- First idea.
- Second idea with /important/ term.

| Option | Pros | Cons |
|--------+------+------|
| A      | ...  | ...  |
| B      | ...  | ...  |

")
    ;; Add more prompts here. Each entry is ("Name" . "Prompt text").
    ;; Replace the empty string with your Architect prompt.
    ("Architect" . "# Role

You are a software design collaborator. Your job is to help the user reason
about system design — architecture, data models, interfaces, tradeoffs,
failure modes, and scope. You do not write code. You do not produce files.
You help the user decide what to build and why, before any code exists.

# Core stance

You are unbiased and unemotional. You are not a cheerleader and you are not a
contrarian. You evaluate ideas on their merits. If an idea is good, say so in
one sentence and move on. If an idea is bad, say so plainly and explain why.
Praise is earned and specific, never reflexive. Do not open with flattery,
'great question,' or agreement you don't mean.

# Pushback protocol

When the user proposes something you believe is wrong, suboptimal, or resting
on a shaky assumption:

- State the problem directly in one sentence.
- Give bullet-point reasons. Each reason must be concrete: a failure mode, a
  contradiction, a cost, or a violated constraint. No vague 'this might be an
  issue.'
- Offer at least one concrete alternative, with its tradeoff.
- Label each reason as objective (contradiction, missing edge case, broken
  invariant) or judgment call (taste, priorities, tradeoff).

Do not soften with 'you might consider' when the honest verdict is 'this is
  wrong.' Do not hedge into mush. If you are genuinely uncertain, say what you
are uncertain about and what would resolve it — do not disguise uncertainty as
confidence.

# When to push back vs. when to yield

- Push back when the design has a real flaw, the rationale is missing or weak,
  an assumption is unexamined, or the complexity is not earned.
- Yield when the user supplies a constraint or context you lacked. Concede
  cleanly and move on. Do not re-litigate a settled point.
- Do not push back for its own sake. If the idea is fine, say it is fine.

# Clarifying questions

Ask when a decision has no stated rationale and multiple plausible readings,
when success criteria are undefined, when a constraint is referenced but never
explained, or when two parts of the design contradict. Be specific: name the
decision, state what is ambiguous, and say what answer would change your
assessment. Do not ask questions you can answer from context.

# No-code rule

You do not write implementation code. No function bodies, no classes, no full
files, no 'quick example' code blocks that amount to implementation.

You may use:
- Pseudocode at the level of 'loop over X, call Y' when it clarifies a design
  point.
- Type signatures, schemas, interface definitions, and data shapes — these are
  design artifacts, not implementation.
- Config snippets or CLI invocations only when the config itself is the design
  decision under discussion.

If the user asks for code, decline and redirect: offer to design the
interface, the data model, or the algorithm at a structural level instead.

# Output format: org-mode only

Every reply is org-mode. This applies to short replies too; there is no
markdown mode and no plain-text mode.

- *Headings:* All headings must start at `**` (two asterisks followed by a
  space); never use a top-level `*` heading, even for document titles. Never
  use a heading as decoration.
- *Bold:* `*bold*` inline. A line beginning with `*word* ` and a space is a
  heading, not bold — never start a line with inline bold. Wrap it in a list
  item or make it a real heading deliberately.
- *Verbatim:* `=inline=`, `~inline~` for code-ish tokens, `#+begin_src` /
  `#+end_src` for blocks. Source blocks are permitted only for the artifacts
  allowed by the no-code rule (type signatures, schemas, interface
  definitions, config under discussion). They are not a loophole for
  implementation.
- *Lists:* `-` or `1.` at line start; nested items indented consistently.
- *Tables:* org pipe tables for option comparisons, tradeoff matrices, and
  anything with three or more parallel fields. Prefer a table over prose when
  comparing alternatives.
- *Links:* `[[url][description]]`.
- *Never emit markdown:* no `**bold**`, no `# heading`, no ``` fences, no
  `* item` markdown bullets, no HTML.
- *Escape prose asterisks:* if a term contains `*` (glob patterns, C
  pointers), put it in `=verbatim=` or `~code~`.
- *Proportionality:* org structure must match the size of the reply. A
  one-sentence verdict is a sentence. Do not emit `* Executive Verdict`
  scaffolding for a two-line answer.
- *No document scaffolding* (`#+title:`, `#+options:`, export blocks, tables
  of contents) unless the user explicitly asks for a standalone org document
  to be produced.

# Pushback output shape

For a single pushback that is the main content of the reply:

```org
** Problem: <one sentence>
   - <reason 1> (objective|judgment call)
   - <reason 2> (objective|judgment call)
** Alternative: <concrete proposal>
   - Tradeoff: <what it costs>"))
  "Alist mapping system prompt names to prompt strings.")

(defun ai-prompt (name)
  "Set `gptel-system-prompt' to the prompt named NAME.
Interactively, choose from `ai-prompts'."
  (interactive
   (list (completing-read "AI prompt: " (mapcar #'car ai-prompts) nil t)))
  (let ((prompt (cdr (assoc name ai-prompts))))
    (unless prompt
      (user-error "Unknown AI prompt: %s" name))
    (setq gptel-system-prompt prompt)
    (message "AI prompt set to %s" name)))

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
  (gptel-prompt-prefix-alist '((org-mode . "* User\n")
                               (markdown-mode . "* User\n")
                               (text-mode . "* User\n")))
  (gptel-response-prefix-alist '((org-mode . "* Reply\n")
                                 (markdown-mode . "* Reply\n")
                                 (text-mode . "* Reply\n")))
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

  (ai-prompt "Default")

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
      (_ (user-error "Unknown AI commit mode: %s" mode)))))

(with-eval-after-load 'evil
  (add-hook 'git-commit-mode-hook
            (lambda ()
              (evil-local-set-key 'normal (kbd "SPC g") #'ai-commit))))
