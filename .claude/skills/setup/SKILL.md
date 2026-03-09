---
description: "Initialize template + install deps, scaffold, start dev servers"
disable-model-invocation: true
---

# Setup

Initialize the template and set up the project locally.

## Process

### 0. Initialize Template Files

- **CLAUDE.md** — if missing, copy from `.claude/templates/CLAUDE.md`. If exists with placeholders, remind to fill in.
- **.mcp.json** — if missing, copy from `.claude/templates/mcp.json`
- **.gitignore** — append missing entries from `.claude/templates/gitignore-entries.txt` under `# Template entries (added by /setup)`
- **.agents/** — create `plans/`, `progress/`, `rca/` if missing

Report what was created/skipped.

### 0.5. Configure Automation

One-time: configure MCP servers, subagents, and hooks based on tech stack. Skip if already configured (check `.mcp.json` and `.claude/settings.json`).

1. **Read context** — PRD, CLAUDE.md, `.mcp.json`, `.claude/agents/`, `.claude/settings.json`
2. **Read recommendations** — `.claude/reference/automation-recommendations.md` (source of truth)
3. **MCP servers** — filter by tech stack, skip installed. Present: Server / Why / Install Command. Ask: "Which? (numbers, 'all', 'none')"
4. **Subagents** — template ships: code-reviewer, test-planner, rca, code-specter, researcher, session-cleanup. Ask: "Remove any? (or 'keep all')"
5. **Hooks** — filter by stack, skip configured. Present: Hook / What / When. Ask: "Which?"
6. **Custom skills** — suggest 1-3 project-specific skills if clear pattern exists. Run `/create-skill` for confirmed.
7. **Report** — what was configured. Note: MCP changes require restarting Claude Code.

### 1. Read Project Context

Read `PRD.md` and `CLAUDE.md` for tech stack and architecture.

### 2. Install Dependencies

Run install commands from CLAUDE.md/PRD. If not specified, ask.

### 3. Scaffold Structure

If needed: create directories, config files, .env.example from PRD architecture.

### 4. Start Dev Servers

Run dev commands from CLAUDE.md. Start both if frontend + backend.

### 5. Validate

Verify dev server responds.

### 6. Update CLAUDE.md

Fill in: Commands, Project Structure, Access Points.

### 6.5. Discover Stack-Specific Skills

Check `.claude/reference/popular-skills.md` for curated skills matching the project stack. Run `npx skills find [tech]` if not covered. Suggest 1-2 relevant skills. Don't auto-install.

### 7. Reference Doc Cleanup

Template ships tech-specific reference docs that may not apply. Delete any that don't match the project stack:
- `deployment-best-practices.md`, `fastapi-best-practices.md`, `react-frontend-best-practices.md`, `sqlite-best-practices.md`, `testing-and-logging.md`

Keep general docs: `automation-recommendations.md`, `context-architecture.md`, `mcp-and-plugins-guide.md`, `skill-authoring-guidelines.md`, `skills-and-workflow-guide.md`, `subagents-and-hooks-guide.md`, `popular-skills.md`, `skill-quality-heuristic.md`, `token-and-rate-limit-guide.md`

### 8. Update README.md

If README has template docs, replace with: project name, description, tech stack, getting started, structure (30-50 lines).

## Outputs

- Updated/created: `CLAUDE.md`, `.mcp.json`, `.gitignore`, `README.md`
- Created directories: `.agents/plans/`, `.agents/progress/`, `.agents/rca/`
- Installed: project dependencies, configured MCP servers/hooks

## Next Step

- `/describe` → `/plan` for first feature
- `/prime` at next session start
