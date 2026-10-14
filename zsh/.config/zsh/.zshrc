# config location
export zdotdir="$HOME/.config/zsh"

# term
export TERM=xterm-256color

# paths
export PATH="$HOME/.cargo/bin:$PATH"

export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

typeset -U path

# autosuggest
typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ad8ee6"
typeset -g ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# plugins
if [[ ! -e "$zdotdir/.antidote" ]]; then
  git clone --depth=1 https://github.com/mattmc3/antidote.git "$zdotdir/.antidote"
fi

source "$zdotdir/.antidote/antidote.zsh"
antidote load "$zdotdir/plugins.txt"

# zoxide
eval "$(zoxide init zsh)"

# prompt
eval "$(oh-my-posh init zsh -c "$zdotdir/omp.json")"

# history
export HISTFILE="$zdotdir/history"
export HISTSIZE=50000
export SAVEHIST=50000

setopt extended_history
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_find_no_dups
setopt hist_ignore_space
setopt hist_verify

# misc
export VINTAGE_STORY=/opt/vintagestory

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# interactive
if [[ -o interactive ]]; then

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
  alias vi="emacsclient -n"
  alias vim="emacsclient -n"
  alias e="emacsclient -n"

  # enhanced lsblk
  alias lsblk="command lsblk --output name,label,size,rota,mountpoints,fstype"

  cd() {
    case $# in
      0) builtin cd ~ || return ;;
      1)
        if [[ $1 == - ]]; then
          builtin cd - || return
        else
          z "$1" 2>/dev/null || builtin cd "$1" || return
        fi
        ;;
      *) builtin cd "$@" || return ;;
    esac
    eza
  }

  clear() {
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
    if command 7z l -slt "$archive" 2>/dev/null | command grep -q '^Encrypted = +'; then
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
    if (( $# < 3 )); then
      print -u2 "usage: pack <zip|tar|rar> <output> <files...>"
      return 1
    fi

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

  # history substring search
  HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

  bindkey -M emacs '^[[a' history-substring-search-up
  bindkey -M viins '^[[a' history-substring-search-up
  bindkey -M vicmd '^[[a' history-substring-search-up

  bindkey -M emacs '^[[b' history-substring-search-down
  bindkey -M viins '^[[b' history-substring-search-down
  bindkey -M vicmd '^[[b' history-substring-search-down

  # vterm
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
fi
