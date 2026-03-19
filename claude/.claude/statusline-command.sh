#!/usr/bin/env bash

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Context usage
ctx_info="ctx: N/A"
if [ -n "$used" ]; then
  used_int=${used%.*}
  ctx_info="ctx: ${used_int}%"
fi

# Git branch (skip optional locks to avoid contention)
git_branch="no branch"
if [ -n "$cwd" ] && git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$cwd" -c core.hooksPath=/dev/null symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    git_branch="$branch"
  fi
fi

printf '\033[0;36m%s\033[0m \033[0;37m|\033[0m \033[0;32m%s\033[0m \033[0;37m|\033[0m \033[0;33m%s\033[0m' \
  "$ctx_info" \
  "$model" \
  "$git_branch"
