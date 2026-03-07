---
description: Display template version, component inventory, and health status
argument-hint: "[skill-name for blast radius | 'check' for cross-references | no args for full report]"
---

# Template Info

## Process

Parse `$ARGUMENTS` to determine mode:
- **No args** → Full report (Steps 1-5)
- **`check`** → Cross-reference check only (Step 5)
- **`<skill-name>`** → Blast radius analysis only (Step 6)

### 1. Read Version

Read `.claude/template-version.json`. If missing: report "No template-version.json found" and stop.

Display: `Template: [name] v[version] | Upgraded: [date] | Source: [repo]`

### 2. Component Inventory

| Component | Location | Check |
|-----------|----------|-------|
| Subagents | `.claude/agents/*.md` | List each |
| Skills | `.claude/skills/*/SKILL.md` | Count + list |
| Hooks | `.claude/settings.json` | List configured hooks |
| Reference docs | `.claude/reference/*.md` | List each |

### 3. Health Check

- template-version.json exists and valid JSON
- settings.json exists and valid JSON
- All subagent files present
- All skill directories have SKILL.md
- CLAUDE.md exists

Report: **Healthy** or **Degraded** (with specifics).

### 4. Skill Dependency Map

Scan all `.claude/skills/*/SKILL.md` files for:
- "Next Step" references to other skills (e.g., "Run `/skillname`")
- Pipeline chain references (→ arrows, "then /skillname")
- Subagent invocations (e.g., "Invoke `agent-name` subagent")

Build and display dependency graph:
```
skill → [skills it references]
```

### 5. Cross-Reference Check

Scan all skills (`.claude/skills/*/SKILL.md`) and reference docs (`.claude/reference/*.md`) for references to skills that don't exist in `.claude/skills/`.

Report stale references:
```
| File | References | Status |
|------|------------|--------|
| review/SKILL.md | /nonexistent-skill | STALE |
```

If no stale references found: "All cross-references valid."

### 6. Blast Radius Analysis

Given `$ARGUMENTS` as a skill name:
1. **Upstream**: Show all skills that reference this skill (grep for `/skill-name` in all SKILL.md files)
2. **Docs**: Show all reference docs that mention this skill
3. **Pipelines**: Show all pipeline chains this skill belongs to (from workflow patterns in help, execute, skills-and-workflow-guide)
4. **Verdict**: "Safe to modify" (0 dependents) or "N skills/docs depend on this — review before changing"

### 7. Upgrade Guidance

If degraded or outdated: suggest copying latest template from source repo and merging updates while preserving project-specific CLAUDE.md and settings.json.

## Next Step

- Degraded → follow upgrade guidance
- Stale references → fix the references
- Healthy → no action needed
