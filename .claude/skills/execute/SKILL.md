---
description: Execute an implementation plan
argument-hint: "path-to-plan"
---

# Execute: Implement from Plan

> **MANDATORY**: After all tasks are implemented, you MUST continue to the **Template Sync Gate** (if applicable) then the **Post-Execution Pipeline** below. Do NOT stop after the output report — the pipeline handles validation, review, progress tracking, and commit.

## Plan to Execute

Read plan file: `$ARGUMENTS`

- **No path** → find most recent in `.agents/plans/`, ask if multiple
- **Path provided** → use directly (check `.agents/plans/` if no directory)
- Only execute from `.agents/plans/` — not `~/.claude/plans/`

**Phase index** (filename ends `-index.md` or contains Phases table):
1. Read index, understand all phases
2. List sub-plans for user
3. Ask: "Start with Phase 1, or a specific phase?"
4. Execute one phase at a time — each gets its own pipeline run

## Execution

### 1. Read and Understand
Read the entire plan. Understand tasks, dependencies, validation commands, testing strategy.
Scan `.claude/reference/` headers (first 5 lines) — fully read only docs whose **Applies to** tags match the project stack.

### 2. Execute Tasks in Order
For each task: read existing files → implement following specs → verify syntax/imports/types after each change.

### 3. Implement Testing Strategy
Create test files from the plan, implement cases, cover edge cases.

### 4. Run Validation Commands
Run all validation commands. If failure:
1. Read error, attempt one targeted fix, re-run
2. Still failing → invoke `rca` subagent with error context
3. Apply rca fix, re-run. Continue only when passing.

### 5. Final Verification
All tasks done, tests passing, validation clean, conventions followed.

## Output Report

- **Completed Tasks**: list with file paths
- **Tests Added**: files and results
- **Validation Results**: each command output

## Template Sync Gate

Read and follow `template-sync-gate.md` in this skill's directory. Skip if conditions don't apply.

## Pipeline Gate

| Scope | Criteria | Pipeline |
|-------|----------|----------|
| **Small** | ≤3 files, ≤100 lines, no new deps | `/check` → `/update-progress` → `/commit` |
| **Medium** | 4-10 files, new deps, or API changes | `/test` → `/check` → `/review` → `/update-progress` → `/commit` |
| **Large** | 10+ files, architecture changes, new features | Full pipeline below |

After assessing scope, use `TodoWrite` to register applicable pipeline steps.

---

## Post-Execution Pipeline

> **First**: Use `TodoWrite` to register the steps that apply to your scope. Check each off as you complete it — this makes skipped steps immediately visible.

### Step 1: Test
Run `/test` — plan's testing strategy, fix-as-you-go. `test-planner` subagent validates test plan.

### Step 2: Code Review (subagent)
Invoke `code-reviewer` subagent on all changes. Produces findings for Step 4.

### Step 3: Validate
Run `/check` — lint, types, tests, build. Fix and re-run until clean.

### Step 4: Code Review
Run `/review` starting from subagent findings (Step 2). Auto-fix low-severity, present medium+ to user.

### Step 5: Update Progress (MANDATORY — all scopes)
Run `/update-progress` to capture session state, document findings, and record quality check results. Run this **after** quality checks so the progress doc reflects the full picture.

### Step 6: Commit
Run `/commit` — draft message and commit.

### Step 7 (optional): Execution Report
Run `/execution-report` — only if divergences or challenges were detected during execution. Skip if clean.

### Step 8 (optional): Sync Docs
Ask: "Want to run `/sync-docs`? It archives completed plans, flags stale docs, and syncs CLAUDE.md/README.md." Skip if declined.
