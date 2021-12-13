# If not running interactively, do nothing
[[ $- != *i* ]] && return

export EDITOR="nvim"
if command -v bat > /dev/null; then
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    export MANROFFOPT="-c"
fi
export RANGER_LOAD_DEFAULT_RC=FALSE
export pager=less

# exa for ls
if command -v exa > /dev/null; then
    alias ls="exa"
    alias ll="exa -l"
    alias la="exa -a"
    alias lla="exa -la"
fi

# source fzf
FZF_COMPLETIONS=/usr/share/fzf/completion.bash
FZF_KEYBINDINGS=/usr/share/fzf/key-bindings.bash
[[ -e $FZF_COMPLETIONS ]] && source $FZF_COMPLETIONS
[[ -e $FZF_KEYBINDINGS ]] && source $FZF_KEYBINDINGS

# git aliases
alias gaa="git add ."
alias gcam="git commit -am"
alias gcm="git commit -m"
alias glog="git log --oneline --decorate --graph"
alias gst="git status"
if command -v bat > /dev/null; then
    alias gdf="git diff --name-only --diff-filter=d | xargs bat --diff"
fi

# diff function
diff() {
  if command -v diff-so-fancy > /dev/null; then
      git diff --color $@ | diff-so-fancy | less -r
  else
      git diff --color $@
  fi
}

# Because I am lazy
alias e="nvim"
alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias paci="pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S"

# PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/fuchsia/.jiri_root/bin:$PATH"
if [[ -e "$HOME/fuchsia/scripts/fx-env.sh" ]]; then
    source "$HOME/fuchsia/scripts/fx-env.sh"
fi
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/software/go/bin:$PATH"
export PATH="$HOME/.ghcup/bin:$PATH"

# For ccache
if command -v ccache > /dev/null; then
    export USE_CCACHE=1
    export CCACHE_EXEC=$(which ccache)
    export CCACHE_DIR=$HOME/.ccache
    if [[ ! -e "$CCACHE_DIR" ]]; then
	mkdir $CCACHE_DIR
    fi
fi

# starship
if command -v starship > /dev/null; then
    eval "$(starship init bash)"
fi

# zoxide
if command -v zoxide > /dev/null; then
    eval "$(zoxide init bash)"
    alias cd=z
fi

export FIDLMISC_DIR=$HOME/software/fidl-misc/
alias fidldev=$FIDLMISC_DIR/fidldev/fidldev.py
export ASAN_SYMBOLIZER_PATH="$HOME/fuchsia/prebuilt/third_party/clang/linux-x64/bin/llvm-symbolizer"

alias java11="$HOME/software/jdk-11.0.13+8/bin/java"

# Base16 Shell
BASE16_SHELL="$HOME/software/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
. "$HOME/.cargo/env"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

