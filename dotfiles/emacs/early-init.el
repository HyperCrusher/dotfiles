;;; Early Init Performance
(setq gc-cons-threshold (* 256 1024 1024)) ; 256MB for startup
(setq process-adaptive-read-buffering nil)
(setq read-process-output-max (* 1024 1024)) ; 1mb

;;; Cache Directories Setup
(setq user-cache-directory (expand-file-name ".cache/" user-emacs-directory))
(make-directory user-cache-directory t)

;;; Native Compilation
(when (and (fboundp 'startup-redirect-eln-cache)
          (fboundp 'native-comp-available-p)
          (native-comp-available-p))
 (startup-redirect-eln-cache
  (convert-standard-filename
   (expand-file-name  ".cache/eln-cache/" user-emacs-directory))))
(setq native-comp-async-report-warnings-errors nil)
(setq native-comp-deferred-compilation t)

;;; Cache File Locations
(setq straight-base-dir user-cache-directory)
(setq custom-file (expand-file-name "custom.el" user-cache-directory))
(setq bookmark-default-file (expand-file-name "bookmarks" user-cache-directory))
(setq recentf-save-file (expand-file-name "recentf" user-cache-directory))
(setq save-place-file (expand-file-name "places" user-cache-directory))
(setq transient-history-file (expand-file-name "transient/history.el" user-cache-directory))
(setq dirvish-cache-dir (expand-file-name "dirvish/" user-cache-directory))
(setq lsp-session-file (expand-file-name "lsp-session" user-cache-directory))
(setq lsp-server-install-dir (expand-file-name "lsp" user-cache-directory))
(setq tramp-persistency-file-name (expand-file-name "tramp" user-cache-directory))
(setq undo-fu-session-directory (expand-file-name "undo" user-cache-directory))
(setq eshell-directory-name (expand-file-name "eshell" user-cache-directory))
(setq url-cache-directory (expand-file-name "url" user-cache-directory))
(setq project-list-file (expand-file-name "projects" user-cache-directory))
(setq package-user-dir (expand-file-name "packages" user-cache-directory))
(setq projectile-cache-file (expand-file-name "projectile/cache" user-cache-directory))
(setq projectile-known-projects-file (expand-file-name "projectile/projects" user-cache-directory))

;;; Create Cache Directories
(dolist (dir '("lsp" "undo" "eshell" "url" "transient" "dirvish" "projectile"))
 (make-directory (expand-file-name dir user-cache-directory) t))

;;; UI Cleanup
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(setq inhibit-splash-screen t)

;;; Performance Optimizations
(setq cache-long-scans t)
(setq inhibit-compacting-font-caches t)

;;; LSP Performance
(setenv "LSP_USE_PLISTS" "true")
