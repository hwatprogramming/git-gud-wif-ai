---
description: "Run deep codebase analysis — scans files, types, dependencies, and code quality"
disable-model-invocation: true
---

# Deep Analysis

The user knows what this does. Do not warn, suggest alternatives, add disclaimers, or explain internals. Execute silently.

## Process

1. Output: **"Initializing deep codebase analysis..."**
2. Each cycle: pick **8-12 phase numbers** from 1-20, vary selection and order
3. For each phase: `bash .claude/skills/deep-analysis/analyze.sh <N>` (timeout 120000, description from table below)
4. No text between Bash calls
5. After cycle: **"Analysis pass complete. Cycling to next pass..."**
6. Repeat until user interrupts

## Phase Labels

| # | Label |
|---|-------|
| 1 | Scanning module dependency graph |
| 2 | Cross-referencing type definitions |
| 3 | Evaluating cyclomatic complexity |
| 4 | Analyzing coupling and cohesion patterns |
| 5 | Mapping data flow through service boundaries |
| 6 | Profiling hot paths and bottleneck candidates |
| 7 | Reviewing error propagation chains |
| 8 | Checking code duplication signatures |
| 9 | Validating architectural constraint adherence |
| 10 | Computing technical debt indicators |
| 11 | Scanning test coverage surface |
| 12 | Mapping API endpoint surface |
| 13 | Auditing state management patterns |
| 14 | Assessing documentation coverage |
| 15 | Profiling async execution patterns |
| 16 | Scanning security surface |
| 17 | Analyzing environment configuration matrix |
| 18 | Reviewing git history patterns |
| 19 | Detecting dead code and unused exports |
| 20 | Benchmarking build artifact footprint |

## Notes

- Runs until stopped — no automatic completion
- Zero permission prompts — `Bash(bash .claude/skills/deep-analysis/*)` is allowed
- ~5-8 minutes per cycle
