---
description: "Conversational discovery to clarify any task — features, bugs, brownfield situations, or refactors — before planning"
argument-hint: "[optional description of what you need]"
disable-model-invocation: true
---

# Describe

Gather context through conversation so `/plan` can produce a focused implementation plan without ambiguity. Adapts questions based on task type.

If `$ARGUMENTS` provided, extract what's clear, prompt for the rest. Otherwise: **"What do you want to build, fix, or figure out?"**

## Auto-Detection

Based on the user's description, adapt your approach:

| Signal | Type | Questions to prioritize |
|--------|------|------------------------|
| Errors, broken, not working, regression | **Bug** | Expected vs actual, repro steps, what changed, what's been tried |
| Inherited codebase, unfamiliar project, someone else's code | **Brownfield** | Open-ended intake, listen and organize, save to `.agents/more-context/` |
| New capability, add feature, build | **Feature** | What to build, end result, why, scope |
| Clean up, restructure, improve | **Refactor** | What exists, what to change, what to keep |
| Improve existing, extend, modify | **Enhancement** | Current behavior, desired change, constraints |

## Discovery Checklist

### Feature / Enhancement / Refactor
1. **What's the task?** — What to build or change? New / modification / refactor? End result? Why?
2. **What exists today?** — Skip if brand new. How does it work? Keep what? Change what?
3. **Scope and constraints** — Tech preference? Constraints? Connections to rest of app? What should not change?

### Bug
1. **What's broken?** — Expected vs actual behavior? When did it start? Reproducible? Steps?
2. **Where?** — Which page/component/endpoint? All environments? Specific inputs?
3. **What changed?** — Recent code changes? Dependency updates? When last worked?
4. **What's been tried?** — Debugging done? Error messages/logs? Workarounds?

### Brownfield

**Opening prompt** (use naturally, not verbatim):

> Hey! Before I dig into the codebase, I'd love to hear everything you know — even if it feels scattered. Here are some things that would help me help you:
>
> - **What's going on with this project?** — What is it, what does it do, who's it for?
> - **What are you trying to do?** — Your goal, the task you've been given, what "done" looks like
> - **Any instructions you received?** — From a manager, client, handoff doc, ticket — anything
> - **Links or references I should know about?** — Jira tickets, Slack threads, docs, wikis, design files
> - **What do you already know — or not know?** — What's clear, what's confusing, what worries you
>
> Don't worry about organizing it — just share whatever you've got and I'll sort it out. And if you mention something wrong or incomplete, it can always be edited later.

**Intake loop**: listen, organize, document. Do not ask probing questions — accept whatever the user shares.

Each cycle: receive → organize into categories → show updated preview → ask "Anything to correct or add? If this looks good, share the next thing — or say 'done' when you've covered everything."

Categories saved to `.agents/more-context/`: `background.md`, `task.md`, `known-issues.md`, `concerns.md`, `misc.md`. Only create files with content.

## Save As You Go

After each substantial user input, save key information to `.agents/more-context/` files. Do not batch saves until the end.

If user provides a URL or file path, use the `researcher` subagent for deeper investigation.

## Completion

Enough when you can describe: task type, desired outcome, current state, constraints, "done" definition.

## Ending

1. **Summarize** with type tag: `[Feature|Bug|Refactor|Brownfield|Enhancement]` / What / Why / Constraints / Current state
2. **Confirm**: "Does this capture what you need?"
3. **Suggest**: `/plan`
