# Fish shell configuration
# bugeats development environment

# Disable greeting
set fish_greeting

# Set color scheme (customize these)
set -g fish_color_normal normal
set -g fish_color_command blue
set -g fish_color_quote yellow
set -g fish_color_redirection cyan
set -g fish_color_end green
set -g fish_color_error red
set -g fish_color_param cyan
set -g fish_color_comment brblack
set -g fish_color_match --background=brblue
set -g fish_color_selection white --bold --background=brblack
set -g fish_color_search_match bryellow --background=brblack
set -g fish_color_operator brcyan
set -g fish_color_escape brcyan
set -g fish_color_autosuggestion brblack

# Prompt
function fish_prompt
    set -l last_status $status

    # Display username@hostname
    set_color brblack
    echo -n (whoami)@(hostname)
    set_color normal
    echo -n " "

    # Display working directory
    set_color blue
    echo -n (prompt_pwd)
    set_color normal

    # Git status (if in a git repo)
    if git rev-parse --git-dir >/dev/null 2>&1
        set -l branch (git branch 2>/dev/null | grep '^\*' | sed 's/^\* //')
        set_color yellow
        echo -n " ($branch)"
        set_color normal
    end

    # Prompt symbol
    if test $last_status -eq 0
        set_color green
    else
        set_color red
    end
    echo -n " λ "
    set_color normal
end

# Environment variables (add your preferences here)
set -gx EDITOR hx
set -gx VISUAL hx

# ----

alias ls 'ls --color=auto'
alias ll 'ls -lah'
alias g git
alias gs 'git status'
alias gd 'git diff'
alias gl 'git log --oneline --graph'
alias gup 'git fetch --all --prune && git pull'
alias gst 'git status --short --branch'

# ----

# Quick git checkpoint commit
function wip
    git add -A
    if test (count $argv) -eq 0
        git commit -m WIP
    else
        git commit -m "WIP ($argv)"
    end
end

# Spin up new tmux sessions dedicated to a code project
function tmux-hack
    set hackPath $argv[1]
    set session_name (path-short-display "$hackPath")
    set watch_session_name "$session_name/watch"

    # new session needs to be -d detached first
    tmux new-session -s "$session_name" -c "$PWD" -d
    tmux new-session -s "$watch_session_name" -c "$PWD" -d
    tmux switch-client -t "$session_name"
    tmux new-window
    tmux new-window
    tmux select-window -t 1
end

function tmux-here
    tmux-hack "$PWD"
end
