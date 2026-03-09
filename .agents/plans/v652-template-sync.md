# Feature: V6.5.2 Template Sync & Rename

The following plan should be complete, but validate documentation and codebase patterns before implementing.

## Feature Description

Mirror all V6.5.2 skill/doc changes from root `.claude/` into the distributable template folder, rename the folder from V6.5.1 to V6.5.2, update all references across the repo, and align token usage numbers in README and reference guide.

## User Story

As a template user
I want the distributable template folder to reflect V6.5.2 changes
So that cloning/downloading the repo gives me the latest version

## Problem Statement

Root `.claude/` has been upgraded to V6.5.2 (12 modified skills, 1 new reference doc, version bump) but the distributable `Claude-Code-Template-V6.5.1/` folder still has V6.5.1 content. README and CLAUDE.md reference "V6.5.1" throughout. Token usage numbers need updating.

## Solution Statement

Copy changed files into the template folder, rename the folder, update all version references, and correct token numbers in docs.

## Feature Metadata

**Feature Type**: Enhancement
**Estimated Complexity**: Low
**Primary Systems Affected**: Template folder, README.md, CLAUDE.md, reference docs
**Dependencies**: None

---

## CONTEXT REFERENCES

### Relevant Codebase Files — READ BEFORE IMPLEMENTING

- `README.md` (lines 86, 131, 157) - V6.5.1 references and token usage section
- `CLAUDE.md` (lines 3, 9, 15, 21) - V6.5.1 folder references
- `Claude-Code-Template-V6.5.1/README.md` (lines 1, 6) - Template title and changelog
- `Claude-Code-Template-V6.5.1/.claude/template-version.json` - Version file
- `.claude/reference/token-and-rate-limit-guide.md` (lines 11-31, 126-131) - Token tables and TL;DR

### Files to Modify (in template folder)

12 skill files + 1 version file + 1 new reference doc to copy in:
- `.claude/skills/create-prd/SKILL.md`
- `.claude/skills/create-skill/SKILL.md`
- `.claude/skills/execute/SKILL.md`
- `.claude/skills/execution-report/SKILL.md`
- `.claude/skills/plan/SKILL.md`
- `.claude/skills/qa/SKILL.md`
- `.claude/skills/review/SKILL.md`
- `.claude/skills/safe-fix/SKILL.md`
- `.claude/skills/security-audit/SKILL.md`
- `.claude/skills/setup/SKILL.md`
- `.claude/skills/update-progress/SKILL.md`
- `.claude/skills/upgrade-template/SKILL.md`
- `.claude/template-version.json`
- `.claude/reference/token-and-rate-limit-guide.md` (new file)

### Patterns to Follow

- Conventional commits: `docs:` for doc updates, `chore:` for template sync
- Template folder is self-contained — must work when copied standalone

---

## STEP-BY-STEP TASKS

Execute every task in order, top to bottom.

### Task 1: Copy 12 modified skill files into template folder

- **IMPLEMENT**: For each of the 12 modified skill files, copy from root `.claude/skills/*/SKILL.md` to `Claude-Code-Template-V6.5.1/.claude/skills/*/SKILL.md`
- **VALIDATE**: `diff .claude/skills/execute/SKILL.md Claude-Code-Template-V6.5.1/.claude/skills/execute/SKILL.md` — should show no diff for all 12 files

### Task 2: Copy new reference doc into template folder

- **IMPLEMENT**: Copy `.claude/reference/token-and-rate-limit-guide.md` to `Claude-Code-Template-V6.5.1/.claude/reference/token-and-rate-limit-guide.md`
- **VALIDATE**: `diff .claude/reference/token-and-rate-limit-guide.md Claude-Code-Template-V6.5.1/.claude/reference/token-and-rate-limit-guide.md`

### Task 3: Update template-version.json in template folder

- **IMPLEMENT**: Update `Claude-Code-Template-V6.5.1/.claude/template-version.json` to version 6.5.2, date 2026-03-09
- **VALIDATE**: `cat Claude-Code-Template-V6.5.1/.claude/template-version.json` — should show 6.5.2

### Task 4: Update template README.md (What's New section)

- **IMPLEMENT**: In `Claude-Code-Template-V6.5.1/README.md`:
  - Change title from "V6.5.1" to "V6.5.2"
  - Replace "What's New in V6.5.1" with "What's New in V6.5.2" and update content to reflect V6.5.2 changes:
    - Expanded downstream readiness checklist in `/create-prd`
    - Reordered `/execute` pipeline (commit earlier, progress mandatory)
    - Reference doc cleanup step in `/setup`
    - `/create-skill` now updates `/help` table
    - Stronger enforcement in `/update-progress`, `/safe-fix`, `/upgrade-template`
    - New `token-and-rate-limit-guide.md` reference doc (9 total, up from 8)
    - Deprecated skill cleanup in `/upgrade-template`
  - Update "34 Skills" mention if count changed (it didn't — still 34)
  - Update reference doc count from 8 to 9 in directory structure section
- **VALIDATE**: Read the file and verify no "6.5.1" remains

### Task 5: Rename template folder

- **IMPLEMENT**: `git mv Claude-Code-Template-V6.5.1 Claude-Code-Template-V6.5.2`
- **VALIDATE**: `ls -d Claude-Code-Template-V6.5.2` succeeds, `ls -d Claude-Code-Template-V6.5.1` fails

### Task 6: Update root README.md

- **IMPLEMENT**: Replace all "V6.5.1" / "Claude-Code-Template-V6.5.1" references with "V6.5.2" / "Claude-Code-Template-V6.5.2"
- Update token usage section (line 131):
  - Change "~6,000-8,000 tokens" → "~5,500-7,500 tokens" (with system prompt)
  - Change "~3-4%" → "~3-4%" (stays the same)
  - Change "~400-1,400 tokens" → "~400-1,150 tokens" per skill
- **VALIDATE**: `grep -n "6\.5\.1" README.md` — should return nothing

### Task 7: Update root CLAUDE.md

- **IMPLEMENT**: Replace all "V6.5.1" / "Claude-Code-Template-V6.5.1" references with "V6.5.2" / "Claude-Code-Template-V6.5.2"
- **VALIDATE**: `grep -n "6\.5\.1" CLAUDE.md` — should return nothing

### Task 8: Update token-and-rate-limit-guide.md

- **IMPLEMENT**: Update the reference guide with V6.5.2 numbers:
  - Always-loaded table: keep as-is (~2,575, close enough to current values)
  - On-demand section: Skills 34 → ~25,500; Reference docs 8→9 → ~10,650; Subagents 6 → ~5,550
  - Update per-skill range if needed
  - Fix TL;DR: "~2,500 tokens (~1.3% of context)" — add note that with system prompt it's ~5,500-7,500
- **VALIDATE**: Read file, verify numbers are internally consistent

### Task 9: Final validation

- **IMPLEMENT**: Run full grep for any remaining "6.5.1" references across the repo
- **VALIDATE**: `grep -rn "6\.5\.1" --include="*.md" --include="*.json" . | grep -v ".git/"` — should return nothing

---

## TESTING STRATEGY

### Manual Validation
- Grep for stale "6.5.1" references
- Diff all 12 skill files between root and template to confirm sync
- Verify template folder is self-contained (has all expected files)

---

## VALIDATION COMMANDS

### Level 1: No stale references
```bash
grep -rn "6\.5\.1" --include="*.md" --include="*.json" . | grep -v ".git/"
```

### Level 2: Skills in sync
```bash
for f in create-prd create-skill execute execution-report plan qa review safe-fix security-audit setup update-progress upgrade-template; do
  diff ".claude/skills/$f/SKILL.md" "Claude-Code-Template-V6.5.2/.claude/skills/$f/SKILL.md" && echo "$f: OK" || echo "$f: MISMATCH"
done
```

### Level 3: Template folder completeness
```bash
ls Claude-Code-Template-V6.5.2/.claude/template-version.json
ls Claude-Code-Template-V6.5.2/.claude/reference/token-and-rate-limit-guide.md
ls Claude-Code-Template-V6.5.2/README.md
```

---

## ACCEPTANCE CRITERIA

- [ ] All 12 modified skills identical between root and template
- [ ] New reference doc copied to template
- [ ] Template folder renamed to V6.5.2
- [ ] Zero "6.5.1" references remaining in repo
- [ ] Token numbers updated in README and reference guide
- [ ] Template README has V6.5.2 changelog
