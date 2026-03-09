---
description: Prime agent with codebase understanding
---

# Prime: Load Project Context

Build comprehensive codebase understanding by analyzing structure, documentation, and key files.

## Process

### 0. Check for Previous Session Progress

Read `.agents/progress/` files. If found, include **Session Pickup**: completed, remaining, recommended next steps.

### 1. Check Template Version

Read `.claude/template-version.json`. Include version in report header.

### 2. Analyze Project Structure

!`git ls-files`

Show directory structure: `tree -L 3 -I 'node_modules|__pycache__|.git|dist|build'`

### 3. Read Core Documentation

- CLAUDE.md, README.md, architecture docs (ARCHITECTURE.md, docs/)
- `.agents/more-context/` if it exists (user-provided brownfield context from /describe)
- `.agents/research/` directory listing if it exists (external research findings)
- PRD.md or `.claude/PRD.md` if it exists (project requirements)

### 4. Identify Key Files

Read: entry points, config files, model/schema definitions, key services/controllers.

### 5. Check Configuration

- `.claude/agents/` — list subagents
- `.claude/settings.json` — note hooks
- `.claude/reference/` — note available docs

### 6. Current State

!`git log -10 --oneline`
!`git status`

### 6.5. Detect Deployment

Check: `ls vercel.json fly.toml railway.toml Dockerfile docker-compose.yml netlify.toml wrangler.toml render.yaml heroku.yml app.yaml 2>/dev/null`

Scan CLAUDE.md for `https://` (not localhost). Check: `git tag | grep -E "^v[0-9]"`

Record: "Deployed — [signals]" or "Not yet deployed"

## Output Report

Concise summary with bullet points:

- **Project Overview**: version, purpose, technologies
- **Architecture**: structure, patterns, key directories
- **Tech Stack**: languages, frameworks, build tools, testing
- **Available Agents & Tools**: subagents, hooks, reference docs
- **Current State**: branch, recent focus, deployment status

## Next Step

Based on what you found, recommend ONE next action:

### Priority 1: Resume previous work
If a progress doc has Status: In Progress → follow its "Next Session Should" guidance.

### Priority 2: Act on project state
| State | Recommendation |
|-------|---------------|
| Uncommitted changes | "/check → /commit" |
| Unexecuted plan exists | "/execute [plan-path]" |
| Clean, no active work | "What do you want to work on? Run /describe or /plan" |

### Priority 3: Event-driven maintenance (only if triggered)
Check these signals. Only mention if a signal fires — do NOT recommend maintenance by default.

| Signal | Check | Recommendation |
|--------|-------|---------------|
| Stale dependencies | `package-lock.json` or `requirements.txt` modified >30 commits ago | "Dependencies haven't been updated in a while. Consider /test-everything for a full health check." |
| No recent security check | No `.agents/security-*.md` file in last 50 commits | "No security audit on record. Consider /security-audit before your next release." |
| Test coverage unknown | No test files found in project | "No tests found. Consider /test to add coverage for critical paths." |

If no signals fire → say nothing about maintenance. Focus on what the user wants to do.
