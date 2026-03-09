---
description: "Cautious fix for legacy code — blast radius analysis, safety nets, and careful implementation"
argument-hint: "[description of what to fix, or triage item number]"
disable-model-invocation: true
---

# Safe Fix: Cautious Legacy Code Fix

Fix something in a legacy codebase without breaking anything else. Analyzes blast radius, creates safety nets, verifies extensively.

**vs `/plan` + `/execute`**: standard flow = your codebase, plan then implement. `/safe-fix` = inherited/unknown, understand → safety-net → fix → verify extensively.

**Philosophy:** The thing you don't understand is the thing that breaks. Every change gets a blast radius check first.

## Process

### Phase 0: Load User Context

If `.agents/more-context/` exists, read all files. Increase caution if `concerns.md` mentions the area being fixed.

### Phase 1: Understand the Target

Read `$ARGUMENTS`:
- **Triage item reference** → read latest `.agents/triage-report-*.md`, extract details
- **Description** → extract problem and affected area
- **No argument** → ask: "What do you want to fix?"

Investigate: read affected code + surrounding module, `git blame`, `git log --oneline -15 -- {file}`.

**Deliverable**: What we're changing and why.

### Phase 2: Blast Radius Analysis

- **Upstream**: who calls this code? (grep function/class names, check dynamic invocations)
- **Downstream**: what does it call? (APIs, databases, services)
- **Shared state**: globals, singletons, DB writes, cache invalidation
- **Side effects**: emails, webhooks, event emission
- **Timing**: sequence dependencies, async patterns

```
Direct impact:   [files directly using this code]
Indirect impact: [files using direct-impact files]
External impact: [APIs, databases, services]
```

**Deliverable**: Blast radius map with confidence: High / Medium / Low

### Phase 3: Safety Net

- **Tests exist and pass** → list them, run to confirm baseline
- **No tests** → write characterization tests: `test_{function}_current_behavior_{scenario}`, focus on real inputs
- **Tests exist but fail** → document which and why, do not fix yet

### Phase 4: Plan the Fix

Present: what changes, files modified, smallest possible diff, blast radius summary, confidence, safety net coverage. Wait for confirmation.

### Phase 5: Implement

1. Smallest diff — only what's needed
2. Re-read each file after editing
3. Match existing style exactly (consistency > style in legacy code)
4. No refactoring, no features
5. Comment if non-obvious: `# Fixed: [what] — [date]`

### Phase 6: Verify

1. Safety net tests pass? → 2. Full suite — new failures? → 3. Fix works? → 4. Blast radius files OK? → 5. Build OK?

If a previously-passing test now fails: **STOP immediately.** Present to user, do not proceed.

### Phase 7: Document

Save to `.agents/safe-fixes/fix-{YYYY-MM-DD}-{kebab-description}.md` with: what was fixed, blast radius, changes table, safety net results, verification checklist, rollback command.

## Next Step

- More items → `/safe-fix [next item]`
- Done → `/check` → `/review` → `/commit`
- Found more issues → `/triage`
