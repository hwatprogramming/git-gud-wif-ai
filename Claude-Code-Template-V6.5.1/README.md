# Claude Code Template V6.5.1

A Claude Code project template with full SDLC coverage — from discovery to
implementation to reflection, with automated quality gates and subagents.

## What's New in V6.5.1

- **Permissions Security Audit** — Systematic audit of all ~145 allow patterns across 4 risk categories
- **New deny rule** — `rm -r *` closes gap where recursive delete without `-f` bypassed the `rm -rf` deny
- **8 patterns moved to ask** — `npx`, `pipx`, `kill`, `pkill`, `chmod`, `ln`, bare `env`, bare `printenv`
- **Documented rationale** — Every keep/move/deny decision documented with risk analysis
- **`/remove-personal-info`** — New skill to scrub personal info, audit .gitignore, and prepare for public sharing
- **34 Skills** — Tighter security posture plus public sharing workflow
- **V6.4 hooks** — SessionStart JSON fix (doesn't work?), PostToolUse auto-formatter (2 hook scripts)

## Quick Install

Copy these 3 directories into your project root:

```
.claude/      → Skills, subagents, hooks, rules, reference docs, templates
.agents/      → Plans, progress docs, changelog (created by /setup if missing)
.mcp.json     → MCP server config (created by /setup if missing)
```

Then run `/setup` — it handles the rest:
- Creates `CLAUDE.md`, `.gitignore` entries, and `.mcp.json` from templates
- Installs dependencies, scaffolds structure, starts dev servers

**That's it.** Run `/help` to see all available skills.

### Template Reference Docs

When you replace this README with your project's README, the template documentation
is preserved in `.claude/reference/`:

| Document | Contents |
|----------|----------|
| `skills-and-workflow-guide.md` | Skills overview, workflow patterns, directory structure |
| `subagents-and-hooks-guide.md` | 6 subagents, hooks, configuration examples |
| `context-architecture.md` | Layered context system (CLAUDE.md, rules, reference, memory) |
| `mcp-and-plugins-guide.md` | MCP server setup, plugins, configuration examples |

## Skills Overview (34 total)

Run `/help` for the full context-aware reference. Summary:

| Category | Skills |
|----------|--------|
| **Setup & Onboarding** | `/new-project`, `/create-prd`, `/setup` |
| **Planning & Discovery** | `/prime`, `/describe`, `/plan` |
| **Development** | `/execute`, `/restart-dev` |
| **Brownfield / Legacy** | `/investigate`, `/triage`, `/safe-fix`, `/thrown-into-someones-hell-hole`, `/deep-analysis` |
| **Validation & Review** | `/check`, `/review`, `/qa` |
| **Testing & Release** | `/test`, `/test-everything`, `/release` |
| **Security & Sharing** | `/security-audit`, `/remove-personal-info` |
| **Git & Workflow** | `/commit`, `/create-pr`, `/update-progress`, `/execution-report`, `/sync-docs` |
| **Template & Meta** | `/help`, `/template-info`, `/create-skill`, `/manage-skills`, `/find-skills`, `/toggle-visibility`, `/upgrade-template`, `/audit-pipeline` |

## Workflow Patterns

```
Session start:    /prime
New project:      /new-project → /create-prd → /setup
Development:      /describe → /plan → /execute → [auto-pipeline] → /commit
Brownfield:       /thrown-into-someones-hell-hole (orchestrates full pipeline)
Full testing:     /test-everything → suggests /release
Release:          /release (orchestrates /qa → /security-audit → /create-pr)
Session end:      /sync-docs (or integrated into auto-pipeline)
```

## Subagents

6 specialized agents defined in `.claude/agents/`:

| Subagent | Model | What It Does |
|----------|-------|--------------|
| code-reviewer | Haiku | Reviews changed files for bugs, security, patterns |
| test-planner | Haiku | Validates test plan structure and data strategy |
| session-cleanup | Haiku | End-of-session housekeeping (archive, stale doc detection) |
| rca | Sonnet | Classifies errors and traces root causes |
| code-specter | Sonnet | Deep specification work with web research |
| researcher | Sonnet | External research with two-pass citation validation |

## Hooks

Defined in `.claude/settings.json`:

| Hook | Trigger | Effect |
|------|---------|--------|
| Branch safety | `git push` to main | Blocks direct push, suggests feature branch |
| Session start | New session begins | Reminds user to run `/prime` |
| Context recovery | After compaction | Re-reads CLAUDE.md, checks git state, resumes work |

## Directory Structure

```
your-project/
├── .claude/
│   ├── settings.json          # Permissions, hooks
│   ├── agents/                # Subagent definitions (6 agents)
│   ├── rules/                 # Auto-loaded conventions
│   ├── skills/                # 34 workflow skills
│   ├── templates/             # Root-file templates (used by /setup)
│   ├── template-version.json  # Template version tracking
│   └── reference/             # Best practices docs (loaded on demand)
├── .agents/                   # Pipeline output (selectively gitignored)
│   ├── plans/                 # Implementation plans (tracked)
│   ├── progress/              # Session handoff docs (tracked)
│   └── changelog.md           # Template evolution log (tracked)
├── CLAUDE.md                  # Project context (lean template, < 60 lines)
├── README.md                  # This file
├── .gitignore
└── .mcp.json                  # MCP server configuration
```

## Context Architecture

The template uses a layered context system:

| Layer | File | Auto-loaded? | What Goes Here |
|-------|------|-------------|----------------|
| **CLAUDE.md** | `CLAUDE.md` | Always | Project identity: name, tech stack, commands. Under 60 lines. |
| **Rules** | `.claude/rules/*.md` | Always | Detailed conventions, standards, patterns. One topic per file. |
| **Reference docs** | `.claude/reference/*.md` | Only when skills read them | Deep technical guides. No token cost when unused. |
| **MEMORY.md** | `~/.claude/projects/<hash>/memory/MEMORY.md` | First 200 lines | Auto-managed by Claude. Cross-session learnings. |
| **MCP servers** | `.mcp.json` | Config at startup | External tool integrations (GitHub, databases, etc.) |

## MCP Servers

The template ships an empty `.mcp.json` — add servers based on your project needs. Pick 2-3 that match your stack.

| Server | What it does | Install |
|--------|-------------|---------|
| **GitHub** | PRs, issues, CI/CD | `claude mcp add --transport http github https://api.githubcopilot.com/mcp/` |
| **Context7** | Up-to-date library docs | `claude mcp add --transport http context7 https://mcp.context7.com/mcp` |
| **Sentry** | Error tracking | `claude mcp add --transport http sentry https://mcp.sentry.dev/mcp` |
| **Playwright** | Browser automation, E2E | `claude mcp add playwright -- npx @playwright/mcp@latest` |

Browse all: [MCP Registry](https://code.claude.com/docs/en/mcp)
