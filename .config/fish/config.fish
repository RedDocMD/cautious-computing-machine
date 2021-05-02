# Greeting
function fish_greeting
end

# Set environment variables
set -x EDITOR nvim
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -x RANGER_LOAD_DEFAULT_RC FALSE

# exa for ls
if command -v exa > /dev/null
    abbr -a ls exa
    abbr -a ll exa -l
    abbr -a la exa -a
    abbr -a lla exa -la
end

# git abbreviations
abbr -a gaa git add .
abbr -a gcam git commit -am
abbr -a gcmsg git commit -m
abbr -a glog git log --oneline --decorate --graph
abbr -a gst git status
abbr -a gdf "git diff --name-only --diff-filter=d | xargs bat --diff"

abbr -a e nvim

# Dotfile repo
alias config '/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# PATH
set -px PATH $HOME/.local/bin
set -px PATH $HOME/.local/share/gem/ruby/3.0.0/bin
set -px PATH $HOME/.cargo/bin
set -px PATH $HOME/software/node-v14.16.1-linux-x64/bin

# starship
if command -v starship > /dev/null
    starship init fish | source
end
