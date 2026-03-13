# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A portable, reproducible terminal development environment (devkit). Not a software project with build/test/lint cycles -- it's a collection of dotfiles, Zellij layouts, shell scripts, Homebrew package manifests, tool configs, and optionally AI agent/assistant configs. The goal is to replicate the same workflow on any machine: clone, install, symlink, and go. All tools are installed via Homebrew and orchestrated through Zellij terminal multiplexer.

## Repository Structure

- `brewfile` -- Homebrew package manifest (install with `brew bundle --file=brewfile`)
- `zellij/layouts/` -- KDL layout files for Zellij workspaces (lazyai, fulldev, grove, testrunner, etc.)
- `zellij/launch-lazyai.sh` -- Launcher script; supports `AI_EDITOR` env var (`opencode`, `claude`, etc.)
- `opencode/aig_agents/` -- AI agent persona definitions for OpenCode (advisor, architect, engineer, QA, security, etc.)
- `skills/` -- AI assistant skill definitions (code quality, debugging, flow diagrams, frontend design, etc.)
- `.claude/rules/` -- Claude Code rules (mirrored from `skills/` into Claude-specific format)
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

### Skills System
Skills in `skills/` are teaching-oriented (Socratic method). Key skills:
- `refactor-challenge` and `trace-debug` guide the developer rather than fixing directly
- `explain-code` and `why-this-way` analyze without modifying
- `generate-flow` produces Mermaid diagrams from code
- `complexity-check` teaches performance reasoning
- `frontend-design/` includes sub-skills (audit, polish, critique, animate, etc.) with reference docs

## When Editing This Repo

- Layout files use KDL format (`*.kdl`) -- Zellij's configuration language
- Agent configs are markdown files with persona/behavior instructions
- Shell scripts should use `set -e` and follow existing patterns in `scripts/`
- The `.claude/rules/`, `.cursor/rules/`, `.github/copilot-instructions.md`, and `skills/` directories contain overlapping content adapted for each tool's format -- keep them in sync when modifying standards
