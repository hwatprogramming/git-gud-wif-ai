---
description: "Upgrade a project's template — merge skills, agents, rules, docs without overwriting customizations"
argument-hint: "[template-source-path] [target project path(s)]"
disable-model-invocation: true
---

# Upgrade Template: Push Template Updates to a Project

Merge template components into a project's `.claude/` — new files added, existing template files updated, custom project files preserved.

**Template source**: Provide path to template directory via `$ARGUMENTS`, or configure in this skill for your setup.

## Process

### 1. Discover Targets

**If `$ARGUMENTS` provided:** First arg containing `.claude/` = template source, remaining = targets.

**If no arguments:** Ask user for:
1. Template source path (directory containing `.claude/`)
2. Target project path(s)

Show each target with `.claude/` status: `[x]` = upgrade, `[ ]` = fresh install.

**For each target:**

- **No `.claude/` (fresh install):** Confirm → copy entire template → scaffold `.agents/` dirs → write `template-version.json` → suggest `/setup`. Stop here.
- **Has `.claude/` (upgrade):** Read both `template-version.json` files, report versions. If already current, warn and wait for confirmation.

### 2. Inventory Source & Target

Dynamically list `.claude/` contents in both (skills, agents, rules, reference, templates, settings.json). Do not hardcode file names.

### 3. Compute Upgrade Manifest

| Category | Meaning | Action |
|----------|---------|--------|
| **ADD** | In template, not in target | Copy |
| **UPDATE** | In both | Template overwrites |
| **PRESERVE** | In target only | Untouched |

### 4. Present Plan & Get Approval

Show full manifest with counts per component type. Ask: "Proceed with upgrade?" Do not change anything until confirmed.

### 5. Copy Components

Copy each component individually (merge, not replace):
- **Skills**: `cp -r` each skill folder
- **Agents/Rules/Reference**: `cp` each .md file
- **Templates**: replace entire directory

Create missing directories first. Batch copies with loops.

### 6. Merge settings.json

- **permissions.allow/deny**: Show additions, note custom entries preserved, ask to confirm
- **hooks**: Show new/changed hooks, ask per section
- **Quick option**: "Take all template defaults" for projects with no customizations
- No target settings.json → copy directly. Invalid → warn, offer replace or skip.

### 7. Scaffold & Update Version

- Copy `.agents/changelog.md` only if missing (never overwrite)
- Create `.agents/code-reviews/`, `.agents/execution-reports/` if missing
- Write `template-version.json` with new version and today's date

### 8. Loop & Summary

Repeat steps 2-7 for each target. Final rollup:

```
=== Upgrade Summary ===
ProjectName → v[version]  (add: 2, update: 15, preserve: 1)
All projects upgraded to v[version].
```

## Do Not Touch

Project-specific files: `CLAUDE.md`, `README.md`, `.mcp.json`, `.gitignore`, `.agents/plans/*`, `.agents/progress/*`, `.agents/changelog.md` (if exists), custom skill/reference folders.

## Next Step

Run `/template-info check` in the target project to verify no stale references after upgrade.
