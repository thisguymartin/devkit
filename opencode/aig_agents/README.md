# OpenCode AI Agents

A collection of specialized AI agents for software engineering workflows, configured for the **OpenCode + Copilot Pro** dual-tool strategy. Each agent is designed to be invoked independently — you orchestrate them as needed.

## Model Routing Strategy

**Expensive model for thinking. Cheap model for doing. Free model for grunt work. Copilot for everything small.**

| Layer | Model Tier | Models | Cost |
|-------|-----------|--------|------|
| **Thinking** | Gemini 3.1 Pro | architect, reviewer, plan-reviewer, security, agent-advisor | $2 / $12 per 1M |
| **Doing** | GPT 5.4 | engineer, lead_dev | $2.50 / $15 per 1M |
| **Autonomous** | GPT 5.3 Codex | coder | $1.75 / $14 per 1M |
| **Budget** | GLM 5 | budget-builder | $1 / $3.20 per 1M |
| **Frontend** | Kimi K2.5 | frontend | $0.60 / $3 per 1M |
| **Utility** | Gemini 3 Flash | qa, test_generator, documenter, linear | $0.50 / $3 per 1M |
| **Minimal** | GPT 5.4 Nano | commiter | $0.20 / $1.25 per 1M |

### Cross-Model Review Rule

**Never review code with the same model that wrote it.** Builder agents (GPT 5.4/Codex) are always reviewed by Gemini 3.1 Pro agents. Blind spots compound when the same model reviews its own output.

### Copilot Pro Integration

Before reaching for OpenCode, check if Copilot handles it:
- **Tab completions** → Copilot Inline (unlimited, always on in Neovim)
- **Quick questions** → Copilot Chat (300 free premium reqs/mo)
- **PR review** → Assign Copilot as reviewer (free)
- **CLI tasks** → Copilot CLI: Explore (codebase Q&A), Task (run tests/builds)

---

## Quick Reference

| Agent | Purpose | Model | Invocation |
|-------|---------|-------|------------|
| `agent-advisor` | Task routing & agent selection | Gemini 3.1 Pro | `@agent-advisor` |
| `architect` | System design & architecture | Gemini 3.1 Pro | `@architect` |
| `plan-reviewer` | Review architecture plans | Gemini 3.1 Pro | `@plan-reviewer` |
| `linear` | Linear project/issue management | Gemini 3 Flash | `@linear` |
| `engineer` | Complex, high-risk implementation | GPT 5.4 | `@engineer` |
| `lead_dev` | Quick, low-risk implementation | GPT 5.4 | `@lead_dev` |
| `coder` | Autonomous test-fix loops | GPT 5.3 Codex | `@coder` |
| `budget-builder` | Cost-efficient implementation | GLM 5 | `@budget-builder` |
| `frontend` | UI/vision-to-code specialist | Kimi K2.5 | `@frontend` |
| `reviewer` | Code quality review | Gemini 3.1 Pro | `@reviewer` |
| `security` | Security audit | Gemini 3.1 Pro | `@security` |
| `qa` | Test generation & execution | Gemini 3 Flash | `@qa` |
| `test_generator` | BDD test generation | Gemini 3 Flash | `@test_generator` |
| `documenter` | Documentation (inline + external) | Gemini 3 Flash | `@documenter` |
| `commiter` | Git commits with branch protection | GPT 5.4 Nano | `@commiter` |

---

## Agent Details

### 0. Agent Advisor (`agent-advisor.md`)

**Purpose:** Meta-agent that helps you choose the right agent for your task. Includes model routing guidance and Copilot Pro integration.

**Best For:**
- When you're unsure which agent to use
- Understanding the cost implications of different agents
- Getting workflow recommendations

**Example:**
```bash
@agent-advisor "I need to add user authentication"
```

---

### 1. Architect (`architect.md`)

**Purpose:** Design system architecture, create flow diagrams, break down features into tasks.

**Model:** Gemini 3.1 Pro (1M context, read-only)

**Best For:**
- Starting a new feature
- System architecture design
- Migration planning
- Complex requirements breakdown

**Example:**
```bash
@architect "Design a user authentication system with OAuth2 and JWT"
```

**Output:** `.opencode/plans/plan-YYYYMMDD-{feature}.md`

---

### 2. Plan Reviewer (`plan-reviewer.md`)

**Purpose:** Critically review architecture plans, identify gaps, suggest improvements.

**Model:** Gemini 3.1 Pro

**Example:**
```bash
@plan-reviewer "Review ./plan-20260203-auth.md"
```

---

### 3. Linear Agent (`linear.md`)

**Purpose:** Create Linear projects and issues via MCP integration.

**Requires:** Linear MCP server configured in `opencode.json`

**Example:**
```bash
@linear "Create project 'Auth System' with issues from ./plan-20260203-auth.md"
```

---

### 4. Engineer (`engineer.md`)

**Purpose:** Senior orchestrator for complex, security-sensitive, or high-risk work. Follows rigorous engineering principles. Requires explicit user approval before every commit.

**Model:** GPT 5.4 (1M context, full access)

**Best For:**
- Payment flows, auth systems, data integrity
- Complex multi-file refactors
- Tasks requiring careful trade-off analysis

**Example:**
```bash
@engineer "Implement idempotent payment processing with retry logic"
```

**Workflow:** Pre-Flight → Discovery → Implementation → QA → Review → **Approval** → Commit

---

### 5. Lead Developer (`lead_dev.md`)

**Purpose:** Lightweight orchestrator for quick, low-risk features. Auto-commits after QA and review pass.

**Model:** GPT 5.4 (full access)

**Best For:**
- Config flags, error messages, small features
- Clear-scope tasks where auto-commit is fine

**Example:**
```bash
@lead_dev "Add a config flag for dark mode"
```

**Workflow:** Discovery → Implementation → QA → Review → **Auto-Commit**

---

### 6. Coder (`coder.md`)

**Purpose:** Autonomous implementation agent for spec-driven test-fix loops. Given a spec and tests, iterates until all tests pass.

**Model:** GPT 5.3 Codex (RL-trained for agentic coding)

**Best For:**
- "Implement this spec and make all tests pass"
- Refactoring with existing test coverage
- Well-defined tasks with clear acceptance criteria

**Example:**
```bash
@coder "Implement the DynamoDB query handler per the spec in ./docs/spec.md"
```

**Distinct from Engineer:** Coder executes defined specs. Engineer explores problems.

---

### 7. Budget Builder (`budget-builder.md`)

**Purpose:** Cost-efficient implementation at ~80% of premium model quality and ~30% of the cost.

**Model:** GLM 5 ($1/$3.20, 200K context)

**Best For:**
- Well-defined tasks when saving tokens matters
- Bulk implementation work
- Following established codebase patterns

**Example:**
```bash
@budget-builder "Add CRUD endpoints for the settings module"
```

**Escalation:** Will recommend `@engineer` if the task is too complex.

---

### 8. Frontend (`frontend.md`)

**Purpose:** UI and frontend specialist with vision-to-code capabilities.

**Model:** Kimi K2.5 ($0.60/$3, 256K context)

**Best For:**
- Figma/screenshot to React code
- UI redesigns, marketing sites
- Component implementation with responsive design

**Example:**
```bash
@frontend "Recreate this design as a React component with Tailwind" [attach screenshot]
```

---

### 9. Code Reviewer (`reviewer.md`)

**Purpose:** Review code for quality, performance, and clean code standards.

**Model:** Gemini 3.1 Pro (read-only — cross-model with GPT 5.4 builders)

**Example:**
```bash
@reviewer "Review ./src/services/payment.ts"
```

**Output:** `.opencode/reviewer/review-YYYYMMDD-{name}.md`

---

### 10. Security Auditor (`security.md`)

**Purpose:** Audit code for security vulnerabilities.

**Model:** Gemini 3.1 Pro (read-only — cross-model with builders)

**Supports:** Go, Python, TypeScript/JavaScript, .NET

**Example:**
```bash
@security "Audit ./src/api/ - this is public-facing"
```

**Output:** `.opencode/security/audit-YYYYMMDD-{scope}.md`

---

### 11. QA Automation (`qa.md`)

**Purpose:** Generate and execute tests.

**Model:** Gemini 3 Flash

**Supports:** Jest, Vitest, Pytest, go test, xUnit, NUnit

**Example:**
```bash
@qa "Write tests for ./src/utils/dateParser.ts - comprehensive"
```

---

### 12. Test Generator (`test_generator.md`)

**Purpose:** BDD test generation from requirements and user stories.

**Model:** Gemini 3 Flash

**Example:**
```bash
@test_generator "Generate tests for a function that validates credit card numbers"
```

---

### 13. Documenter (`documenter.md`)

**Purpose:** Add inline documentation or generate external docs.

**Model:** Gemini 3 Flash

**Modes:** inline (comments) or external (markdown docs)

**Example:**
```bash
@documenter "Add logic comments to ./src/services/billing.ts"
@documenter "mode=external source=./src/auth target=./docs/auth"
```

---

### 14. Git Commiter (`commiter.md`)

**Purpose:** Manage git commits with branch protection and semantic messages.

**Model:** GPT 5.4 Nano (cheapest — commits are trivial work)

**Example:**
```bash
@commiter "Commit the authentication changes"
```

---

## Choosing an Agent: Quick Comparison

### Builder Agents

| Agent | Model | Cost | Use When |
|-------|-------|------|----------|
| `engineer` | GPT 5.4 | $$$ | Complex, risky, needs approval |
| `lead_dev` | GPT 5.4 | $$$ | Simple, low-risk, auto-commit OK |
| `coder` | GPT 5.3 Codex | $$ | Spec + tests exist, autonomous |
| `budget-builder` | GLM 5 | $ | Well-defined, saving tokens |
| `frontend` | Kimi K2.5 | $ | UI/design-to-code |

### Thinking Agents

| Agent | Model | Cost | Use When |
|-------|-------|------|----------|
| `architect` | Gemini 3.1 Pro | $$ | System design, planning |
| `plan-reviewer` | Gemini 3.1 Pro | $$ | Validate plans |
| `reviewer` | Gemini 3.1 Pro | $$ | Code quality review |
| `security` | Gemini 3.1 Pro | $$ | Security audit |

---

## Common Workflows

### Feature Development Flow

```bash
# 1. Plan the feature
@architect "Design user notification system with email and push"

# 2. Review the plan
@plan-reviewer "Review ./plan-20260203-notifications.md"

# 3. Create Linear issues
@linear "Create issues from ./plan-20260203-notifications.md"

# 4. Implement
@engineer "Implement notification service"  # or @lead_dev for simple features

# 5. Test
@qa "Write tests for ./src/services/notification.ts - comprehensive"

# 6. Review + Security
@reviewer "Review ./src/services/notification.ts"
@security "Audit ./src/services/notification.ts"

# 7. Document + Commit
@documenter "Document ./src/services/notification.ts inline"
@commiter "Commit notification service implementation"
```

### Autonomous Implementation (spec exists)

```bash
@coder "Implement the query handler per spec, make all tests pass"
@reviewer "Review the changes"
@commiter "Commit"
```

### Budget Workflow

```bash
@budget-builder "Add CRUD endpoints following existing patterns"
```

### Quick Code Review

```bash
@reviewer "./src/newFeature.ts"
@security "./src/newFeature.ts"
```

### Bug Fix

```bash
@qa "Write test that reproduces bug #123"
@lead_dev "Fix the bug"
@qa "Verify fix"
@commiter "Fix: [description]"
```

---

## Configuration

### Agent Files
All agents are markdown files with YAML frontmatter in `opencode/aig_agents/`. Filename becomes the agent name, invoked with `@filename`.

### Global Config
`opencode.json` at project root configures:
- Default models
- MCP servers (GitHub, Context7, Linear, Filesystem, Database)
- Plugins (tokenscope for cost tracking)

### Customization
Edit the `.md` file to modify an agent's behavior. Key sections:
- **Clarification Protocol** — Questions the agent asks before acting
- **Standards/Checks** — What the agent evaluates
- **Output Format** — How results are presented

---

## Troubleshooting

### Not sure which agent?
Use `@agent-advisor` — it asks about your task and recommends the right agent(s).

### Quick question or small task?
Use **Copilot Chat** instead of burning Zen credits.

### Agent not responding to clarification?
Answer all questions before expecting output.

### Linear agent fails?
Verify Linear MCP server is configured in `opencode.json` and `LINEAR_API_KEY` is set.

### Token costs too high?
Switch to `@budget-builder` (GLM 5) for routine work, or use free models for tests/docs.

### Code review found same issues as last time?
Check that the builder model differs from the reviewer model (cross-model review rule).
