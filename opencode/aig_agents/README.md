---
disable: true
---

# OpenCode AI Agents

A collection of specialized AI subagents for software engineering workflows. Each agent is designed to be invoked independently — you orchestrate them as needed.

All agents route through **OpenCode Zen** models optimized for cost and capability. See [Model Routing](#model-routing-reference) for the full breakdown.

## Quick Reference

| Agent | Purpose | Model | Cost | Invocation |
|-------|---------|-------|------|------------|
| `agent-advisor` | Help choose the right agent | Gemini 3 Flash | Budget | `@agent-advisor` |
| `planning-agent` | Architecture design & task breakdown | Gemini 3.1 Pro | $2/$12 | `@planning-agent` |
| `plan-reviewer` | Review architecture plans | Gemini 3.1 Pro | $2/$12 | `@plan-reviewer` |
| `linear` | Create Linear projects/issues | Gemini 3 Flash | Budget | `@linear` |
| `lead_dev` | Quick orchestrator (auto-commits) | MiniMax M2.5 Free | FREE | `@lead_dev` |
| `engineer` | Senior builder (approval required) | GPT 5.4 | $2.50/$15 | `@engineer` |
| `coder` | Autonomous test-fix loops | GPT 5.3 Codex | $1.75/$14 | `@coder` |
| `frontend` | UI/vision-to-code | Kimi K2.5 | $0.60/$3 | `@frontend` |
| `reviewer` | Code quality review | Gemini 3.1 Pro | $2/$12 | `@reviewer` |
| `security` | Security audit | Gemini 3.1 Pro | $2/$12 | `@security` |
| `qa` | Test generation & execution | GPT 5.3 Codex | $1.75/$14 | `@qa` |
| `test_generator` | BDD/requirements-driven tests | GPT 5.3 Codex | $1.75/$14 | `@test_generator` |
| `docs_generator` | Documentation (inline + external) | Gemini 3 Flash | Budget | `@docs_generator` |
| `commiter` | Git commits with branch protection | MiniMax M2.5 Free | FREE | `@commiter` |

---

## Model Routing Reference

**The rule:** Expensive model for thinking. Cheap model for doing. Free model for grunt work.

| Tier | Model | Cost (per 1M tokens) | Agents |
|------|-------|---------------------|--------|
| **FREE** | MiniMax M2.5 Free | $0 | lead_dev, commiter |
| **Budget** | Gemini 3 Flash | ~$0.50/$3 | docs_generator, linear, agent-advisor |
| **Standard** | GPT 5.4 | $2.50/$15 | engineer |
| **Standard** | GPT 5.3 Codex | $1.75/$14 | coder, qa, test_generator |
| **Standard** | Kimi K2.5 | $0.60/$3 | frontend |
| **Premium** | Gemini 3.1 Pro | $2/$12 | planning-agent, plan-reviewer, reviewer, security |

**Cross-model review rule:** Builder (GPT 5.4) and Reviewer (Gemini 3.1 Pro) always use different models. Never review code with the model that wrote it.

---

## Agent Details

### 0. Agent Advisor (`agent-advisor.md`)

**Purpose:** Meta-agent that helps you choose the right agent for your task. Also routes between OpenCode and Copilot Pro.

**Best For:**
- When you're unsure which agent to use
- Understanding agent capabilities and costs
- Getting workflow recommendations

**Example Commands:**
```bash
@agent-advisor "I need to add user authentication"
@agent-advisor "Should I use reviewer or security for this code?"
@agent-advisor "I'm building a payment system, what's the process?"
```

---

### 1. Planning Agent (`planning-agent.md`)

**Model:** Gemini 3.1 Pro (1M context, best price-to-performance planner)

**Purpose:** Design system architecture, create flow diagrams, break down features into tasks.

**Best For:**
- Starting a new feature
- Designing system architecture
- Breaking down complex requirements

**Example Commands:**
```bash
@planning-agent "Design a user authentication system with OAuth2 and JWT"
@planning-agent "Plan the migration from REST to GraphQL for the user service"
```

**Expected Output:** `.opencode/plans/plan-YYYYMMDD-{feature}.md` with architecture diagrams, file structure, implementation steps, risks.

---

### 2. Plan Reviewer (`plan-reviewer.md`)

**Model:** Gemini 3.1 Pro

**Purpose:** Critically review architecture plans, identify gaps, suggest improvements.

**Example Commands:**
```bash
@plan-reviewer "Review ./plan-20260203-auth.md"
@plan-reviewer "Review the payment integration plan - we expect 10k transactions/day"
```

---

### 3. Linear Agent (`linear.md`)

**Model:** Gemini 3 Flash (budget tier)

**Purpose:** Create Linear projects and issues via MCP integration.

**Example Commands:**
```bash
@linear "Create project 'Auth System' with issues from ./plan-20260203-auth.md"
@linear "Create issue: Fix login timeout - priority high, label: bug"
```

---

### 4. Lead Developer (`lead_dev.md`)

**Model:** MiniMax M2.5 Free (FREE)

**Purpose:** Lightweight orchestrator for quick, low-risk feature work. Auto-commits after QA + review pass.

**Best For:**
- Quick, clear-scope tasks where auto-commit is fine
- Trivial changes, config updates, error message fixes

**Example Commands:**
```bash
@lead_dev "Add a config flag for dark mode"
@lead_dev "Fix the typo in the API response field"
```

---

### 5. Engineer (`engineer.md`)

**Model:** GPT 5.4 (default builder — fast iteration, idiomatic Go/TS)

**Purpose:** Senior implementation engineer. Plans, codes, delegates testing and review, requires explicit approval before commits.

**Best For:**
- Complex, security-sensitive, or high-risk work
- Tasks requiring design decisions and trade-off analysis
- When you want approval before anything is committed

**Example Commands:**
```bash
@engineer "Implement idempotent payment processing with retry logic"
@engineer "Build the authentication middleware with proper session handling"
```

---

### 6. Coder (`coder.md`)

**Model:** GPT 5.3 Codex (RL-trained for agentic coding — precise, spec-driven)

**Purpose:** Autonomous test-fix agent. Give it a spec and tests, it loops until green. No human intervention between iterations.

**Best For:**
- Well-defined tasks with existing tests
- "Implement this and make all tests pass" scenarios
- Autonomous implement → test → fix → repeat cycles

**Example Commands:**
```bash
@coder "Implement the UserService interface and make all tests in user_test.go pass"
@coder "Refactor the date parser — keep all existing tests green"
```

**Key Difference from Engineer:** Coder is autonomous and spec-driven. Engineer requires approval and handles ambiguity. Use Coder when tests are clear. Use Engineer when you're still figuring out the approach.

---

### 7. Frontend Developer (`frontend.md`)

**Model:** Kimi K2.5 (vision-to-code specialist)

**Purpose:** UI implementation from screenshots, mockups, or descriptions. Builds responsive, accessible components.

**Best For:**
- Screenshot/mockup to code
- React/Vue/Svelte component development
- Responsive design and accessibility

**Example Commands:**
```bash
@frontend "Recreate this Figma comp as a React component with Tailwind"
@frontend "Build a responsive dashboard layout with sidebar navigation"
@frontend "Convert this screenshot to a styled landing page"
```

---

### 8. Code Reviewer (`reviewer.md`)

**Model:** Gemini 3.1 Pro (different model from builder — cross-model review)

**Purpose:** Review code for quality, performance, and clean code standards.

**Example Commands:**
```bash
@reviewer "Review ./src/services/payment.ts"
@reviewer "Review ./src/auth/ focusing on performance"
```

**Reports saved to:** `.opencode/reviewer/`

---

### 9. Security Auditor (`security.md`)

**Model:** Gemini 3.1 Pro

**Purpose:** Audit code for security vulnerabilities. Supports Go, Python, TypeScript/JavaScript, .NET.

**Example Commands:**
```bash
@security "Audit ./src/api/ - this is public-facing"
@security "Check ./src/auth/ for authentication vulnerabilities"
```

**Reports saved to:** `.opencode/security/`

---

### 10. QA Automation (`qa.md`)

**Model:** GPT 5.3 Codex (optimized for test-fix loops)

**Purpose:** Generate and execute tests. Supports Jest, Vitest, Pytest, go test, xUnit, NUnit.

**Example Commands:**
```bash
@qa "Write tests for ./src/utils/dateParser.ts"
@qa "Test ./src/services/payment.ts - happy path + sad path + edge cases"
```

---

### 11. Test Generator (`test_generator.md`)

**Model:** GPT 5.3 Codex

**Purpose:** BDD/requirements-driven test generation from natural language.

**Example Commands:**
```bash
@test_generator "Generate tests for a function that validates credit card numbers"
```

---

### 12. Documentation Generator (`docs_generator.md`)

**Model:** Gemini 3 Flash (budget — docs are cheap work)

**Purpose:** Add inline documentation or generate external docs.

**Example Commands:**
```bash
@docs_generator "Add logic comments to ./src/services/billing.ts"
@docs_generator "mode=external source=./src/auth target=./docs/auth"
```

---

### 13. Git Committer (`commiter.md`)

**Model:** MiniMax M2.5 Free (FREE — git ops don't need expensive models)

**Purpose:** Manage git commits with branch protection and semantic messages.

**Example Commands:**
```bash
@commiter "Commit the authentication changes"
@commiter "Commit all changes for the payment refactor"
```

---

## Implementation Agent Comparison

| Criteria | `lead_dev` | `engineer` | `coder` | `frontend` |
|----------|-----------|-----------|---------|-----------|
| **Use when** | Quick, trivial, low-risk | Complex, needs approval | Spec + tests are clear | UI/visual work |
| **Model** | MiniMax Free | GPT 5.4 | GPT 5.3 Codex | Kimi K2.5 |
| **Cost** | FREE | $2.50/$15 | $1.75/$14 | $0.60/$3 |
| **Approval** | Auto-commits | Requires approval | Autonomous loops | Full access |
| **Pre-flight** | None | Asks clarifying questions | Asks for spec + tests | Asks for framework |
| **Best at** | Config changes, typos | Design decisions, trade-offs | Test-fix cycles | Vision-to-code |
| **Analogy** | "Just do it" | "Let's think this through" | "Give me the spec, I'll ship it" | "Show me the design" |

---

## Common Workflows

### Feature Development Flow
```bash
1. @planning-agent "Design user notification system"
2. @plan-reviewer "Review ./plan-20260203-notifications.md"
3. @linear "Create issues from plan"
4. @engineer "Implement notification service"
5. @qa "Write tests for notification service"
6. @reviewer "Review notification service"
7. @commiter "Commit notification service"
```

### Spec-Driven Implementation
```bash
1. @coder "Implement UserService - make all tests in user_test.go pass"
# Coder loops autonomously until green, then reports
```

### Frontend Build
```bash
1. @frontend "Build dashboard from screenshot"
2. @reviewer "Review for accessibility and performance"
```

### Quick Code Review
```bash
@reviewer "./src/newFeature.ts"
@security "./src/newFeature.ts"
```

### Bug Fix Flow
```bash
1. @qa "Write test that reproduces bug #123"
2. @coder "Fix the code to make the test pass"
3. @security "Check the fix"
4. @commiter "Fix: resolve race condition in session handler"
```

---

## Configuration

All agents are configured as OpenCode subagents. Source of truth: `devkit/opencode/aig_agents/`.

Symlinked to `~/.config/opencode/agents/` via `scripts/opencode-setup.sh`.

### Agent Settings

| Setting | Description |
|---------|-------------|
| `mode: subagent` | Runs as invokable subagent via `@agent-name` |
| `mode: primary` | Runs as primary agent (Tab to switch) |
| `model` | OpenCode Zen model to use |
| `temperature` | Creativity vs determinism (lower = more deterministic) |
| `tools` | Available tools (read, write, edit, bash) |

### Customization

To modify an agent's behavior, edit its `.md` file in `opencode/aig_agents/`. Key sections:
- **Clarification Protocol** — Questions the agent asks before acting
- **Standards/Checks** — What the agent evaluates
- **Output Format** — How results are presented

---

## Best Practices

1. **Not sure which agent?** Start with `@agent-advisor`
2. **Always let agents ask clarifying questions** — they're designed to gather context first
3. **Cross-model review** — Builder and Reviewer are different models by design
4. **Cost-conscious** — Use FREE agents for trivial work, save Zen credits for reasoning
5. **Chain agents for comprehensive review:** `@reviewer` then `@security` then `@qa`
6. **Trust but verify** — Agents may have false positives; review their findings
