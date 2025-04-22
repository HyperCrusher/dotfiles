export ZDOTDIR="$HOME/.config/zsh"

# Plugins
if [[ ! -e $ZDOTDIR/.antidote ]]; then
  git clone --depth=1 https://github.com/mattmc3/antidote.git $ZDOTDIR/.antidote
fi

source $ZDOTDIR/.antidote/antidote.zsh
antidote load $ZDOTDIR/plugins.txt

# Zoxide
eval "$(zoxide init zsh)"

# History
export HISTFILE="$ZDOTDIR/history"
export HISTSIZE=50000
export SAVEHIST=50000

setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY


typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ad8ee6"
typeset -g ZSH_AUTOSUGGEST_STRATEGY=(completion)
eval "$(oh-my-posh init zsh -c $ZDOTDIR/omp.json)"

# File and directory operations
alias ls="eza"
alias lsa="eza -a"
alias lst="eza --tree --level=2"
alias grep="grep --color=auto"
alias chown="chown --preserve-root"
alias chmod="chmod --preserve-root"
alias chgrp="chgrp --preserve-root"
alias ..="cd ../"
alias .="cd ~"

# Nvim
alias vi="nvim"
alias vim="nvim"
alias e="emacsclient"

# Enhanced lsblk
alias lsblk="lsblk --output name,label,size,rota,mountpoints,fstype"

# Cargo
export PATH="$HOME/.cargo/bin:$PATH"

function cd(){
  z "$@" && eza
}
clear(){
  command clear && eza
}
rm() {
  command rm -r "$@" && eza;
}
mkdir() {
  command mkdir -pv "$@" && eza;
}

touch() {
  command touch "$@" && eza;
}
unzip() {
  local filename=$(basename "$1" .zip)
  mkdir -p "$filename"
  command unzip "$1" -d "$filename"
  _post_command
}

unrar() {
  local filename=$(basename "$1" .rar)
  mkdir -p "$filename"
  command unrar x "$1" "$filename"
  _post_command
}

vterm_printf() {
    if [ -n "$TMUX" ] \
        && { [ "${TERM%%-*}" = "tmux" ] \
            || [ "${TERM%%-*}" = "screen" ]; }; then
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "${TERM%%-*}" = "screen" ]; then
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}

vterm_cmd() {
    local vterm_elisp
    vterm_elisp=""
    while [ $# -gt 0 ]; do
        vterm_elisp="$vterm_elisp""$(printf '"%s" ' "$(printf "%s" "$1" | sed -e 's|\\|\\\\|g' -e 's|"|\\"|g')")"
        shift
    done
    vterm_printf "51;E$vterm_elisp"
}

ff() {
    vterm_cmd find-file "$(realpath "${@:-.}")"
}

eza
