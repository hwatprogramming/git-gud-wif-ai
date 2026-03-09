#!/usr/bin/env bash
# SessionStart hook — injects /prime reminder and in-progress work into Claude's context.
# Output must be valid JSON with "additionalContext" key.

set -euo pipefail

msg="Run /prime to load project context."

# Check for in-progress work in .agents/progress/
progress_dir="${CLAUDE_PROJECT_DIR:-.}/.agents/progress"
if [ -d "$progress_dir" ]; then
  in_progress=$(grep -rl "Status:.*In Progress" "$progress_dir" 2>/dev/null | tr -d '\r' || true)
  if [ -n "$in_progress" ]; then
    files=$(echo "$in_progress" | xargs -I{} basename {} | sed 's/-progress\.md//' | tr '\n' ', ' | sed 's/, $//')
    msg="$msg In-progress work found: $files — check .agents/progress/ for details."
  fi
fi

# Escape for valid JSON output (backslashes, then quotes)
msg="${msg//\\/\\\\}"
msg="${msg//\"/\\\"}"
printf '{"additionalContext": "%s"}\n' "$msg"
