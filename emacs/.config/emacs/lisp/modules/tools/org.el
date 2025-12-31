;; Core org-mode configuration
(use-package org
  :config
  (setq org-ellipsis " 󱞱"
        org-pretty-entities t
        org-confirm-babel-evaluate nil
        org-highest-priority 1
        org-lowest-priority 4
        org-default-priority 4)
  :hook (org-mode . org-indent-mode))

;; Visual and UI enhancements
(use-package org-fancy-priorities
  :config
  (setq org-fancy-priorities-list '((?1 . "[High]")
                                    (?2 . "[Medium]")
                                    (?3 . "[Low]")
                                    (?4 . "[Backlog]")))
  :hook (org-mode . org-fancy-priorities-mode))

(use-package org-table-sticky-header
  :hook (org-mode . org-table-sticky-header-mode))

(use-package org-super-agenda)
(use-package org-rich-yank)

;; Editing and workflow helpers TODO
(use-package org-autolist
  :straight (:host github :repo "ucizi-turintech/org-autolist" :branch "master")
  :hook (org-mode . org-autolist-mode))

(use-package org-download
  :config (setq-default org-download-image-dir "~/Org/assets/images"))

(use-package org-auto-tangle
  :config (setq org-auto-tangle-default t))

;; Babel language support
(use-package ob-nix)
(use-package ob-go)
(use-package ob-rust)

;; Configure Babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (python . t)
   (shell . t)
   (js . t)
   (C . t)
   (lua . t)
   (nix . t)
   (go . t)
   (rust . t)))
