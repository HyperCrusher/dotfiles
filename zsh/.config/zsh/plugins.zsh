if ! (( $+functions[zsh-defer] )); then
  fpath+=( "$HOME/.cache/antidote/github.com/romkatv/zsh-defer" )
  source "$HOME/.cache/antidote/github.com/romkatv/zsh-defer/zsh-defer.plugin.zsh"
fi
fpath+=( "$HOME/.cache/antidote/github.com/zsh-users/zsh-autosuggestions" )
zsh-defer source "$HOME/.cache/antidote/github.com/zsh-users/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/github.com/zsh-users/zsh-syntax-highlighting" )
source "$HOME/.cache/antidote/github.com/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/github.com/clarketm/zsh-completions" )
zsh-defer source "$HOME/.cache/antidote/github.com/clarketm/zsh-completions/zsh-completions.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/github.com/zsh-users/zsh-history-substring-search" )
source "$HOME/.cache/antidote/github.com/zsh-users/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/github.com/ChrisPenner/copy-pasta" )
zsh-defer source "$HOME/.cache/antidote/github.com/ChrisPenner/copy-pasta/copy-pasta.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/github.com/mdumitru/fancy-ctrl-z" )
zsh-defer source "$HOME/.cache/antidote/github.com/mdumitru/fancy-ctrl-z/fancy-ctrl-z.zsh"
fpath+=( "$HOME/.cache/antidote/github.com/jeffreytse/zsh-vi-mode" )
zsh-defer source "$HOME/.cache/antidote/github.com/jeffreytse/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
