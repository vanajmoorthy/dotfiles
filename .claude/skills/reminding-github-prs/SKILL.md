---
name: reminding-github-prs
description: Creates reminder messages for PRs awaiting review. Fetches open PRs across repos, ranks by merge-readiness, and generates copy-paste messages. Use when asking for PR review reminders, nudging reviewers, or "remind team about my PRs".
---

# Reminding GitHub PRs

Generate reminder messages for PRs that need reviews.

## Repositories

Search these repositories for open PRs:

- oban
- chivas
- lagavulin
- nikka-from-the-barrel

## Workflow

### Step 1: Fetch Open PRs

Get all open PRs authored by the current user across all repos:

```bash
# Get current GitHub username
gh api user --jq '.login'

# For each repo, fetch open PRs
gh pr list --repo oban --author @me --state open --json number,title,url,createdAt,changedFiles,reviews,reviewRequests
gh pr list --repo chivas --author @me --state open --json number,title,url,createdAt,changedFiles,reviews,reviewRequests
gh pr list --repo lagavulin --author @me --state open --json number,title,url,createdAt,changedFiles,reviews,reviewRequests
gh pr list --repo nikka-from-the-barrel --author @me --state open --json number,title,url,createdAt,changedFiles,reviews,reviewRequests
```

### Step 2: Calculate Review Status

For each PR, determine:

- **Approved reviews**: Count reviews where `state == "APPROVED"`
- **Unapproved reviews**: Count reviews where `state != "APPROVED"` (pending, changes requested, commented)
- **Age**: Calculate from `createdAt` - show in days if >24h, otherwise hours
- **Files changed**: From `changedFiles`

### Step 3: Calculate Merge Readiness Score

Rank PRs by how close they are to being mergeable. Need 2 approvals to merge.

**Scoring formula:**

- Base score = approved_count \* 50 (more approvals = closer to merge)
- Size penalty = -1 \* files_changed (smaller PRs are easier to review)
- If approved_count >= 2: add 100 (already mergeable, highest priority for awareness)

Higher score = closer to merge = show first.

### Step 4: Display Table

Present the PRs in a ranked table with PR links:

```
| # | PR Name | Unapproved | Approved | Age | Files | Link |
|---|---------|------------|----------|-----|-------|------|
| 1 | Fix auth bug | 0 | 1 | 2d | 3 | [#123](url) |
| 2 | Add feature X | 1 | 1 | 5h | 8 | [#456](url) |
| 3 | Refactor utils | 0 | 0 | 3d | 12 | [#789](url) |
```

Then ask the user:

> Which PRs would you like to remind about? Enter the numbers (e.g., 1, 2, 3):

### Step 5: Generate Reminder Message

Once the user provides numbers, generate a message in this exact format:

```
A few PRs I'm looking for reviews on:

• [10-word-max summary] - [PR URL]
• [10-word-max summary] - [PR URL]
```

**Summarizing titles:**

- Strip prefixes like "feat:", "fix:", "[WIP]"
- Use plain language, max 10 words
- Focus on what the PR does, not technical details

**Examples:**

- "Add user authentication flow" (from "feat: implement OAuth2 authentication with refresh tokens")
- "Fix checkout crash on empty cart" (from "[BUG] Cart page throws exception when items array is null")
- "Update API rate limits" (from "chore: Adjust rate limiting configuration for production")

### Step 6: Present for Copying

Display the message clearly so the user can copy it:

```
Here's your reminder message:

---
A few PRs I'm looking for reviews on:

• Add user authentication flow - https://github.com/org/repo/pull/123
• Fix checkout crash on empty cart - https://github.com/org/repo/pull/456
---
```

## Guidelines

- Run all repo queries in parallel for speed
- If a repo doesn't exist or returns an error, skip it silently
- Show "No open PRs found" if there are none across all repos
- Keep summaries genuinely short - 10 words max, no exceptions
- The message should be ready to paste into Slack/Teams without editing
