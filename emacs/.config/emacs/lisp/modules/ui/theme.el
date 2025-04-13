(use-package nerd-icons)
(use-package tokyo-dark
  :straight (tokyo-dark :type git :host github :repo "hypercrusher/tokyo-dark.el")
  :init
  (setq tokyo-dark-transparent-background t
        tokyo-dark-italic-comments t)
  (load-theme 'tokyo-dark t))

(use-package solaire-mode
  :config
  (setq solaire-mode-real-buffer-fn
        (lambda ()
          (or (string-prefix-p "*scratch" (buffer-name))
              (buffer-file-name (buffer-base-buffer))))))

(use-package ligature
  :config
  (ligature-set-ligatures 't '("--" "---" "==" "===" "!=" "!==" "=!="
                              "=:=" "=/=" "<=" ">=" "&&" "&&&" "&=" "++" "+++" "***" ";;" "!!"
                              "??" "???" "?:" "?." "?=" "<:" ":<" ":>" ">:" "<:<" "<>" "<<<" ">>>"
                              "<<" ">>" "||" "-|" "_|_" "|-" "||-" "|=" "||=" "##" "###" "####"
                              "#{" "#[" "]#" "#(" "#?" "#_" "#_(" "#:" "#!" "#=" "^=" "<$>" "<$"
                              "$>" "<+>" "<+" "+>" "<*>" "<*" "*>" "</" "</>" "/>" "<!--" "<#--"
                              "-->" "->" "->>" "<<-" "<-" "<=<" "=<<" "<<=" "<==" "<=>" "<==>"
                              "==>" "=>" "=>>" ">=>" ">>=" ">>-" ">-" "-<" "-<<" ">->" "<-<" "<-|"
                              "<=|" "|=>" "|->" "<->" "<~~" "<~" "<~>" "~~" "~~>" "~>" "~-" "-~"
                              "~@" "[||]" "|]" "[|" "|}" "{|" "[<" ">]" "|>" "<|" "||>" "<||"
                              "|||>" "<|||" "<|>" "..." ".." ".=" "..<" ".?" "::" ":::" ":=" "::="
                              ":?" ":?>" "//" "///" "/*" "*/" "/=" "//=" "/==" "@_" "__" "???"
                              "<:<" ";;;")))

(add-to-list 'default-frame-alist '(font . "JetBrainsMono NF 13"))

(use-package colorful-mode
  :ensure t
  :hook (prog-mode text-mode)
  :init
  (setq colorful-allow-mouse-clicks nil
        colorful-extra-color-keyword-functions '(((mhtml-mode html-ts-mode css-mode css-ts-mode)
                                                . (colorful-add-rgb-colors colorful-add-hsl-colors))
                                               (latex-mode . colorful-add-latex-colors)
                                               colorful-add-hex-colors)))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package highlight-parentheses
  :config
  (setq highlight-parentheses-colors nil
        highlight-parentheses-background-colors nil
        highlight-parentheses-attributes nil))
