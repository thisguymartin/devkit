# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A portable, reproducible terminal development environment (devkit). Not a software project with build/test/lint cycles -- it's a collection of dotfiles, Zellij layouts, shell scripts, Homebrew package manifests, tool configs, and optionally AI agent/assistant configs. The goal is to replicate the same workflow on any machine: clone, install, symlink, and go. All tools are installed via Homebrew and orchestrated through Zellij terminal multiplexer.

## Repository Structure

- `brewfile` -- Homebrew package manifest (install with `brew bundle --file=brewfile`)
- `zellij/layouts/` -- KDL layout files for Zellij workspaces (api, database, debug, golang, migrations, monitor, node, pipeline, testrunner)
- `opencode/aig_agents/` -- OpenCode agent persona definitions (planning, engineer, coder, frontend, QA, reviewer, security, docs, Linear, pickle agents)
- `skills/rules/` -- Always-on coding standards and personal preferences (code quality, engineering principles, security, workflow, personal profile)
- `skills/commands/` -- On-demand slash commands (refactor-challenge, trace-debug, explain-code, etc.)
- `skills/plane/` -- Plane.so project management commands
- `.claude/rules/` -- Symlinked from `skills/rules/` (single source of truth)
- `.cursor/rules/` -- Cursor rules (same standards, `.mdc` format)
- `.config/` -- Tool configs: Ghostty terminal, git-delta, Starship prompt, shell enhancements (zoxide, fzf, eza aliases)
- `sounds/` -- Notification sounds for Claude Code hooks (Navi "Hey! Listen!" from Zelda)
- `AGENTS.md` -- Repo-local defaults for Codex and other coding agents
- `opencode.json` -- OpenCode configuration (model routing, MCP servers, plugins)
- `scripts/` -- Utility scripts (killport.sh, brew-update.sh, dev-cleanup.sh, opencode-setup.sh)

## Key Commands

```bash
# Install/update tools
brew bundle --file=brewfile

# Zellij layouts
zdebug   # Debug workspace with log stacking
ztest    # Test runner (unit/integration/E2E)
zmig     # Migrations (runner, DB console, queries, seed data)
zapi     # API development (server, request logs, test, schema)
zpipe    # Pipeline (build, deploy, rollback, container logs)
zmon     # Monitor (btop + logs + Docker)
zdb      # Database (PostgreSQL + Redis)
znode    # Node.js development
zgo      # Go development

# Utilities
./scripts/killport.sh <port>
./scripts/brew-update.sh
./scripts/dev-cleanup.sh
./scripts/opencode-setup.sh  # Set up OpenCode + Copilot Pro

# OpenCode
oc           # Launch OpenCode (alias)
```

## Configuration Linking

Configs are symlinked from this repo to `~/.config/` and `~/`:
- `zellij/` -> `~/.config/zellij/`
- `.config/ghostty/config` -> `~/.config/ghostty/config`
- `.config/git/delta.gitconfig` -> included via `git config --global include.path`
- `.config/shell/enhancements.zsh` -> sourced from `.zshrc`
- `.claude/settings.json` -> `~/.claude/settings.json`
- `opencode/aig_agents/` -> `~/.config/opencode/agents/` (via `scripts/opencode-setup.sh`)
- `opencode.json` -> `~/.config/opencode/opencode.json` (via `scripts/opencode-setup.sh`)

### OpenCode + Copilot Pro Setup

```bash
./scripts/opencode-setup.sh
```

This symlinks OpenCode agents and config, and installs the Copilot CLI extension. See `opencode/aig_agents/README.md` for the full agent reference and model routing strategy.

### Claude Code Settings

```bash
ln -sf /path/to/devkit/.claude/settings.json ~/.claude/settings.json
```

The settings include hooks that play Navi's "Hey! Listen!" sound (from The Legend of Zelda) when Claude finishes a task or sends a notification. Uses `afplay` on macOS and `aplay` on Linux.

The sound path defaults to `~/personal-workspace/devkit/sounds/`. Override by setting `DEVKIT_PATH` in your shell if you cloned the repo elsewhere:

```bash
export DEVKIT_PATH="$HOME/path/to/devkit"
```

## AI Tools (Optional)

AI agent and assistant configs are included but optional -- the core workflow (tools, layouts, shell configs) works without them.

### Dual-Tool Strategy
- **OpenCode + Zen** (~$90/mo) -- Heavy agentic work: architecture, multi-file refactors, autonomous coding, code review pipelines
- **Copilot Pro** ($10/mo) -- Lightweight: inline completions (unlimited), quick chat (300 reqs), PR review (free), CLI agents
- **Claude Code** -- Kept for work use; devkit includes Claude rules and settings for both tools

### OpenCode Agents
11 specialized agents in `opencode/aig_agents/`, invoked with `@agent-name` syntax inside OpenCode:
- `@planning-agent` -- architecture, task breakdown, and plan review (Gemini 3.1 Pro)
- `build` mode in `opencode.json` -- default free implementation lane (MiniMax M2.5 Free)
- `@engineer` -- premium implementation/orchestration for harder work (Gemini 3.1 Pro)
- `@coder` -- autonomous test-fix loops when the spec and tests are clear (GPT-5 via OpenAI API)
- `@frontend` -- cost-sensitive UI and component work (Kimi K2.5)
- `@reviewer` / `@security` -- code review and security audit (Gemini 3.1 Pro, cross-model)
- `@qa` -- test generation, execution, and BDD flows (GPT-5-mini via OpenAI API)
- `@docs_generator` -- documentation (Gemini 3 Flash)
- `@linear` -- Linear project management (GPT-5-mini via OpenAI API)
- `@pickle-think` -- free triage and rough planning (Big Pickle)
- `@pickle-implement` -- free low-risk code changes (Big Pickle)

### Rules & Commands
Always-on rules in `skills/rules/` are symlinked into `.claude/rules/` -- they apply to every conversation automatically. Personal preferences live in `skills/rules/personal-profile.md`.

On-demand commands in `skills/commands/` are invoked as slash commands:
- `/refactor-challenge` and `/trace-debug` -- Socratic tutors (guide, don't fix)
- `/explain-code` and `/why-this-way` -- analyze without modifying
- `/generate-flow` -- Mermaid diagrams from code
- `/complexity-check` -- performance reasoning
- `/pr-automation` -- PR creation

Plane commands in `skills/plane/` manage project work:
- `/plane-work`, `/plane-triage`, `/plane-standup`, `/plane-sprint-run`, `/plane-close`, `/plane-review`

Frontend design skills (`/audit`, `/polish`, `/critique`, `/animate`, etc.) are provided by [Impeccable](https://github.com/pbakaus/impeccable) -- install separately into `~/.claude/skills/`.

## When Editing This Repo

- Layout files use KDL format (`*.kdl`) -- Zellij's configuration language
- Agent configs are markdown files with persona/behavior instructions
- Shell scripts should use `set -e` and follow existing patterns in `scripts/`
- `skills/rules/` is the single source of truth for always-on rules -- `.claude/rules/` files are symlinks. Edit files in `skills/rules/`, not `.claude/rules/`
- `opencode/aig_agents/` is the single source of truth for OpenCode agents -- `~/.config/opencode/agents/` is a symlink
- Agent model IDs use the `opencode/` prefix for Zen models (e.g., `opencode/minimax-m2.5-free`, `opencode/gemini-3.1-pro`)
- `skills/commands/` and `skills/plane/` are slash commands symlinked into `~/.claude/skills/`
- `.cursor/rules/` is maintained separately in `.mdc` format -- update when modifying standards in `skills/`
