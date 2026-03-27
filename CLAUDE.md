# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A portable, reproducible terminal development environment (devkit). Not a software project with build/test/lint cycles -- it's a collection of dotfiles, Zellij layouts, shell scripts, Homebrew package manifests, tool configs, and optionally AI agent/assistant configs. The goal is to replicate the same workflow on any machine: clone, install, symlink, and go. All tools are installed via Homebrew and orchestrated through Zellij terminal multiplexer.

## Repository Structure

- `brewfile` -- Homebrew package manifest (install with `brew bundle --file=brewfile`)
- `zellij/layouts/` -- KDL layout files for Zellij workspaces (api, database, debug, golang, migrations, monitor, node, pipeline, testrunner)
- `opencode/aig_agents/` -- AI agent persona definitions for OpenCode (advisor, architect, engineer, QA, security, etc.)
- `skills/rules/` -- Always-on coding standards (code quality, engineering principles, security, workflow)
- `skills/commands/` -- On-demand slash commands (refactor-challenge, trace-debug, explain-code, etc.)
- `skills/plane/` -- Plane.so project management commands
- `.claude/rules/` -- Symlinked from `skills/rules/` (single source of truth)
- `.cursor/rules/` -- Cursor rules (same standards, `.mdc` format)
- `.config/` -- Tool configs: Ghostty terminal, git-delta, Starship prompt, shell enhancements (zoxide, fzf, eza aliases)
- `sounds/` -- Notification sounds for Claude Code hooks (Navi "Hey! Listen!" from Zelda)
- `scripts/` -- Utility scripts (killport.sh, brew-update.sh, dev-cleanup.sh)

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
```

## Configuration Linking

Configs are symlinked from this repo to `~/.config/` and `~/`:
- `zellij/` -> `~/.config/zellij/`
- `.config/ghostty/config` -> `~/.config/ghostty/config`
- `.config/git/delta.gitconfig` -> included via `git config --global include.path`
- `.config/shell/enhancements.zsh` -> sourced from `.zshrc`
- `.claude/settings.json` -> `~/.claude/settings.json`

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

### OpenCode Agents
OpenCode agents in `opencode/aig_agents/` are invoked with `@agent-name` syntax inside OpenCode:
- `@agent-advisor` -- routes tasks to appropriate agents
- `@planning-agent` -- system design and architecture
- `@engineer` / `@lead_dev` -- implementation
- `@reviewer` / `@plan-reviewer` -- code review
- `@qa` / `@test_generator` -- testing
- `@security` -- vulnerability scanning
- `@linear` -- Linear project management integration

### Rules & Commands
Always-on rules in `skills/rules/` are symlinked into `.claude/rules/` -- they apply to every conversation automatically.

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
- `skills/commands/` and `skills/plane/` are slash commands symlinked into `~/.claude/skills/`
- `.cursor/rules/` is maintained separately in `.mdc` format -- update when modifying standards in `skills/`
