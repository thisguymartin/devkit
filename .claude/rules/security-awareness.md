---
description: Checks for injection, deserialization, path traversal, auth, and secrets in application code. Use when writing or reviewing code in TypeScript, JavaScript, Python, Go, or C#.
globs: "**/*.{ts,tsx,js,jsx,py,go,cs,rs}"
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

## Input Validation Rules
- Validate at system boundaries (user input, external APIs)
- Sanitize before use in: DB queries, file operations, shell commands, URL construction, regex
- Set limits on: file upload sizes, request body sizes, loop iterations from user data
- Rate limit public-facing endpoints
