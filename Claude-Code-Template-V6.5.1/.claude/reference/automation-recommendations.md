# Automation Recommendations

> Referenced by `/plan`, `/create-prd`, `/setup`, and `/new-project` when suggesting
> automation for a project. Read this when recommending MCP servers, subagents, or hooks.

## MCP Server Recommendations

Match the project's tech stack to relevant servers. Pick 1-3 that match — don't suggest all.

| If the project uses... | Recommend | Install |
|------------------------|-----------|---------|
| GitHub for PRs, issues, CI | GitHub MCP | `claude mcp add --transport http github https://api.githubcopilot.com/mcp/` |
| External libraries/frameworks | Context7 MCP (up-to-date docs) | `claude mcp add --transport http context7 https://mcp.context7.com/mcp` |
| Supabase / hosted Postgres | Supabase MCP | `claude mcp add --transport http supabase https://mcp.supabase.com/mcp` |
| Vercel / Next.js deployment | Vercel MCP | `claude mcp add --transport http vercel https://mcp.vercel.com` |
| E2E or browser testing | Playwright MCP | `claude mcp add playwright -- npx @playwright/mcp@latest` |
| Error tracking / Sentry | Sentry MCP | `claude mcp add --transport http sentry https://mcp.sentry.dev/mcp` |
| Notion for docs | Notion MCP | `claude mcp add --transport http notion https://mcp.notion.com/mcp` |
| Linear for project management | Linear MCP | `claude mcp add --transport http linear https://mcp.linear.app/mcp` |

Check `.mcp.json` first — don't suggest what's already configured.

## Subagent Recommendations

The template ships 4 subagents. Note which apply to the project type.

| If the project involves... | Recommend |
|---------------------------|-----------|
| Significant code changes (any project) | code-reviewer (reviews after implementation) |
| Test-heavy project (APIs, E2E) | test-planner (structures test approach) |
| Complex debugging expected | rca-agent (root cause analysis before blind retries) |
| Deep specification / PRD work | code-specter (web research + spec writing) |

If a useful subagent doesn't exist yet, suggest creating one in `.claude/agents/`.

## Hook Recommendations

Hooks automate repetitive tasks. Suggest based on project needs.

| If the project involves... | Recommend |
|---------------------------|-----------|
| Code formatting standard | PostToolUse hook with formatter (Prettier, Black, rustfmt) |
| Strict lint rules | PostToolUse hook with linter |
| Protected branches | Deny rules in settings.json (already pre-configured for main/master) |

See `.claude/reference/subagents-and-hooks-guide.md` for hook configuration examples.

## How to Use This Doc

When a skill tells you to read this file:
1. Check `.mcp.json` for already-configured servers
2. Check `.claude/agents/` for already-configured subagents
3. Check `.claude/settings.json` for already-configured hooks
4. Based on the project's tech stack, suggest 1-3 relevant items from each section
5. Ask the user before installing anything
