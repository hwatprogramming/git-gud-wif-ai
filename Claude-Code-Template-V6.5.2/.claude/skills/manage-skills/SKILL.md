---
description: "Activate or deactivate skills per project — reduces token overhead from unused skills"
argument-hint: "[list | activate <skill> | deactivate <skill> | suggest]"
disable-model-invocation: true
---

# Manage Skills

Activate or deactivate skills per project. Inactive skills are moved out of `.claude/skills/` so they don't load at startup, saving tokens.

## Process

Parse `$ARGUMENTS` to determine subcommand. Default to `list` if empty.

### `list` — Show Active and Inactive Skills

1. Scan `.claude/skills/` for active skill directories (each contains `SKILL.md`)
2. Scan `.claude/skills/.inactive/` for inactive skill directories
3. Display two tables:

```
### Active Skills
| Skill | Description |
|-------|-------------|
| help  | Your starting point — scans project state... |
| ...   | ... |

### Inactive Skills
| Skill | Description |
|-------|-------------|
| (none yet) | |
```

Group by category if there are 15+ active skills:
- **Discovery**: new-project, describe, investigate, triage
- **Planning**: plan, create-prd, create-skill
- **Execution**: execute, safe-fix, setup, restart-dev
- **Quality**: check, test, test-everything, review, qa, security-audit, deep-analysis
- **Session**: prime, help, update-progress, sync-docs, commit, create-pr, execution-report
- **Orchestrators**: thrown-into-someones-hell-hole, test-everything, release
- **Configuration**: toggle-visibility, manage-skills, find-skills, upgrade-template, template-info, audit-pipeline

### `deactivate <skill>` — Move Skill to Inactive

1. **Protected skills** — never deactivate: `help`, `prime`, `plan`, `execute`, `commit`, `check`, `manage-skills`. If requested, explain why and refuse.
2. Check if `.claude/skills/<skill>/` exists. If not, report error.
3. Create `.claude/skills/.inactive/` if it doesn't exist.
4. Move `.claude/skills/<skill>/` → `.claude/skills/.inactive/<skill>/`
5. Confirm: "Deactivated `/<skill>`. It won't load in future sessions. Run `/manage-skills activate <skill>` to restore."

### `activate <skill>` — Restore Skill from Inactive

1. Check if `.claude/skills/.inactive/<skill>/` exists. If not, report error.
2. Move `.claude/skills/.inactive/<skill>/` → `.claude/skills/<skill>/`
3. Confirm: "Activated `/<skill>`. It will load in future sessions."

### `suggest` — Recommend Deactivations

1. Read CLAUDE.md to detect project type (tech stack, framework, project purpose)
2. Suggest skills to deactivate based on irrelevance:
   - No frontend → UI-focused skills
   - No database → DB-focused skills
   - Not brownfield → brownfield skills (investigate, triage, safe-fix)
   - Knowledge base / docs-only → most execution and testing skills
3. Present as a table:

```
| Skill | Reason to Deactivate | Deactivate? |
|-------|---------------------|-------------|
| safe-fix | No brownfield work detected | confirm/skip |
```

4. Only deactivate after user confirms each row or approves all at once.

## Safety

- Deactivated skills are NOT deleted — just moved to `.inactive/`
- Run `/template-info [skill-name]` to check blast radius before deactivating
- Warn if deactivating a skill referenced in another skill's Next Step section (grep for the skill name in other SKILL.md files)
- `.inactive/` should be git-tracked so deactivation decisions persist across clones

## Next Step

- After deactivating → run `/help` to verify the updated skill list
- After activating → skill is immediately available in the current session
