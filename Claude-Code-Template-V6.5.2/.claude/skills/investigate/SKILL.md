---
description: "Deep codebase investigation for unknown repos — generates a State of the Codebase report"
disable-model-invocation: true
---

# Investigate: Deep Codebase Investigation

Map and understand an unfamiliar codebase. Goes deeper than `/prime` — designed for repos with no docs, messy code, and zero context.

**vs `/prime`**: `/prime` = your own project, loading context. `/investigate` = inherited/unknown repo, understanding from scratch.

## Iron Laws

- Every claim must have evidence (file:line reference, command output, or git history) — do not speculate
- Time-box each step to ~10 minutes — breadth over depth, go deeper in follow-up
- Record scores and findings as you go — do not save everything for the end

## Process

### Step 0: Load User Context

- If `.agents/more-context/` exists, read all files — treat as verified understanding (overrides codebase inference)
- If `.agents/research/` exists, read all files — cross-reference during investigation
- If neither exists, proceed normally

### Step 1: First Impressions

```bash
git log --oneline -30
git shortlog -sn --all
```

Check root directory for: README, CLAUDE.md, docs/, .env.example, docker-compose.yml, Makefile, LICENSE.

**Record** documentation score: 0 (nothing) / 1 (minimal) / 2 (decent) / 3 (comprehensive)

### Step 2: Tech Stack Detection

Scan for config files (package.json, pyproject.toml, Cargo.toml, go.mod, Gemfile, pom.xml, composer.json, *.csproj).

Extract from main config: language versions, frameworks, key dependencies. Also check: `.tool-versions`/`.nvmrc`, build system, CI/CD config.

**Record**: Tech stack inventory table.

### Step 3: Architecture Mapping

```bash
find . -type d -maxdepth 3 -not -path '*/node_modules/*' -not -path '*/.git/*' -not -path '*/dist/*' -not -path '*/__pycache__/*' -not -path '*/build/*' -not -path '*/.next/*' -not -path '*/target/*'
```

Identify: architecture pattern, entry points, module boundaries, data layer, API surface, shared state.

### Step 4: Code Health Assessment

Sample 5-8 representative files. Assess: size, complexity, naming, error handling, comments, function length.

Check for: god classes (>500 lines), deep nesting (>4 levels), magic numbers, copy-paste, dead code, overly clever code.

**Record**: Code health score (1-10) + top code smells with file:line references.

### Step 5: Test Coverage Reality Check

```bash
find . -name "*test*" -o -name "*spec*" | grep -v node_modules | grep -v .git
```

Assess: test-to-source ratio, test quality (real or placeholders?), runner config, try running if safe.

**Record**: None / Stale / Partial / Decent / Comprehensive

### Step 6: Dependency Health Snapshot

Quick overview (full audit is Phase 3 of `/test-everything`): total count, lock file committed?, ancient versions?, deprecated packages?

**Record**: Healthy / Aging / Concerning / Critical

### Step 7: Mystery & Tribal Knowledge Detection

- Cryptic files/folders with unexplained purposes
- TODO/FIXME/HACK/XXX census:
  ```bash
  grep -rn "TODO\|FIXME\|HACK\|XXX" --include="*.{js,ts,py,rb,go,rs,java,php,cs}" . | grep -v node_modules | grep -v .git
  ```
- Environment-specific hacks, hardcoded IPs/paths
- Git blame on confusing code
- "Temporary" code from years ago
- Undocumented environment variables

### Step 8: Generate Report

Save to: `.agents/investigation-report-{YYYY-MM-DD}.md`

```markdown
# State of the Codebase

**Date**: {date}
**Repo**: {repo name}

## Executive Summary
{3-5 sentences: what this repo is, its state, biggest concerns}

## Scores
| Dimension | Score | Notes |
|-----------|-------|-------|
| Documentation | {0-3} | |
| Code Health | {1-10} | |
| Test Coverage | {status} | |
| Dependency Health | {status} | |
| Architecture Clarity | {1-10} | |
| Onboarding Difficulty | {Easy/Moderate/Hard/Nightmare} | |

## Tech Stack
| Category | Technology | Version | Notes |
|----------|-----------|---------|-------|

## Architecture
{text-based map, entry points, data flow}

## Code Health Details
### Strengths
### Code Smells Found
### Testing Status

## Dependency Snapshot
## Mystery Items
## TODO/FIXME/HACK Census
## Immediate Concerns
## Recommendations
```

## Next Step

- `/triage` to prioritize issues into a ranked fix plan
- `/test-everything` for full testing + dependency health audit
- `/safe-fix [description]` if you already know what to fix
