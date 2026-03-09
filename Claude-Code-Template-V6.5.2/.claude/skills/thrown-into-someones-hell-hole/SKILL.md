---
description: "Orchestrates the full brownfield pipeline for inherited codebases — intake, investigate, triage, fix. Use when dropped into an unfamiliar repo with no docs."
disable-model-invocation: true
---

# Thrown Into Someone's Hell-Hole

Single entry point for the brownfield pipeline. Chains: `/describe` (intake) → `/investigate` → `/triage` → fix loop.

## Process

### Phase 1: Intake

Run `/describe` in brownfield mode. Open-ended — accept whatever the user shares about the codebase, its problems, and context. Save after every user input to `.agents/more-context/`.

Keep going until the user says they've shared everything, or context is sufficient to proceed.

### Phase 2: Investigate

Run `/investigate`. Deep codebase analysis — tech stack, architecture, code health, tests, dependencies, mystery items.

Generates: `.agents/investigation-report-{YYYY-MM-DD}.md`

### Phase 3: Pause — Review Investigation

Present the investigation report summary to the user:
- Executive summary, scores table, top concerns
- Ask: **"Ready to triage and plan fixes?"**

Wait for confirmation before proceeding.

### Phase 4: Triage

Run `/triage` on the investigation report. Produces a ranked fix list prioritising user-reported issues from `.agents/more-context/`.

Generates: `.agents/triage-report-{YYYY-MM-DD}.md`

### Phase 5: Pause — Choose Fix Approach

Present the ranked fix list. Ask:

> **"How do you want to tackle these?"**
> - `/safe-fix` — cautious, blast-radius-aware (recommended for unfamiliar code)
> - `/plan` → `/execute` — standard development flow (when you're more confident)

### Phase 6: Fix Loop

For each fix (starting from Tier 1):
1. Run the chosen approach (`/safe-fix [item]` or `/plan` → `/execute`)
2. Auto-pipeline runs after each fix (test → review → check)
3. `/commit` after each successful fix
4. Ask: **"Continue to next item, or stop here?"**

## Outputs

- `.agents/more-context/*.md` — user-provided context (from intake)
- `.agents/investigation-report-{date}.md` — codebase state report
- `.agents/triage-report-{date}.md` — prioritized fix list
- `.agents/progress/` — progress doc per fix cycle
- Commits for each completed fix

## Next Step

- Stable after fixes → `/test-everything`
- More issues surfaced → re-run `/triage`
- Done → `/commit` remaining work
