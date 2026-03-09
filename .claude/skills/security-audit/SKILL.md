---
description: "Audit the codebase for security vulnerabilities — generates a report"
disable-model-invocation: true
---

# Security Audit

Systematic security review: dependency CVE scanning + OWASP Top 10 code review. Outputs severity-ranked report.

**Release pipeline**: `/test-everything` → `/release` (chains `/qa` → `/security-audit` → `/create-pr`)
**Maintenance**: `/security-audit` → `/plan` + `/execute` if Critical/High → `/commit`

## Iron Laws

- Never whitelist Critical or High CVEs — they must be fixed or explicitly accepted by user
- Never commit secrets — if found, rotate immediately and add to .gitignore
- Run the dependency scanner even if code review looks clean — known CVEs are the #1 real-world attack vector

## Process

### 1. Read Project Context

Read `CLAUDE.md` (tech stack, entry points) and `PRD.md` (data handled, auth, payments, public exposure). Identify risk surface: external APIs, authentication flows, user-submitted data, file uploads, database queries.
Scan `.claude/reference/` headers (first 5 lines) — fully read only docs whose **Applies to** tags match the project stack.

### 2. Dependency Vulnerability Scan

Run matching scanner (npm audit --json, pip-audit, cargo audit, bundle audit, govulncheck). Record CVE IDs and severity. If command unavailable, note as "not scanned".

### 3. Secrets Scan

```bash
git ls-files | xargs grep -l -i "api_key\|api_secret\|password\s*=\|secret\s*=\|private_key\|access_token" 2>/dev/null
git ls-files | grep -E "^\.env$|^\.env\."
```

Tracked `.env` files → Critical.

### 4. Code Review — OWASP Top 10

| Category | What to Look For |
|----------|-----------------|
| Injection | String interpolation in queries, unsanitized shell/eval inputs |
| Broken Auth | Weak sessions, no token expiry, unhashed passwords, no rate limiting |
| Data Exposure | Hardcoded creds, sensitive data logged, unencrypted PII |
| Access Control | Missing auth checks, IDOR, path traversal |
| Misconfiguration | Debug mode, default creds, verbose errors, missing security headers |
| XSS | Unescaped user input, unsafe innerHTML/dangerouslySetInnerHTML |
| Insecure Deserialization | Untrusted data in pickle/YAML.load/eval |
| Insufficient Logging | Missing audit logs for auth/privilege/sensitive ops |
| CSRF | State-changing endpoints without CSRF protection |

### 5. Generate Report

Save to: `.agents/security-audit-{YYYY-MM-DD}.md`

```markdown
# Security Audit Report

**Date**: {date} | **Project**: {name} | **Risk Surface**: {brief}

## Summary
- Dep scan: {ran/unavailable} — Critical: {X} | High: {X} | Medium: {X} | Low: {X}
- Code findings: Critical: {X} | High: {X} | Medium: {X} | Low: {X}
- Secrets: {clean / X issues}

## Verdict
**{PASS / PASS WITH NOTES / FAIL}**

## Dependency Vulnerabilities
## Secrets Scan
## Code Findings
### Critical / High / Medium / Low
{each: file:line | description | fix}
## Passed Checks
## Top Priorities Before Going Live
```

## Next Step

- **PASS** → `/create-pr`
- **PASS WITH NOTES** → address Medium at discretion, then `/create-pr`
- **FAIL** → fix Critical/High with `/plan` + `/execute`, re-run audit
