---
description: Document progress after execution — what's done, what's left, findings — and sync docs if direction changed
argument-hint: "[optional description of what changed]"
---

# Update Progress

Capture implementation state after `/execute` or `/plan`. Produces a handoff document so the next session knows where to pick up. If direction changed, propagates updates across docs.

**When to run**: After any execution — complete or interrupted.

## Current State (auto-injected)

!`git status`

!`git log --oneline -5`

## Part 1: Capture Progress (Always Runs)

1. **What was planned** — read active plan from `.agents/plans/` or RCA from `.agents/rca/`
2. **What happened** — review git diff/log, cross-reference plan tasks
3. **Findings** — bugs found, unexpected patterns, wrong assumptions, edge cases, tech debt
4. **Remaining work** — what's left, blockers, plan revisions needed

### Save Progress Document

Save to: `.agents/progress/[plan-name]-progress.md`

```markdown
# Progress: [Feature/Fix Name]

**Plan**: [path]
**Date**: [date]
**Status**: [Complete / In Progress / Blocked]

## Completed
- [x] Task — description

## Remaining
- [ ] Task — description

## Findings
- **[Finding]**: Description and impact

## Blockers (if any)

## Next Session Should
1. [First action]
2. [Context needed]

## Files Changed
- `path` — what and why
```

---

## Part 2: Sync Docs (Only If Direction Changed)

**Check**: Did requirements shift, tech stack change, PRD no longer match, or user course-correct?

If no direction changes → skip Part 2.

If direction changed:

1. **Identify delta** — from `$ARGUMENTS` or ask: "What changed?"
2. **Assess impact** — does this affect PRD, CLAUDE.md, README, reference docs, plans?
3. **Draft changes** — for each doc: what section, current content, new content, why
4. **Confirm** with user before applying
5. **Apply** — update files, flag stale plans with warning

## Next Step

- Complete → `/commit`
- Incomplete → progress saved, start new session with `/prime`
- Major pivot → `/describe` to re-clarify
