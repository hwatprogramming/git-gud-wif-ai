# Skill Quality Heuristic

> **Applies to**: Skill evaluation, community skill assessment
> **When to read**: During `/find-skills`, `/create-skill`, or skill improvement sessions
> **Referenced by**: `/create-skill`, `/find-skills`

---

## Token Cost Model

| Layer | When Loaded | Cost | Implication |
|-------|-------------|------|-------------|
| Description | At startup, ALL skills | ~150 tokens/skill/session | Every word here costs the most |
| SKILL.md body | On invocation | ~2000 tokens one-time | Moderate — only pay when used |
| Supporting files | On demand | Free until read | Cheapest — use for detailed reference |

**Rule of thumb**: A skill earns its token cost if it saves more tokens than it consumes. A 300-line skill (~2000 tokens) that prevents one retry loop (~5000+ tokens) is a net win.

## Integration Decision Matrix

| Signal | Action |
|--------|--------|
| Community skill covers something template lacks | Add as net-new if used weekly+ |
| Community skill has a pattern mine lacks | Cherry-pick the pattern, compress to template style |
| Community skill is bulkier with same coverage | Keep yours — bulk = token waste |
| Community skill is clearly better structured | Replace, but compress to size targets first |
| Community skill is a knowledge skill (no steps) | Convert to `.claude/reference/` doc with Applies-to header |
| Community skill duplicates `.claude/rules/` content | Skip — rules auto-load every session already |

## Quality Checklist

For any skill (yours or community):

- [ ] Description: third person, WHAT + WHEN, under 100 words, trigger phrases
- [ ] Body: under 500 lines (300 preferred for focused skills)
- [ ] No prose explaining what Claude already knows (git basics, JSON format, etc.)
- [ ] Uses decision tables or constraint lists, not paragraphs
- [ ] Output artifacts explicitly defined (what files, what format, where)
- [ ] Anti-patterns table or iron law if methodology skill
- [ ] Passes the 40% compression test (cut 40%, same output quality)
- [ ] Tested on a real task

## Formal Eval Method

For core pipeline skills where quality justifies investment, use `/create-skill` Phase 6-10:

1. Write 2-3 realistic test prompts
2. Run with-skill vs baseline (parallel subagents)
3. Grade assertions against outputs
4. Iterate: generalise from feedback, keep prompt lean, bundle repeated work

Reserve formal eval for skills invoked 10+ times per week. For occasional skills, the quality checklist above is sufficient.

## When to Install vs Integrate vs Ignore

| Frequency | Community Quality | Action |
|-----------|------------------|--------|
| Daily use | Better than mine | Replace (compress first) |
| Daily use | Has good patterns | Cherry-pick into existing |
| Weekly use | Standalone utility | Install per-project via `/find-skills` |
| Rare use | Any | Add to `popular-skills.md` for discovery, do not install |
| Any | Knowledge skill | Convert to reference doc |
