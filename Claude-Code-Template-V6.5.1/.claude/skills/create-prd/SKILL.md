---
description: Create a Product Requirements Document from conversation
argument-hint: "[output-filename]"
disable-model-invocation: true
---

# Create PRD: Generate Product Requirements Document

Generate a PRD from conversation context. The PRD feeds directly into `/plan` — structure decisions clearly so planning doesn't re-derive what's decided. For complex projects, consider the code-specter subagent for deep spec work.

**Output file**: `$ARGUMENTS` (default: `PRD.md`)

## PRD Sections

Adapt depth based on available information:

1. **Executive Summary** — overview, value proposition, MVP goal
2. **Mission** — mission statement, 3-5 core principles
3. **Target Users** — personas, technical level, needs/pain points
4. **MVP Scope** — in scope vs out of scope, grouped by category
5. **User Stories** — 5-8 stories: "As a [user], I want [action], so that [benefit]" with examples
6. **Core Architecture** — approach, directory structure, design patterns
7. **Tools/Features** — detailed specs (agent tools or app features)
8. **Technology Stack** — backend/frontend with versions, deps, integrations
9. **Security & Configuration** — auth, config management, deployment
10. **API Specification** (if applicable) — endpoints, formats, examples
11. **Success Criteria** — MVP definition, functional requirements, quality indicators
12. **Implementation Phases** — 3-4 phases, each: goal, deliverables, validation. Each phase = 1-3 `/plan` runs
13. **Future Considerations** — post-MVP enhancements
14. **Risks & Mitigations** — 3-5 key risks with strategies
15. **Key Decisions Log** — table: Decision / Context / Chosen / Rejected / Confidence (High/Medium/Low). High = constraint for `/plan`. Low = re-evaluate.
16. **Appendix** (if applicable)

## Process

1. **Extract** requirements from conversation — explicit and implicit needs, constraints
2. **Synthesize** into sections, fill reasonable assumptions, maintain consistency
3. **Write** with clear language, concrete examples, markdown formatting
4. **Quality check**: all sections present, stories have benefits, MVP realistic, tech justified, phases actionable, criteria measurable
5. **Downstream readiness**: tech stack has versions, architecture derives file structure, scope boundaries unambiguous, phases map to plannable features, low-confidence decisions flagged, examples are concrete, criteria measurable

## After PRD

1. **CLAUDE.md** — populate at project root: `# [Project Name]`, Tech Stack, Project Structure, Commands (placeholders), Reference Documentation, MCP Servers, Notes
2. **README.md** — if still has template docs, replace with: project name, description, tech stack, getting started, structure (30-50 lines)

## Output Confirmation

1. Confirm file paths
2. Brief PRD summary
3. Highlight assumptions
4. Suggest: `npx skills find [primary-tech]` to check for relevant community skills
5. Suggest: `/setup`
