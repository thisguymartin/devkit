---
name: security-awareness
description: Checks for injection, deserialization, path traversal, auth, and secrets in application code. Use when writing or reviewing code in TypeScript, JavaScript, Python, Go, or C#.
---

# Security Awareness

## Critical Vulnerability Patterns

### Injection
- **Never** use `eval()`, `exec()`, `Function()`, `compile()` with user input
- **Never** concatenate strings into SQL queries - use parameterized queries
- **Never** pass user input to `os.system()`, `subprocess`, or `exec.Command` unsanitized
- **Never** use `innerHTML` or `dangerouslySetInnerHTML` with unsanitized data

### Deserialization
- **Never** use `pickle.loads()` on untrusted data
- **Never** use `yaml.load()` without `SafeLoader`
- **Never** use `BinaryFormatter` or `TypeNameHandling.Auto` in .NET

### Path Traversal
- **Always** sanitize file paths from user input
- **Never** use `open()`, `filepath.Join`, or `Path.Combine` with raw user input

### Authentication & Authorization
- **Always** add auth middleware to endpoints
- **Always** check resource ownership (prevent IDOR)
- **Always** validate JWT expiration and signature
- **Never** log passwords or tokens in plaintext

### Secrets
- **Never** hardcode API keys, passwords, or tokens
- **Never** commit `.env` files
- **Never** expose internal errors to users in production

## Language-Specific Checks

### TypeScript/JavaScript
- XSS: `innerHTML`, `dangerouslySetInnerHTML`, unescaped templates
- Prototype pollution: `obj[userInput]` assignments
- ReDoS: Complex regex on user input

### Python
- SQL injection: f-strings or `.format()` in SQL
- SSRF: `requests.get(user_url)` without URL validation
- Command injection: `os.system()`, `subprocess` with `shell=True`

### Go
- SQL injection: string concatenation in queries
- Race conditions: shared state without mutex/sync
- Unsafe: avoid `import "unsafe"` unless justified
- Error handling: never ignore `err` in auth/crypto paths

### .NET/C#
- XSS: `Html.Raw()`, `@Html.Raw`
- XXE: XML parsing without disabling DTD processing
- SQL: `FromSqlRaw` with string concatenation

## Input Validation Rules
- Validate at system boundaries (user input, external APIs)
- Sanitize before use in: DB queries, file operations, shell commands, URL construction, regex
- Set limits on: file upload sizes, request body sizes, loop iterations from user data
- Rate limit public-facing endpoints
