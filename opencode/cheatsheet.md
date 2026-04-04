# OpenCode Agent Cheatsheet

Quick reference for the consolidated OpenCode agent set. Invoke subagents with `@agent-name` in any OpenCode session. Switch primary agents with `Tab`.

---

## Quick Routing

```
Planning or reviewing a plan?  → @planning-agent
Building backend/app logic?    → build mode (MiniMax Free) by default, @engineer for harder work, or @coder if tests define done
Building UI/components?        → @frontend
Writing or running tests?      → @qa
Reviewing code quality?        → @reviewer
Auditing security?             → @security
Creating Linear work items?    → @linear
Generating docs?               → @docs_generator
Cheap throwaway edits?         → @pickle-implement or the configured small model
Cheap brainstorming?           → @pickle-think
```

---

## Default Build Lane

### build mode — Default Builder
**Model:** MiniMax M2.5 Free | **Use for:** Day-to-day implementation when you want the cheapest default lane

```
Implement a REST endpoint for /api/properties that returns paginated results
Build webhook support for the payment service with validation and retries
Refactor the HVAC controller to use the strategy pattern
```

---

## Subagents

### @engineer — Premium Builder
**Model:** Gemini 3.1 Pro | **Use for:** Harder implementation, trade-offs, risky multi-file changes

```
@engineer Implement a multi-step billing migration with rollback safety and monitoring
@engineer Refactor the auth flow across services and preserve backward compatibility
```

### @planning-agent — Architect + Plan Reviewer
**Model:** Gemini 3.1 Pro | **Use for:** Architecture, migrations, task breakdown, plan review

```
@planning-agent Design the database schema for a multi-tenant property management system
@planning-agent Break down the OAuth2 + PKCE authentication flow
@planning-agent Review docs/migration-plan.md for gaps and risks
```

### @linear — Project Management
**Model:** GPT 5.4 Mini | **Use for:** Creating/managing Linear issues and projects with structured output

```
@linear Create a project "Q2 Auth Rewrite" with issues from docs/auth-plan.md
@linear Create an issue: Add rate limiting to public API endpoints
```

### @coder — Autonomous Test-Fix Loop
**Model:** GPT 5.3 Codex | **Use for:** Clear specs with existing tests - implement until green

```
@coder Implement the OrderService interface in internal/service/order.go and run tests until all pass
@coder Refactor calculateDiscount to handle the new tier system and keep all tests green
```

### @frontend — UI Specialist
**Model:** Kimi K2.5 | **Use for:** Cost-sensitive React/TS components, responsive UI, accessibility, screenshot-to-code

```
@frontend Build a pricing page with 3 tiers using Tailwind and make it responsive
@frontend Implement this design as a React component and preserve keyboard accessibility
```

### @reviewer — Code Review
**Model:** Gemini 3.1 Pro | **Use for:** SRP, complexity, performance, readability review

```
@reviewer Review internal/handler/payment.go for clean code and performance issues
@reviewer Check the new auth middleware for unnecessary complexity
```

### @security — Security Audit
**Model:** Gemini 3.1 Pro | **Use for:** OWASP-style review, auth flaws, injection, validation gaps

```
@security Audit the authentication flow in internal/auth/
@security Review the file upload handler for traversal and size-limit issues
```

### @qa — QA Automation + BDD
**Model:** GPT 5.4 Mini | **Use for:** Test generation, execution, requirements-driven tests

```
@qa Write unit tests for internal/service/order.go and cover edge cases
@qa Users can only edit their own profiles; admins can edit any profile; email changes require reverification
```

### @docs_generator — Documentation
**Model:** Gemini 3 Flash | **Use for:** Inline comments, JSDoc, GoDoc, external docs

```
@docs_generator Add inline documentation to internal/service/
@docs_generator Generate module-level docs for src/components/
```

### @pickle-think — Cheap Planner
**Model:** Big Pickle | **Use for:** Cheap triage, rough plans, file discovery, disposable brainstorming

```
@pickle-think Map this feature into the smallest safe set of file changes
@pickle-think Read src/auth and tell me the cheapest implementation path
```

### @pickle-implement — Cheap Implementer
**Model:** Big Pickle | **Use for:** Low-risk code edits, boilerplate, config changes, first-pass implementation

```
@pickle-implement Add a new env var to the config loader and docs
@pickle-implement Rename this route handler and update its imports
```

---

## Common Workflows

### New Feature
```
1. @pickle-think   → cheap first-pass triage
2. @planning-agent → architecture and task breakdown
3. @linear         → create issues from the plan
4. build mode      → implement by default
5. @engineer       → escalate if the implementation is hard or high-risk
6. @qa             → tests
7. @reviewer       → code review
8. @security       → audit if needed
```

### Cheap First Pass
```
1. @pickle-think   → map the smallest safe change
2. @pickle-implement → make the low-risk edit
3. Escalate if the task grows
```

### Spec-Driven Implementation
```
1. @qa             → turn requirements into tests
2. @coder          → implement until green
3. @reviewer       → review the implementation
```

### Frontend Feature
```
1. @frontend       → build from screenshot or description
2. @qa             → add component tests
3. @reviewer       → review accessibility and maintainability
```

### Plan Review
```
1. @planning-agent → review existing plan in critic mode
2. build mode or @engineer → implement once approved
```

---

## Cost Awareness

| Tier | Agents | Cost |
|------|--------|------|
| **Free** | pickle-think, pickle-implement | Free |
| **Budget** | docs_generator | ~$0.50/$3 per 1M |
| **Workhorse** | linear, qa | $0.75/$4.50 per 1M |
| **Specialist** | coder | $1.75/$14 per 1M |
| **Premium** | planning-agent, reviewer, security | $2/$12 per 1M |
| **Premium Builder** | engineer | $2/$12 per 1M |
| **Builder Default** | build mode | Free |
| **Frontend** | frontend | $0.60/$3 per 1M |

**Rule:** keep the default build lane free, use `@engineer` only when the harder model is justified, and keep implementation/review on different model families where possible.

**Free lane:** `small_model` is set to `opencode/big-pickle`, and `@pickle-think` / `@pickle-implement` make that lane explicit. Use them for low-risk edits, drafts, and disposable passes. If the change matters, escalate to `@coder`, `@qa`, or `engineer`.
