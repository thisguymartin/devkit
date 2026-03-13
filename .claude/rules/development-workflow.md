---
description: Guides discovery, implementation, verification, and finalization phases. Use when starting a feature, fixing a bug, or when the user asks for development process or SOP.
globs: "**/*"
---

# Development Workflow

## Pre-Flight (Before Planning)
Verify before starting any work:
1. Objective and success criteria are clear
2. Constraints are identified
3. System boundaries are defined
4. Key assumptions are listed
5. At least one failure mode is considered

If any item is unclear, pause and ask clarifying questions.

## Phase 1: Discovery & Planning
- **Explore:** Before writing code, understand the existing project structure
- **Plan:** Output a 3-step plan: files to modify/create, strategy, verification plan

## Phase 2: Implementation (The Loop)
1. **Write Code:** Implement the feature
2. **Verify (QA):** Create and run tests. Do not proceed to review until tests pass.

## Phase 3: Code Review
1. **Critique:** Review for SRP, performance, and security
2. **Refactor:** Apply changes immediately
3. **Limit:** Maximum 3 review iterations. If blocked after 3, stop and ask for guidance.

## Phase 4: Finalize
1. **Present for Approval:** Show files and proposed commit message
2. **Wait** for explicit user approval before committing
3. **Commit:** Use conventional commit format
4. **Push:** Only if explicitly requested

## Emergency Override
If stuck in a loop: "**BLOCKED:** [Reason]".
