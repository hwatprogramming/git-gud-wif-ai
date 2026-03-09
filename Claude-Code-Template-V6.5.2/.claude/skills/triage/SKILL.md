---
description: "Prioritize codebase issues by severity and effort — generates a ranked fix list"
argument-hint: "[path to investigation report, or 'auto' to find latest]"
disable-model-invocation: true
---

# Triage: Prioritize and Rank Issues

After `/investigate` reveals codebase state, triage turns findings into a prioritized fix list. Answers: "With limited time, what should I fix first?"

## Process

### Step 0: Load User Context

If `.agents/more-context/` exists, read all files. Include `known-issues.md` alongside investigation findings. Factor `concerns.md` into risk scoring.

**User-reported issues from `.agents/more-context/` take PRIORITY over codebase-detected issues.** These come from someone who knows the project — weight them accordingly.

### Step 1: Load Investigation Context

- `$ARGUMENTS` is a path → read that report
- `$ARGUMENTS` is "auto" or empty → find latest `.agents/investigation-report-*.md`
- No report exists → tell user to run `/investigate` first, stop

Extract: scores, code smells, mystery items, concerns, dependency issues, TODO/FIXME items.

### Step 2: Categorize Issues

| Category | Description |
|----------|-------------|
| **Security** | Vulnerabilities, exposed secrets, auth issues |
| **Stability** | Crash risks, data corruption, race conditions |
| **Functionality** | Broken features, incorrect logic, edge cases |
| **Maintainability** | Code smells, tech debt, missing docs |
| **Cosmetic** | Style, naming, formatting |

If the report lacks detail for a category, do a quick targeted scan.

### Step 3: Score Each Issue

| Dimension | Scale | Description |
|-----------|-------|-------------|
| **Severity** | 1-5 | Impact if not fixed |
| **Effort** | 1-5 | Work to fix |
| **Risk** | 1-5 | Chance of breaking something else |

**Priority = Severity × 2 - Effort - Risk + User Bonus** (higher = fix first)

User-reported issues (from `.agents/more-context/`) get **+2 bonus** to priority score.

### Step 4: Generate Ranked Fix List

| Tier | Criteria | Action |
|------|----------|--------|
| **1: Fix Now** | High severity, low effort/risk | Quick wins — do first |
| **2: Plan and Fix** | High severity, higher effort | Needs `/plan` first |
| **3: Convenient** | Medium severity, low effort | Low-hanging fruit |
| **4: Backlog** | Low severity or high effort | Track, don't rush |
| **5: Leave It** | Not worth fixing | Risk outweighs benefit |

### Step 5: Generate Report

Save to: `.agents/triage-report-{YYYY-MM-DD}.md`

```markdown
# Triage Report

**Date**: {date} | **Source**: {report path} | **Total Issues**: {count}

## Summary
| Tier | Count | Description |
|------|-------|-------------|

## Tier 1: Fix Now
| # | Issue | Category | Sev | Effort | Risk | Priority | Location |
|---|-------|----------|-----|--------|------|----------|----------|
Suggested approach for each item.

## Tier 2: Plan and Fix
{table — each needs a `/plan` first}

## Tier 3-5
{abbreviated tables}

## Recommended Fix Order
{numbered list considering dependencies between fixes}

## Estimated Effort
| Tier | Estimate |
|------|----------|
```

## Next Step

- First Tier 1 item → `/safe-fix [description]`
- Dependency issues in Tier 1 → address in `/test-everything` Phase 3
- No Tier 1 → start Tier 2 with `/plan` + `/execute`
