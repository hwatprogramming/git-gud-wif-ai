---
description: Create a pull request from the current branch with auto-generated summary
argument-hint: "[base-branch (default: main)]"
---

# Create PR

Create a PR with auto-generated title and description.

## Prerequisites

Current branch is not main/master. Changes committed. Remote exists or can be pushed.

## Process

### 1. Gather Context

!`git status`
!`git log --oneline -10`

- Base branch: `$ARGUMENTS` or `main`
- Read active plan in `.agents/plans/` for feature description
- `git log [base]..HEAD --oneline` and `git diff [base]...HEAD --stat`

### 2. Generate PR Content

**Title**: conventional prefix + concise (<70 chars)

**Body**:
```
## Summary
- [2-4 bullets: what changed and why]
## Changes
- [file-level summary]
## Testing
- [what was tested, edge cases]
## Related
- [plan file, issues — "Fixes #123"]
```

### 3. Push and Create

1. Check remote: `git ls-remote --heads origin [branch]`
2. Push if needed: `git push -u origin [branch]`
3. Create: `gh pr create --title "[title]" --body "[body]" --base [base]`

### 4. Report

PR URL, title, base ← head, commit count.

## Next Step

- Needs review → share URL
- Ready to merge → `gh pr merge [number] --squash` (confirm first)
