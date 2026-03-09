---
description: "Create comprehensive implementation plan for new features, modifications, or refactors"
argument-hint: "[task description or reference to /describe output]"
disable-model-invocation: true
---

# Plan

## Task: $ARGUMENTS

## Iron Laws

- Never plan without reading the codebase first — plans built on assumptions fail during execution
- Every task must be completable in <30 minutes — split larger work into sub-tasks. Before finalizing, scan all tasks and split any that look >30 minutes.
- Never defer architecture decisions to execution — decide here, execute there
- Every task needs an executable validation command — untestable tasks get skipped or done wrong

## Process

Write plans to `.agents/plans/` using the Write tool. Do NOT use EnterPlanMode (saves to `~/.claude/plans/`, not git-tracked). Create directory if needed.

### Phase 0: Check for Existing PRD

1. Look for `PRD.md` in project root, `.claude/PRD.md`, or user-referenced PRD
2. If found: high confidence decisions → constraints; medium → validate; low → re-evaluate in Phase 4
3. If no PRD: complex projects → suggest `/create-prd` first; simple features → proceed

### Phase 1: Feature Understanding

- Core problem, user value, feature type (New / Enhancement / Refactor / Bug Fix)
- Complexity: Low / Medium / High
- Affected systems and components
- User story: `As a <user> I want <goal> So that <benefit>`

#### Bug Fix Path

When type is **Bug Fix**, inject these required plan tasks:

1. **Reproduce-first gate** — failing test or manual repro steps. Do not investigate fixes for unreproducible bugs.
2. **Binary search isolation** — comment out half suspect code, check persistence, repeat. Use `git bisect` for regressions.
3. **RCA documentation** — save to `.agents/rca/[kebab-case].md`:
   ```
   # Root Cause: [Title]
   Bug Summary | Expected vs Actual | Root Cause (files, functions, analysis)
   Proposed Fix: strategy, files to modify, risks
   ```
4. **Test-that-proves-bug-exists** — first task in testing strategy

For unclear root causes, invoke the `rca` subagent before proposing a fix.

### Complexity Gate

| Complexity | Criteria | Output |
|------------|----------|--------|
| **Simple** | Single file, clear change, no deps | Lightweight plan: tasks + validation only. Skip Phases 3-4. |
| **Medium** | Multiple files, some research | Single plan file. Full process. |
| **Complex** | New feature, arch decisions, 4+ phases / 15+ tasks | Phase index + sub-plans. Full process. |

### Split Plans (Complex Only)

- **Phase index** `.agents/plans/{name}-index.md`: overview, phases table, shared constraints, acceptance criteria
- **Sub-plans** `.agents/plans/{name}-phase-{N}.md`: complete standalone plans using full template
- Split when: 4+ independent phases or 15+ tasks

For **Simple** tasks: description, step-by-step tasks with validation, acceptance criteria. Skip to Phase 5.

### Phase 2: Codebase Intelligence

1. Project structure — languages, frameworks, config, build
2. Reference doc scan — list all files in `.claude/reference/` first, read first 5 lines of each, fully read only matching docs
3. Pattern recognition — find similar implementations in codebase for reference. Check naming, error handling, CLAUDE.md.
4. Dependencies — relevant libraries, versions, integration patterns
5. Testing patterns — framework, structure, coverage. Find existing test examples for reference.
6. Integration points — files to update, files to create, registration patterns, database/model patterns if applicable

Ask user if requirements are unclear.

### Phase 3: External Research

Research latest versions, best practices, official docs, known gotchas.

Check `.claude/reference/popular-skills.md` for community skills. If nothing matches, run `npx skills find [domain]`. Include relevant skills in plan's "Applicable Skills" section.

### Phase 3b: Confidence Check

| Decision Type | Confidence | Action |
|---------------|-----------|--------|
| Known pattern in codebase | High | Proceed |
| Common, well-documented | Medium | Proceed, note assumption |
| Novel, unfamiliar, conflicting | Low | Invoke `researcher` subagent |

Skip if all decisions are High/Medium.

### Phase 4: Strategic Thinking

Architectural fit, dependency ordering, edge cases, testing strategy, performance/security implications. Choose between approaches with clear rationale.

### Phase 5: Generate Plan

Read `.claude/templates/plan-template.md` and use as output structure. Fill from Phases 1-4.

**Filename**: `.agents/plans/{kebab-case-descriptive-name}.md`

**Cleanup**: Before finishing, check `.agents/plans/` for completed plans (matching a progress doc with Status: Complete). Archive them to `.agents/plans/archive/` to keep the folder lean.

## Anti-Patterns

| Pattern | Why it fails |
|---------|-------------|
| Planning without reading code | Assumptions diverge from reality → rework |
| Monolithic tasks | Large tasks get partially done, lose context |
| Missing validation commands | No way to verify → bugs slip through |
| Deferring "we'll figure it out" | Execution hits blockers, wastes tokens on retries |
| Skipping research for unfamiliar tech | Wrong patterns → full rewrite |

## Quality Criteria

- [ ] Every task has an executable validation command
- [ ] Tasks ordered by dependency, each atomic and independently testable
- [ ] Pattern references include file:line numbers
- [ ] Another developer could execute without additional context

## Next Step

1. Run `/update-progress` to capture the planning session
2. Suggest: "Run `/execute [plan-path]` to implement this plan."
