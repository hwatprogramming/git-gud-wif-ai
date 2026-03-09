---
description: Create a new commit for all uncommitted changes
---

# Commit

Create a new commit for all uncommitted changes.

## Current State (auto-injected)

**Current state:**
!`git status`

**Uncommitted changes:**
!`git diff HEAD`

## Process

### 0. Pre-Commit Check

1. Review the git state above
2. **If no staged or unstaged changes exist**: Report "Nothing to commit — working tree clean" and stop
3. **If running standalone** (not from `/execute` pipeline): Suggest running `/check` first if there are significant changes. Don't block — just mention it.

### 1. Stage Changes

Stage untracked and changed files.

### 2. Draft Commit Message

Draft an atomic commit message with conventional prefix (`feat`, `fix`, `docs`, `refactor`, `test`, `chore`).

**Validate format**: Message must start with a recognized prefix followed by colon and space. If it doesn't, fix it before committing.

### 3. Commit

Commit immediately — do not ask for separate approval (the tool permission system handles confirmation).

## Note

This command is typically run as part of the post-execution pipeline (Step 6 of `/execute`). The full pipeline is: `/test` → code-reviewer → `/check` → `/review` → `/update-progress` → `/commit`.

## Next Step

After committing:

- **If you want to create a PR** → Run `/create-pr`
- **If running as part of `/execute` pipeline** → Continue to `/execution-report` if needed
- **If running standalone and you want to reflect** → Run `/execution-report` to analyze how it went
- **Otherwise** → Start the next task with `/help`
