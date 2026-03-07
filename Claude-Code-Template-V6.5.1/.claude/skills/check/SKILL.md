---
description: Run comprehensive validation — types, tests, lint, build
---

# Check: Validate Project Health

Run comprehensive validation of the project. All commands are read from CLAUDE.md — this skill is framework-agnostic.

## 1. Lint / Format Check

Run the lint command defined in CLAUDE.md → Commands section.
If no lint command is documented, skip this step and note it.

## 2. Type Checking

Run the type check command defined in CLAUDE.md.
If the project doesn't use static types, skip this step.

## 3. Unit Tests

Run the test command defined in CLAUDE.md.

## 4. Build

Run the build command defined in CLAUDE.md.

## 5. Summary Report

After all validations complete, provide:

| Check | Status | Details |
|-------|--------|---------|
| Lint | PASS/FAIL/SKIPPED | [errors or "clean"] |
| Types | PASS/FAIL/SKIPPED | [errors or "no type errors"] |
| Tests | PASS/FAIL/SKIPPED | [X/Y passed] |
| Build | PASS/FAIL/SKIPPED | [errors or "build successful"] |
| **Overall** | **PASS/FAIL** | |

If any command is not documented in CLAUDE.md, report it as SKIPPED and note: "No [lint/type/test/build] command found in CLAUDE.md."

## Next Step

After validation:

- **All pass** → `/review` for code review, or `/commit` for small changes
- **Failures** → Fix issues and re-run `/check`
- **Running from `/execute` pipeline** → Continue to the next pipeline step
