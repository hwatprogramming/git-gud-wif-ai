---
description: "Scope a new project — problem, users, tech stack, MVP"
disable-model-invocation: true
---

# New Project

Gather project context through conversational prompting so `/create-prd` and CLAUDE.md can be produced without gaps.

**One-time use** at the start of a new project. For existing codebases, use `/thrown-into-someones-hell-hole`. For individual tasks/bugs, use `/describe`.

**Core Principle**: Ask conversationally — group related questions, skip what's clear, stop when you have enough.

Start with: **"Tell me about your idea — what problem are you trying to solve?"**

### Must have before proceeding

| Question | Why |
|----------|-----|
| What problem does this solve? | Defines scope |
| Who is the target user? | Shapes UX |
| What's the core flow? | This is the MVP |
| What platforms? | Framework choices |
| Solo or team? | Architecture complexity |
| Existing code, designs, references? | Avoid rebuilding |
| Budget constraints? | $0 vs $500/month = different architectures |
| Deadline? | MVP scope |

### Before choosing tech stack

Skip items that don't apply: expected user count, auth needs, real-time/uploads/payments, third-party integrations, offline capability.

### Before writing code

User roles/permissions, core user flows, search/filtering/notifications, data sensitivity/compliance, accessibility.

### Don't forget (mention after core is solid)

Backup/recovery, logging/monitoring, environment setup, rate limiting.

---

## Completion Criteria

- [ ] What the project is/will be and who it's for
- [ ] Target state and MVP scope vs deferred
- [ ] Key constraints (budget, deadline, platforms)
- [ ] Tech stack direction

## Ending

1. Summarize (5-10 bullets)
2. Flag gaps or assumptions
3. Confirm: "Does this capture the full picture?"
4. Suggest: `/create-prd`
