# greeting
function fish_greeting
end

function fish_user_key_bindings
    fzf_key_bindings
end

# terminal title
function fish_title
    set -q argv[1]; or set argv fish
    # Looks like ~/d/fish: git log
    # or /e/apt: fish
    echo (fish_prompt_pwd_dir_length=1 prompt_pwd);
end

# Set environment variables
set -x EDITOR nvim
if command -v bat > /dev/null
    set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
    set -x MANROFFOPT "-c"
end
set -x RANGER_LOAD_DEFAULT_RC FALSE
set -x pager less

# exa for ls
if command -v exa > /dev/null
    abbr -a ls exa
    abbr -a ll exa -l
    abbr -a la exa -a
    abbr -a lla exa -la
end

# source autojump
set --local AUTOJUMP_PATH /usr/share/autojump/autojump.fish
if test -e $AUTOJUMP_PATH
    source $AUTOJUMP_PATH
end

# git abbreviations
abbr -a gaa git add .
abbr -a gcam git commit -am
abbr -a gcm git commit -m
abbr -a glog git log --oneline --decorate --graph
abbr -a gst git status
if command -v bat > /dev/null
    abbr -a gdf "git diff --name-only --diff-filter=d | xargs bat --diff"
end

function diff -d "Fancy diff from Git"
    if command -v diff-so-fancy > /dev/null
        command git diff --color $argv | diff-so-fancy | less -r
    else
        command git diff --color $argv
    end
end


abbr -a e nvim

# Dotfile repo
alias config '/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# Pacman "interactive"
abbr -a paci "pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S"

# PATH
set -px PATH $HOME/.local/bin
set -px PATH $HOME/.local/share/gem/ruby/3.0.0/bin
set -px PATH $HOME/.cargo/bin
set -px PATH $HOME/software/node-v14.17.3-linux-x64/bin
set -px PATH $HOME/software/platform-tools
set -px PATH $HOME/software/julia-1.6.1/bin
set -px PATH $HOME/fuchsia/.jiri_root/bin
set -px PATH $HOME/software/go/bin
set -px PATH $HOME/.local/share/coursier/bin
source ~/fuchsia/scripts/fx-env.fish
set -px PATH $HOME/.linuxbrew/bin $HOME/.linuxbrew/sbin
set -px PATH $HOME/software/spark-3.1.2-bin-hadoop2.7/bin

# Homebrew
set -x HOMEBREW_PREFIX "/home/dknite/.linuxbrew"
set -x HOMEBREW_CELLAR "/home/dknite/.linuxbrew/Cellar"
set -x HOMEBREW_REPOSITORY "/home/dknite/.linuxbrew/Homebrew"

# For ccache
if command -v ccache > /dev/null
    set -x USE_CCACHE 1
    set -x CCACHE_EXEC /usr/bin/ccache
end

# starship
if command -v starship > /dev/null
    starship init fish | source
end
set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin /home/dknite/.ghcup/bin $PATH # ghcup-env
