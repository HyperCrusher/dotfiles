export zdotdir="$HOME/.config/zsh"
export PATH="$HOME/.cargo/bin:$PATH"

# plugins
if [[ ! -e "$zdotdir/.antidote" ]]; then
  git clone --depth=1 https://github.com/mattmc3/antidote.git "$zdotdir/.antidote"
fi

source "$zdotdir/.antidote/antidote.zsh"
antidote load "$zdotdir/plugins.txt"

# zoxide
eval "$(zoxide init zsh)"

# history
export HISTFILE="$zdotdir/history"
export HISTSIZE=50000
export SAVEHIST=50000

setopt extended_history
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_find_no_dups
setopt hist_ignore_space
setopt hist_save_no_dups
setopt hist_verify

typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ad8ee6"
typeset -g ZSH_AUTOSUGGEST_STRATEGY=(completion)
eval "$(oh-my-posh init zsh -c "$zdotdir/omp.json")"

# paru is yay, yay is paru
alias yay="paru"

# file and directory operations
alias ls="eza"
alias lsa="eza -a"
alias lst="eza --tree --level=2"
alias grep="rg"
alias chown="chown --preserve-root"
alias chmod="chmod --preserve-root"
alias chgrp="chgrp --preserve-root"

# package management
alias update="yay -Syu"
alias search="yay -Ss"
alias install="yay -S"
alias remove="yay -Rns"

# nvim
alias nvim="emacsclient -n"
alias vi="nvim"
alias vim="nvim"
alias e="emacsclient -n"

# enhanced lsblk
alias lsblk="command lsblk --output name,label,size,rota,mountpoints,fstype"

function cd(){
  if [[ "$1" == "-" ]]; then
    builtin cd - && eza
  elif [[ $# -eq 0 ]]; then
    builtin cd ~ && eza
  elif z "$@"; then
    eza
  else
    builtin cd "$@" && eza
  fi
}

clear(){
  command clear && eza
}

rm() {
  command rm -r --preserve-root "$@" && eza
}

mkdir() {
  command mkdir -pv "$@" && eza
}

touch() {
  command touch "$@" && eza
}

unpack() {
  local archive="$1"
  [[ -f "$archive" ]] || { echo "unpack: not a file: $archive" >&2; return 1; }

  local file
  file=$(basename "$archive")
  local target_dir="$file"

  local ext
  for ext in .tar.gz .tar.zst .tar.bz2 .tar.xz .tar.lz .tar.lzma \
             .tgz .tbz2 .txz .zip .rar .7z .gz .bz2 .xz .zst \
             .iso .jar; do
    if [[ "$target_dir" == *"$ext" ]]; then
      target_dir="${target_dir%$ext}"
      break
    fi
  done

  [[ -n "$target_dir" ]] || target_dir="unpacked"

  command mkdir -p "$target_dir"

  local password=""
  if ! command 7z t "$archive" -p >/dev/null 2>&1; then
    printf "Password: "
    read -s password
    echo
  fi

  if [[ -n "$password" ]]; then
    command 7z x "$archive" -o"$target_dir" -bso0 -p"$password"
  else
    command 7z x "$archive" -o"$target_dir" -bso0
  fi

  eza
}

pack() {
  local format="$1"
  local output="$2"

  case "$format" in
    zip)
      command 7z a "${output}.zip" "${@[3,-1]}"
      ;;
    tar)
      command 7z a -m0=zstd -mx=9 "${output}.tar.zst" "${@[3,-1]}"
      ;;
    rar)
      command rar a -m3 -idq "${output}.rar" "${@[3,-1]}"
      ;;
    *)
      ;;
  esac
  eza
}

packmod() {
    if [ -z "$1" ]; then
        return 1
    fi
    if [ ! -d "$1" ]; then
        return 1
    fi
    (cd "$1" && zip -r "../${1%/}.zip" .)
}

if [[ "$INSIDE_EMACS" == *vterm* ]]; then
    vterm_printf() {
        if [ -n "$TMUX" ] \
            && { [ "${TERM%%-*}" = "tmux" ] \
                || [ "${TERM%%-*}" = "screen" ]; }; then
            printf "\eptmux;\e\e]%s\007\e\\" "$1"
        elif [ "${TERM%%-*}" = "screen" ]; then
            printf "\ep\e]%s\007\e\\" "$1"
        else
            printf "\e]%s\e\\" "$1"
        fi
    }

    vterm_cmd() {
        local vterm_elisp=""
        while [ $# -gt 0 ]; do
            vterm_elisp="$vterm_elisp""$(printf '"%s" ' "$(printf "%s" "$1" | sed -e 's|\\|\\\\|g' -e 's|"|\\"|g')")"
            shift
        done
        vterm_printf "51;e$vterm_elisp"
    }

    ff() {
        vterm_cmd find-file "${@:-.}"
    }

    vterm_prompt_end() {
        vterm_printf "51;a$USER@${HOST%%.*}:$PWD" > /dev/tty
    }

    autoload -Uz add-zsh-hook
    add-zsh-hook precmd vterm_prompt_end
fi

eza

bindkey -M emacs '^[[a' history-substring-search-up
bindkey -M viins '^[[a' history-substring-search-up
bindkey -M vicmd '^[[a' history-substring-search-up

bindkey -M emacs '^[[b' history-substring-search-down
bindkey -M viins '^[[b' history-substring-search-down
bindkey -M vicmd '^[[b' history-substring-search-down

HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export VINTAGE_STORY=/opt/vintagestory

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

term=xterm-256color
