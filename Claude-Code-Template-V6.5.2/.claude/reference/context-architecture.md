# Context Architecture

> How the template's layered context system works. Read this to understand what goes
> where and why, so you avoid context bloat and token waste.

## Context Layers

The template uses a layered context system. Understanding what goes where prevents context bloat and token waste:

| Layer | File | Auto-loaded? | What Goes Here |
|-------|------|-------------|----------------|
| **CLAUDE.md** | `CLAUDE.md` | Always | Project identity: name, tech stack, commands. Under 60 lines. |
| **Rules** | `.claude/rules/*.md` | Always (path-scoped conditional) | Detailed conventions, standards, patterns. One topic per file. |
| **Reference docs** | `.claude/reference/*.md` | Only when skills read them | Deep technical guides. No token cost when unused. |
| **MEMORY.md** | `~/.claude/projects/<hash>/memory/MEMORY.md` | First 200 lines | Auto-managed by Claude. Cross-session learnings. |
| **MCP servers** | `.mcp.json` | Config at startup | External tool integrations (GitHub, databases, etc.) |

## Path-Scoped Rules

Rules can be conditionally loaded based on file patterns:

```yaml
---
paths:
  - "src/components/**/*.tsx"
---

# React Component Rules
- Use functional components with hooks
- Props interface above component definition
```

This rule ONLY loads when Claude works on files matching those paths — saving tokens.

## Global Context (applies to ALL projects)

| Location | What It Does |
|----------|-------------|
| `~/.claude/CLAUDE.md` | Personal preferences for all projects |
| `~/.claude/rules/*.md` | Personal rules for all projects |
| `~/.claude/skills/` | Global skills — each description loaded every session |

**Tip**: Audit global skills with `npx skills ls -g`. Remove tech-specific skills from global if you only use them in specific projects.

## Best Practices

- **CLAUDE.md under 60 lines** — it's loaded every turn. Keep it lean.
- **Move conventions to rules/** — they auto-load but only when relevant (path-scoped).
- **Put deep guides in reference/** — zero token cost until a skill reads them.
- **One topic per rule file** — easier to enable/disable and keeps path-scoping clean.
- **Don't duplicate** — if it's in rules/, don't also put it in CLAUDE.md.
