zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' max-errors 2 numeric
zstyle :compinstall filename '/home/dknite/.zshrc'

autoload -Uz compinit
compinit

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=50000
setopt autocd
bindkey -e

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
FZF_COMPLETIONS=/usr/share/fzf/completion.zsh
FZF_KEYBINDINGS=/usr/share/fzf/key-bindings.zsh
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
export PATH="/var/lib/snapd/snap/bin:$PATH"
export PATH="$HOME/.nimble/bin:$PATH"
export PATH="$HOME/.local/share/gem/ruby/3.0.0/bin:$PATH"
export PATH="$HOME/software/platform-tools:$PATH"

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
    eval "$(starship init zsh)"
fi

# zoxide
if command -v zoxide > /dev/null; then
    eval "$(zoxide init zsh)"
    alias cd=z
fi

export FIDLMISC_DIR=$HOME/software/fidl-misc/
alias fidldev=$FIDLMISC_DIR/fidldev/fidldev.py
export ASAN_SYMBOLIZER_PATH="$HOME/fuchsia/prebuilt/third_party/clang/linux-x64/bin/llvm-symbolizer"

alias java11="$HOME/software/amazon-corretto-11.0.13.8.1-linux-x64/bin/java"
alias caff="_JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on' java11 -jar $HOME/software/CaffeineLeet.jar"

# Base16 Shell
BASE16_SHELL="$HOME/software/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
