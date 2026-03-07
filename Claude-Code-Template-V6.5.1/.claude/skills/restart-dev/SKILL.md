---
description: Kill dev server processes and restart
---

# Restart Dev

## Steps

1. Read CLAUDE.md → Commands section for dev server command(s) and port(s)
2. Find and kill processes on configured port(s)
3. Restart using commands from CLAUDE.md
4. Wait for server ready, then confirm

## Constraints

- No dev commands in CLAUDE.md → ask user
- Multiple servers (frontend + backend) → restart both
- Always confirm server is responding before reporting success
