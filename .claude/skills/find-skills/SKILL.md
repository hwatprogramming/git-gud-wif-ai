---
description: "Discover and install community skills from skills.sh — search, evaluate, and add to project"
disable-model-invocation: true
---

# Find Skills: Discover Community Skills

Help users find and install community skills for their project.

## Process

### 1. Check Local Catalog First

Read `.claude/reference/popular-skills.md`. Search for skills matching the user's need by category or keyword. If a match exists, present it with the install command.

### 2. Live Search (if catalog misses)

```bash
npx skills find [query]
```

Try specific keywords, then broader terms. Common categories: web development, testing, DevOps, documentation, code quality, design, AI/LLM.

### 3. Present Results

For each relevant skill:
- Name and what it provides
- Install command: `npx skills add <owner/repo@skill> -y`
- Whether it overlaps with an existing template skill

### 4. Install

When user confirms: `npx skills add <owner/repo@skill> -y`

For global install (available across all projects): add `-g` flag.

## Integration Notes

- Check `.claude/reference/skill-quality-heuristic.md` if unsure whether a skill is worth the token cost
- Knowledge skills (no steps, just domain expertise) may be better as reference docs -- see `lessons/community-skills-and-knowledge-types.md`
- After install, verify the skill appears in `.claude/skills/` or `.agents/skills/`

## No Results

If nothing matches: acknowledge, offer direct assistance, or suggest `/create-skill` to build a custom one.

## Next Step

- Skill installed -> try it out
- Want to evaluate quality -> check against skill-quality-heuristic.md
- Want to build your own -> `/create-skill`
