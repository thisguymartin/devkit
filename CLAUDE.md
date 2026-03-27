# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A portable, reproducible terminal development environment (devkit). Not a software project with build/test/lint cycles -- it's a collection of dotfiles, Zellij layouts, shell scripts, Homebrew package manifests, tool configs, and optionally AI agent/assistant configs. The goal is to replicate the same workflow on any machine: clone, install, symlink, and go. All tools are installed via Homebrew and orchestrated through Zellij terminal multiplexer.

## Repository Structure

- `brewfile` -- Homebrew package manifest (install with `brew bundle --file=brewfile`)
- `zellij/layouts/` -- KDL layout files for Zellij workspaces (lazyai, fulldev, grove, testrunner, etc.)
- `zellij/launch-lazyai.sh` -- Launcher script; supports `AI_EDITOR` env var (`opencode`, `claude`, etc.)
- `opencode/aig_agents/` -- AI agent persona definitions for OpenCode (advisor, architect, engineer, QA, security, etc.)
- `skills/rules/` -- Always-on coding standards (code quality, engineering principles, security, workflow)
- `skills/commands/` -- On-demand slash commands (refactor-challenge, trace-debug, explain-code, etc.)
- `skills/plane/` -- Plane.so project management commands
- `.claude/rules/` -- Symlinked from `skills/rules/` (single source of truth)
- `.cursor/rules/` -- Cursor rules (same standards, `.mdc` format)
- `.github/copilot-instructions.md` -- GitHub Copilot instructions
- `.config/` -- Tool configs: Ghostty terminal, git-delta, Starship prompt, shell enhancements (zoxide, fzf, eza aliases)
- `scripts/` -- Setup and utility scripts (setup-all.sh, setup-db.sh, setup-ssl.sh, start/stop-services.sh, killport.sh, etc.)

## Key Commands

```bash
# Full environment setup
./scripts/setup-all.sh

# Install/update tools
brew bundle --file=brewfile

# Launch development workspace (God Mode: AI + LazyGit + Shell)
zdev

# Other Zellij layouts
zfull    # Editor + LazyGit + Terminal
zgrove   # Full-stack multi-tab
ztest    # Test runner
zapi     # API development
znode    # Node.js development
zgo      # Go development

# Launch with specific AI editor
AI_EDITOR=claude zellij -l zellij/layouts/lazyai.kdl
./zellij/launch-lazyai.sh claude

# Service management
./scripts/start-services.sh   # PostgreSQL, Redis, Docker
./scripts/stop-services.sh
brew services list

# Utilities
./scripts/killport.sh <port>
./scripts/setup-db.sh
./scripts/setup-ssl.sh
```

## Configuration Linking

Configs are symlinked from this repo to `~/.config/` and `~/`. The setup script handles:
- `.zshrc` -> `~/.zshrc`
- `zellij/` -> `~/.config/zellij/`
- `.config/ghostty/config` -> `~/.config/ghostty/config`
- `.config/git/delta.gitconfig` -> included via `git config --global include.path`
- `.config/shell/enhancements.zsh` -> sourced from `.zshrc`

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
- `.cursor/rules/` and `.github/copilot-instructions.md` are maintained separately in their tool-specific formats -- update them when modifying standards in `skills/`
