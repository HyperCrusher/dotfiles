(use-package projectile
  :config
  (projectile-mode 1))

(use-package consult-projectile
  :straight (consult-projectile :type git :host gitlab :repo "OlMon/consult-projectile" :branch "master"))
