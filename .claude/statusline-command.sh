#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Get current working directory from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir')

# Get directory name (basename of current directory)
dir_name=$(basename "$cwd")

# Get git branch if in a git repo
git_branch=""
if git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
    if [ -n "$branch" ]; then
        git_branch="  $branch"
    fi
fi

# Get current time
current_time=$(date +%H:%M)

# Get context window usage percentage (null if no messages yet)
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Get terminal width
cols=$(echo "$input" | jq -r '.terminal.columns // empty')
if [ -z "$cols" ]; then
    cols=$(tput cols 2>/dev/null || echo 80)
fi

# Build left and right sides (plain text for length calculation)
left_plain="${dir_name}${git_branch}"
if [ -n "$used_pct" ]; then
    right_plain="ctx:${used_pct}%  ${current_time}"
else
    right_plain="${current_time}"
fi

# Calculate padding
left_len=${#left_plain}
right_len=${#right_plain}
padding=$((cols - left_len - right_len))
if [ "$padding" -lt 1 ]; then
    padding=1
fi
spaces=$(printf '%*s' "$padding" '')

# Build the status line with colors spread across the width
# Pink for directory (bold), green for git branch (bold), yellow for context, cyan for time
if [ -n "$used_pct" ]; then
    printf "\033[1;95m%s\033[0m\033[1;92m%s\033[0m%s\033[33mctx:%s%%\033[0m  \033[36m%s\033[0m" "$dir_name" "$git_branch" "$spaces" "$used_pct" "$current_time"
else
    printf "\033[1;95m%s\033[0m\033[1;92m%s\033[0m%s\033[36m%s\033[0m" "$dir_name" "$git_branch" "$spaces" "$current_time"
fi
