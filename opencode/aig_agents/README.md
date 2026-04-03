# OpenCode AI Agents

A collection of specialized AI subagents for software engineering workflows with model routing optimized for OpenCode Zen + Copilot Pro ($100/mo budget).

**The One Rule:** Expensive model for thinking. Cheap model for doing. Free model for grunt work. Copilot for everything small.

## Model Routing Strategy

| Layer | Models | Cost | Purpose |
|-------|--------|------|---------|
| **Think (Plan Mode)** | Gemini 3.1 Pro | $2/$12 per 1M | Architecture, debugging, analysis, review |
| **Do (Build Mode)** | GPT 5.4 / GPT 5.3 Codex | $2.50/$15 / $1.75/$14 | Implementation, iteration, test-fix loops |
| **Budget Build** | GLM 5 / Kimi K2.5 | $1/$3.20 / $0.60/$3 | Simple tasks, frontend, save tokens |
| **Grunt Work** | MiniMax M2.5 Free / Qwen3.6+ | FREE | Tests, docs, boilerplate |
| **Trivial** | GPT 5.4 Nano | $0.20/$1.25 | Git ops, trivial completions |
| **Lightweight** | Copilot Pro | $0 (included) | Inline completions, quick chat, PR review |

**Cross-Model Review Rule:** Never review code with the same model that wrote it.

## Quick Reference

| Agent | Purpose | Model | Cost Tier | Invocation |
|-------|---------|-------|-----------|------------|
| `agent-advisor` | Help choose the right agent | GPT 5.4 Mini | Lightweight | `@agent-advisor` |
| **Think Mode (Planning)** | | | | |
| `architect` | Systems architecture & design | Gemini 3.1 Pro | Think | `@architect` |
| `planning-agent` | Architecture & task breakdown | Gemini 3.1 Pro | Think | `@planning-agent` |
| `plan-reviewer` | Review architecture plans | GPT 5.4 | Cross-model | `@plan-reviewer` |
| **Build Mode (Implementation)** | | | | |
| `builder` | Default implementation (Go/TS) | GPT 5.4 | Do | `@builder` |
| `coder` | Autonomous test-fix loops | GPT 5.3 Codex | Do | `@coder` |
| `frontend` | UI & vision-to-code | Kimi K2.5 | Budget | `@frontend` |
| `budget-builder` | Cost-effective implementation | GLM 5 | Budget | `@budget-builder` |
| `engineer` | Senior orchestrator (approval req) | GPT 5.4 | Do | `@engineer` |
| `lead_dev` | Lightweight orchestrator (auto) | GPT 5.4 Mini | Lightweight | `@lead_dev` |
| **Quality & Review** | | | | |
| `reviewer` | Code quality review | Gemini 3.1 Pro | Think | `@reviewer` |
| `security` | Security audit | Gemini 3.1 Pro | Think | `@security` |
| **Testing (Free)** | | | | |
| `qa` | Test generation & execution | MiniMax M2.5 Free | Free | `@qa` |
| `test_generator` | BDD test generation | MiniMax M2.5 Free | Free | `@test_generator` |
| **Docs & Ops** | | | | |
| `docs_generator` | Documentation | Gemini 3 Flash | Bulk | `@docs_generator` |
| `linear` | Linear issue management | GPT 5.4 Mini | Lightweight | `@linear` |
| `commiter` | Git commits | GPT 5.4 Nano | Trivial | `@commiter` |
| `security` | Security audit | `@security` |
| `qa` | Test generation & execution | `@qa` |
| `test_generator` | BDD/Requirements-driven test generation | `@test_generator` |
| `docs_generator` | Documentation (inline + external) | `@docs_generator` |
| `commiter` | Git commits with branch protection | `@commiter` |

---

## Agent Details

### 0. Agent Advisor (`agent-advisor.md`)

**Purpose:** Meta-agent that helps you choose the right agent for your task. Asks clarifying questions and provides clear recommendations with example commands.

**Best For:**
- When you're unsure which agent to use
- Understanding agent capabilities
- Getting workflow recommendations
- Learning the agent ecosystem

**Example Commands:**

```bash
# Get help choosing an agent
@agent-advisor "I need to add user authentication"

# Understand which agent for review
@agent-advisor "Should I use reviewer or security for this code?"

# Get workflow recommendations
@agent-advisor "I'm building a payment system, what's the process?"
```

**How It Works:**
1. You describe your task
2. Agent asks clarifying questions (scope, complexity, risk, approval preference)
3. Agent recommends the best agent(s) with reasoning
4. Agent provides example commands and workflow

**Expected Output:**
- Primary agent recommendation with rationale
- Example command to run
- Multi-agent workflow if needed
- Alternative approaches if applicable

**Example Interaction:**
```
You: "I need to review my authentication code"

Agent Advisor: 
- What kind of review? (quality, security, or both)
- Pre-merge or pre-deployment?
- Any specific concerns?

You: "Security review before deploying"

Agent Advisor:
Primary Agent: @security
Why: Security audit for authentication code before deployment
Command: @security "Audit ./src/auth/ for authentication vulnerabilities"
Also consider: @reviewer after security fixes to check code quality
```

---

### NEW: Architect (`architect.md`)

**Purpose:** Systems architecture, migration plans, domain modeling. Read-only — cannot modify files. Default Plan mode agent.

**Model:** `opencode/gemini-3.1-pro` (1M context, $2/$12, 80.6% SWE-bench)

**Best For:**
- System design and architecture decisions
- Migration planning (database, API, framework)
- Large codebase analysis (leverages 1M token context)
- Debugging strategy and root cause analysis

**Example Commands:**
```bash
@architect "Design the DB schema for properties with multi-tenant support"
@architect "Plan migration from REST to GraphQL for user service"
@architect "Analyze the codebase and identify performance bottlenecks"
```

**Cross-Model Review:** Plans reviewed by `@plan-reviewer` (GPT 5.4)

---

### NEW: Builder (`builder.md`)

**Purpose:** Default implementation agent. Writes Go/TS code, runs tests, applies changes. The daily driver for Build mode.

**Model:** `opencode/gpt-5.4` ($2.50/$15, 1M context)

**Best For:**
- Daily implementation work
- Ambiguous or exploratory tasks
- Multi-file refactors
- When still figuring out what to build

**Example Commands:**
```bash
@builder "Implement the DynamoDB query handler for property lookups"
@builder "Add retry logic to the payment service with exponential backoff"
@builder "Refactor the config module to support environment-specific overrides"
```

**Cross-Model Review:** Code reviewed by `@reviewer` (Gemini 3.1 Pro)

---

### NEW: Coder (`coder.md`)

**Purpose:** Autonomous test-fix agent. Give it a spec + tests, it implements until all tests pass. RL-trained for agentic coding.

**Model:** `opencode/gpt-5.3-codex` ($1.75/$14, 1M context)

**Best For:**
- "Implement this interface and make all tests pass"
- Refactor modules with existing test coverage
- Spec-driven implementation with clear acceptance criteria

**Example Commands:**
```bash
@coder "Implement the UserRepository interface — tests are in user_test.go"
@coder "Refactor the HVAC handler to match the new schema — run tests after each change"
```

**Key Difference from Builder:** Codex is rigid and precise, follows instructions exactly. Builder (GPT 5.4) is flexible and creative. Use Coder when spec is clear; use Builder when exploring.

---

### NEW: Frontend (`frontend.md`)

**Purpose:** UI implementation and vision-to-code. Accepts screenshots and images as input.

**Model:** `opencode/kimi-k2.5` ($0.60/$3, 256K context)

**Best For:**
- Implementing UI components from designs or screenshots
- React/Next.js/Vue component development
- Figma comp to React conversion
- Marketing sites and landing pages

**Example Commands:**
```bash
@frontend "Implement this dashboard layout [attach screenshot]"
@frontend "Create a responsive pricing page matching this Figma design"
@frontend "Build a dark mode toggle component for the settings page"
```

---

### NEW: Budget Builder (`budget-builder.md`)

**Purpose:** Cost-effective implementation for well-defined tasks. ~80% quality of GPT 5.4 at ~30% cost.

**Model:** `opencode/glm-5` ($1/$3.20, 200K context)

**Best For:**
- CRUD operations with existing patterns
- Config changes, schema updates
- Simple refactors with clear requirements
- When budget is tight

**Example Commands:**
```bash
@budget-builder "Add the 'status' field to the Property model and migration"
@budget-builder "Create CRUD endpoints for the notification preferences"
```

**Limitation:** 200K context. Escalates to `@builder` if requirements are ambiguous.

---

### 1. Planning Agent (`planning-agent.md`)

**Purpose:** Design system architecture, create flow diagrams, break down features into tasks.

**Best For:**
- Starting a new feature
- Designing system architecture
- Breaking down complex requirements
- Creating implementation roadmaps

**Example Commands:**

```bash
# Design a new feature
@planning-agent "Design a user authentication system with OAuth2 and JWT"

# Plan a refactoring effort
@planning-agent "Plan the migration from REST to GraphQL for the user service"

# Break down a complex task
@planning-agent "Break down the payment processing integration with Stripe"
```

**Expected Output:**
- `.opencode/plans/plan-YYYYMMDD-{feature}.md` with:
  - Architecture diagrams (mermaid)
  - File structure
  - Implementation steps with complexity estimates
  - Risks and mitigations

**Workflow:**
1. Agent asks clarification questions (goal, constraints, scale)
2. You provide context
3. Agent generates comprehensive plan in markdown

---

### 2. Plan Reviewer (`plan-reviewer.md`)

**Purpose:** Critically review architecture plans, identify gaps, suggest improvements.

**Best For:**
- Validating plans before implementation
- Getting a second opinion on architecture
- Identifying risks you might have missed

**Example Commands:**

```bash
# Review a plan file
@plan-reviewer "Review ./plan-20260203-auth.md"

# Review with specific context
@plan-reviewer "Review the payment integration plan - we expect 10k transactions/day"

# Quick sanity check
@plan-reviewer "Is this architecture scalable? [paste plan summary]"
```

**Expected Output:**
- `.opencode/plans/plan-reviewer-YYYYMMDD-{feature}.md` with:
- Overall rating (1-5)
- Strengths and concerns (categorized by severity)
- Questions for the architect
- Suggested improvements

**Workflow:**
1. Provide the plan (file path or inline)
2. Agent asks about scale, timeline, constraints
3. Agent outputs structured review

---

### 3. Linear Agent (`linear.md`)

**Purpose:** Create Linear projects and issues via MCP integration.

**Requires:** Linear MCP server configured

**Best For:**
- Converting plans to actionable Linear issues
- Bulk issue creation from requirements
- Project setup automation

**Example Commands:**

```bash
# Create project with issues from file
@linear "Create project 'Auth System' with issues from ./plan-20260203-auth.md"

# Create single issue
@linear "Create issue: Fix login timeout on slow networks - priority high, label: bug"

# Bulk create from requirements
@linear "Parse ./requirements.md and create issues for each ## heading"

# Create project only
@linear "Create project 'Q1 Refactoring' in the Platform team"
```

**Input Formats Supported:**

```markdown
# From a requirements file:
## User Authentication          <-- becomes issue title
Implement secure login flow     <-- becomes description
- OAuth2 integration
- Session management
priority: high                  <-- sets priority
labels: feature, security       <-- sets labels

# From task list:
- [ ] Fix password reset        <-- becomes issue
- [ ] Add 2FA support           <-- becomes issue
```

**Expected Output:**
- Markdown summary of created items
- Project/issue IDs and URLs

---

### 4. Lead Developer (`lead_dev.md`)

**Purpose:** Lightweight orchestrator for quick, low-risk feature work. Autonomously writes code, delegates testing to `@qa`, delegates review to `@reviewer`, and auto-commits when QA and review pass.

**Model:** `opencode/gpt-5.4-mini` (fast, cost-effective)

**Best For:**
- Quick, clear-scope tasks
- Low-risk changes with minimal architectural impact
- Tasks where auto-commit after QA + review is acceptable

**Real-World Examples:**
- "Add a config flag for dark mode"
- "Update the error message on the login form"
- "Fix the typo in the API response field"
- "Add a unit test for the existing date parser"
- "Extract the validation logic into a helper function"

**Example Commands:**
```bash
@lead_dev "Implement the user login API endpoint with rate limiting"
@lead_dev "Add password strength validator to the registration form"
@lead_dev "Refactor the date formatting into a shared utility"
```

**Workflow:**
1. Discovery & Planning
2. Implementation Loop (Write Code <-> Verify with QA)
3. Code Review Loop (Refactor <-> Reviewer)
4. Finalize (Auto-commit when QA + review pass)

**Key Trait:** Auto-commits without waiting for approval — best for straightforward tasks.

---

### 5. Engineer (`engineer.md`)

**Purpose:** Senior implementation engineer with strong reasoning capabilities. Follows rigorous engineering principles (correctness, safety, clarity). Similar to Lead Developer but adds mandatory pre-flight checks and requires explicit user approval before commits.

**Model:** `opencode/gpt-5.4` (stronger reasoning, best Go/TS)

**Best For:**
- Complex, security-sensitive, or high-risk work
- Tasks requiring careful trade-off analysis
- Situations where you want explicit approval before commits
- Work involving concurrency, payment systems, or correctness-critical logic

**Real-World Examples:**
- "Design and implement the payment flow with Stripe"
- "Migrate auth from JWT to OAuth2"
- "Refactor the order processing pipeline to handle retries"
- "Build the data export feature with GDPR compliance"
- "Fix the race condition in the session handler"

**Example Commands:**
```bash
@engineer "Implement idempotent payment processing with retry logic"
@engineer "Build the authentication middleware with proper session handling"
@engineer "Refactor the inventory system to prevent overselling"
```

**Workflow:**
1. **Mandatory Pre-Flight** (asks clarifying questions about objectives, constraints, assumptions, failure modes)
2. Discovery & Planning
3. Implementation Loop (Write Code <-> Verify with QA)
4. Code Review Loop (Refactor <-> Reviewer)
5. **Present for Approval** (shows files + commit message, waits for your approval)
6. Finalize (Commit only after explicit approval)

**Key Trait:** Requires your approval before every commit — best for critical, complex, or irreversible work.

---

### Lead Dev vs Engineer — Quick Comparison

| Aspect | Lead Dev | Engineer |
|--------|----------|----------|
| **Use when** | Quick, simple, low-risk | Complex, risky, security-critical |
| **Model** | Lighter, faster (`gpt-5.4-mini`) | Stronger reasoning (`gpt-5.4`) |
| **Pre-flight** | None | Asks clarifying questions before planning |
| **Approval** | Auto-commits after QA + review | Waits for explicit user approval |
| **Philosophy** | SOP-driven workflow | Principles + decision framework + SOP |
| **Analogy** | Junior dev: "Here's the task, go do it" | Senior dev: "Let's think through this together" |

**Rule of Thumb:**
- Use **Lead Dev** when the task is clear, risk is low, and you're fine with auto-commits.
- Use **Engineer** when the task is fuzzy, irreversible, or requires careful reasoning, and you want approval before commits.

---

### 6. Code Reviewer (`reviewer.md`)

**Purpose:** Review code for quality, performance, and clean code standards.

**Best For:**
- Pre-merge code review
- Performance optimization suggestions
- Clean code enforcement

**Example Commands:**

```bash
# Review specific file
@reviewer "Review ./src/services/payment.ts"

# Review with focus area
@reviewer "Review ./src/auth/ focusing on performance"

# Review entire module
@reviewer "Review the user service - deep analysis"

# Quick scan
@reviewer "Quick review of ./utils/helpers.ts - readability only"
```

**Review Categories:**
- **SRP** - Single Responsibility Principle
- **Complexity** - Nesting depth, cyclomatic complexity
- **Performance** - Big O, N+1 queries, loop optimizations
- **Readability** - Naming, magic numbers, clarity

**Expected Output:**
- Status: PASS or CHANGES REQUESTED
- Issues by line number with suggestions
- Or simply "LGTM" if code is clean
- Markdown reports saved to `.opencode/reviewer/`

---

### 7. Security Auditor (`security.md`)

**Purpose:** Audit code for security vulnerabilities.

**Supports:** Go, Python, TypeScript/JavaScript, .NET

**Best For:**
- Pre-deployment security review
- Finding injection vulnerabilities
- Auth/authz verification
- Secrets detection

**Example Commands:**

```bash
# Full security audit
@security "Audit ./src/api/ - this is public-facing"

# Focused audit
@security "Check ./src/auth/ for authentication vulnerabilities"

# Quick scan
@security "Scan for hardcoded secrets in the codebase"

# Specific concern
@security "Review the file upload handler for path traversal"
```

**Checks by Language:**

| TypeScript | Python | Go | .NET |
|------------|--------|-----|------|
| XSS | eval/exec | SQL injection | Deserialization |
| Prototype pollution | pickle | Race conditions | Html.Raw |
| eval() | Command injection | unsafe package | XXE |

**Expected Output:**
- `.opencode/security/audit-YYYYMMDD-{scope}.md` with findings
- Severity-rated findings (CRITICAL/HIGH/MEDIUM/LOW)
- Vulnerable code with line numbers
- Suggested fixes
- References to CWE/OWASP

---

### 8. QA Automation (`qa.md`)

**Purpose:** Generate and execute tests for code.

**Supports:** Jest, Vitest, Pytest, go test, xUnit, NUnit

**Best For:**
- Writing unit tests
- Testing edge cases
- Validating bug fixes
- Increasing test coverage

**Example Commands:**

```bash
# Generate tests for a function
@qa "Write tests for ./src/utils/dateParser.ts"

# Comprehensive testing
@qa "Test ./src/services/payment.ts - happy path + sad path + edge cases"

# Test with specific focus
@qa "Write tests for the login flow focusing on error handling"

# Run existing tests
@qa "Run tests for the auth module and report coverage"
```

**Coverage Levels:**
- **Happy path** - Normal inputs, expected outputs
- **Sad path** - Errors, invalid inputs, timeouts
- **Comprehensive** - Edge cases, property testing, boundary conditions

**Expected Output:**
- Test plan before coding
- Generated test file
- Execution results (PASS/FAIL)
- Defect report if bugs found in source code

---

### 9. Test Generator (`test_generator.md`)

**Purpose:** Collaborative Test Generator specialized in Behavior-Driven Development (BDD). Translates natural language requirements into rigorous test code.

**Best For:**
- Creating tests from user stories or requirement lists
- Ensuring all edge cases are covered before implementation

**Example Commands:**
```bash
@test_generator "Generate tests for a function that validates credit card numbers"
```

---

### 10. Documentation Generator (`docs_generator.md`)

**Purpose:** Add inline documentation or generate external docs.

**Modes:**
- **Inline** - Add logic comments to source files
- **External** - Generate markdown documentation

**Best For:**
- Documenting domain logic
- Creating API documentation
- Generating architecture docs
- Onboarding documentation

**Example Commands:**

```bash
# Inline documentation (default)
@docs_generator "Add logic comments to ./src/services/billing.ts"

# External documentation
@docs_generator "mode=external source=./src/auth target=./docs/auth"

# Document entire module
@docs_generator "Document the payment module - both inline and external"

# Update existing docs
@docs_generator "Update ./docs/api.md based on changes in ./src/api/"
```

**What Gets Documented (Inline):**
- Business rules and domain logic
- Non-obvious algorithms
- Edge cases and gotchas
- Integration points

**What Gets Generated (External):**
- `overview.md` - Module purpose
- `architecture.md` - System diagrams
- `api.md` - API contracts
- `data-flow.md` - Flow diagrams

---

### 11. Git Commiter (`commiter.md`)

**Purpose:** Manage git commits with branch protection and semantic messages.

**Best For:**
- Safe committing (never to main)
- Semantic commit messages
- Branch management

**Example Commands:**

```bash
# Commit current changes
@commiter "Commit the authentication changes"

# Commit with context
@commiter "Commit - added OAuth2 integration"

# After finishing a feature
@commiter "Commit all changes for the payment refactor"
```

**Branch Protection:**
- Automatically detects if on `main`/`master`
- Creates feature branch if needed
- Always pushes after commit

**Commit Format (Conventional Commits):**
```
feat(auth): add OAuth2 login flow
fix(api): handle null response from payment service
refactor(utils): extract date formatting to helper
chore(deps): upgrade typescript to 5.3
```

**Expected Output:**
- Branch verification status
- Commit hash and message
- Push status

---

## Common Workflows

### Feature Development Flow

```bash
# 1. Plan the feature
@planning-agent "Design user notification system with email and push"

# 2. Review the plan
@plan-reviewer "Review ./plan-20260203-notifications.md"

# 3. Create Linear issues
@linear "Create issues from ./plan-20260203-notifications.md in Platform team"

# 4. [You implement the code]

# 5. Write tests
@qa "Write tests for ./src/services/notification.ts - comprehensive"

# 6. Security check
@security "Audit ./src/services/notification.ts"

# 7. Code review
@reviewer "Review ./src/services/notification.ts"

# 8. Add documentation
@docs_generator "Document ./src/services/notification.ts inline"

# 9. Commit
@commiter "Commit notification service implementation"
```

### Quick Code Review

```bash
@reviewer "./src/newFeature.ts"
@security "./src/newFeature.ts"
```

### Documentation Sprint

```bash
# Generate docs for entire module
@docs_generator "mode=external source=./src/core target=./docs/core"

# Then add inline comments
@docs_generator "Add inline comments to ./src/core/ - domain logic only"
```

### Bug Fix Flow

```bash
# 1. Understand the issue
# [Read the code, reproduce the bug]

# 2. Fix and test
@qa "Write test that reproduces bug #123, then verify fix"

# 3. Security check (if relevant)
@security "Check the fix doesn't introduce vulnerabilities"

# 4. Commit
@commiter "Fix: resolve race condition in session handler"
```

---

## Configuration

All agents are configured as OpenCode subagents in `~/.config/opencode/agent/`.

### Agent Settings

| Setting | Description |
|---------|-------------|
| `mode: subagent` | Runs as invokable subagent |
| `model` | LLM model to use |
| `temperature` | Creativity vs determinism (lower = more deterministic) |
| `tools` | Available tools (bash, mcp, etc.) |

### Customization

To modify an agent's behavior, edit its `.md` file. Key sections:
- **Clarification Protocol** - Questions the agent asks before acting
- **Standards/Checks** - What the agent evaluates
- **Output Format** - How results are presented

---

## Best Practices

1. **Copilot first** — Quick questions, error explanations, small refactors → Use Copilot Chat (300 free premium reqs). Don't burn Zen credits on lightweight tasks.

2. **Not sure which agent to use?** Start with `@agent-advisor` — it routes based on model cost, task complexity, and cross-model review rules.

3. **Cross-model review is mandatory** — Never review code with the same model that wrote it:
   - GPT 5.4 wrote it → Review with Gemini 3.1 Pro (`@reviewer`)
   - Gemini planned it → Review with GPT 5.4 (`@plan-reviewer`)

4. **Use the right cost tier:**
   - Thinking/planning → `@architect` or `@planning-agent` (Gemini 3.1 Pro)
   - Implementation → `@builder` (GPT 5.4) or `@coder` (GPT 5.3 Codex)
   - Simple tasks → `@budget-builder` (GLM 5) or `@lead_dev` (GPT 5.4 Mini)
   - Tests/docs → `@qa` (free) or `@docs_generator` (cheap)
   - Git ops → `@commiter` (GPT 5.4 Nano)

5. **Free models for grunt work** — Tests, docs, boilerplate use MiniMax M2.5 Free. Save paid tokens for reasoning and implementation.

6. **Chain agents for comprehensive review:**
   ```bash
   @reviewer && @security && @qa
   ```

7. **Save outputs for reference** — Agents save to `.opencode/{plans|reviewer|security}/`

---

## Troubleshooting

### Not sure which agent to use?
Use `@agent-advisor` - it will ask about your task and recommend the right agent(s).

### Agent not responding to clarification
Make sure you answer all the questions before expecting output.

### Linear agent fails
Verify your Linear MCP server is configured and running.

### Wrong test framework detected
Specify explicitly: `@qa "Write Jest tests for..."`

### Too many false positives in security scan
Provide context: `@security "This is internal tooling, lower risk tolerance"`
