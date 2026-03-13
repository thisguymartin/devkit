# AGENTS.md - Instructions for Autonomous Coding Agents

Welcome to the `ai-native-dev` repository. This document outlines the build, test, coding style, and security guidelines for all autonomous coding agents operating within this codebase. It incorporates rules from both `.cursor/rules/` and GitHub Copilot instructions.

---

## 1. Project Overview & Environment

This repository contains scripting, agent definitions, tools, and rule configurations.
- **Tech Stack:** Shell Scripts, Markdown, Configuration files (.mdc, .toml, .json), and potentially multiple languages (TS/JS, Python, Go) as subprojects.
- **Execution:** Execute scripts natively (e.g., `bash scripts/setup-all.sh`).

---

## 2. Build, Lint, and Test Commands

Since this codebase relies on scripts and varying tech stacks, always determine the local context.
- **Build:**
  - Standard Tools: Execute `npm run build`, `cargo build`, or `go build` based on the local directory's configuration file.
- **Linting:**
  - Shell Scripts: Use `shellcheck <script-name>` before execution.
  - TS/JS/Python: Run `npm run lint`, `eslint .`, or `ruff check .`.
- **Testing:**
  - *Full Suite:* Run the conventional command for the language (e.g., `npm test`, `pytest`, `go test ./...`).
  - *Single Test:* To isolate a single test to save time and tokens, use specific targeted commands:
    - Python: `pytest path/to/test.py::test_function_name`
    - Node/Jest: `npm test -- -t "test_function_name"` or `npx jest path/to/test.file.js`
    - Go: `go test -run ^TestFunctionName$`
  - *No test suite:* Always verify functionality manually by running `bash <script>` in a safe directory.

---

## 3. Code Quality Standards & Style Guidelines

### 3.1 Principles & Philosophy
- **Priority Order:** 1. Safety & Correctness -> 2. Understandability -> 3. Robustness -> 4. Maintainability -> 5. Performance -> 6. Novelty.
- **Design:** Simple, proven, boring solutions over novelty. Readable > clever. Explicit > implicit.
- **Assumptions:** Make assumptions explicit; challenge risky ones. Design for failure, detection, and recovery.

### 3.2 Single Responsibility Principle (SRP)
- Functions and classes do only ONE thing.
- Functions should be 20-30 lines max.
- Avoid function names containing "And" (e.g., `validateAndSave`) - split them into separate functions.
- Classes should not mix unrelated responsibilities.

### 3.3 Complexity & Nesting
- **Hard Limit:** No nesting deeper than 3 levels.
- Use guard clauses (early returns) to flatten `if/else` structures.
- Refactor functions that have more than 5 branch paths.

### 3.4 Formatting, Types, and Imports
- **Imports:** Group imports systematically (Standard Library -> Third-party -> Internal Modules). Use absolute paths or module aliases (`@/src`) over deeply nested relative paths (`../../`).
- **Formatting:** Use the standard formatter for the given language (Prettier, Black, gofmt). Keep line lengths under 100 characters.
- **Types:** Always use strong, strict typing (e.g., `strict: true` in `tsconfig.json`). Avoid `any` or `unknown` unless strictly unavoidable. Define explicit return types for all public functions.

### 3.5 Readability & Naming Conventions
- Variable names must be descriptive (no `x`, `data`, `tmp`, `ret`).
- No magic numbers - extract to named constants.
- Maintain consistent naming conventions throughout the codebase.
- Clear function signatures with meaningful parameter names.

### 3.6 Performance Patterns
- Avoid nested loops O(n^2) when a Hash Map O(n) works. Use Sets for containment checks.
- **NEVER** put DB queries, API calls, or File I/O inside loops (N+1 problem). Batch fetch before the loop, then iterate.
- Move invariant calculations outside loops.
- Use specific field selection instead of `SELECT *`.

### 3.7 Error Handling
- Never silently swallow errors (`catch (e) {}`).
- Catch specific exceptions rather than broad `Exception` classes.
- Wrap external API/DB calls in `try/catch` and provide sufficient fallback contexts or gracefully degrade.

---

## 4. Security Awareness

### 4.1 NEVER Do This
- Use `eval()`, `exec()`, `Function()`, `compile()` with user input.
- Concatenate strings into SQL queries - always use parameterized queries.
- Pass unsanitized user input to `os.system()`, `subprocess`, or `exec.Command`.
- Use `innerHTML` or `dangerouslySetInnerHTML` with unsanitized data.
- Use `pickle.loads()` on untrusted data or `yaml.load()` without `SafeLoader`.
- Hardcode API keys, passwords, or tokens. Log them in plaintext, or commit `.env` files.

### 4.2 ALWAYS Do This
- Sanitize file paths derived from user input.
- Add auth middleware to endpoints and check resource ownership (prevent IDOR).
- Validate JWT expiration and signatures.
- Validate data at system boundaries (user input, external APIs). Rate limit public endpoints.

### 4.3 Language-Specific Security Checks
- **TypeScript/JS:** XSS, prototype pollution, ReDoS.
- **Python:** SQL injection via f-strings, SSRF, command injection with `shell=True`.
- **Go:** SQL string concatenation, race conditions, ignored `err` in auth/crypto.
- **C#/.NET:** `Html.Raw()` XSS, XXE, `FromSqlRaw` injection.

---

## 5. Frontend Design Standards

If generating or modifying frontend components:
- **Typography:** Choose distinctive fonts (e.g., Instrument Sans, Plus Jakarta Sans). **DON'T** use generic fonts like Inter, Roboto, Arial. Use fluid sizing (clamp).
- **Color:** Use OKLCH for perceptually uniform palettes. Tint neutrals toward brand hue. **DON'T** use pure black/gray on colored backgrounds or generic AI palettes.
- **Layout:** Create visual rhythm through varied spacing. **DON'T** wrap everything in cards or center everything.
- **Motion:** Use exponential easing (ease-out-quart/quint/expo). **DON'T** use bounce or elastic easing.
- **Anti-Patterns:** Avoid glassmorphism, rounded rectangles with generic shadows, hero metric layouts, and unnecessary modals.

---

## 6. Development Workflow & PR Automation

### 6.1 Pre-Flight & Implementation
- **Verify:** Ensure the objective is clear, constraints identified, system boundaries defined, assumptions listed, and failure modes considered.
- **Plan:** Outline files to modify, development strategy, and a verification plan.
- **Implement:** Write code, create tests, and ensure tests pass before proceeding. Review your own code for SRP, performance, and security constraints.

### 6.2 Finalization & PRs
- **Commit Format:** Use conventional commits: `type(scope): description`.
- **PR Rules:**
  - Never create PRs from `main`/`master`. Always check for an existing PR before creating a new one.
  - Descriptions must be in plain language (no code snippets). Include sections for Overview, Changes, Files Modified, Context, and Testing.