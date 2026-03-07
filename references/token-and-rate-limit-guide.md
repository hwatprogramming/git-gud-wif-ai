---
Applies to: all projects
---

# Token & Rate Limit Guide

Practical guidelines for using this template on Claude Pro and Max plans.

## Template Overhead

**Always loaded (every turn):**

| Component | ~Tokens |
|-----------|---------|
| CLAUDE.md | ~430 |
| Rules (3 files) | ~910 |
| settings.json | ~1,240 |
| Claude Code system prompt | ~3,000-5,000 |
| **Total baseline** | **~6,000-8,000** |

This is ~3-4% of the 200k context window. Negligible.

**On-demand (loaded when invoked):**

| Component | ~Tokens |
|-----------|---------|
| Skills (34 total) | ~24,700 |
| Reference docs (8) | ~9,400 |
| Subagents (6) | ~5,550 |

Skills load one at a time, not all at once. A single skill adds ~400-1,400 tokens.

## Rate Limits by Plan

Anthropic adjusts these dynamically. These are approximate as of early 2026:

| Plan | Opus | Sonnet | Reset |
|------|------|--------|-------|
| Pro ($20/mo) | ~45 msgs / 5 hrs | ~80 msgs / 5 hrs | Rolling window |
| Max ($100/mo) | ~225 msgs / 5 hrs | ~400 msgs / 5 hrs | Rolling window |
| Max ($200/mo) | ~900 msgs / 5 hrs | ~1,600 msgs / 5 hrs | Rolling window |

**In Claude Code, one user message can trigger multiple API calls.** Tool use, subagent invocations, and chained skills all consume from your quota.

## Turns Per Skill

| Skill | Typical turns | Notes |
|-------|--------------|-------|
| `/help` | 1-2 | Glob + response |
| `/commit` | 2-3 | Status + diff + commit |
| `/prime` | 2-4 | Read files + summarize |
| `/describe` | 3-8 | Multi-turn conversation |
| `/plan` | 3-5 | Read context + write plan |
| `/check` | 2-4 | Lint + types + tests + build |
| `/review` | 3-5 | Spawns code-reviewer subagent |
| `/test` | 5-15 | Write tests + run + fix loop |
| `/execute` | 10-30+ | Full pipeline with auto-chain |
| `/test-everything` | 8-20 | 4 phases + report |
| `/release` | 10-20 | Chains /qa + /security-audit + /create-pr |
| `/thrown-into-someones-hell-hole` | 20-50+ | Full brownfield pipeline |

Each subagent call (code-reviewer, test-planner, rca, etc.) counts as separate turns.

## Realistic Session Budgets

### Pro Plan (Opus) — ~45 messages / 5 hrs

| Workflow | Turns | Remaining |
|----------|-------|-----------|
| `/prime` | 3 | 42 |
| `/describe` | 5 | 37 |
| `/plan` | 4 | 33 |
| `/execute` (small feature) | 15 | 18 |
| `/commit` | 3 | 15 |
| Ad-hoc questions | 10 | 5 |

**One full feature cycle per window.** Complex features or brownfield pipelines may exhaust the quota.

### Pro Plan (Sonnet) — ~80 messages / 5 hrs

| Workflow | Turns | Remaining |
|----------|-------|-----------|
| `/prime` | 3 | 77 |
| `/describe` | 5 | 72 |
| `/plan` | 4 | 68 |
| `/execute` (medium feature) | 20 | 48 |
| `/test` | 8 | 40 |
| `/commit` | 3 | 37 |
| Second feature cycle | 30 | 7 |

**Two feature cycles per window.** Enough for a productive session.

### Max Plan ($100) — ~225 Opus messages / 5 hrs

Comfortable for full-day work. Can run `/thrown-into-someones-hell-hole` + multiple fix cycles without hitting limits.

### Max Plan ($200) — ~900 Opus messages / 5 hrs

Effectively unlimited for normal use. Rate limits are rarely a concern.

## Guidelines for Pro Users

1. **Use Sonnet for heavy execution** — `/execute`, `/test`, `/investigate` burn lots of turns. Sonnet gets ~2x the quota and handles these well.
2. **Use Opus for thinking** — `/describe`, `/plan`, `/review` benefit from Opus reasoning. These are low-turn-count skills.
3. **Avoid redundant chains** — `/execute` already runs test + review + check. Don't re-run `/check` before `/commit` if execute just passed.
4. **Batch your context** — give `/describe` everything upfront instead of drip-feeding across many turns.
5. **Skip optional subagents when tight** — the code-reviewer and test-planner subagents improve quality but cost turns. On a tight budget, you can run `/check` instead of `/review`.

## Guidelines for Max Users

1. **Use Opus freely** — you have the budget for it.
2. **Let pipelines chain** — `/execute` auto-pipeline, `/release` full chain, `/thrown-into-someones-hell-hole` end-to-end. No need to break them up to conserve turns.
3. **Use subagents liberally** — code-reviewer, test-planner, rca all improve output quality.

## What Actually Consumes Tokens (Context Window)

The template is not the bottleneck. These are:

1. **Tool results** — file reads, git diffs, grep output (biggest consumer)
2. **Conversation history** — long back-and-forth accumulates
3. **Subagent results** — investigation reports, review findings
4. **Your codebase** — large files read into context

Claude Code auto-compresses old messages when approaching context limits, so sessions can run much longer than the raw 200k window suggests.

## TL;DR

- Template overhead: ~2,500 tokens (~1.3% of context). Not a concern.
- Pro users: plan your model choice around the task. Opus for thinking, Sonnet for doing.
- Max users: use everything freely.
- The real limits are API rate limits (messages/hr), not template size.
