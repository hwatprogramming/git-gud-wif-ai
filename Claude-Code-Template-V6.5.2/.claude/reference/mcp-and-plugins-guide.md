# MCP Servers & Plugins Guide

> How to extend Claude Code with MCP servers and plugins. Referenced by `/plan` and
> `/create-prd` when suggesting MCP integrations.

## MCP Servers

Model Context Protocol (MCP) extends Claude with external tool access. The template ships an empty `.mcp.json` — add servers based on your project needs.

### Recommended Servers

Pick 2-3 that match your stack. Too many servers slow down startup.

| Server | What it does | Install |
|--------|-------------|---------|
| **GitHub** | PRs, issues, CI/CD, code reviews | `claude mcp add --transport http github https://api.githubcopilot.com/mcp/` |
| **Context7** | Up-to-date library docs (prevents hallucinated APIs) | `claude mcp add --transport http context7 https://mcp.context7.com/mcp` |
| **Sentry** | Error tracking, production debugging | `claude mcp add --transport http sentry https://mcp.sentry.dev/mcp` |
| **Supabase** | Database, auth, storage management | `claude mcp add --transport http supabase https://mcp.supabase.com/mcp` |
| **Vercel** | Deployment analysis, project management | `claude mcp add --transport http vercel https://mcp.vercel.com` |
| **Playwright** | Browser automation, E2E testing | `claude mcp add playwright -- npx @playwright/mcp@latest` |
| **Notion** | Content and docs management | `claude mcp add --transport http notion https://mcp.notion.com/mcp` |
| **Linear** | Issue tracking and project management | `claude mcp add --transport http linear https://mcp.linear.app/mcp` |

Browse all available servers: [MCP Registry](https://code.claude.com/docs/en/mcp)

### Configuration

```json
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/",
      "headers": {
        "Authorization": "Bearer ${GITHUB_TOKEN}"
      }
    }
  }
}
```

- `.mcp.json` is checked into version control — team members share MCP configs
- Secrets use environment variable expansion: `${VAR}` or `${VAR:-default}`
- Manage via CLI: `claude mcp add/remove/list`
- Use `/mcp` inside Claude Code to authenticate OAuth servers

## Plugins

Claude Code has a plugin ecosystem for code intelligence, external integrations, and community workflows.

### Official Plugins (via `/plugin`)

> Requires Claude Code v1.0.33+. Run `claude --version` to check.

Run `/plugin` inside Claude Code to browse and install from the official marketplace.

**Code Intelligence (LSP)** — gives Claude real-time diagnostics after every edit:

| Plugin | Language |
|--------|----------|
| `typescript-lsp` | TypeScript/JavaScript |
| `pyright-lsp` | Python |
| `rust-analyzer-lsp` | Rust |
| `gopls-lsp` | Go |

**External Integrations** — pre-configured MCP bundles:
`github`, `gitlab`, `atlassian`, `asana`, `linear`, `notion`, `figma`, `vercel`, `firebase`, `supabase`, `sentry`, `slack`

**Built-in Skills** — ship with every Claude Code installation:
- `/simplify` — reviews changed code for reuse, quality, efficiency (3 parallel review agents)
- `/batch <instruction>` — orchestrates parallel changes across codebase (5-30 agents in git worktrees)

### Community Marketplaces

Add third-party marketplaces for more skills:
```shell
/plugin marketplace add owner/repo
```

Browse the demo marketplace: `/plugin marketplace add anthropics/claude-code`

## Reference Docs Inventory

The template includes these tech-specific reference docs in `.claude/reference/`:

| Document | Coverage |
|----------|----------|
| `fastapi-best-practices.md` | FastAPI patterns, routing, Pydantic, async |
| `react-frontend-best-practices.md` | React components, state, forms, performance |
| `sqlite-best-practices.md` | Schema design, indexing, queries, SQLAlchemy |
| `testing-and-logging.md` | pytest, structlog, testing pyramid |
| `deployment-best-practices.md` | Docker, Nginx, CI/CD, monitoring |

Delete docs you don't need for your project to keep the reference folder clean.
