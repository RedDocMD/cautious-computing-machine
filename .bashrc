#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source "$HOME/.cargo/env"

# Envirionment
export EDITOR=nvim
if command -v bat > /dev/null; then
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    export MANROFFOPT="-c"
fi
export RANGER_LOAD_DEFAULT_RC=FALSE
export pager=less

# autojump
AUTOJUMP_PATH=/usr/share/autojump/autojump.bash
[ -f $AUTOJUMP_PATH ] && source $AUTOJUMP_PATH

# aliases
if command -v exa > /dev/null; then
    alias ls='exa'
    alias ll='exa -l'
    alias la='exa -a'
    alias lla='exa -la'
fi

# git aliases
alias gaa='git add .'
alias gcam='git commit -am'
alias gcm='git commit -m'
alias glog='git log --oneline --decorate --graph'
alias gst='git status'
if command -v bat > /dev/null; then
    alias gdf='git diff --name-only --diff-filter=d | xargs bat --diff'
fi

gdiff() {
    if command -v diff-so-fancy > /dev/null; then
        git diff --color $* | diff-so-fancy | less -r
    else
        git diff --color $*
    fi
}

alias e=nvim

# Dotfile repo
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# Pacman "interactive"
alias paci="pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S"

# PATHS
export PATH="$HOME/.local/bin":$PATH
export PATH="$HOME/.local/share/gem/ruby/3.0.0/bin":$PATH
export PATH="$HOME/software/node-v16.4.0-linux-x64/bin":$PATH
export PATH="$HOME/software/platform-tools":$PATH
export PATH="$HOME/software/julia-1.6.1/bin":$PATH

# For ccache
if command -v ccache > /dev/null; then
    export USE_CACHE=1
    export CCACHE_EXEC=/usr/bin/ccache
    export CCACHE_DIR=$HOME/ccache
fi

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"


[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f ~/.config/broot/launcher/bash/br ] && source ~/.config/broot/launcher/bash/br

command -v starship > /dev/null && eval "$(starship init bash)"
. "$HOME/.cargo/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
