export ZDOTDIR="$HOME/.config/zsh"
export PATH="$HOME/.cargo/bin:$PATH"

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

# Parus is yay, yay is paru
alias yay="paru"

# File and directory operations
alias ls="eza"
alias lsa="eza -a"
alias lst="eza --tree --level=2"
alias grep="rg"
alias chown="chown --preserve-root"
alias chmod="chmod --preserve-root"
alias chgrp="chgrp --preserve-root"

# Package managment
alias update="yay -Syu"
alias search="yay -Ss"
alias install="yay -S"
alias remove="yay -Rs"

# Nvim
alias vi="nvim"
alias vim="nvim"
alias e="emacsclient"

# Enhanced lsblk
alias lsblk="lsblk --output name,label,size,rota,mountpoints,fstype"

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

unpack() {
  local archive="$1"
  local file
  file=$(basename "$archive")
  local target_dir="${file%%.*}"
  command mkdir -p "$target_dir"
  command 7z t "$archive" -p"" > /dev/null 2>&1
  if [[ $? -ne 0 ]]; then
    echo "Password:"
  fi
  command 7z x "$archive" -o"$target_dir" -bso0
  eza
}

pack() {
  local format="$1"
  local output="$2"

  case "$format" in
    zip)
      command 7z a "${output}.zip" "$@[3,-1]"
      ;;
    tar)
      command 7z a -m0=zstd -mx=9 "${output}.tar.zst" "$@[3,-1]"
      ;;
    rar)
      command rar a -m3 -idq "${output}.rar" "$@[3,-1]"
      ;;
    *)
  esac
  eza
}

if [[ "$INSIDE_EMACS" == 'vterm' ]]; then
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
    vterm_prompt_end() {
        vterm_printf "51;A$(whoami)@$(hostname):$(pwd)"
    }
    autoload -U add-zsh-hook
    add-zsh-hook -Uz chpwd () { vterm_prompt_end }
    vterm_prompt_end
fi
eza
bindkey -M emacs '^[[A' history-substring-search-up
bindkey -M viins '^[[A' history-substring-search-up
bindkey -M vicmd '^[[A' history-substring-search-up

bindkey -M emacs '^[[B' history-substring-search-down
bindkey -M viins '^[[B' history-substring-search-down
bindkey -M vicmd '^[[B' history-substring-search-down
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
