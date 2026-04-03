# OpenCode Agent Cheatsheet

Quick reference for all custom agents. Invoke subagents with `@agent-name` in any OpenCode session. Switch primary agents with `Tab`.

---

## Quick Routing

```
Need help choosing?     →  @agent-advisor what agent should I use for X?
Planning/architecture?  →  Switch to plan mode (Tab)
Writing code?           →  Switch to engineer (Tab) or build mode
Quick question?         →  Use Copilot Chat instead (save Zen credits)
Tab-complete?           →  Use Copilot inline (unlimited, always on)
```

---

## Primary Agents (Tab to switch)

### engineer — Default Builder
**Model:** GPT 5.4 | **Use for:** Day-to-day implementation, ambiguous tasks

```
# Start coding directly — engineer is the default build agent
Implement a REST endpoint for /api/properties that returns paginated results

# Multi-file feature
Add webhook support to the payment service. Create the handler, register the route, and add validation.

# Refactor with context
Refactor the HVAC controller to use the strategy pattern instead of the switch statement
```

### lead_dev — Orchestrator
**Model:** MiniMax M2.5 Free | **Use for:** Quick tasks, auto-delegation to QA/reviewer/commit

```
# Full lifecycle — plans, codes, tests, reviews, commits
Add a health check endpoint to the API server

# Delegates automatically
Fix the failing test in auth_test.go and commit when green
```

---

## Subagents (@mention to invoke)

### @agent-advisor — Task Router
**Model:** Gemini 3 Flash (cheap) | **Use for:** Picking the right agent or tool

```
@agent-advisor I need to redesign the database schema and then implement it. What's the workflow?

@agent-advisor Should I use Copilot or OpenCode for reviewing this PR?

@agent-advisor I have a Figma mockup to implement and tests to write. Which agents and in what order?
```

### @planning-agent — Systems Architect
**Model:** Gemini 3.1 Pro (1M context) | **Use for:** Architecture, migration plans, system design
**Saves plans to `.opencode/plans/`** — designs blueprints, does not write implementation code

```
@planning-agent Design the database schema for a multi-tenant property management system

@planning-agent Plan the migration from REST to gRPC for the internal services

@planning-agent Break down the authentication flow for OAuth2 + PKCE. Include a Mermaid diagram.

@planning-agent Review the current project structure and propose a module boundary refactor
```

### @plan-reviewer — Plan Critic
**Model:** GPT 5.4 (cross-model from planner's Gemini) | **Use for:** Reviewing architecture plans before implementation
**Requires a file path or pasted plan as input. Saves review to `.opencode/plans/`**

```
@plan-reviewer Review the plan in docs/migration-plan.md for gaps and risks

@plan-reviewer Critique this API design:
  POST /api/orders → creates order + sends email + updates inventory

@plan-reviewer Is this DynamoDB single-table design going to scale? See docs/schema.md
```

### @coder — Autonomous Test-Fix Loop
**Model:** GPT 5.3 Codex | **Use for:** Clear specs with existing tests — implement until green

```
@coder Implement the OrderService interface in internal/service/order.go. Run tests until all pass.

@coder The spec is in docs/webhook-spec.md. Implement it and make all tests in webhook_test.go pass.

@coder Refactor calculateDiscount to handle the new tier system. Existing tests must stay green.
```

### @frontend — UI Specialist
**Model:** Kimi K2.5 (vision) | **Use for:** Screenshots to code, responsive UI, component implementation

```
@frontend Build a pricing page with 3 tiers: Free, Pro, Enterprise. Use Tailwind, make it responsive.

@frontend Implement this design [paste screenshot]. Use React + Tailwind. Match the spacing exactly.

@frontend Create a dashboard sidebar with collapsible navigation groups and active state indicators

@frontend Add a dark mode toggle to the header. Persist preference in localStorage.
```

### @reviewer — Code Review
**Model:** Gemini 3.1 Pro | **Use for:** SRP, complexity, performance, readability review
**Read-only** — critiques, does not fix

```
@reviewer Review internal/handler/payment.go for clean code and performance issues

@reviewer Check the new auth middleware for SRP violations and unnecessary complexity

@reviewer Review the last 3 commits for code quality. Focus on the service layer changes.
```

### @security — Security Audit
**Model:** Gemini 3.1 Pro | **Use for:** OWASP top 10, injection, auth flaws, input validation
**Read-only** — reports vulnerabilities, does not patch

```
@security Audit the authentication flow in internal/auth/ for common vulnerabilities

@security Check api/handlers/ for injection risks, especially the search endpoint

@security Review the file upload handler for path traversal and size limit issues

@security Full security scan of the payment processing module. Check for IDOR and SSRF.
```

### @qa — QA Automation
**Model:** GPT 5.3 Codex | **Use for:** Writing comprehensive test suites with mocking

```
@qa Write unit tests for internal/service/order.go. Cover happy path, sad path, and edge cases.

@qa Create integration tests for the webhook handler. Mock the external payment API.

@qa The calculateShipping function has no tests. Write comprehensive coverage including boundary values.

@qa Add property-based tests for the JSON serialization round-trip in the config package.
```

### @test_generator — Requirements-Driven Tests
**Model:** GPT 5.3 Codex | **Use for:** Translating user requirements into BDD-style tests

```
@test_generator The user should not be able to place an order if their cart is empty or payment is declined

@test_generator Requirements:
  - Users can only edit their own profiles
  - Admins can edit any profile
  - Email changes require re-verification

@test_generator Generate tests for the discount engine based on this spec: docs/discount-rules.md
```

### @docs_generator — Documentation
**Model:** Gemini 3 Flash (cheap) | **Use for:** Inline comments, JSDoc, GoDoc, external docs

```
@docs_generator Add inline documentation to internal/service/. Focus on domain logic, skip obvious code.

@docs_generator Generate GoDoc for all exported functions in the auth package

@docs_generator mode=external source=internal/ target=docs/ — generate module-level documentation

@docs_generator Add JSDoc to the React components in src/components/dashboard/
```

### @commit — Git Automation
**Model:** MiniMax M2.5 Free (free) | **Use for:** Semantic commits, branch protection

```
@commit Stage and commit the changes to the auth handler with a descriptive message

@commit Review the staged changes and create a conventional commit

@commit Stage only the test files and commit separately from the implementation
```

### @linear — Project Management
**Model:** Gemini 3 Flash | **Use for:** Creating/managing Linear issues and projects

```
@linear Create an issue: "Add rate limiting to public API endpoints" with priority High

@linear Create a project "Q2 Auth Rewrite" with 5 issues broken down from docs/auth-plan.md

@linear What are the open issues in the current sprint?
```

---

## Common Workflows

### New Feature (full pipeline)
```
1. @agent-advisor  → picks the right workflow
2. @planning-agent → designs architecture
3. @plan-reviewer  → critiques the plan
4. engineer (Tab)  → implements the feature
5. @qa             → writes and runs tests
6. @reviewer       → code review (different model than builder)
7. @security       → security audit
8. @commit         → semantic commit
```

### Bug Fix (fast track)
```
1. engineer (Tab)  → investigate and fix
2. @qa             → verify with tests
3. @commit         → commit the fix
```

### Spec-Driven Implementation
```
1. @planning-agent → write the spec
2. @test_generator → generate tests from spec
3. @coder          → implement until tests pass (autonomous)
4. @reviewer       → review the implementation
```

### Frontend Feature
```
1. @frontend       → implement from design/screenshot
2. @qa             → component tests
3. @security       → XSS/input validation check
4. @commit         → commit
```

### Pre-Merge Review
```
1. @reviewer       → code quality
2. @security       → vulnerability scan
3. @commit         → squash and commit
   (or use Copilot PR review — free)
```

---

## Cost Awareness

| Tier | Agents | Cost |
|------|--------|------|
| **Free** | commit, lead_dev | $0 |
| **Cheap** | agent-advisor, docs_generator, linear | ~$0.50-3/1M tokens |
| **Standard** | engineer, coder, frontend, qa, test_generator | ~$1.75-15/1M tokens |
| **Premium** | planning-agent, reviewer, security (Gemini 3.1 Pro), plan-reviewer (GPT 5.4) | ~$2-15/1M tokens |

**Rule:** Free for grunt work. Cheap for docs/routing. Standard for building. Premium for thinking.
