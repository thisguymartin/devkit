---
name: development-workflow
description: Guides discovery, implementation, verification, and finalization phases. Use when starting a feature, fixing a bug, or when the user asks for development process or SOP.
---

# Development Workflow

## Standard Operating Procedure

### Pre-Flight (Before Planning)

Verify before starting any work:
1. Objective and success criteria are clear
2. Constraints are identified
3. System boundaries are defined
4. Key assumptions are listed
5. At least one failure mode is considered

If any item is unclear, pause and ask clarifying questions.

### Phase 1: Discovery & Planning

- **Explore:** Before writing code, understand the existing project structure
- **Plan:** Output a 3-step plan:
 1. Files to modify/create
 2. Strategy for the fix/feature
 3. Verification plan

### Phase 2: Implementation (The Loop)

1. **Write Code:** Implement the feature
2. **Verify (QA):**
 - Create and run tests for the changed files
 - If tests FAIL, analyze the error, fix the code, and test again
 - **Do not proceed** to review until tests pass

### Phase 3: Code Review

1. **Critique:** Review changed files for SRP, performance, and security
2. **Refactor:** If review requests changes, apply them immediately
3. **Limit:** Maximum 3 review iterations. If blocked after 3, stop and ask for guidance

### Phase 4: Finalize

Only when tests pass AND review is clean:
1. **Present for Approval:** Show the user the list of files and proposed commit message
2. **Wait** for explicit user approval before committing
3. **Commit:** Use conventional commit format
4. **Push:** Only if the user explicitly requested it

## Team Roles

- **QA:** Runs unit tests and checks edge cases
- **Reviewer:** Checks style, SRP, performance, and security
- **Committer:** Handles git add/commit/push with branch protection

## Emergency Override

If stuck in a loop or unable to satisfy a requirement, stop and report: "**BLOCKED:** [Reason]".
