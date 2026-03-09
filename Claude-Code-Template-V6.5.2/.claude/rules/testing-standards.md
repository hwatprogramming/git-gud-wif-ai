<!-- Customize the Framework section for your project. Anti-patterns are universal. -->

# Testing Standards

## Framework

- **Test runner**: <!-- Fill in: vitest, jest, pytest, go test, cargo test -->
- **Test location**: <!-- Fill in: tests/ at root, __tests__/ next to source, *_test.go -->
- **Coverage target**: 80% for business logic, 60% overall

## Conventions

- **Naming**: `describe('ComponentName', () => { it('should do X when Y') })`
- **Structure**: Arrange → Act → Assert
- **Isolation**: Each test creates its own data, no shared mutable state
- **Mocking**: Mock at system boundaries (APIs, databases, file system), not internal functions

## Anti-Patterns

- No blind retries — if a test fails, diagnose the root cause first
- No hardcoded delays / sleep() — use waitFor or polling assertions
- No dependency on test execution order
- No network calls to external services in unit tests
