# Subagents & Hooks Guide

> This document preserves template documentation that would otherwise be lost when
> README.md is replaced with a project-specific README. Read this to understand what
> automation runs behind the scenes and how to customize it.

## Subagents

6 specialized agents defined in `.claude/agents/`:

| Subagent | What It Does |
|----------|--------------|
| code-reviewer | Reviews changed files for bugs, security, patterns |
| test-planner | Validates test plan structure and data strategy |
| rca | Classifies errors and traces root causes |
| code-specter | Deep specification work with web research |
| researcher | External research with citation validation |
| session-cleanup | End-of-session housekeeping scan |

Some subagents fire automatically when a skill explicitly calls them; others are manual-only. You don't invoke them directly — the skills handle invocation.

| Subagent | How It Fires |
|----------|-------------|
| `code-reviewer` | Auto — explicitly called in `/execute` Step 2 |
| `test-planner` | Auto — explicitly called in `/test` Phase 2 |
| `rca` | Auto — explicitly called in `/execute` error recovery |
| `code-specter` | Manual only — invoked via `/create-prd` for deep spec work |
| `researcher` | Auto — explicitly called in `/plan` Phase 3b, `/describe` for URLs |
| `session-cleanup` | Auto — explicitly called in `/sync-docs` Step 2 |

## Hooks

> The template ships 2 hooks where automation is strictly better than manual skill invocation. Additional hooks are documented below as examples for project-specific customization. The template still favours deterministic skills and permission rules for everything else.

Defined in `.claude/settings.json`, scripts in `.claude/hooks/`:

### Deployed Hooks

| Hook | Event | Matcher | Script | What It Does |
|------|-------|---------|--------|--------------|
| Session start | `SessionStart` | — | `session-start.sh` | Injects `/prime` reminder + detects in-progress work via JSON `additionalContext` |
| Auto-formatter | `PostToolUse` | `Edit\|Write\|MultiEdit` | `auto-format.sh` | Runs the right formatter (Prettier, Black, gofmt, rustfmt) based on file extension |

Branch safety is handled via the `deny` and `ask` permission lists (not hooks). Context recovery is handled by `/prime`.

### Hook Scripts

Scripts live in `.claude/hooks/` and are referenced by relative path in settings.json:

- **`session-start.sh`** — Outputs JSON `{"additionalContext": "..."}` with /prime reminder. Scans `.agents/progress/` for in-progress work and includes it in the message.
- **`auto-format.sh`** — Detects file extension from `$CLAUDE_TOOL_INPUT_FILE_PATH` and runs: Prettier (JS/TS/CSS/JSON/HTML/MD/YAML), Black or autopep8 (Python), gofmt (Go), rustfmt (Rust). Exits 0 silently if formatter not installed or file type unsupported.

## Hook Examples for Customization

The hooks above are shipped with the template. Add project-specific hooks in `.claude/settings.json`:

**Notification when Claude needs input** (OS-specific, add to user settings not project):
```json
"Notification": [{
  "hooks": [{
    "type": "command",
    "command": "bash .claude/hooks/notify.sh",
    "timeout": 5
  }]
}]
```

Example `notify.sh` for each platform:
- **macOS**: `osascript -e 'display notification "Claude needs input" with title "Claude Code"'`
- **Linux**: `notify-send 'Claude Code' 'Claude needs input'`
- **Windows** (from Git Bash): `powershell.exe -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Claude needs input', 'Claude Code')"`

### Hook Types

| Type | What It Does |
|------|-------------|
| `command` | Runs a shell command. stdout is fed back to Claude as context. Use for reminders, formatters, validators. |
| `prompt` | Sends a prompt to a small model for allow/block evaluation. Use for safety gates (PreToolUse). |
| `agent` | Multi-turn subagent with tool access. Use for complex evaluations that need file reads. Timeout: 60s. |
| `http` | POSTs event data to an HTTP endpoint. Use for external integrations and webhooks. |

### Hook Triggers

| Trigger | When It Fires |
|---------|---------------|
| `PreToolUse` | Before a tool executes (can block it) |
| `PostToolUse` | After a tool executes (for formatting, validation) |
| `SessionStart` | When a new session begins or after context compaction |

## Permissions

Defined in `.claude/settings.json` alongside hooks. Controls which tools and commands Claude can run without prompting.

### Permission Levels

| Level | Behavior |
|-------|----------|
| `allow` | Auto-approved, no prompt |
| `ask` | Prompts user every time |
| `deny` | Blocked entirely |

**Evaluation order**: deny → ask → allow (first match wins). Deny rules from ANY scope always take highest precedence.

### Pattern Syntax

```
"Bash(git status)"       # Exact match — bare command only
"Bash(git status *)"     # Wildcard — matches "git status --short", etc.
"Bash(* --version)"      # Leading wildcard — matches any tool's --version
```

- Space before `*` matters: `Bash(ls *)` matches `ls -la` but NOT `lsof`
- **Bare forms needed**: `git log` does NOT match `Bash(git log *)` — add both bare and wildcard patterns
- **Shell operators blocked**: Compound commands (`&&`, `||`, `;`, `|`, `for/do/done`) never match simple patterns — this is by design for security

### What's Pre-Configured

The template ships ~137 allow patterns across these categories (audited V6.5):

| Category | Examples |
|----------|----------|
| **Tools** | Read, Glob, Grep, Edit, Write, WebSearch, WebFetch, NotebookEdit |
| **Git** | status, diff, log, branch, checkout, add, commit, stash, show, blame, fetch, merge, rebase, restore, etc. |
| **File ops** | ls, cat, head, tail, tree, mkdir, touch, mv, rm, cp, ln, chmod, zip, tar |
| **Text processing** | sort, uniq, cut, tr, sed, awk, jq, xargs, tee, wc, diff, find |
| **System/env** | pwd, whoami, hostname, date, uname, env, file, stat, du, df, which |
| **Process mgmt** | ps, lsof, netstat, ss (kill/pkill moved to ask) |
| **Networking** | curl, wget (ask) |
| **Package managers** | npm, npx, pip, uv, bun, pnpm, yarn, cargo, go, deno, conda, composer, gem, etc. |
| **Build/lint** | tsc, eslint, prettier, black, pytest, vitest, jest, make, cmake, gradle, mvn |
| **Runtimes** | node, python, dotnet, swift, flutter, tauri (docker moved to ask) |
| **Prompted (ask)** | npx, pipx, kill, pkill, chmod, ln, env (bare), printenv (bare) |

**Deny list** blocks: push to main/master, force push, `git reset --hard`, `git clean`, `rm -rf`, `rm -r` (recursive delete), reading `.env` files.

**Ask list**: `git push *`, `curl *`, `wget *`, `docker *`, `npx *`, `pipx *`, `kill *`, `pkill *`, `chmod *`, `ln *`, bare `env`, bare `printenv` (all prompt for confirmation).

### Customizing Permissions

Add project-specific patterns in `.claude/settings.json`:

```json
{
  "permissions": {
    "allow": ["Bash(my-custom-script *)"],
    "deny": ["Bash(dangerous-thing *)"]
  }
}
```

Use `.claude/settings.local.json` (gitignored) for machine-specific overrides.

### Known Limitations (as of March 2026)

SessionStart hooks have known bugs in Claude Code:
- Hooks may not fire on brand new conversations (GitHub #10373)
- Compact matcher output may not be injected into context (GitHub #15174)
- `/prime` remains the primary and most reliable way to load context

The template's SessionStart hook uses proper JSON `additionalContext` output (not plain `echo`) to maximize reliability. If it doesn't fire, `/prime` covers the same ground.
