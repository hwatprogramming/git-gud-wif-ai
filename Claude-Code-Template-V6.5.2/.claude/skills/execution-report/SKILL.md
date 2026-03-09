---
description: Generate implementation report — with smart process improvement when divergences are found
argument-hint: "[plan-file]"
---

# Execution Report

Review the implementation just completed. If divergences or challenges exist, analyze root causes and apply process improvements.

## Context & Inputs

- **Plan**: `$ARGUMENTS` (or most recent in `.agents/plans/`)
- **Execute skill**: Read `.claude/skills/execute/SKILL.md`
- **Current state**: !`git diff --stat` and !`git log --oneline -10`

## Part 1: Generate Report (Always Runs)

Save to: `.agents/execution-reports/[feature-name].md`

Include:
- **Meta**: plan file, files added/modified, lines changed
- **Validation Results**: linting, types, tests — pass/fail
- **What Went Well**: specifics
- **Challenges**: specifics with reasons
- **Divergences**: for each — planned vs actual, reason, type (Better approach / Plan wrong / Security / Performance / Other)
- **Skipped Items**: what and why
- **Recommendations**: plan/execute/CLAUDE.md improvements

## Smart Gate: Run Part 2?

- 2+ divergences, challenges, or skipped items → run Part 2
- Clean execution → skip Part 2, done

## Part 2: Process Improvement (Only When Triggered)

### 1. Classify Divergences
- **Good**: plan assumed wrong, better pattern found, perf/security needed
- **Bad**: ignored constraints, wrong architecture, shortcuts, misunderstood requirements

### 2. Trace Root Causes
Plan unclear? Context missing? Validation missing? Manual step repeated?

### 3. Generate Improvements
CLAUDE.md updates, skill updates, new skills, validation additions.

### 4. Categorize & Apply

| Safe to Apply | Defer to User |
|---|---|
| Add patterns/conventions/gotchas | Remove/restructure instructions |
| Add validation steps | Change workflow order |
| Clarify ambiguous instructions | Change output formats |

**Safe**: read target, edit, log. Only reusable things. Preserve structure.
**Risky**: add to report as "Changes NOT Applied" with rationale.

### 5. Log to Changelog
Append to `.agents/changelog.md` (create if it doesn't exist): date, trigger, applied/deferred changes, rationale. Every finding must have a concrete improvement suggestion.

## Next Step

- `/update-progress` → review deferred changes → check `.agents/changelog.md`
- Be specific (not "plan was unclear" but "plan didn't specify auth pattern"). Focus on patterns. Every finding needs a concrete suggestion.
