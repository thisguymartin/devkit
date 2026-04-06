---
disable: true
---

# OpenCode AI Agents

A consolidated 11-agent OpenCode setup tuned around Zen pricing and current model strengths. The routing goal is simple: keep the default build lane free with MiniMax M2.5 Free, reserve `@engineer` for premium implementation, and keep implementation/review on different model families where possible.

## Quick Reference

| Agent | Purpose | Model | Cost (per 1M in/out) | Invocation |
|-------|---------|-------|----------------------|------------|
| `planning-agent` | Architecture design, task breakdown, plan review | Gemini 3.1 Pro | $2/$12 | `@planning-agent` |
| `linear` | Create Linear projects/issues | GPT-5-mini (OpenAI) | $0.25/$2 | `@linear` |
| `engineer` | Premium senior builder (approval required) | Gemini 3.1 Pro | $2/$12 | `@engineer` |
| `coder` | Autonomous test-fix loops | GPT-5 (OpenAI) | $1.25/$10 | `@coder` |
| `frontend` | UI/component development | Kimi K2.5 | $0.60/$3 | `@frontend` |
| `reviewer` | Code quality review | Gemini 3.1 Pro | $2/$12 | `@reviewer` |
| `security` | Security audit | Gemini 3.1 Pro | $2/$12 | `@security` |
| `qa` | Test generation, execution, BDD | GPT-5-mini (OpenAI) | $0.25/$2 | `@qa` |
| `docs_generator` | Documentation (inline + external) | Gemini 3 Flash | ~$0.50/$3 | `@docs_generator` |
| `pickle-think` | Free triage, brainstorming, rough planning | Big Pickle | Free | `@pickle-think` |
| `pickle-implement` | Free low-risk implementation | Big Pickle | Free | `@pickle-implement` |

---

## Model Routing Reference

**The rule:** cheap default build mode for routine implementation, premium models for planning/review and high-stakes engineering, smaller models for structured support work.

| Tier | Model | Cost (per 1M tokens) | Agents |
|------|-------|----------------------|--------|
| **Premium Review** | Gemini 3.1 Pro | $2/$12 | planning-agent, reviewer, security |
| **Premium Builder** | Gemini 3.1 Pro | $2/$12 | engineer |
| **Builder Default** | MiniMax M2.5 Free | Free | default build mode in `opencode.json` |
| **Specialist** | GPT-5 (OpenAI) | $1.25/$10 | coder |
| **Workhorse** | GPT-5-mini (OpenAI) | $0.25/$2 | qa, linear |
| **Frontend** | Kimi K2.5 | $0.60/$3 | frontend |
| **Budget** | Gemini 3 Flash | ~$0.50/$3 | docs_generator |
| **Free** | Big Pickle | Free | pickle-think, pickle-implement |

**Cross-model review rule:** Code written by the default MiniMax M2.5 Free build lane should be reviewed with a different model family, typically Gemini 3.1 Pro. If `@engineer` is also using Gemini 3.1 Pro, avoid same-model self-review.

---

## Agent Details

### 1. Planning Agent (`planning-agent.md`)

**Model:** Gemini 3.1 Pro

**Purpose:** Architecture design, task breakdown, and plan review. Use the same agent for first-pass planning and critic-mode plan review.

**Example Commands:**
```bash
@planning-agent "Design a user authentication system with OAuth2 and JWT"
@planning-agent "Plan the migration from REST to GraphQL for the user service"
@planning-agent "Review ./plan-20260203-auth.md"
```

**Outputs:**
- New plans: `.opencode/plans/plan-YYYYMMDD-{feature}.md`
- Reviews: `.opencode/plans/plan-review-YYYYMMDD-{feature}.md`

### 2. Linear (`linear.md`)

**Model:** GPT-5-mini (OpenAI API)

**Purpose:** Create Linear projects and issues with better structured output than the cheaper routing tier, while still staying in the low-cost bucket.

**Example Commands:**
```bash
@linear "Create project 'Auth System' with issues from ./plan-20260203-auth.md"
@linear "Create issue: Fix login timeout - priority high, label: bug"
```

### 3. Engineer (`engineer.md`)

**Model:** Gemini 3.1 Pro

**Purpose:** Premium implementation agent for ambiguous, risky, or architecture-sensitive work where stronger reasoning is worth the cost. Requires approval before commit-oriented actions.

**Example Commands:**
```bash
@engineer "Implement idempotent payment processing with retry logic"
@engineer "Build the authentication middleware with proper session handling"
```

### 4. Coder (`coder.md`)

**Model:** GPT-5 (OpenAI API)

**Purpose:** Autonomous spec-driven implementation with test-fix loops. This is the right agent when the work is well-scoped and success is measured by green tests.

**Example Commands:**
```bash
@coder "Implement the UserService interface and make all tests in user_test.go pass"
@coder "Refactor the date parser - keep all existing tests green"
```

### 5. Frontend (`frontend.md`)

**Model:** Kimi K2.5

**Purpose:** Cost-optimized UI and component implementation with emphasis on React/TypeScript, responsive behavior, accessibility, and production-ready structure.

**Example Commands:**
```bash
@frontend "Recreate this Figma comp as a React component with Tailwind"
@frontend "Build a responsive dashboard layout with sidebar navigation"
```

### 6. Reviewer (`reviewer.md`)

**Model:** Gemini 3.1 Pro

**Purpose:** Code quality review focused on structure, readability, maintainability, and performance.

**Example Commands:**
```bash
@reviewer "Review ./src/services/payment.ts"
@reviewer "Review ./src/auth/ focusing on performance"
```

**Reports saved to:** `.opencode/reviewer/`

### 7. Security (`security.md`)

**Model:** Gemini 3.1 Pro

**Purpose:** Security review for auth, validation, dependency risk, and common application vulnerabilities.

**Example Commands:**
```bash
@security "Audit ./src/api/ - this is public-facing"
@security "Check ./src/auth/ for authentication vulnerabilities"
```

**Reports saved to:** `.opencode/security/`

### 8. QA (`qa.md`)

**Model:** GPT-5-mini (OpenAI API)

**Purpose:** Test generation and execution across languages, plus BDD / requirements-driven test generation when the user starts from behavior instead of code.

**Example Commands:**
```bash
@qa "Write tests for ./src/utils/dateParser.ts"
@qa "Test ./src/services/payment.ts - happy path + sad path + edge cases"
@qa "Users can only edit their own profile; admins can edit any profile; email changes require reverification"
```

### 9. Docs Generator (`docs_generator.md`)

**Model:** Gemini 3 Flash

**Purpose:** Low-cost documentation generation for inline comments, API docs, and external markdown.

**Example Commands:**
```bash
@docs_generator "Add inline documentation to internal/service/"
@docs_generator "Generate GoDoc for all exported functions in the auth package"
```

### 10. Pickle Think (`pickle-think.md`)

**Model:** Big Pickle

**Purpose:** Cheap triage, brainstorming, rough plans, and first-pass decomposition before deciding whether stronger agents are needed.

**Example Commands:**
```bash
@pickle-think "Sketch the safest way to add a feature flag to the billing flow"
@pickle-think "Read this module and give me a cheap file-by-file plan"
```

### 11. Pickle Implement (`pickle-implement.md`)

**Model:** Big Pickle

**Purpose:** Free low-risk implementation for config changes, boilerplate, tiny refactors, and disposable first-pass code changes.

**Example Commands:**
```bash
@pickle-implement "Rename this env var across the config layer"
@pickle-implement "Add a placeholder endpoint and wire the route"
```

---

## Common Workflows

### New Feature

```bash
1. @pickle-think "Draft a cheap first-pass plan"
2. @planning-agent "Design [feature]"
3. @linear "Create issues from [plan file]"
4. Use default build mode for routine implementation, or `@engineer` when the change is hard or high-risk
5. @qa "Write and run tests for [files]"
6. @reviewer "Review [files]"
7. @security "Audit [scope]"
```

### Plan Review

```bash
1. @planning-agent "Review ./plan-YYYYMMDD-feature.md"
2. Address critical findings
3. Hand off to the default build mode or `@engineer` once approved
```

### Cheap First Pass

```bash
1. @pickle-think "Map the files and suggest the smallest change"
2. @pickle-implement "Make the low-risk edit"
3. Escalate to @qa, @coder, or engineer if the task grows
```

### Spec-Driven Implementation

```bash
1. @qa "Translate these requirements into tests"
2. @coder "Implement the spec and make all tests pass"
3. @reviewer "Review the implementation"
```

### Frontend Feature

```bash
1. @frontend "Build [component/page] from screenshot or description"
2. @qa "Add component tests"
3. @reviewer "Review for accessibility and maintainability"
```

---

## Implementation Agent Comparison

| Criteria | `engineer` | `coder` | `frontend` |
|----------|-----------|---------|-----------|
| **Use when** | Highest-stakes implementation | Spec + tests are clear | UI/component work |
| **Model** | Gemini 3.1 Pro | GPT-5 (OpenAI) | Kimi K2.5 |
| **Cost** | $2/$12 | $2/$8 | $0.60/$3 |
| **Approval** | Requires approval | Autonomous loops | Full access |
| **Best at** | Hard trade-offs, risky implementation | Test-fix cycles | Responsive UI, a11y |

---

## Notes

- The system now uses **11 agents** across **7 models**.
- The default build mode in `opencode.json` now uses `MiniMax M2.5 Free`; `@engineer` remains the premium escalation path on Gemini 3.1 Pro.
- `planning-agent` absorbed plan review.
- `qa` absorbed requirements-driven / BDD test generation.
- `pickle-think` and `pickle-implement` provide a free first-pass lane on Big Pickle.
- Git automation is no longer a dedicated OpenCode agent in this folder; handle commits in your normal toolchain.
