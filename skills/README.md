# AI Skills / Rules

Universal development skills that work across all AI coding tools. These define how AI assistants should behave when working on your projects.

## Available Skills

| Skill | Purpose | Trigger |
|-------|---------|---------|
| **code-quality-standards** | SRP, complexity limits, performance, readability | Writing or reviewing code |
| **complexity-check** | Big-O analysis, scaling bottlenecks | Performance analysis |
| **development-workflow** | Discovery, implementation, verification, finalization | Starting features or fixing bugs |
| **engineering-principles** | Decision framework, trade-offs, priorities | Design decisions |
| **explain-code** | Plain English explanations with data flow | Understanding code |
| **generate-flow** | Mermaid diagrams for any flow type | Visualizing code |
| **pr-automation** | PR creation with structured descriptions | Opening pull requests |
| **refactor-challenge** | Socratic code tutor for learning | Code review with learning |
| **security-awareness** | Injection, auth, secrets, OWASP patterns | Writing or reviewing code |
| **trace-debug** | Systematic debugging framework | Debugging |
| **why-this-way** | Design decision analysis and alternatives | Understanding trade-offs |

## How to Use in Each Tool

### Cursor
```bash
# Symlink to your project
ln -sf ~/devkit/skills ~/.cursor/skills
```
Cursor reads `SKILL.md` files from `.cursor/skills/*/SKILL.md`.

### Claude Code
```bash
# Copy or symlink the CLAUDE.md to your project root
ln -sf ~/devkit/.claude/rules/ .claude/rules/
```
Claude Code reads rules from `.claude/rules/`.

### GitHub Copilot
```bash
# Symlink instructions
ln -sf ~/devkit/.github/copilot-instructions.md .github/copilot-instructions.md
```
Copilot reads `.github/copilot-instructions.md`.

### OpenCode
Already configured via `opencode/aig_agents/`.

### Generic (any tool)
Point your AI tool's system prompt or rules config at the `skills/` directory.

## Setup Script

Run this to link skills into a project:
```bash
~/devkit/scripts/link-skills.sh /path/to/your/project
```
