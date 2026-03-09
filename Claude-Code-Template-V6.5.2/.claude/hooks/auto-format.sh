#!/usr/bin/env bash
# PostToolUse hook — auto-format files after Edit/Write/MultiEdit.
# Detects language by file extension and runs the appropriate formatter.
# Exits 0 silently if no formatter is available or file type is unsupported.

file="${CLAUDE_TOOL_INPUT_FILE_PATH:-}"
[ -z "$file" ] && exit 0
[ ! -f "$file" ] && exit 0

ext="${file##*.}"

case "$ext" in
  js|ts|jsx|tsx|css|scss|json|html|md|yaml|yml)
    command -v npx >/dev/null 2>&1 && npx --yes prettier --write "$file" >/dev/null 2>&1 || true
    ;;
  py)
    if command -v black >/dev/null 2>&1; then
      black --quiet "$file" 2>/dev/null || true
    elif command -v autopep8 >/dev/null 2>&1; then
      autopep8 --in-place "$file" 2>/dev/null || true
    fi
    ;;
  go)
    command -v gofmt >/dev/null 2>&1 && gofmt -w "$file" 2>/dev/null || true
    ;;
  rs)
    command -v rustfmt >/dev/null 2>&1 && rustfmt "$file" 2>/dev/null || true
    ;;
esac

exit 0
