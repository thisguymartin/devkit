---
disable: true
---

# OpenCode AI Agents

A consolidated 14-agent OpenCode setup tuned around current model strengths with a split between cheap MiniMax defaults, GPT/Codex execution lanes, and Gemini deep engineering. The routing goal is simple: keep the cheap MiniMax lanes for low-cost support work, use dedicated GPT/Codex lanes when you want stronger execution, use Gemini 3.1 Pro when the hard part is architectural judgment, and keep implementation/review on different model families where possible.

## Quick Reference

| Agent | Purpose | Model | Cost (per 1M in/out) | Invocation |
|-------|---------|-------|----------------------|------------|
| `planning-agent` | Architecture design, task breakdown, plan review | Gemini 3.1 Pro | $2/$12 | `@planning-agent` |
| `linear` | Create Linear projects/issues | MiniMax M2.5 | ~$0.20-$3 | `@linear` |
| `engineer` | OpenAI execution engineer | GPT 5.3 Codex | $1.75/$14 | `@engineer` |
| `shipwright` | Unique primary Codex build lane | GPT 5.3 Codex | $1.75/$14 | `@shipwright` |
| `principal-engineer` | Deep engineering thinking, architecture, technical direction | Gemini 3.1 Pro | $2/$12 | `@principal-engineer` |
| `coder` | Autonomous test-fix loops | GPT 5.3 Codex | $1.75/$14 | `@coder` |
| `frontend` | UI/component development | Kimi K2.5 | $0.60/$3 | `@frontend` |
| `reviewer` | Code quality review | GPT 5.4 Mini | $0.75/$4.50 | `@reviewer` |
| `senior-reviewer` | GPT-family backup review lane | GPT-5 mini | $0.25/$2 | `@senior-reviewer` |
| `security` | Security audit | Gemini 3.1 Pro | $2/$12 | `@security` |
| `qa` | Test generation, execution, BDD | GPT 5.4 Mini | $0.75/$4.50 | `@qa` |
| `docs_generator` | Documentation (inline + external) | MiniMax M2.5 Free | $0 | `@docs_generator` |
| `pickle-think` | Free triage, brainstorming, rough planning | Big Pickle | Free | `@pickle-think` |
| `pickle-implement` | Free low-risk implementation | Big Pickle | Free | `@pickle-implement` |

---

## Model Routing Reference

**The rule:** OpenAI-first for execution, Gemini-first for deep engineering judgment, and different model families for implementation vs review whenever possible.

| Tier | Model | Cost (per 1M tokens) | Agents |
|------|-------|----------------------|--------|
| **Premium Review** | Gemini 3.1 Pro | $2/$12 | planning-agent, security |
| **Premium Builder** | Gemini 3.1 Pro | $2/$12 | principal-engineer |
| **Builder Default** | MiniMax M2.5 | ~$0.20-$3 | default build mode in `opencode.json`, linear |
| **Specialist** | GPT 5.3 Codex | $1.75/$14 | coder, engineer |
| **Workhorse** | GPT 5.4 Mini | $0.75/$4.50 | reviewer, qa |
| **Backup Review** | GPT-5 mini | $0.25/$2 | senior-reviewer |
| **Frontend** | Kimi K2.5 | $0.60/$3 | frontend |
| **Budget** | MiniMax M2.5 | ~$0.20-$3 | linear |
| **Free** | MiniMax M2.5 Free, Big Pickle | $0 | docs_generator, pickle-think, pickle-implement |

**Cross-model review rule:** Code written by the default MiniMax build lane should be reviewed with a different model family when the work matters. Code written by Codex lanes should usually be reviewed with GPT 5.4 Mini. If Gemini 3.1 Pro writes or heavily reshapes the implementation, prefer `@reviewer` or `@senior-reviewer` for the second pass instead of same-model self-review.

## Recommended Routing

- `@pickle-think` -> cheap triage, rough brainstorming, disposable first pass
- `@planning-agent` -> architecture, system design, and decision-heavy planning
- `@principal-engineer` -> deep engineering thinking, major tradeoffs, migrations, and technical direction
- default `build` mode -> cheap routine implementation on MiniMax M2.5
- `@shipwright` -> named Codex primary when you want the stronger build lane
- `@coder` / `@engineer` -> specialist execution lanes when you want a narrower workflow
- `@qa` -> test generation and execution
- `@reviewer` -> fresh second-pass review
- `@senior-reviewer` -> GPT-family backup review lane
- `@security` -> auth, secrets, public API, and user-input risk

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

**Model:** MiniMax M2.5

**Purpose:** Create Linear projects and issues with better structured output than the cheaper routing tier, while still staying in the low-cost bucket.

**Example Commands:**
```bash
@linear "Create project 'Auth System' with issues from ./plan-20260203-auth.md"
@linear "Create issue: Fix login timeout - priority high, label: bug"
```

### 3. Engineer (`engineer.md`)

**Model:** GPT 5.3 Codex

**Purpose:** Execution-first implementation agent. Use this when the job is to take a concrete assignment, run the loop, make the change, verify it, and hand it back cleanly.

**Example Commands:**
```bash
@engineer "Implement idempotent payment processing with retry logic"
@engineer "Build the authentication middleware with proper session handling"
```

### 4. Shipwright (`shipwright.md`)

**Model:** GPT 5.3 Codex

**Purpose:** Distinct primary Codex build lane for end-to-end execution when you want a named builder without changing the cheaper MiniMax support lanes.

**Example Commands:**
```bash
@shipwright "Implement the retry queue and make the tests pass"
@shipwright "Refactor the auth middleware and verify the regression suite"
```

### 5. Principal Engineer (`principal-engineer.md`)

**Model:** Gemini 3.1 Pro

**Purpose:** Deep engineering thinking, architecture-heavy tradeoffs, migration strategy, and technical direction when the hard part is choosing the right design, not just executing it.

**Example Commands:**
```bash
@principal-engineer "Design the migration from single-tenant to multi-tenant billing"
@principal-engineer "Figure out the safest architecture for background job retries and idempotency"
```

### 6. Coder (`coder.md`)

**Model:** GPT 5.3 Codex

**Purpose:** Autonomous spec-driven implementation with test-fix loops. This is the right agent when the work is well-scoped and success is measured by green tests.

**Example Commands:**
```bash
@coder "Implement the UserService interface and make all tests in user_test.go pass"
@coder "Refactor the date parser - keep all existing tests green"
```

### 7. Frontend (`frontend.md`)

**Model:** Kimi K2.5

**Purpose:** Cost-optimized UI and component implementation with emphasis on React/TypeScript, responsive behavior, accessibility, and production-ready structure.

**Example Commands:**
```bash
@frontend "Recreate this Figma comp as a React component with Tailwind"
@frontend "Build a responsive dashboard layout with sidebar navigation"
```

### 8. Reviewer (`reviewer.md`)

**Model:** GPT 5.4 Mini

**Purpose:** Code quality review focused on structure, readability, maintainability, and performance. This is the default fresh second-pass reviewer for Codex-built work.

**Example Commands:**
```bash
@reviewer "Review ./src/services/payment.ts"
@reviewer "Review ./src/auth/ focusing on performance"
```

**Reports saved to:** `.opencode/reviewer/`

### 9. Senior Reviewer (`senior-reviewer.md`)

**Model:** GPT-5 mini

**Purpose:** Backup review lane when you want a fresh GPT-family pass instead of the default reviewer.

**Example Commands:**
```bash
@senior-reviewer "Review ./src/services/payment.ts"
@senior-reviewer "Review ./src/auth/ for correctness and maintainability"
```

### 10. Security (`security.md`)

**Model:** Gemini 3.1 Pro

**Purpose:** Security review for auth, validation, dependency risk, and common application vulnerabilities.

**Example Commands:**
```bash
@security "Audit ./src/api/ - this is public-facing"
@security "Check ./src/auth/ for authentication vulnerabilities"
```

**Reports saved to:** `.opencode/security/`

### 11. QA (`qa.md`)

**Model:** GPT 5.4 Mini

**Purpose:** Test generation and execution across languages, plus BDD / requirements-driven test generation when the user starts from behavior instead of code.

**Example Commands:**
```bash
@qa "Write tests for ./src/utils/dateParser.ts"
@qa "Test ./src/services/payment.ts - happy path + sad path + edge cases"
@qa "Users can only edit their own profile; admins can edit any profile; email changes require reverification"
```

### 12. Docs Generator (`docs_generator.md`)

**Model:** MiniMax M2.5 Free

**Purpose:** Low-cost documentation generation for inline comments, API docs, and external markdown.

**Example Commands:**
```bash
@docs_generator "Add inline documentation to internal/service/"
@docs_generator "Generate GoDoc for all exported functions in the auth package"
```

### 13. Pickle Think (`pickle-think.md`)

**Model:** Big Pickle

**Purpose:** Cheap triage, brainstorming, rough plans, and first-pass decomposition before deciding whether stronger agents are needed.

**Example Commands:**
```bash
@pickle-think "Sketch the safest way to add a feature flag to the billing flow"
@pickle-think "Read this module and give me a cheap file-by-file plan"
```

### 14. Pickle Implement (`pickle-implement.md`)

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
4. Use default build mode for the cheap MiniMax path, or `@shipwright` for the stronger Codex path
5. Escalate to `@principal-engineer` when architecture or risk decisions dominate the task
6. Use `@coder` or `@engineer` when you want a narrower execution workflow
7. `@qa` "Write and run tests for [files]"
8. `@reviewer` or `@senior-reviewer` "Review [files]"
9. `@security` "Audit [scope]"
```

### Plan Review

```bash
1. @planning-agent "Review ./plan-YYYYMMDD-feature.md"
2. Address critical findings
3. Hand off to the default build mode, `@shipwright`, `@coder`, or `@engineer` once approved
```

### Cheap First Pass

```bash
1. @pickle-think "Map the files and suggest the smallest change"
2. @pickle-implement "Make the low-risk edit"
3. Escalate to `@qa`, `@shipwright`, `@coder`, `@engineer`, or `@principal-engineer` if the task grows
```

### Spec-Driven Implementation

```bash
1. @qa "Translate these requirements into tests"
2. @coder "Implement the spec and make all tests pass"
3. @reviewer "Review the implementation"
```

### Frontend Feature

```bash
1. @frontend "Build [component/page] from screenshot or description when the work is screenshot-driven or visually heavy"
2. @qa "Add component tests"
3. @reviewer "Review for accessibility and maintainability"
```

---

## Implementation Agent Comparison

| Criteria | `engineer` | `principal-engineer` | `coder` |
|----------|-----------|---------|-----------|
| **Use when** | Execute the job | Resolve the hard design call | Spec + tests are clear |
| **Model** | GPT 5.3 Codex | Gemini 3.1 Pro | GPT 5.3 Codex |
| **Cost** | $1.75/$14 | $2/$12 | $1.75/$14 |
| **Approval** | Full execution lane | Higher-cost thinking lane | Autonomous loops |
| **Best at** | Implement, verify, close the loop | Trade-offs, migrations, architecture | Test-fix cycles |

---

## Notes

- The system now uses **14 agents** across **8 models**.
- The default build mode in `opencode.json` uses `MiniMax M2.5`; `@shipwright` is the distinct primary Codex build lane; `@engineer` remains an execution-oriented Codex specialist; `@principal-engineer` is the Gemini 3.1 Pro deep-thinking lane.
- `@reviewer` remains the default second-pass reviewer on GPT 5.4 Mini; `@senior-reviewer` is the newer GPT-family backup review lane on GPT-5 mini.
- `@linear` is the low-cost project-management lane on MiniMax M2.5.
- `@docs_generator` is the free documentation lane on MiniMax M2.5 Free.
- `planning-agent` absorbed plan review.
- `qa` absorbed requirements-driven / BDD test generation.
- `pickle-think` and `pickle-implement` provide a free first-pass lane on Big Pickle.
- Git automation is no longer a dedicated OpenCode agent in this folder; handle commits in your normal toolchain.
