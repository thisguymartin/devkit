---
description: Creates or updates pull requests with overview, change summary, and optional Mermaid flow. Use when the user asks to create a PR, update a PR, or open a pull request.
globs: "**/*"
---

# PR Automation

## Workflow
1. Check branch - Never create PRs from main/master
2. Commit & push - Stage, commit (conventional format), push to origin
3. Check existing PR - `gh pr view $(git branch --show-current)`
4. Create or update

## PR Description Rules
- No code snippets - describe changes in plain language only
- Conventional commit format for titles: `type(scope): description`
- Mermaid flow diagram only for new workflow/data pipeline/API patterns

## PR Body Structure
1. Overview (2-3 sentences)
2. Changes (bullet list, plain language)
3. Files Modified (table with change type and description)
4. Flow (only if applicable)
5. Context (why and how, no code)
6. Testing

## Constraints
- Never force push
- Always commit and push before creating/updating PR
- Always check for existing PR before creating new one
