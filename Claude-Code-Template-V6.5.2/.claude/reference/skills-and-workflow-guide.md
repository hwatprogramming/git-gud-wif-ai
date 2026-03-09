# Skills & Workflow Guide

> This document preserves template documentation that would otherwise be lost when
> README.md is replaced with a project-specific README. Read this to understand the
> full skill set and recommended workflows.

## Workflow Patterns

```
Session start:    /prime
New project:      /new-project → /create-prd → /setup
New feature:      /describe → /plan → /execute → [auto-pipeline] → /commit
Bug fix:          /describe → /plan → /execute → [auto-pipeline] → /commit
Brownfield:       /thrown-into-someones-hell-hole (orchestrates full pipeline)
Full testing:     /test-everything → suggests /release
Release:          /release (orchestrates /qa → /security-audit → /create-pr)
Doc cleanup:      /sync-docs (anytime — archive plans, sync docs)
```

## Skills Overview

Run `/help` for the complete, context-aware skill reference with tables and workflow recommendations.

The authoritative skill list lives in `.claude/skills/help/SKILL.md`. This guide focuses on workflow patterns and upgrade information below.

## Directory Structure

```
your-project/
├── .claude/
│   ├── settings.json          # Permissions, hooks
│   ├── agents/                # Subagent definitions
│   │   ├── code-reviewer.md   # Code review (haiku, read-only)
│   │   ├── test-planner.md    # Test planning (haiku, read-only)
│   │   ├── rca.md             # Root cause analysis (sonnet)
│   │   ├── code-specter.md    # PRD/spec generation (sonnet)
│   │   ├── researcher.md      # External research with vetting (sonnet)
│   │   └── session-cleanup.md # End-of-session housekeeping (haiku, read-only)
│   ├── rules/                 # Auto-loaded conventions
│   │   ├── coding-conventions.md
│   │   ├── testing-standards.md
│   │   └── git-workflow.md
│   ├── skills/                # 33 workflow skills
│   │   ├── help/SKILL.md
│   │   ├── prime/SKILL.md
│   │   └── ... (31 more)
│   ├── templates/             # Root-file templates (used by /setup)
│   │   ├── CLAUDE.md
│   │   ├── gitignore-entries.txt
│   │   └── mcp.json
│   ├── template-version.json  # Template version tracking
│   └── reference/             # Best practices docs (loaded on demand)
│       ├── automation-recommendations.md
│       ├── context-architecture.md
│       ├── mcp-and-plugins-guide.md
│       ├── popular-skills.md
│       ├── skill-authoring-guidelines.md
│       ├── skill-quality-heuristic.md
│       ├── skills-and-workflow-guide.md
│       └── subagents-and-hooks-guide.md
├── .agents/                   # Pipeline output (selectively gitignored)
│   ├── plans/                 # Implementation plans (tracked)
│   ├── progress/              # Session handoff docs (tracked)
│   ├── rca/                   # Root cause analyses (tracked)
│   ├── code-reviews/          # Code review reports (gitignored)
│   ├── execution-reports/     # Implementation reports (gitignored)
│   └── changelog.md           # Template evolution log (tracked)
├── CLAUDE.md                  # Project context (lean template, < 60 lines)
├── README.md                  # Project README
├── .gitignore
└── .mcp.json                  # MCP server configuration
```

## Upgrading from V4.5

Key changes from V4.5 to V5:

| Change | Details |
|--------|---------|
| Skills | 22 skills → 19 skills (merges reduced count, gained functionality) |
| Subagents | NEW — 4 specialized agents in `.claude/agents/` |
| Rules | NEW — `.claude/rules/` replaces inline conventions in CLAUDE.md |
| Hooks | NEW — branch safety, session start, context recovery in `settings.json` |
| CLAUDE.md | 114 lines → ~57 lines (conventions moved to rules/) |
| MCP | NEW — `.mcp.json` for external tool integrations |

### Skill Name Changes from V4.5

| V4.5 Name | V5 Name | Notes |
|-----------|---------|-------|
| `/describe-new-project` | `/new-project` | New projects only (existing → `/thrown-into-someones-hell-hole`) |
| `/describe-existing-project` | `/thrown-into-someones-hell-hole` | Brownfield orchestrator |
| `/describe-problem` | `/describe` | Merged into unified describe |
| `/describe-other` | Removed | Rarely used |
| `/plan-task` | `/plan` | Shortened |
| `/init-project` | `/setup` | Renamed |
| `/rca` | `/plan` (Bug Fix path) | RCA methodology in /plan + rca subagent |
| `/implement-fix` | `/execute` | Standard execution flow |
| `/validate` | `/check` | Renamed |
| `/code-review` | `/review` | Shortened |
| `/code-review-fix` | Removed | Absorbed into `/review` |
| `/update-docs` | `/update-progress` (Part 2) | Merged |
| `/system-review` | `/execution-report` (Part 2) | Smart gate — only fires on divergences |
| NEW | `/test` | Test execution with planning (includes discovery) |
| NEW | `/template-info` | Template diagnostics |
