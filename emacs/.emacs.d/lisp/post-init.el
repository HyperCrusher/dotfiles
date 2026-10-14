;;; -*- lexical-binding: t; -*-
;; Reset GC threshold
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024))))
