# Template Changelog

This file tracks improvements applied to the template by `/execution-report`. Each entry documents what was changed, what was deferred, and why.

Format: Newest entries at the top.

---

## V6.5.1 — Public Sharing Workflow (2026-03-08)

### New Skill (1)
- `/remove-personal-info` — scan and remove personal information, credentials, internal references before sharing a project. Includes .gitignore visibility audit, git history advisory, and pre-share checklist. Chains to `/sync-docs` for doc polish.

### Fixed
- `/upgrade-template` (distributable) — removed hardcoded repo-specific paths (`Claude-Code-Template-V6.4`, `D:\A-Personal-Coding-Projects-Folder`). Now generic: user provides template source via arguments.
- `/upgrade-template` (repo) — updated version references from V6.4 to V6.5.1

### Changed
- Skill count: 33 → 34
- Template folder renamed: `Claude-Code-Template-V6.5` → `Claude-Code-Template-V6.5.1`

---

## V6.5 — Permissions Tightening (2026-03-07)

### Security Audit
- Systematic audit of all ~145 allow patterns across 4 risk categories: secret exfiltration, destructive ops, code execution, process manipulation
- Every decision documented with risk analysis (findings table + kept-in-allow rationale)

### New Deny Rule
- `Bash(rm -r *)` — closes gap where recursive delete without `-f` flag bypassed the existing `rm -rf *` deny

### Moved from Allow to Ask (8 patterns)
- `Bash(env)` / `Bash(printenv)` — bare forms dump all env vars including secrets. `env *` / `printenv *` kept in allow (targeted lookups)
- `Bash(npx *)` / `Bash(pipx *)` — download and execute arbitrary packages (supply chain risk)
- `Bash(kill *)` / `Bash(pkill *)` — can kill any process including system processes
- `Bash(chmod *)` / `Bash(ln *)` — rarely needed, can modify permissions or redirect I/O

### Deliberately Kept in Allow
- `node *`, `python *`, all runtimes — high frequency, essential for dev
- `rm *` (single file), `mv *` — git-recoverable, needed constantly
- `cat *`, `head *`, `tail *` — `.env` denied specifically, `Read` tool bypasses cat denies anyway
- `find *` — read-only, doesn't expose file content
- `bash .claude/skills/deep-analysis/*` — already scoped to specific path

### Updated
- `subagents-and-hooks-guide.md` permissions section — new ask/deny entries, updated counts
- Permission counts: allow 145→137, deny 20→21, ask 4→12

---

## V6.4 — Hooks Implementation (2026-03-07)

### New Hook Scripts
- **`session-start.sh`** — SessionStart hook with proper JSON `additionalContext` output. Detects in-progress work from `.agents/progress/`. Replaces broken plain `echo` hook.
- **`auto-format.sh`** — PostToolUse auto-formatter. Runs Prettier (JS/TS/CSS/JSON/HTML/MD/YAML), Black/autopep8 (Python), gofmt (Go), rustfmt (Rust) based on file extension. Exits silently if formatter not installed.

### Changed
- `settings.json` hooks block updated: SessionStart calls script (timeout 10s), PostToolUse matcher `Edit|Write|MultiEdit` calls formatter (timeout 30s)
- `subagents-and-hooks-guide.md` — deployed hooks table, script documentation, updated customization examples, Windows notification pattern
- Hook count: 1 → 2 (SessionStart fix + PostToolUse auto-formatter)
- Skill count: 33 (unchanged)

### Evaluated & Rejected (5)
- PreCompact transcript backup, desktop notification (user-level), git dirty logger, Stop uncommitted gate, PreToolUse archive protection

---

## V6.3 — Skill Quality Optimization (2026-03-07)

### Body Optimization
- `/plan` compressed 155 → 124 lines (-20%), added Iron Laws and Anti-Patterns table
- `/execute` compressed 111 → 88 lines (-21%), extracted Template Sync Gate to supporting file
- `/create-skill` compressed 167 → 99 lines (-41%), removed philosophy duplicated in authoring guidelines
- `/wrap-up` compressed 71 → 59 lines (-17%), removed redundant fallback logic
- `/describe-project` removed inline Automation Note (already in reference doc)
- `/create-prd` tightened downstream scaffolding section

### Iron Laws Added
- `/plan` — 4 iron laws (read codebase first, <30 min tasks, no deferred arch decisions, validation commands required)
- `/review` — 3 iron laws (never auto-fix security, review changed files only, file:line references required)
- `/investigate` — 3 iron laws (evidence-based claims, time-box steps, record as you go)
- `/security-audit` — 3 iron laws (never whitelist Critical/High CVEs, never commit secrets, always run dep scanner)

### Output Artifacts Added
- `/setup`, `/toggle-visibility`, `/thrown-into-someones-hell-hole`, `/test-everything` — explicit outputs section

### Other Improvements
- `/find-skills` description trimmed from 52 to 12 words
- `/restart-dev` reformatted from prose to structured checklist with constraints
- New supporting file: `.claude/skills/execute/template-sync-gate.md`

### Unchanged
- Skill count: 33 (no additions or removals)

---

## V6.2 — Pipeline Revision (2026-03-07)

### New Skills (4)
- `/describe` — unified intake (merges describe-task + describe-bug + describe-situation + research)
- `/thrown-into-someones-hell-hole` — brownfield pipeline orchestrator
- `/test-everything` — full test pipeline (automated + browser + deps + manual checklist)
- `/release` — release pipeline orchestrator (QA → security-audit → PR)

### New Utility
- `/audit-pipeline` — audit skills and pipelines against actual usage

### Removed Skills (9)
- `/describe-task`, `/describe-bug`, `/describe-situation` — merged into `/describe`
- `/fix-bug` — absorbed into `/plan` bug-fix path
- `/configure-automation` — merged into `/setup`
- `/test-all`, `/plan-test` — absorbed into `/test-everything`
- `/dependency-audit` — absorbed into `/test-everything`
- `/research` — absorbed into `/describe`

### Modified Skills (7)
- `/execute` — reordered auto-pipeline (conditional execution-report, wrap-up prompt, removed /create-pr from auto-pipeline), added Template Sync Gate for auto version bump + mirror in template repos
- `/plan` — bug-fix methodology (reproduce gate, binary search, RCA)
- `/setup` — absorbed configure-automation as a phase
- `/help` — updated command reference and workflow patterns
- `/manage-skills` — updated categories, blast radius check
- `/upgrade-template` — fixed template source reference
- `/template-info` — upgraded with dependency mapping, blast radius analysis, cross-reference checking

### Changed
- Skill count: 37 → 33 (9 removed, 5 added)
- Auto-pipeline reordered: execution-report now conditional before review, wrap-up prompt at end
- All cross-references updated across skills, agents, reference docs, templates

---

## V6.0 — Token Optimisation, Subagents & Workflow Redesign (2026-03-07)

### Token Optimisation
- Compressed all 33 skills (4409 → 2198 lines, 50.1% reduction) following new authoring guidelines
- Downgraded read-only subagents (code-reviewer, test-planner) to Haiku model
- Skill authoring guidelines document (`.claude/reference/skill-authoring-guidelines.md`)

### New Subagents
- `researcher` — external research with two-pass citation validation, invoked by /plan when confidence is low
- `session-cleanup` — end-of-session housekeeping, invoked by /wrap-up

### New Skills
- `/manage-skills` — activate/deactivate skills per project, suggest based on project type
- `/plan-test` — generate repeatable manual test checklists (auto + describe modes)
- `/wrap-up` — end-of-session cleanup orchestrator (invokes session-cleanup subagent)

### Workflow Improvements
- `/prime` — event-driven maintenance recommendations (no more static suggestions), expanded document awareness
- `/help` — reorganised into 9 scenario-based categories with full command tables
- Updated workflow patterns across all docs

### Conventions
- Logging convention added to coding-conventions.md
- Plan template includes logging setup task

### Subagent Optimisation
- All subagents now have `memory: project` for cross-session learning
- Model routing: read-only agents → Haiku, reasoning agents → Sonnet
- Subagent count: 4 → 6

### Changed
- Skill count: 32 → 36 (3 new + describe-test removed)

---
## V5.6.1 — Pipeline Ordering Fix (2026-03-06)

### Changed
- `/execute` post-execution pipeline: moved `/update-progress` from Step 1 (before quality checks) to just before `/commit` (after test, validate, review) so progress docs capture full quality check results
- Updated all three template variants (main, Claude Code, Antigravity)
- Renamed `Claude-Code-Template-V5.5` to `Claude-Code-Template-V5.6.1`

---

## V5.6.0 — Brownfield Intake & Research (2026-03-04)

### Added
- `/describe-situation` skill — structured intake for brownfield projects, captures user knowledge into categorized files (`.agents/more-context/`)
- `/research` skill — external source investigation (URLs via WebFetch + Playwright fallback, Excel via exceljs/openpyxl, web search)
- `/investigate` skill — mirrored to template (was missing from previous brownfield commit)
- `/triage` skill — mirrored to template
- `/safe-fix` skill — mirrored to template
- `/dependency-audit` skill — mirrored to template
- Step 0 / Phase 0 on all brownfield skills — checks `.agents/more-context/` for user-provided context before proceeding
- Brownfield workflow pattern: `/describe-situation → [/research] → /investigate → /triage → /safe-fix → /check → /review → /commit`

### Changed
- Skill count: 26 → 32

---

## V5.5.0 — Release & Maintenance Pipeline (2026-03-03)

### Added
- `/qa` skill — verify implementation against PRD requirements, outputs `.agents/qa-{date}.md`
- `/security-audit` skill — OWASP code review + dep CVE scanning, outputs `.agents/security-audit-{date}.md`
- Release pipeline: `/test-all → /qa → /security-audit → /create-pr`
- Maintenance pipeline: `/security-audit → [/fix-bug if needed] → /commit`
- `/prime` deployment detection — recognizes deployed projects (config files, live URLs, git tags) and surfaces the right pipeline

### Changed
- Skill count: 24 → 26

---

## V5.4.0 — Deterministic Triggers + Plan Splitting (2026-03-03)

### Added
- `/configure-automation` skill — dedicated pipeline step for MCP/subagent/hook setup (`/describe-project → /create-prd → /configure-automation → /setup`)
- Plan splitting in `/plan` — Complex tasks produce phase index + sub-plan files instead of one monolithic plan
- Explicit `rca` invocation in `/execute` validation failure path and `/fix-bug`
- Index file detection in `/execute` — detects phase index files and guides sequential sub-plan execution
- Accurate subagent invocation table in `subagents-and-hooks-guide.md`

### Removed
- Scattered MCP/subagent/hook recommendation steps from `/create-prd` (3 sections), `/plan` (2 sections), and `/setup` (1 section) — consolidated into `/configure-automation`
- AI Self-Detection trigger from `/create-skill` — now user-only
- Project-Aware Suggestions trigger from `/create-skill` — moved to `/configure-automation` Step 6
- "context matches" language from subagent documentation — replaced with accurate invocation model
- "may be invoked" language from `/fix-bug` rca mention

### Changed
- `/create-skill` is now `disable-model-invocation: true` — user-only invocation
- Skill count: 23 → 24

---

## V5.3.0 — Review Response: Pipeline Gate, Skill Consolidation, /test-all (2026-03-02)

**Source**: External review of V5.2 template (15 recommendations)

### Added
- `/test-all` skill — comprehensive project test sweep with coverage gap analysis
- Pipeline complexity gate in `/execute` — scales post-execution pipeline to change scope
- `/update-progress` step in `/plan` — creates progress doc before execution
- Phase 0 discovery in `/test` — absorbed from removed `/describe-test`
- Notification hook example in subagents-and-hooks-guide
- Reference doc cleanup step in `/setup`
- `npm install` and other package manager install permissions
- EnterPlanMode override moved from CLAUDE.md to git-workflow.md rules

### Removed
- `/describe-test` skill (merged into `/test` Phase 0)
- `work-context.md` — removed entirely from template and all references
- `disable-model-invocation` from `/help` frontmatter
- `defaultMode` from shared settings.json (moved to settings.local.json)
- Workflow Overrides section from CLAUDE.md templates
- Full development history from distributable template changelog
- `work` preset from `/toggle-visibility`

### Changed
- code-specter model: opus → sonnet
- Skill tables deduplicated (skills-and-workflow-guide now points to /help)
- Template folder renamed: AI-Coding-Template-V5.2 → AI-Coding-Template-V5.3
- Skill count: 23 (removed `/describe-test`, added `/test-all` and `/upgrade-template`)

---

## V5.2.0 — DRY Consolidation, Test Workflow Fix, PR Skill (2026-03-02)

### DRY Consolidation
- **Extracted automation recommendation tables** into `.claude/reference/automation-recommendations.md` — eliminates 4-way DRY violation across `/plan`, `/create-prd`, `/setup`, `/describe-project` (each skill lost ~40-60 lines of inline tables)
- **Extracted plan output template** into `.claude/templates/plan-template.md` — `/plan` Phase 5 now references the file instead of inline template block

### New Skill
- **`/create-pr`** — Create pull request from current branch with auto-generated title and summary from plan/commits. Fills pipeline gap after `/commit`. 21 → 22 skills.

### Skills Improved
- **`/plan`** — Added complexity gate (Simple/Medium/Complex) after Phase 1. Simple tasks skip Phases 3-4 for faster planning.
- **`/test`** — Redesigned for fix-as-you-go workflow. Tests now run per-file with immediate fix loop (max 3 attempts) instead of batch-all-then-fix. Integrates test-planner subagent explicitly in Phase 2.
- **`/commit`** — Added pre-commit check (detects empty commits, suggests `/check` for standalone runs). Added `/create-pr` to Next Step.
- **`/execute`** — Redesigned post-execution pipeline: `/test` (Step 1) → code-reviewer subagent (Step 2) → `/check` → `/review` → `/update-progress` → `/commit` → `/execution-report` → `/create-pr`. Subagents now explicitly invoked, not implicit "auto-fire."

### Accuracy Fixes
- **`/plugin` confirmed real** — All references retained. Added minimum version note (v1.0.33+) to mcp-and-plugins-guide.
- **`npx skills` confirmed real** — All references retained. Added source attribution (Vercel Labs) to skill discovery sections.
- **Subagent trigger language fixed** — Changed "auto-fire based on events" to accurate "Claude spawns based on context" across README, help, subagents-and-hooks-guide, and CLAUDE.md template.
- **Template changelog synced** — V5.1.3 and V5.1.5 entries added to template's changelog.

### Agents
- **rca-agent** — Added `memory: project` for cross-session root cause pattern retention.

### Rules
- **coding-conventions.md** — Replaced `[e.g., ...]` placeholders with common defaults (kebab-case files, camelCase functions, etc.)
- **testing-standards.md** — Replaced framework placeholders with fill-in comments, kept universal anti-patterns.

### Reference Docs
- **NEW: `automation-recommendations.md`** — Single source of truth for MCP, subagent, and hook recommendation tables.
- **`work-context.md`** — Generalized for template (personal version kept in repo root). Removed specific names and company references.
- **`mcp-and-plugins-guide.md`** — Added version requirement note for `/plugin` (v1.0.33+).

### Documentation
- **Skill count**: 21 → 22 across README, help, skills-and-workflow-guide.
- **Workflow patterns**: Updated to include `/test` and `/create-pr` steps.

### Deferred to V5.3
- `context: fork` for heavy skills — not supported for skills (only agents). Needs Claude Code feature.
- `allowed-tools` for discovery skills — not supported for skills (only agents). Needs Claude Code feature.
- Positional `$ARGUMENTS[N]` / `$N` syntax — low impact, no Claude Code support yet.

---

## V5.1.5 — Remove PreToolUse Hook (2026-03-02)

### Hooks
- **Removed PreToolUse Bash safety hook** — LLM-based safety gating on every Bash command was redundant with the comprehensive deny/ask lists (137 allow, 8 deny). Eliminating it removes latency on every Bash call with no loss of safety.

### Permissions Verified
- **Deny rules work correctly**: `git push origin main` is hard-blocked (deny evaluated before ask). Previous session reported this as a bug, but fresh-session testing confirmed deny takes priority over the `Bash(git push *)` ask rule. The earlier false positive was likely caused by a stale permission cache from editing settings.json mid-session.
- **Three-tier permission model confirmed**: deny (hard-block) > allow (silent) > ask (prompt user). Non-main pushes correctly trigger the ask prompt.

---

## V5.1.3 — Permissions Expansion + Help Fix (2026-03-02)

### Permissions
- **Expanded allow list**: 55 → 137 patterns across 10 categories (git, file ops, text processing, system/env, process mgmt, networking, package managers, build/lint, runtimes, wildcards)
- **New git subcommands**: show, blame, rev-parse, remote, fetch, tag, shortlog, reflog, cherry-pick, merge, rebase, restore; broadened checkout beyond `-b` only
- **New safety denies**: `git reset --hard *` and `git clean *` added to deny list
- **New categories**: text processing (sort, uniq, cut, tr, sed, awk, jq, xargs, tee), system/env (pwd, whoami, hostname, date, uname, env, file, stat), process mgmt (ps, lsof, netstat, kill, pkill), networking (curl, wget), 16 additional dev tools (docker, deno, go, dotnet, swift, flutter, cmake, make, gradle, mvn, etc.)
- **Bare command forms**: Added for ls, ps, env, printenv, netstat, and common git subcommands (remote, tag, stash, fetch, reflog)

### Help Skill
- Added `/execution-report` to Quality Checks table (was missing from command reference)
- Removed phantom `/plugin` reference from Extensions section (command doesn't exist)

### Documentation
- Removed Plugins section from V5.1 README (referenced non-existent `/plugin` command)
- Fixed repo README skill count: 19 → 21
- Added Permissions section to `subagents-and-hooks-guide.md` — documents pattern syntax, pre-configured categories, customization

### Reference Docs Updated
- `subagents-and-hooks-guide.md` — new Permissions section with pattern syntax, allow categories, customization guide

---

## V5.1.1 — Real-World Fixes (2026-03-01)

### Bug Fixes
- **Permission patterns**: Added `cd *` and 17 other dev tool commands to allow list — fixes compound command prompts
- **Plan location**: Added explicit instruction to /plan and /execute to write/read `.agents/plans/`, not built-in plan mode directory
- **Hooks**: Changed SessionStart hooks from `prompt` to `command` type — correct usage for context injection vs. safety gating. Documented known Claude Code bugs.

### Improvements
- **Plug-and-play**: Moved `template-version.json` into `.claude/`, removed `PIVLoopDiagram.png`. Root now only has files required by Claude Code.
- **Renamed `/setup-project` → `/setup`**: Added Step 0 (template initialization) — creates CLAUDE.md, .mcp.json, .gitignore entries, .agents/ from `.claude/templates/`. Existing project setup is now: copy `.claude/` → run `/setup` → done.
- **README auto-update**: `/setup` and `/create-prd` now generate project-specific README.md
- **New skill: /toggle-visibility**: Manage .gitignore with presets (work, private, stealth, open) or per-file toggling. 20 → 21 skills.
- **Quick Install guide**: README now documents how to add the template to an existing project

### Reference Docs Updated
- `subagents-and-hooks-guide.md` — added `agent` and `http` hook types, known limitations section
- `skills-and-workflow-guide.md` — updated directory tree, skill count

---

## V5.1.0 — 2026-03-01

**Trigger**: Audit against official Claude Code docs (code.claude.com)

**Changes Applied**:
- All 19 skills: removed redundant `user-invokable: true` from frontmatter (default is true)
- 4 subagents: fixed stale skill name cross-references (V4.5 names → V5 names)
- 5 skills: added `!`command`` dynamic context injection (review, commit, help, update-progress, execution-report)
- test-planner: added `memory: project` for cross-session learning
- help skill: added built-in `/simplify` and `/batch` reference, MCP/plugin awareness
- README: expanded MCP section with recommended servers table, added Plugins section
- CLAUDE.md: updated MCP stub to reference plugins
- plan + create-prd: added contextual MCP server recommendations (checks stack, suggests relevant servers, offers to install)
- NEW skill: `/create-skill` — meta-skill that creates new skills (auto-detects repeated patterns or manual invoke)
- Folder renamed from `AI-Coding-Template-V5/` to `AI-Coding-Template-V5.1/` to match version
- Extracted critical README content into 4 reference docs in `.claude/reference/`:
  - `skills-and-workflow-guide.md` — skills overview, workflow patterns, directory structure, V4.5 upgrade
  - `subagents-and-hooks-guide.md` — subagents, hooks, hook configuration examples
  - `context-architecture.md` — layered context system documentation
  - `mcp-and-plugins-guide.md` — MCP servers, plugins, reference docs inventory
- Updated skill references from "see README" to point to reference docs (plan, create-prd, help)
- Removed hardcoded "V5" version labels from skills and README
- plan + create-prd: added contextual subagent & hook recommendations (checks project type, suggests relevant automation, offers to configure)
- setup: added step 7 — MCP, subagent & hook recommendations after scaffolding
- describe-project: added lightweight MCP/subagent/hook suggestions before handoff to /create-prd

**Deferred to V5.2**:
- `context: fork` for heavy skills (review, execution-report, test) — needs per-skill testing
- `allowed-tools` restrictions for discovery skills — needs per-skill testing
- Supporting files extraction (inline templates → separate .md files)
- Positional `$ARGUMENTS[N]` / `$N` syntax — low impact

**Rationale**: Official docs revealed features V5 wasn't using (dynamic injection, memory), bugs in subagent cross-references, and zero MCP/plugin ecosystem guidance.

<!-- Entries will be appended here by /execution-report -->
