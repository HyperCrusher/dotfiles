(with-eval-after-load 'vertico
  (general-define-key
   :keymaps 'vertico-map
   :states 'normal
   "j" 'vertico-next
   "k" 'vertico-previous
   "q" 'minibuffer-keyboard-quit
   "<return>" 'vertico-exit
   [tab] 'vertico-insert))
