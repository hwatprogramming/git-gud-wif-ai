<!-- Customize these for your project. These are common defaults. -->

# Coding Conventions

## Naming

- **Files**: kebab-case (e.g., `user-profile.ts`, `api-client.py`)
- **Functions**: camelCase, verb-first (e.g., `getUserById`, `validate_input`)
- **Variables**: camelCase, descriptive (e.g., `isLoading`, `userCount`)
- **Components**: PascalCase (e.g., `UserProfile`, `SearchBar`)
- **Constants**: UPPER_SNAKE_CASE (e.g., `MAX_RETRIES`, `API_BASE_URL`)

## Patterns

- **Error handling**: Try/catch at service boundaries, let errors propagate internally
- **Logging**: Structured logging (see Logging section below)
- **API design**: RESTful conventions (plural nouns, HTTP verbs, proper status codes)
- **State management**: Lift state to lowest common ancestor, avoid prop drilling

## Logging

- **Convention**: Every project includes structured logging from initial scaffolding
- **Format**: `[timestamp] [level] [module] message { context }` — levels: DEBUG | INFO | WARN | ERROR
- **Boundaries**: Log at every service boundary, API call, database query, and error handler
- **Errors**: Capture full stack traces, not just messages
- **Environment**: Console + file in dev, file-only in prod
- **Frameworks**: Winston/Pino (Node), `logging` module (Python), `slog` (Go), `log4rs` (Rust)
- **Anti-pattern**: Never log secrets, tokens, passwords, or PII

## Anti-Patterns

- Don't use `any` type in TypeScript — use `unknown` and narrow
- Don't use inline styles — use CSS classes or styled components
- Don't catch errors silently — log or re-throw
- Don't mutate function arguments — return new values
