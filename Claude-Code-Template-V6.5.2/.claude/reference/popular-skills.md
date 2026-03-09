# Popular Community Skills

> **Applies to**: All projects (stack discovery)
> **When to read**: During `/find-skills`, `/setup`, or when user asks about extending capabilities.
> **Referenced by**: `/find-skills`, `/setup` Step 6.6

Curated list from [skills.sh](https://skills.sh). Check before running `npx skills find` -- the answer may already be here.

## Code Quality & Workflow

| Skill | Repo | What it provides |
|-------|------|-----------------|
| code-review | supercent-io/skills-template | Peer review processes |
| test-driven-development | obra/superpowers | TDD methodology |
| git-workflow | supercent-io/skills-template | Version control practices |
| debugging | supercent-io/skills-template | Error diagnosis techniques |
| find-skills | vercel-labs/skills | Discover and install community skills |
| skill-creator | anthropics/skills | Create your own skills |

## Document & File Processing

| Skill | Repo | What it provides |
|-------|------|-----------------|
| pdf | anthropics/skills | PDF manipulation and OCR |
| pptx | anthropics/skills | PowerPoint creation and editing |
| docx | anthropics/skills | Word document handling |
| xlsx | anthropics/skills | Excel spreadsheet operations |



| Skill | Repo | What it provides |
|-------|------|-----------------|
| claude-api | anthropics/skills | Claude API and SDK reference |
| mcp-builder | anthropics/skills | MCP server construction |
| webapp-testing | anthropics/skills | Playwright web app testing |
| doc-coauthoring | anthropics/skills | Collaborative document writing |

## Frontend & Web

| Skill | Repo | What it provides |
|-------|------|-----------------|
| frontend-design | anthropics/skills | UI creation techniques |
| vercel-react-best-practices | vercel-labs/agent-skills | React patterns from Vercel |
| next-best-practices | vercel-labs/next-skills | Next.js recommendations |
| web-design-guidelines | vercel-labs/agent-skills | Web interface standards |
| tailwind-design-system | wshobson/agents | Tailwind CSS patterns |

## Browser & Automation

| Skill | Repo | What it provides |
|-------|------|-----------------|
| agent-browser | vercel-labs/agent-browser | Web browsing automation |
| browser-use | browser-use/browser-use | Browser interaction framework |

## Cloud & Infrastructure

| Skill | Repo | What it provides |
|-------|------|-----------------|
| azure-* (15+ skills) | microsoft/github-copilot-for-azure | Azure cloud services suite |
| supabase-postgres-best-practices | supabase/agent-skills | Postgres/Supabase patterns |

## Install Patterns

```bash
# Install a skill (project-level)
npx skills add <owner/repo@skill> -y

# Install globally (user-level)
npx skills add <owner/repo@skill> -g -y

# Live search (when this list doesn't cover your need)
npx skills find [query]
```

> **Last updated**: 2026-03-07. Run `npx skills find` for the latest.
