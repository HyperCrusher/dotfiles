;;; -*- lexical-binding: t; -*-
(use-package vertico
  :init
  (vertico-mode))


(use-package consult
  :config
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref
        consult-ripgrep-args (concat consult-ripgrep-args " --hidden -g !.git")))

(use-package embark
  :after (embark-consult))

(use-package embark-consult
  :after (consult))

(use-package marginalia
  :init
  (marginalia-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package vertico-posframe
  :after vertico
  :demand t
  :config
  (setq vertico-posframe-parameters
        '((left-fringe . 8)
          (right-fringe . 8)))
  (setq vertico-posframe-poshandler #'posframe-poshandler-frame-center)
  (add-hook 'consult-ripgrep-search-mode-hook #'vertico-posframe-mode)
  (vertico-posframe-mode))
