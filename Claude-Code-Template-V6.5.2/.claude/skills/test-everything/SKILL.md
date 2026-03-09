---
description: "Full testing pipeline — automated test sweep, browser/Playwright testing, dependency health audit, and manual test checklist. Use before releasing or when comprehensive validation is needed."
disable-model-invocation: true
---

# Test Everything: Comprehensive Testing Pipeline

Single command for full project validation. Runs four phases: automated tests, browser tests, dependency health, and manual checklist generation.

## Process

### Phase 0: Scope

Quick environment check first:

1. Check for CLAUDE.md, `.agents/plans/`, existing test files, `.agents/more-context/`
2. **If no tests, no plans, and no project context** → this is likely an unfamiliar codebase. Suggest: "It looks like this project hasn't been set up for testing yet. I'd recommend starting with `/thrown-into-someones-hell-hole` to understand the codebase first — that'll give us the context to write meaningful tests. Want to do that instead?"
3. **If user wants to continue anyway** → proceed, but phases will be limited

Then ask: **"What do you want to test? Specific areas, or everything?"**

- **Specific** → user names features, modules, or areas. Focus all phases on those.
- **Everything** → full sweep across the entire project.

Save the scope — all phases use it to stay focused.

### Phase 1: Automated Test Sweep

Run the test suite (scoped or full).

1. Read CLAUDE.md for test commands
2. Glob for test files (`**/*.test.*`, `**/test_*`, `**/*_test.*`, `**/*_spec.*`)
3. **If no tests found**:
   - Check `.agents/plans/` for an active plan
   - **Plan exists** → run `/test` to generate tests from the plan, then continue
   - **No plan** → report "No tests found. Run `/describe` → `/plan` → `/test` to create a test suite." and skip to Phase 2
4. Categorize: unit / integration / e2e
5. Run each suite, record: passed, failed, skipped, duration
6. Collect coverage if available
7. **If coverage is sparse** → flag gaps, ask "Want me to generate tests for uncovered areas?" (requires a plan — if no plan, suggest `/plan` first)
8. Log failures but continue — do not stop at first failure

**Output**: Inventory table + results table + failure details.

### Phase 2: Browser / Playwright Testing

1. Check if Playwright MCP is installed or if the project has Playwright config
2. **Installed** → run e2e browser tests, record results
3. **Not installed** → suggest: "Consider installing Playwright MCP for automated browser testing"
4. **No UI in project** → skip with note: "No UI detected, skipping browser tests"

### Phase 3: Dependency Health Audit

Quick dependency health check:

1. Detect package manager(s)
2. Run outdated command (`npm outdated`, `pip list --outdated`, etc.)
3. Run audit command (`npm audit`, `pip-audit`, etc.)
4. Check lock file: exists? committed? clean?
5. Flag: deprecated packages, major versions behind, known CVEs

**Verdict**: HEALTHY / AGING / CONCERNING / CRITICAL

### Phase 4: Manual Test Checklist

Generate a step-by-step manual test plan from recent changes:

1. Read active plan in `.agents/plans/` and `git log --oneline -10`
2. Extract: what was implemented, acceptance criteria, user-facing behaviors
3. Generate test steps that verify each criterion from a user's perspective
4. Save to `.agents/manual-test-plans/{feature-name}.md`

### Report

Summary table (Phase | Status | Details) for all 4 phases, then per-phase detail sections, then overall verdict.

## Outputs

- Phase 1-3: test results, coverage data, dependency health verdict (console output)
- Phase 4: `.agents/manual-test-plans/{feature-name}.md`
- Summary: 4-phase verdict table

## Next Step

- All clear → `/release` for QA → security audit → PR
- Test failures → `/describe` → `/plan` → `/execute`, then re-run
- Dependency issues → address critical CVEs first
