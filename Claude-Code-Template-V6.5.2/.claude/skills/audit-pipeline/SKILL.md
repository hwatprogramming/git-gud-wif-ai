---
description: "Interactive audit of skills and pipelines — compare prescribed workflows against actual usage to find merges, removals, and improvements"
disable-model-invocation: true
---

# Audit Pipeline

Compare how skills and pipelines are *prescribed* versus how they're *actually used*. Produces findings that feed into `/plan` for pipeline revision.

## Process

### 1. Inventory Skills

List all skills in `.claude/skills/`, grouped by pipeline:

| Pipeline | Skills |
|----------|--------|
| Setup & Onboarding | new-project, create-prd, setup |
| Planning & Development | describe, plan, execute |
| Brownfield | investigate, triage, safe-fix |
| Testing & Release | test, test-everything, release |
| Quality & Validation | check, review, qa, deep-analysis |
| Security | security-audit |
| Git & Progress | commit, create-pr, update-progress, execution-report, sync-docs |
| Session | prime, help, restart-dev |
| Config & Meta | manage-skills, find-skills, create-skill, toggle-visibility, upgrade-template, template-info, audit-pipeline |

### 2. Audit Each Pipeline

For each pipeline, show the prescribed flow and ask:

1. "Do you actually use this flow? What's your real pattern?"
2. "Any skills you never invoke?"
3. "Any steps missing that you wish existed?"

### 3. Categorize Each Skill

For each skill, assign a category based on user feedback:

| Category | Meaning |
|----------|---------|
| **Actively used** | User invokes directly |
| **Auto-pipeline only** | Only runs as part of /execute pipeline |
| **Never used** | User has never invoked it |
| **Needs changes** | Works but needs modifications |

### 4. Identify Actions

From the audit, identify:
- **Merges**: Skills that overlap or could combine
- **Removals**: Skills that are never used and provide no auto-pipeline value
- **New skills**: Gaps in the workflow
- **Pipeline changes**: Reordering, new orchestrators, flow modifications

### 5. Save Findings

Save to `.agents/progress/pipeline-audit-[date].md`:

```markdown
# Pipeline Audit — [date]

## Skill Inventory
| Skill | Category | Notes |

## Findings
### Merges
### Removals
### New Skills Needed
### Pipeline Changes

## Recommended Next Steps
```

## Next Step

- Findings ready → `/plan` with audit findings as input
- No changes needed → done
