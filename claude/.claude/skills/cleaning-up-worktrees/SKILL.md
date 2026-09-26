---
name: cleaning-up-worktrees
description: Clean up unused git worktrees across all repositories. Analyzes worktrees, categorizes by PR status and staleness, then removes safe ones with user confirmation. Use when asked to "clean up worktrees", "remove old worktrees", or "worktree cleanup".
---

# Cleaning Up Worktrees

Two-step workflow: analyze all worktrees across repositories, then clean up based on user choice.

## Prerequisites

- `git` - standard git commands
- `gh` - GitHub CLI for PR status checks

**Limitation**: PR status detection only works for GitHub-hosted repos. For non-GitHub repos, worktrees will be categorized as UNKNOWN.

## Workflow

### Step 1: Find Repos with Worktrees

Scan the user's projects directory for repos with multiple worktrees:

base_dir="${1:-~/projects}"

find "$base_dir" -maxdepth 3 -name ".git" -type d 2>/dev/null | while read gitdir; do
  [ -f "$gitdir" ] && continue
repo_dir=$(dirname "$gitdir")
worktrees=$(git -C "$repo_dir" worktree list 2>/dev/null | wc -l | tr -d ' ')
[ "$worktrees" -gt 1 ] && echo "$repo_dir"
done

### Step 2: Categorize Each Worktree

For each worktree, gather these signals:

branch=$(git -C "$wt" rev-parse --abbrev-ref HEAD 2>/dev/null)
has_changes=$(git -C "$wt" status --porcelain 2>/dev/null | head -1)
last_commit_ts=$(git -C "$wt" log -1 --format=%ct 2>/dev/null)
two_months_ago=$(date -v-2m +%s 2>/dev/null || date -d "2 months ago" +%s)
is_stale=false
[ -n "$last_commit_ts" ] && [ "$last_commit_ts" -lt "$two_months_ago" ] && is_stale=true
last_commit_hr=$(git -C "$wt" log -1 --format=%cr 2>/dev/null)

remote_url=$(git -C "$wt" remote get-url origin 2>/dev/null)
if echo "$remote_url" | grep -q "github.com"; then
  repo=$(echo "$remote_url" | sed 's/.*github.com[:/]\(.*\)\.git$/\1/' | sed 's/._github.com[:/]\(._\)$/\1/')
  pr_info=$(gh pr list --repo "$repo" --head "$branch" --state all --json state,number --jq '.[0] | "\(.state)|\(.number)"' 2>/dev/null)
pr_state=$(echo "$pr_info" | cut -d'|' -f1)
pr_num=$(echo "$pr_info" | cut -d'|' -f2)
fi

remote_exists=$(git -C "$wt" ls-remote --heads origin "$branch" 2>/dev/null | head -1)

### Step 3: Apply Category Logic

| Category       | Signals                              | Action               |
| -------------- | ------------------------------------ | -------------------- |
| SAFE           | PR merged, no uncommitted changes    | Auto-remove          |
| MERGED+CHANGES | PR merged, has uncommitted changes   | Review changes first |
| STALE+OPEN     | PR open, no commits in 2+ months     | Probably abandoned   |
| ABANDONED      | PR closed without merge              | Confirm removal      |
| STALE+WIP      | No PR, remote exists, 2+ months old  | Forgotten            |
| UNKNOWN        | No PR, remote deleted, or non-GitHub | Unknown state        |
| DETACHED       | Detached HEAD                        | Manual review        |
| WIP            | No PR, remote exists, recent         | Keep                 |
| OPEN           | PR open, recent activity             | Keep                 |

### Step 4: Present Results

Display worktrees grouped by action required.

### Step 5: Get User Decision

Options:

- "Remove all safe worktrees" - SAFE category only
- "Review each one individually" - Go through SAFE + REVIEW categories one by one
- "Cancel" - Do nothing

### Step 6: Execute Removal

For approved removals:
main_repo=$(git -C "$wt" rev-parse --path-format=absolute --git-common-dir 2>/dev/null | sed 's/\/.git$//')
git -C "$main_repo" worktree remove "$wt"
git -C "$main_repo" worktree remove --force "$wt"  # if changes confirmed
git -C "$main_repo" worktree prune

## Safety Rules

- NEVER remove a worktree the user is currently inside
- NEVER auto-remove worktrees with uncommitted changes without explicit confirmation
- NEVER remove worktrees with OPEN PRs unless user explicitly requests
- Always show what will be removed before doing it
- Always run git worktree prune after removals

## Guidelines

- Start from the user's current project directory if it has worktrees, otherwise scan ~/projects
- The 2-month staleness threshold catches forgotten work without being too aggressive
- Merged PRs with no local changes are the only truly "safe" removals
- When in doubt about a category, ask the user
- For non-GitHub repos, default to UNKNOWN and let the user decide
- Report a summary at the end: how many removed, how many skipped, any errors
