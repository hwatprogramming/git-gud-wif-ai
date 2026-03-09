# Skill Authoring Guidelines

> **Applies to**: Claude Code template development, skill creation
> **When to read**: Writing, compressing, or reviewing any SKILL.md file.
> **Referenced by**: `/create-skill`

---

## 1. Skill Structure

### Frontmatter

Every SKILL.md starts with YAML frontmatter between `---` delimiters:

```yaml
---
description: "Third-person summary -- WHAT the skill does and WHEN to use it"
argument-hint: "[hint text]"           # Only if the skill takes arguments
disable-model-invocation: true         # Only for user-invoked skills (discovery, planning)
# Optional fields:
# context: fork                        # Isolated context (no parent conversation)
# agent: <subagent-name>              # Delegate to a subagent
# allowed-tools: [Read, Grep, Glob]   # Restrict tool access
# model: claude-haiku-4-5-20251001    # Route to a specific model
---
```

### Description Rules

The description is the most token-expensive field -- loaded at startup for ALL skills. It is also the primary trigger mechanism for auto-suggest skills.

- Third person ("Creates...", "Runs...", not "Create..." or "I will...")
- Include WHAT it does and WHEN to use it
- Max ~100 words
- Include specific trigger phrases -- the description is the activation mechanism
- Be slightly "pushy" -- Claude tends to under-trigger skills. Include contexts where the skill should activate even if the user does not explicitly name it
- Bad: `"Does code review"` -- too vague, no trigger context
- Good: `"Reviews code changes for bugs, security issues, and convention violations. Use after implementation before committing."`

### Body Structure

```
# Title
## Objective (or ## When to Use)
## Process
  ### Step 1: ...
  ### Step 2: ...
## Output
## Next Step
```

Alternative pattern (from skills.sh): When to Use -> Core Instructions -> Examples -> Anti-patterns -> Verification Checklist

### Supporting Files (Bundled Resources)

```
skill-name/
  SKILL.md (required)
  scripts/    -- Executable code for deterministic/repetitive tasks
  references/ -- Docs loaded into context as needed
  assets/     -- Files used in output (templates, icons, fonts)
```

- Scripts can execute without loading into context -- lowest cost option for repetitive work
- Reference files cost zero tokens until Claude reads them
- Keep references one level deep -- no nested reference chains
- Named descriptively: `examples.md`, `checklist.md`, `analyze.sh`
- For large reference files (>300 lines), include a table of contents

**Domain organization**: When a skill supports multiple domains/frameworks, organize by variant:
```
cloud-deploy/
  SKILL.md (workflow + selection)
  references/
    aws.md
    gcp.md
    azure.md
```
Claude reads only the relevant reference file.

### Size Targets

| Type | Lines | Words | Tokens |
|------|-------|-------|--------|
| Focused skill | <300 | 300-800 | <3000 |
| Methodology skill | <500 | 1500-3000 | <5000 |

---

## 2. Progressive Disclosure

Skills use a three-level loading system:

| Level | When Loaded | Cost | Target Size |
|-------|-------------|------|-------------|
| Description (frontmatter) | At startup, for ALL skills | Highest per-word | ~100 words |
| SKILL.md body | When skill is invoked | Moderate -- one-time | <500 lines |
| Bundled resources | When Claude reads them | Lowest -- on demand | Unlimited |

Design with this hierarchy:
- Keep descriptions tight -- every word costs tokens in every session
- Keep SKILL.md as the overview -- enough to execute, not everything
- Push detailed schemas, examples, and reference to supporting files
- Use clear pointers: "Read `references/schemas.md` for the full JSON structure"

---

## 3. Writing Style

- **Imperative voice**: "Read the file", not "You should read the file"
- **Normal language**: Drop MUST/CRITICAL/ALWAYS -- Claude 4.6 overtriggers on aggressive prompting. Normal instructions work equally well.
- **Explain the why**: Tell Claude WHY a rule exists. It generalises from explanations better than from bare commands. If you find yourself writing ALWAYS or NEVER in all caps, reframe -- explain the reasoning so the model understands importance.
- **Positive framing**: Tell Claude what TO DO, not what NOT to do. Instead of "Do not skip validation", write "Run validation after every change."
- **Structured over prose**: Bullets, numbered lists, and tables beat paragraphs. Every paragraph is a candidate for compression into a bullet list.
- **Examples**: Include 1-2 examples for complex or ambiguous steps. Skip examples for obvious actions.
- **Deliverable-driven**: Define explicit output artifacts -- what files the skill creates, what format, where they go.

### For Methodology Skills

- **Anti-patterns tables**: Include "Red Flags" or "Common Rationalizations" tables to encode hard-won lessons (pattern from obra/superpowers)
- **Iron Law**: For complex skills, state one non-negotiable constraint that prevents the most common failure mode

### Defining Output Formats

```markdown
## Report structure
Use this exact template:
# [Title]
## Executive summary
## Key findings
## Recommendations
```

### Examples Pattern

```markdown
## Commit message format
**Example 1:**
Input: Added user authentication with JWT tokens
Output: feat(auth): implement JWT-based authentication
```

---

## 4. Natural Language vs Deterministic Instructions

| Use Deterministic For | Use Natural Language For |
|----------------------|------------------------|
| Sequential steps | Decision-making |
| File operations | Flexible analysis |
| Output format | User-facing communication |
| Literal examples | Edge case judgement |

- If a deterministic instruction and an NL explanation say the same thing, that is bloat -- pick one
- Decision trees and tables are the sweet spot: structured but flexible
- Steps that Claude could figure out on its own do not need detailed instructions

---

## 5. Compression Rules

### The 40% Test

Cut the prompt by 40%. If the compressed version produces equivalent output, the cut was justified. Most skills pass this test because they explain things Claude already knows.

### What to Cut

- Restatements of common knowledge (Git basics, JSON format, what code review means)
- Verbose step descriptions for obvious actions ("Read the file carefully and understand its contents")
- Redundant reinforcement of rules already in `.claude/rules/` files
- Multi-line explanations that can be a single bullet point
- Paragraphs -- almost always compressible to bullets or tables

### What to Keep

- Constraint lists (exact limits, forbidden actions, required order)
- Exact output formats (templates, file paths, section structure)
- Decision tables (if X then Y logic)
- Edge case handling (non-obvious gotchas)
- Motivation for non-obvious rules (WHY something matters)

### Progressive Disclosure (Compression)

- SKILL.md is the overview -- keep it lean
- Detailed reference goes in supporting files (zero token cost until read)
- Example: instead of embedding a full template in the skill body, write "Read `.claude/templates/plan-template.md` for the output structure"

---

## 6. Skill Improvement Philosophy

When iterating on an existing skill:

- **Generalise, do not overfit** -- skills run across many different prompts. Fiddly changes that fix one test case but break others are worse than useless. Try different metaphors or patterns rather than adding constraints.
- **Keep prompts lean** -- remove things that are not pulling their weight. Read execution transcripts to spot where the skill makes the model waste time on unproductive steps.
- **Bundle repeated work** -- if test runs all independently write the same helper script, that is a signal to bundle it in `scripts/`. Write once, use everywhere.
- **Draft, review, improve** -- write a revision, look at it with fresh eyes, then improve before committing. The thinking time is cheap; bad skills are expensive.

---

## 7. Token Budget Awareness

| Layer | When Loaded | Cost Impact |
|-------|-------------|-------------|
| Description | At startup, for ALL skills | Highest per-word cost |
| SKILL.md body | When skill is invoked | Moderate -- one-time per invocation |
| Supporting files | When Claude reads them | Lowest -- only loaded on demand |

Design skills with this hierarchy in mind:
- Keep descriptions tight (~100 words)
- Keep SKILL.md under 500 lines
- Push detailed reference to supporting files

---

## 8. Checklist for New Skills

Before finalizing any skill, verify:

- [ ] Description is third person, includes WHAT and WHEN, under 100 words
- [ ] Description includes trigger phrases for auto-suggest (if applicable)
- [ ] SKILL.md under 500 lines
- [ ] No prose explaining concepts Claude already knows
- [ ] Deterministic where possible, NL only where judgement is needed
- [ ] Has a Next Step section
- [ ] Output artifacts are explicitly defined
- [ ] Tested on a real task before declaring stable
- [ ] Supporting files have clear read-me pointers from SKILL.md
