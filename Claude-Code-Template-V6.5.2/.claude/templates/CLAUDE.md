<!-- Run /prime at the start of every session to load project context. -->

# [Project Name]

<!-- One-line description of what this project does -->

## Tech Stack

- **Language**:
- **Framework**:
- **Database**:
- **Testing**:
- **Package Manager**:

## Project Structure

```
[project-name]/
├── [main source directory]/
├── tests/
└── .claude/
    ├── settings.json      # Permissions, hooks
    ├── agents/            # Subagents (auto-invoked by specific skills)
    ├── rules/             # Coding conventions, standards (auto-loaded)
    ├── skills/            # Workflow skills (/help for full list)
    └── reference/         # Best practices docs (loaded on demand)
```

## Commands

```bash
# Install dependencies

# Run development server

# Run tests

# Run linter / type check

# Build for production

```

## Reference Documentation

| Document | When to Read |
|----------|--------------|
| `.claude/rules/` | Auto-loaded — coding conventions, testing standards, git workflow |
| `.claude/reference/[tech]-best-practices.md` | Implementing features in that tech area |
| `PRD.md` | Understanding requirements and scope |

## MCP Servers & Plugins

<!-- List MCP servers configured for this project. See .mcp.json and .claude/reference/mcp-and-plugins-guide.md. -->

## Workflow

<!-- New project:  /new-project → /create-prd → /setup -->
<!-- Development:  /describe → /plan → /execute -->
<!-- Brownfield:   /thrown-into-someones-hell-hole -->
<!-- Run /help for the full skill reference -->

## Notes

<!-- Project-specific gotchas, deployment notes, known issues -->
