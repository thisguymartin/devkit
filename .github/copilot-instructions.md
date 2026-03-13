# GitHub Copilot Instructions

You are an AI coding assistant. Follow these rules and skills when assisting with development.

---

## Code Quality Standards

- Functions and classes do only ONE thing (SRP)
- Functions should be 20-30 lines max
- No nesting deeper than 3 levels - use guard clauses
- Functions with >5 branch paths need refactoring
- Avoid nested loops O(n^2) when Hash Map O(n) works
- Never put DB queries, API calls, or File I/O inside loops (N+1 problem)
- Variable names must be descriptive (no `x`, `data`, `tmp`, `ret`)
- No magic numbers - extract to named constants

## Engineering Principles

- Correctness, safety, clarity -> then optimization
- Readable > clever, Explicit > implicit
- Simple, proven, boring solutions over novelty
- Design for failure, detection, recovery
- Make assumptions explicit; challenge risky ones

### Priority Order
1. Safety & Correctness
2. Understandability
3. Robustness
4. Maintainability
5. Performance

## Security Awareness

### Never
- Use `eval()`, `exec()`, `Function()`, `compile()` with user input
- Concatenate strings into SQL queries - use parameterized queries
- Pass user input to `os.system()`, `subprocess`, or `exec.Command` unsanitized
- Use `innerHTML` or `dangerouslySetInnerHTML` with unsanitized data
- Use `pickle.loads()` on untrusted data or `yaml.load()` without `SafeLoader`
- Hardcode API keys, passwords, or tokens
- Commit `.env` files
- Log passwords or tokens in plaintext

### Always
- Sanitize file paths from user input
- Add auth middleware to endpoints
- Check resource ownership (prevent IDOR)
- Validate JWT expiration and signature
- Validate at system boundaries (user input, external APIs)
- Rate limit public-facing endpoints

### Language-Specific
- **TypeScript/JS**: Watch for XSS, prototype pollution, ReDoS
- **Python**: Watch for SQL injection via f-strings, SSRF, command injection with `shell=True`
- **Go**: Watch for SQL string concatenation, race conditions, ignored `err` in auth/crypto
- **C#/.NET**: Watch for `Html.Raw()` XSS, XXE, `FromSqlRaw` injection

## Development Workflow

### Before Writing Code
1. Understand the existing project structure
2. Plan: files to modify, strategy, verification plan
3. Verify objective and constraints are clear

### Implementation
1. Write code
2. Create and run tests
3. Review for SRP, performance, security
4. Use conventional commit format

## PR Automation

- Never create PRs from main/master
- Use conventional commit format: `type(scope): description`
- No code snippets in PR descriptions - plain language only
- Include: Overview, Changes, Files Modified, Context, Testing
- Always check for existing PR before creating new one

## Performance

- Show real numbers, not just Big-O notation
- Flag I/O in loops as highest priority
- Common hidden patterns: `array.includes()` in loop (use Set), N+1 queries, spread in loop `[...result, item]` (use push)
