---
description: "Release pipeline — QA verification, security audit, and PR creation. Use when ready to ship after testing."
disable-model-invocation: true
---

# Release: Ship It Pipeline

Orchestrates the release sequence: verify requirements → audit security → create PR.

Consider running `/test-everything` first if you haven't already.

## Process

### Step 1: QA Verification

Run `/qa` — cross-reference implementation against PRD/plan requirements.

- **PASS** → continue to Step 2
- **PASS WITH NOTES** → show notes, ask: "Fix partials first, or continue?"
- **FAIL** → stop, show failures, suggest: `/describe` → `/plan` → `/execute`
- **Brownfield path**: If no PRD exists (e.g., after `/thrown-into-someones-hell-hole`), `/qa` verifies against the plan and CLAUDE.md instead. Ensure at least one documents the acceptance criteria.

### Step 2: Security Audit

Run `/security-audit` — dependency CVE scan + OWASP code review.

- **PASS** → continue to Step 3
- **PASS WITH NOTES** → show notes, continue (Medium findings are acceptable)
- **FAIL** (Critical/High) → stop, suggest fixes before proceeding

### Step 3: Create PR

Run `/create-pr` — auto-generate PR with summary from plan + commits.

### Report

Results table (Step | Verdict | Details) for QA, Security, PR.

## Next Step

- PR created → share URL for review
- Ready to merge → `gh pr merge [number] --squash` (confirm first)
- Issues found → fix with `/plan` → `/execute`, re-run `/release`
