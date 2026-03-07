---
description: "Verify implementation against requirements — generates a QA report"
disable-model-invocation: true
---

# QA: Requirements Verification

Verify implementation meets requirements. Cross-references PRD user stories and acceptance criteria against the codebase.

**Release pipeline**: `/test-everything` → `/release` (chains `/qa` → `/security-audit` → `/create-pr`)

## Process

### 0. Prereq Check

Check for requirements: `PRD.md` / `.claude/PRD.md` → recent plan in `.agents/plans/` → `CLAUDE.md`.

**If none found** → suggest: "I can't find a PRD or requirements to verify against. Want to run `/create-prd` first? QA needs clear requirements to be meaningful."

If user wants to proceed anyway → ask them to describe the requirements verbally.

### 1. Load Requirements

Use: `PRD.md` / `.claude/PRD.md` → recent plan in `.agents/plans/` → `CLAUDE.md` → user-provided description.

### 2. Load Implementation

Read CLAUDE.md, list/read key source files, `git log --oneline -20`.
Scan `.claude/reference/` headers (first 5 lines) — fully read only docs whose **Applies to** tags match the project stack.

### 3. Verify User Stories

| Story | Status | Evidence | Gap |
|-------|--------|----------|-----|
| [text] | ✅ Met / ⚠️ Partial / ❌ Not Met | [file:line] | [if not met] |

### 4. Verify Acceptance Criteria

Each: ✅ Passes / ⚠️ Partial / ❌ Fails

### 5. Common QA Gaps

| Check | Pass/Fail | Notes |
|-------|-----------|-------|
| Error states | | |
| Empty states | | |
| Input validation | | |
| Loading/async | | |
| Edge cases | | |
| Accessibility (if UI) | | |

### 6. Generate Report

Save to: `.agents/qa-{YYYY-MM-DD}.md`

```markdown
# QA Report
**Date**: {date} | **Source**: {requirements source}

## Summary
Stories: ✅ {X} | ⚠️ {X} | ❌ {X}
Criteria: {X}/{total} | Gaps: {X}/{total}

## Verdict: {PASS / PASS WITH NOTES / FAIL}

## User Story Verification
## Acceptance Criteria
## Common Gap Checks
## Issues Found
```

## Next Step

- **PASS** → `/security-audit` → `/create-pr`
- **PASS WITH NOTES** → fix partial items → `/security-audit`
- **FAIL** → `/describe` → `/plan` → `/execute`
