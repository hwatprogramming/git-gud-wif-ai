# Git Workflow

<!-- This file auto-loads into every Claude session. Defines branching strategy
     and commit conventions. -->

## Branching

- **Main branch**: `main` — protected, no direct pushes (enforced by hooks)
- **Feature branches**: `feat/short-description`
- **Bug fixes**: `fix/short-description`
- **Always branch from**: `main`

## Commits

- Use **conventional commits**: `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`
- Keep commits atomic — one logical change per commit
- Write commit messages that explain WHY, not just WHAT

## Push Policy

- Push to feature branches freely (hook will ask for confirmation)
- Never push directly to main (blocked by settings.json)
- Create PRs for main merges

## Plan Files

- **NEVER use the `EnterPlanMode` tool.** It saves plans to `~/.claude/plans/` (global, not git-tracked). Use the `/plan` skill instead — it writes plans to `.agents/plans/` in the project directory where they are tracked by git and accessible to other skills.
