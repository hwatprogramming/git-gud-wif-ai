---
description: "Add or remove files from .gitignore — with presets for common visibility modes"
argument-hint: "[preset name or file path]"
disable-model-invocation: true
---

# Toggle Visibility: Manage .gitignore

Control what's shared in version control. Supports presets and individual toggling.

## Process

### 1. Read Current State
Read `.gitignore`, report hidden vs visible.

### 2. Apply Changes
- **Preset** → apply directly | **File path** → toggle entry | **No argument** → show presets, ask

### Presets

| Preset | Hides | Use Case |
|--------|-------|----------|
| `private` | `.agents/progress/`, `.agents/plans/` | Hide workflow artifacts |
| `stealth` | `CLAUDE.md`, `.mcp.json`, `.claude/`, `.agents/` | Hide all AI files |
| `open` | Nothing extra | Remove restrictions |

### 3. Update .gitignore
Add under `# Visibility (managed by /toggle-visibility)`. Remove header if block empty.

### 4. Handle Tracked Files
If adding already-tracked file: warn, offer `git rm --cached <path>`.

### 5. Confirm
Show added/removed. Include undo instruction.

## Outputs

Updated `.gitignore` with visibility changes under managed header.

## Next Step
- `git status` to verify → `/commit` if untracked files
