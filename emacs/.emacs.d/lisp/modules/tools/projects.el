(use-package projectile
  :config
  (projectile-mode 1)
  (setq projectile-auto-discover t
        projectile-enable-caching t
        projectile-project-search-path '("~/repos/")))


(use-package consult-projectile
  :straight (consult-projectile :type git :host gitlab :repo "OlMon/consult-projectile" :branch "master"))
