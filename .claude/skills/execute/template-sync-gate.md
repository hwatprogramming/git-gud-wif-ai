# Template Sync Gate

Applies when: a `Claude-Code-Template-V*/` folder exists at repo root AND `git diff --name-only` shows changes in `.claude/skills/`, `.claude/reference/`, `.claude/agents/`, `.claude/templates/`, `.claude/rules/`, `.claude/settings.json`, or `.claude/template-version.json`.

If both conditions are false, skip to Pipeline Gate.

## Steps

### 1. Version Decision
"Template files changed. What version number for this release?" (suggest next increment). Or: "Just update the current template without bumping?" — if declined, skip steps 2-4, go straight to mirror.

### 2. Archive (optional)
"Clone current template folder to `old-templates/` before updating?" (if yes, `cp -r Claude-Code-Template-V{old} old-templates/Claude-Code-Template-V{old}`)

### 3. Bump BOTH version files
- `.claude/template-version.json` — repo root copy (version + today's date)
- `Claude-Code-Template-V{old}/.claude/template-version.json` — template's own copy (same values)

Both files must match. This is the most common missed step.

### 4. Rename template folder
```bash
mv Claude-Code-Template-V{old} Claude-Code-Template-V{new}
```

### 5. Mirror all `.claude/` content
Remove stale files from template copy (deleted in main but still in template), then sync:
- `.claude/skills/` — all skill directories
- `.claude/agents/` — all subagent definitions
- `.claude/reference/` — all reference docs
- `.claude/rules/` — all rule files
- `.claude/templates/` — CLAUDE.md template, plan template, gitignore, mcp.json
- `.claude/settings.json` — permissions and hooks
- `.claude/template-version.json` — version file
- `.agents/changelog.md` — changelog
- Template root `CLAUDE.md` and `README.md`

### 6. Update ALL references (mandatory grep sweep)

Run: `grep -rn "Claude-Code-Template-V{old}" --include="*.md" --include="*.json" .`

**Every match must be updated.** Known locations:

| File | What to update |
|------|---------------|
| `README.md` | Template table, how-to-use instructions, README link, evolution table |
| `.claude/skills/upgrade-template/SKILL.md` | Template source path (appears twice: repo root copy AND template copy) |
| `.claude/reference/skills-and-workflow-guide.md` | Skill counts, directory tree |
| `.claude/skills/help/SKILL.md` | Skill counts if mentioned |
| `.agents/changelog.md` | Version entry |
| `.agents/plans/*.md` | Active plan files |
| `.agents/more-context/*.md` | Task context files |
| `.agents/progress/*.md` | Active progress docs |

Also grep for the old version number string (e.g. `V6.3.1`, `6.3.1`) to catch version references without the folder prefix.

### 7. Changelog
Add version entry to `.agents/changelog.md` (newest at top).

### 8. Template README
Update `Claude-Code-Template-V{new}/README.md` if it contains version references.

### 9. Cross-ref check
Scan all skills and reference docs for references to nonexistent skills.

### 10. Verify mirror consistency
```bash
diff -r .claude/skills/ Claude-Code-Template-V{new}/.claude/skills/ --brief
diff .claude/settings.json Claude-Code-Template-V{new}/.claude/settings.json
diff .claude/template-version.json Claude-Code-Template-V{new}/.claude/template-version.json
```
Zero diffs expected (line-ending differences are acceptable).
