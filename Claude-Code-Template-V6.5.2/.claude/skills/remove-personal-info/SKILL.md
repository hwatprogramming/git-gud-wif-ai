---
description: "Scan and remove personal information, private context, and internal references from a project before sharing, open sourcing, or handing off to another developer. Run before making any repo public."
argument-hint: "[optional: comma-separated list of known personal terms to search for]"
disable-model-invocation: true
---

# Remove Personal Info

Prepare a project for public sharing by scanning for and removing personal information, private context, and internal references. Audit-first — never modifies without user confirmation.

## Iron Laws

- Never modify files without explicit user approval — always present findings first
- Always re-scan after applying changes — catch cascading or missed matches
- Never read or modify `.env` files — only scan `.env.example` and `.env.template`

## Process

### 1. Build Search Terms

**Always scan for:**

| Category | Pattern |
|----------|---------|
| Emails | `[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}` |
| Phone numbers | Common formats (international, local) |
| IP / internal URLs | `192.168.*`, `10.*`, `localhost:[0-9]+`, `http://internal*` |
| Credentials | Prefixes: `sk-`, `ghp_`, `Bearer `, `password=`, `secret=`, `token=`, `key=` |
| SSH keys | `-----BEGIN` blocks |

**Auto-detect from git:**
```bash
git log --format="%an %ae" | sort -u
git config user.name && git config user.email
```

**Extract from `$ARGUMENTS`** if provided (user-supplied names, company names, project names).

**Ask the user:** "Any specific names, company names, or internal project names I should look for?"

### 2. Scan

Scan all tracked files. Exclude: `node_modules/`, `.git/`, `dist/`, `build/`, `__pycache__/`.

**File types:** `.md`, `.txt`, `.json`, `.yaml`, `.yml`, `.toml`, `.sh`, `.bash`, `.zsh`, `.py`, `.js`, `.ts`, `.jsx`, `.tsx`, `.env.example`, `.env.template`, and everything in `.claude/`, `.agents/`.

**Record each match:**

| # | File | Line | Preview | Category | Suggested Action |
|---|------|------|---------|----------|-----------------|
| 1 | path/file.md | 42 | "...context..." | Real name | Replace with placeholder |

**Categories:** Real name, Email, Employer/Company, Internal project, Credential, Personal context, Internal URL, Other

**Actions:** Remove, Replace with placeholder, Redact (term only), Keep (flag as intentional), Review (needs user decision)

### 3. Present Findings & Get Approval

Group by category. Show summary counts. Ask:
- **Approve all** suggested actions
- **Approve by category** (e.g. "approve names, emails")
- **Review each** individually
- **Override** specific items

Do not make any changes until the user approves.

### 4. Apply Changes

**Placeholder rules:**

| Category | Replacement |
|----------|-------------|
| Real names | `[Your Name]` or `your-username` |
| Emails | `your-email@example.com` |
| API keys | `YOUR_API_KEY_HERE` |
| Company names | `[Your Company]` |
| Internal projects | `[project-name]` |

After applying, re-scan to verify 0 matches remain. Report: applied N changes across Y files, Z items skipped.

### 5. Visibility Audit

Audit `.gitignore` for public readiness:

| Check | Expected |
|-------|----------|
| `.env` in `.gitignore` | Yes — verify present |
| `.env.example` exists | Suggest creating with placeholders if missing |
| `.agents/progress/`, `.agents/plans/` | Offer to hide (workflow artifacts) |
| Credentials, keys, certificates | Should be gitignored |
| Large binaries, build artifacts | Should be gitignored |

Show what's currently tracked vs hidden. Offer to update `.gitignore` under `# Visibility (managed by /remove-personal-info)` header. Run `git rm --cached` for any newly-ignored but already-tracked files (after confirmation).

### 6. Git History Advisory

File content is now clean, but git history may still contain personal info.

| Option | When | Command |
|--------|------|---------|
| **Fresh repo** (recommended) | Most cases | `mkdir ../repo-public && cp -r . ../repo-public && cd ../repo-public && rm -rf .git && git init && git add . && git commit -m "feat: initial public release"` |
| **Rewrite history** | Preserve timeline | `pip install git-filter-repo && git filter-repo --name-callback 'return b"username"' --email-callback 'return b"email@example.com"'` |
| **Squash** | Nuclear option | `git checkout --orphan clean && git add . && git commit -m "feat: initial public release" && git branch -D main && git branch -m main` |

Ask which approach the user prefers. Provide exact commands for their situation.

### 7. Pre-Share Checklist

- [ ] No personal names in tracked files
- [ ] No email addresses in tracked files
- [ ] No credentials, API keys, or tokens
- [ ] No internal company/project references
- [ ] `.env` gitignored, `.env.example` exists with placeholders
- [ ] README written for external audience
- [ ] No TODO/FIXME with personal context
- [ ] Internal notes cleaned up
- [ ] Git history strategy decided and actioned

Present with pass/fail for each item.

## Output

- Findings table (pre-approval)
- In-place file modifications (post-approval)
- Re-scan confirmation (0 matches)
- `.gitignore` updates (if applicable)
- Git history advisory with commands
- Pre-share checklist results

## Next Step

- Checklist all green → `/sync-docs` to polish docs for external audience → `/commit`
- README needs rewriting → manual edit or `/sync-docs`
- Git history concerns → follow Phase 6 guidance
