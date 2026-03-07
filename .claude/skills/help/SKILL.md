---
description: Your starting point — scans project state and guides you to the right next step
---

# Help

## Project State (auto-injected)

!`git status 2>/dev/null || echo "Not a git repository"`

## Step 1: Scan Project State

1. Check CLAUDE.md — exists? If not, uninitialized project.
2. Review git status above — uncommitted changes? What branch?
3. Check `.agents/progress/` — in-progress work from previous session?
4. Check `.agents/plans/` — plans waiting to execute?

## Step 2: Contextual Recommendation

Give ONE specific recommendation based on state:

| State | Recommendation |
|-------|---------------|
| No CLAUDE.md | `/new-project` to set things up |
| Progress doc In Progress | `/prime` to reload, pick up where left off (include "Next Session Should") |
| Uncommitted changes | `/check` to validate, then `/commit` |
| Unexecuted plan | `/execute [plan-path]` |
| Clean, no active work | "Ready for new work. What do you want to do?" |

Priority: uncommitted > in-progress > unexecuted plans > clean.

## Step 3: Command Reference (MANDATORY — always print in full)

**Setup & Onboarding**
| Command | What it does |
|---------|-------------|
| /new-project | Scope a new project — problem, users, tech stack, MVP |
| /create-prd | Generate PRD + CLAUDE.md |
| /setup | Install deps, configure automation, scaffold, start dev |

**Planning & Discovery**
| Command | What it does |
|---------|-------------|
| /prime | Load project context (start of session) |
| /describe | Clarify any task — features, bugs, brownfield, refactors |
| /plan | Create implementation plan (includes bug-fix methodology) |

**Development**
| Command | What it does |
|---------|-------------|
| /execute | Implement from plan + auto-pipeline |
| /restart-dev | Kill and restart dev servers |

**Existing Codebases**
| Command | What it does |
|---------|-------------|
| /investigate | Deep codebase investigation |
| /triage | Prioritize issues by severity and effort |
| /safe-fix | Cautious legacy fix with blast radius analysis |
| /thrown-into-someones-hell-hole | Full brownfield pipeline orchestrator |
| /deep-analysis | Script-based deep codebase analysis |

**Validation & Review**
| Command | What it does |
|---------|-------------|
| /check | Lint, types, tests, build |
| /review | Code review — auto-fix low, flag major |
| /qa | Verify implementation against requirements |

**Testing & Release**
| Command | What it does |
|---------|-------------|
| /test | Write and run automated tests |
| /test-everything | Full test pipeline (automated + browser + deps + manual checklist) |
| /release | Release pipeline (QA → security audit → PR) |

**Security & Sharing**
| Command | What it does |
|---------|-------------|
| /security-audit | OWASP + dependency CVE audit |
| /remove-personal-info | Scrub personal info, audit .gitignore, prep for public sharing |

**Git & Workflow**
| Command | What it does |
|---------|-------------|
| /commit | Clean atomic commit |
| /create-pr | Create PR with auto-generated summary |
| /update-progress | Document progress and findings |
| /execution-report | Compare implementation against plan |
| /sync-docs | Archive plans, flag stale docs, sync CLAUDE.md/README.md |

**Template & Meta**
| Command | What it does |
|---------|-------------|
| /help | This reference |
| /template-info | Template version and health |
| /create-skill | Create a new skill |
| /manage-skills | Activate/deactivate skills per project |
| /find-skills | Search and install community skills from skills.sh |
| /toggle-visibility | Manage .gitignore |
| /upgrade-template | Upgrade project's template |
| /audit-pipeline | Audit skills and pipelines against actual usage |

### Subagents

| Agent | Model | Purpose |
|-------|-------|---------|
| code-reviewer | haiku | Read-only code review |
| test-planner | haiku | Test plan validation |
| session-cleanup | haiku | End-of-session housekeeping |
| rca | sonnet | Root cause analysis |
| code-specter | sonnet | PRD/spec generation |
| researcher | sonnet | External research with vetting |

### Extensions

MCP servers — external tools (GitHub, databases, Sentry). See `.mcp.json` and `.claude/reference/mcp-and-plugins-guide.md`.
Community skills — run `/find-skills` or `npx skills find [query]` to discover installable skills from skills.sh.

### Workflow Patterns

```
Session start:    /prime
New project:      /new-project → /create-prd → /setup
New feature:      /describe → /plan → /execute → [auto-pipeline] → /commit
Bug fix:          /describe → /plan → /execute → [auto-pipeline] → /commit
Existing codebase: /thrown-into-someones-hell-hole (orchestrates full pipeline)
Full testing:     /test-everything → suggests /release
Release:          /release (orchestrates /qa → /security-audit → /create-pr)
Doc cleanup:      /sync-docs (anytime — archive plans, sync docs)
```
