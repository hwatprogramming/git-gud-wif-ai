---
description: Technical code review for quality and bugs — auto-fixes low-severity, flags major
---

# Review: Code Review + Fix

Review recently changed files. Auto-fix low-severity, present medium+ to user.

## Iron Laws

- Never auto-fix security issues — always present to user regardless of perceived severity
- Review changed files only — do not scope-creep into unrelated code
- Every finding must have a file:line reference — vague findings are not actionable

## Severity Guide

| Severity | Examples | Action |
|----------|----------|--------|
| **Low** | Naming, unused imports, formatting | Auto-fix, mention in review |
| **Medium** | Possibly intentional logic, missing error handling, perf | Ask user |
| **High** | Security, data loss, race conditions, broken logic | Ask user, recommend fix |
| **Critical** | Exposed secrets, injection, auth bypass, corruption | Ask user, strongly recommend |

## Process

### 0. Check for Subagent Findings
If `code-reviewer` subagent already ran, use its findings as starting point. **Don't duplicate its analysis** — build on what it found.

### 1. Gather Context
Read CLAUDE.md, README, key files. Scan `.claude/reference/` headers (first 5 lines) — fully read only docs whose **Applies to** tags match the project stack.

### 2. Identify Changed Files

!`git status`
!`git diff HEAD`
!`git diff --stat HEAD`
!`git ls-files --others --exclude-standard`

Read each changed file in full.

### 3. Review Each File

1. **Logic Errors** — off-by-one, wrong conditionals, missing error handling, races
2. **Security** — injection, XSS, insecure data handling, exposed secrets
3. **Performance** — N+1 queries, inefficient algorithms, memory leaks
4. **Code Quality** — DRY violations, complexity, poor naming, dead code
5. **Pattern Adherence** — CLAUDE.md conventions, codebase consistency

### 4. Verify Issues
Run tests, confirm type errors, validate security concerns.

### 5. Auto-Fix Low-Severity
Fix immediately, list in "Auto-Fixed Issues".

### 6. Present Medium+ to User
List with severity, file, line, suggestion. Ask: "Fix these, or proceed?"

### 7. Fix Mode
Apply fixes → `/check` → report.

## Output

Save to `.agents/code-reviews/[name].md`

**Stats**: files reviewed / modified / added / deleted

**Auto-Fixed**: severity / file / line / issue / fix

**Needs Decision**: severity / file / line / issue / detail / suggestion

No issues → "Code review passed."

## Next Step

- No issues → `/update-progress` → `/commit`
- Fixed → `/check` → `/update-progress` → `/commit`
- In `/execute` → continue pipeline
