---
description: "Sync project docs — archive completed plans, flag stale progress, sync CLAUDE.md/README.md"
disable-model-invocation: true
---

# Sync Docs: Archive, Clean, and Sync Project Documentation

Run whenever you want to tidy up `.agents/` and sync project docs. Standalone — not tied to session endings.

## Process

### 1. Scan Project State

1. Run `git status` and `git log --oneline -10`
2. Check for stale progress docs: run `git log --oneline -5 -- .agents/progress/` and flag any doc with Status: In Progress that hasn't been touched in the last 5 commits

### 2. Invoke Session-Cleanup Subagent

Delegate scan to `session-cleanup` subagent. It checks: plans to archive, stale progress docs (5+ commits without update), CLAUDE.md/README.md sync needs, orphaned files. If unavailable, perform these checks inline.

### 3. Present Cleanup Report

Show each category from the report. For each actionable item, ask:
- **Apply** — make the change
- **Skip** — leave it for now
- **Manual** — flag it but let the user handle it

### 3b. Folder Hygiene

Count files in `.agents/plans/` (excluding `archive/`) and `.agents/progress/`. If either has >10 files, flag for bulk archive:
- Show the file list with status (completed / in-progress / stale)
- Recommend archiving all completed plans and marking stale progress docs
- Let user confirm before bulk action

### 4. Apply Confirmed Changes

| Action | How |
|--------|-----|
| Archive plan | Move to `.agents/plans/archive/` (create dir if needed) |
| Bulk archive completed plans | Move ALL completed plans to archive at once, show summary |
| Mark stale doc | Add `> **STALE**: Not updated since [date/commit]` banner at top |
| Sync CLAUDE.md | Show proposed diff, apply after confirmation |
| Sync README.md | Show proposed diff, apply after confirmation |
| Orphaned files | List them, let user decide: keep / delete / archive |

### 5. Final Summary

```
## Sync Docs Complete

**Archived**: [N] plans moved to archive
**Synced**: [list of docs updated, or "no sync needed"]
**Flagged**: [stale docs marked]
**Skipped**: [list of items deferred]
```

## Next Step

- Run `/update-progress` → `/commit` to save session state
