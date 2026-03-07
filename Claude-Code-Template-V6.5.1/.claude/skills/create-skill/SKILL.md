---
description: "Create a new skill to automate a repeated workflow, with optional eval-driven iteration"
argument-hint: "[description of what the skill should do]"
disable-model-invocation: true
---

# Create Skill

Two modes:
- **Quick** (default): Interview → draft → verify
- **Full**: Interview → draft → test → iterate → optimize description

## Process

### Phase 1: Capture Intent

Extract from `$ARGUMENTS` or conversation. If "turn this into a skill", extract from conversation history — tools used, step sequence, corrections, formats.

Clarify if needed: what it enables, trigger (user-only or auto-suggest), inputs, outputs, type (conversational or action), trigger phrases.

### Phase 2: Interview & Research

Edge cases, formats, examples, success criteria, dependencies. Check `.claude/skills/` for overlap — extend existing if better. Check `popular-skills.md` or `npx skills find [domain]` for community patterns.

### Phase 3: Design

**Read `.claude/reference/skill-authoring-guidelines.md` first.**

| Property | Question |
|----------|----------|
| Name | Verb-first kebab-case |
| Description | Third person, WHAT + WHEN, trigger phrases |
| Arguments | Format? |
| Model invocation | Auto-suggest or user-only? |

Design workflow: numbered steps, decision points, validation, "done" definition.

### Phase 4: Write SKILL.md

1. Create `.claude/skills/[name]/`
2. Write `SKILL.md`: frontmatter + body (`# Title` → `## Process` → `## Output` → `## Next Step`)
3. Style: imperative voice, `$ARGUMENTS` for input, structured over prose
4. Explain WHY behind non-obvious rules
5. Push detailed reference to supporting files (`references/`, `scripts/`, `assets/`) — zero token cost until read
6. Deterministic/repetitive work → write a script in `scripts/` rather than prose
7. Verify against authoring guidelines checklist

### Phase 5: Confirm

1. Present: name, description, type, arguments, steps, workflow placement
2. Check file exists with valid YAML
3. **Quick mode** → "Created `/[name]` — try it out." Stop here.
4. **Full mode** → Continue to Phase 6.

---

## Full Mode: Test & Iterate

### Phase 6: Create Test Cases

Write 2-3 realistic test prompts. Save to `evals/evals.json` in skill directory. See `references/eval-schemas.md` for schema.

### Phase 7: Run Test Cases

For each test case, spawn two subagents in parallel:
1. **With-skill** → save to `{skill}-workspace/iteration-{N}/eval-{ID}/with_skill/outputs/`
2. **Baseline** (no skill) → save to `without_skill/outputs/`

Draft assertions while runs execute. Capture `total_tokens` and `duration_ms` to `timing.json`.

### Phase 8: Grade & Review

1. Grade using `agents/grader.md` instructions → `grading.json`
2. Aggregate: `python -m scripts.aggregate_benchmark {workspace}/iteration-N --skill-name {name}`
3. Launch viewer: `python {create-skill-path}/eval-viewer/generate_review.py {workspace}/iteration-N --skill-name "{name}" --benchmark {workspace}/iteration-N/benchmark.json`
4. Collect feedback as `feedback.json`

### Phase 9: Iterate

Read `feedback.json`. Generalise from feedback — don't overfit to test cases. Keep prompt lean. Bundle repeated work into `scripts/`. Draft, revise, then commit.

Rerun into `iteration-{N+1}/`, launch viewer with `--previous-workspace`, collect feedback. Repeat until satisfied.

### Phase 10: Optimize Description (Optional)

1. Generate 20 eval queries (8-10 should-trigger, 8-10 should-not)
2. Review with user via `assets/eval_review.html`
3. Run: `python -m scripts.run_loop --eval-set {path} --skill-path {path} --model {model-id} --max-iterations 5 --verbose`
4. Apply `best_description` to frontmatter

## Supporting Files

| Directory | Contents |
|-----------|----------|
| `agents/` | Grader, comparator, analyzer agent instructions |
| `references/` | JSON schemas for evals, grading, benchmarks |
| `scripts/` | Benchmark aggregation, description optimization, packaging |
| `eval-viewer/` | HTML review UI generator |
| `assets/` | HTML templates for eval review |
