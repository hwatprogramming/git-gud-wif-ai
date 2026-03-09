# Feature: <feature-name>

The following plan should be complete, but validate documentation and codebase patterns before implementing.

## Feature Description

<Detailed description, purpose, and value>

## User Story

As a <type of user>
I want to <action/goal>
So that <benefit/value>

## Problem Statement

<The specific problem this addresses>

## Solution Statement

<Proposed solution approach>

## Feature Metadata

**Feature Type**: [New Capability/Enhancement/Refactor/Bug Fix]
**Estimated Complexity**: [Low/Medium/High]
**Primary Systems Affected**: [List]
**Dependencies**: [External libraries or services]

---

## CONTEXT REFERENCES

### Relevant Codebase Files — READ BEFORE IMPLEMENTING

- `path/to/file.py` (lines 15-45) - Why: Contains pattern for X
- `path/to/model.py` (lines 100-120) - Why: Database model structure

### New Files to Create

- `path/to/new_file.py` - Purpose

### Relevant Documentation — READ BEFORE IMPLEMENTING

- [Doc Link](url#section) - Why: Needed for X

### Applicable Skills & Reference Docs

| Resource | Type | When to Use |
|----------|------|-------------|
| `resource-name` | Skill / Reference Doc | During which task(s) |

### Applicable Subagents

| Subagent | When to Invoke |
|----------|----------------|
| code-reviewer | After /execute completes |
| rca-agent | When errors occur |

### Patterns to Follow

<Naming conventions, error handling, logging patterns from this codebase>

---

## STEP-BY-STEP TASKS

Execute every task in order, top to bottom. Each task is atomic and independently testable.

### (If new project) CONFIGURE structured logging

- **IMPLEMENT**: Set up project logger following `.claude/rules/coding-conventions.md` → Logging section
- **PATTERN**: See framework-specific guidance in the Logging convention
- **VALIDATE**: `grep -r "logger\|logging\|winston\|pino" src/`

### {ACTION} {target_file}

- **IMPLEMENT**: {Specific detail}
- **PATTERN**: {Reference to existing pattern - file:line}
- **IMPORTS**: {Required imports}
- **GOTCHA**: {Known issues to avoid}
- **VALIDATE**: `{executable validation command}`

---

## TESTING STRATEGY

### Unit Tests
### Integration Tests
### Edge Cases

---

## VALIDATION COMMANDS

### Level 1: Syntax & Style
### Level 2: Unit Tests
### Level 3: Integration Tests
### Level 4: Manual Validation

---

## ACCEPTANCE CRITERIA

- [ ] Feature implements all specified functionality
- [ ] All validation commands pass with zero errors
- [ ] Code follows project conventions and patterns
- [ ] No regressions in existing functionality
