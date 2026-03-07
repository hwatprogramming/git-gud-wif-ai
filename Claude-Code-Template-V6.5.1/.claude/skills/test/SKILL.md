---
description: Implement and run tests — with structured planning and no blind retries
argument-hint: "[path-to-test-plan OR feature description]"
---

# Test: Implement and Execute Tests

## Prerequisites

- A test plan at `$ARGUMENTS`, OR a feature description, OR user instructions
- If nothing provided, check `.agents/plans/` for `*-tests.md`, else Phase 0 handles discovery

## Iron Law

No production code without a failing test first. If a test passes immediately, it proves nothing -- delete and rewrite.

## Process

### Phase 0: Discovery (if no input)

1. Check for existing context: `$ARGUMENTS`, `.agents/plans/*-tests.md`, `.agents/more-context/`
2. **If no context at all** → suggest: "I don't have much context on what to test. Want to run `/describe` first to scope it out? That'll help me write more targeted tests."
3. **If user wants to proceed anyway** → ask: "What feature or area do you want to test?"
4. Clarify: feature/component, new code or coverage improvement, unit/integration/e2e, edge cases to prioritize
5. Summarize in 3-5 bullets, confirm, proceed

Skip if user provided clear instructions or a test plan exists.

### Phase 1: Understand Scope

- **Test plan provided** -> read entirely, understand data strategy and structure
- **Feature description** -> read code, identify public interfaces, map branching logic, find edge cases and external deps

### Phase 2: Test Plan

Scan `.claude/reference/` headers (first 5 lines) -- fully read only docs whose **Applies to** tags match the project stack.

Invoke the `test-planner` subagent to validate your test approach before writing code.

If no plan exists, create a lightweight one:
1. Analyze existing test structure, conventions, framework
2. Design test cases: Name / Type / Input / Expected / Priority
3. Design data strategy:
   - Fixtures and factories, not live data
   - Each test creates own data (no shared state)
   - Mock external services
   - Deterministic data, cleanup after tests

### Phase 3: Implement and Validate (Fix-As-You-Go)

**Process one test file at a time. Fix failures before moving to the next.**

For each file (High -> Medium -> Low priority):

1. **Create** test file following project conventions
2. **Set up** fixtures and mocks before assertions
3. **Write** test cases -- one per behavior, Arrange -> Act -> Assert, independent
4. **Run** this file only (not full suite)
5. **Fix loop** (max 3 attempts): read error -> classify (test bug / feature bug / environment / flaky) -> targeted fix -> re-run. If still failing after 3: stop, report, ask user.
6. **Continue** to next file

Never retry without changing something.

### Phase 4: Final Suite Validation

Run full test suite + coverage. All files should pass individually already. Fix isolation issues if interaction failures appear.

### Phase 5: Report

- Total files/cases: passed/failed
- Coverage (if available)
- Fix loop activations: which files, attempts each
- Feature bugs discovered

## TDD Rationalizations (Red Flags)

| Rationalization | Why it fails |
|----------------|-------------|
| "Too simple to test" | Simple code breaks frequently and silently |
| "I'll add tests after" | Tests-after verify existing behavior, not requirements |
| "Already manually tested" | Manual tests can't be replayed on every change |
| "TDD slows me down" | Debugging untested code in production is slower |
| "Hard to test" | Difficult testing reveals poor interface design |
| "This case is different" | Standardized approach prevents rationalizing |

## Anti-Patterns

- Don't run full suite after every file
- Don't accumulate failures -- fix before moving on
- No blind retries, hardcoded delays, order dependency, shared mutable state, external network calls in unit tests

## Verification Checklist

Before marking tests complete: every new function has a test, each test was observed failing first, failures occurred for expected reasons, minimal code passed each test, edge cases covered.

## Next Step

- All pass -> `/check` -> `/commit`
- Feature bugs found -> `/describe` → `/plan` → `/execute`
- Want comprehensive testing -> `/test-everything` for full test sweep + manual checklist
- Part of `/execute` -> return to pipeline
