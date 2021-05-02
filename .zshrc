# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' max-errors 2 numeric
zstyle :compinstall filename '/home/dknite/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=50000
setopt autocd
bindkey -e
# End of lines configured by zsh-newuser-install

# Envirionment
export EDITOR=nvim
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export RANGER_LOAD_DEFAULT_RC=FALSE

# aliases
alias ls='exa'
alias ll='exa -l'
alias la='exa -a'
alias lla='exa -la'

alias gaa='git add .'
alias gcam='git commit -am'
alias gcmsg='git commit -m'
alias glog='git log --oneline --decorate --graph'
alias gst='git status'
alias gdf='git diff --name-only --diff-filter=d | xargs bat --diff'

# PATHS
export PATH="/home/dknite/.local/bin":$PATH
export PATH="/home/dknite/.local/share/gem/ruby/3.0.0/bin":$PATH

eval "$(starship init zsh)"
source /usr/share/nvm/init-nvm.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source /home/dknite/.config/broot/launcher/bash/br
