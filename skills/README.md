# Skills & Rules

## Structure

```
skills/
  rules/      → Always-on standards (loaded into every conversation)
  commands/   → On-demand slash commands (invoked manually)
  plane/      → Plane.so project management commands
```

### Rules (always-on)

Symlinked into `.claude/rules/` — these are loaded as context automatically.

| Rule | Purpose |
|------|---------|
| **code-quality-standards** | SRP, complexity limits, performance, readability |
| **engineering-principles** | Decision framework, trade-offs, priorities |
| **security-awareness** | Injection, auth, secrets, OWASP patterns |
| **development-workflow** | Discovery, implementation, verification, finalization |

### Commands (on-demand)

Symlinked into `~/.claude/skills/commands/` — invoked as `/command-name`.

| Command | Purpose |
|---------|---------|
| `/refactor-challenge` | Socratic code tutor — guides, doesn't fix |
| `/trace-debug` | Systematic debugging framework |
| `/explain-code` | Plain English explanations with data flow |
| `/why-this-way` | Design decision analysis and alternatives |
| `/generate-flow` | Mermaid diagrams for any flow type |
| `/complexity-check` | Big-O analysis, scaling bottlenecks |
| `/pr-automation` | PR creation with structured descriptions |

### Plane Commands

Symlinked into `~/.claude/skills/plane/` — invoked as `/plane-*`.

| Command | Purpose |
|---------|---------|
| `/plane-work` | Pick a Plane issue, plan, branch, implement, open draft PR |
| `/plane-triage` | Triage untriaged issues (missing milestone, labels, priority) |
| `/plane-standup` | Daily standup summary from Plane.so |
| `/plane-sprint-run` | Batch-work a milestone or set of issues |
| `/plane-close` | Post-merge cleanup — update issue to Done |
| `/plane-review` | Review PR against Plane acceptance criteria |

## Dependencies

External skill packs installed separately into `~/.claude/skills/`:

| Skill Pack | Install | What It Adds |
|------------|---------|-------------|
| [**Impeccable**](https://github.com/pbakaus/impeccable) | `/plugin install impeccable@claude-plugins-official` | 18 frontend design skills — `/audit`, `/polish`, `/critique`, `/animate`, `/frontend-design`, `/normalize`, `/adapt`, `/bolder`, `/clarify`, `/colorize`, `/delight`, `/distill`, `/extract`, `/harden`, `/onboard`, `/optimize`, `/quieter`, `/teach-impeccable` |
| [**Trail of Bits**](https://github.com/trailofbits/skills) | `/plugin marketplace add trailofbits/skills` | 30+ security audit skills — variant analysis, semgrep rule creation, supply chain auditing, smart contract security, property-based testing, static analysis |
| [**Superpowers**](https://github.com/obra/superpowers) | `/plugin install superpowers@claude-plugins-official` | 14 development methodology skills — TDD, systematic debugging, brainstorming, code review (request + receive), plan writing/execution, parallel agents, git worktrees |
| [**Anthropic Skills**](https://github.com/anthropics/skills) | `/plugin marketplace add anthropics/skills` | Official skills — `claude-api`, `mcp-builder`, `skill-creator`, `webapp-testing`, `frontend-design` (basis of Impeccable) |

### Other skill packs (not installed)

| Skill Pack | Why It's Here | Notes |
|------------|--------------|-------|
| [**LibreUIUX**](https://github.com/HermeticOrmus/LibreUIUX-Claude-Code) | 152 agents, 70 plugins, 76 commands for UI/UX. MIT license. | Heavy overlap with Impeccable. Worth browsing for ideas but too bloated to install wholesale. Manual copy install only — no plugin marketplace support. |

## Linking

### Claude Code
```bash
# Rules (always-on) — symlink into project
ln -sf ~/devkit/.claude/rules/ .claude/rules/

# Commands (on-demand) — symlink into user skills
mkdir -p ~/.claude/skills
ln -sf ~/devkit/skills/commands ~/.claude/skills/commands
ln -sf ~/devkit/skills/plane ~/.claude/skills/plane
```

### Cursor
`.cursor/rules/` contains `.mdc` formatted versions of the always-on rules. Maintained separately.

### GitHub Copilot
`.github/copilot-instructions.md` is a curated digest of all rules. Maintained separately.

### OpenCode
Already configured via `opencode/aig_agents/`.
