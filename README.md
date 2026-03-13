# devkit

> **An opinionated, keyboard-first terminal dev environment. Curated CLI tools, purpose-built layouts, and optional AI agents — all managed from one repo.**



## What This Is

A portable development environment built entirely around the terminal. One `brew bundle` installs everything. One repo holds all the configs, layouts, and shell enhancements. Clone it on a fresh Mac and you're productive in minutes.

It ships with 9 Zellij layouts for different workflows (testing, migrations, API work, debugging, CI/CD), modern replacements for standard Unix tools, and optionally integrates AI coding agents if that's your thing. For AI-powered worktree workspaces, see [Grove](https://github.com/thisguymartin/grove).

## Core Stack

| Tool | Purpose | Why |
| :--- | :--- | :--- |
| **Ghostty** | Terminal | GPU-accelerated, fast, Catppuccin themed. |
| **Zellij** | Window Manager | Splits terminal into multi-tab workspaces with stacked/floating panes. |
| **LazyGit** | Git Client | The fastest way to stage, diff, commit, and push. |
| **Yazi** | File Manager | Visual file browsing with previews — faster than Finder. |
| **Starship** | Prompt | Git branch, status, errors, and language versions at a glance. |
| **Btop** | Monitor | Real-time CPU, memory, disk, and process monitoring. |
| **Bat** | Cat Replacement | File reading with syntax highlighting and line numbers. |
| **Ripgrep** | Search | Recursive text search, faster than grep by orders of magnitude. |

### Modern CLI Replacements

| Tool | Replaces | Why |
| :--- | :--- | :--- |
| **eza** | `ls` | Color-coded listings with icons and git status. |
| **fd** | `find` | Respects `.gitignore`, integrates with fzf. |
| **fzf** | — | Fuzzy finder for files, dirs, and history (`Ctrl+T`, `Alt+C`, `Ctrl+R`). |
| **zoxide** | `cd` | Learns your frequent dirs — `z proj` jumps to `~/projects`. |
| **git-delta** | `diff` | Side-by-side syntax-highlighted diffs with Catppuccin theme. |
| **jq** | — | Parse, filter, and transform JSON from the command line. |
| **tldr** | `man` | Practical examples instead of 2000 lines. |
| **dust** | `du` | Visual breakdown of what's eating disk space. |

## Zellij Layouts

9 purpose-built layouts using stacked panes, multi-tab workflows, and floating panes. For AI agent + worktree workspaces, see [Grove](https://github.com/thisguymartin/grove).

### General Purpose

| Command | Layout | What It's For |
| :--- | :--- | :--- |
| `zdebug` | Debug | Log stacking, process inspector, floating notes, reproduce/fix tabs |

### Workflow-Specific

| Command | Layout | What It's For |
| :--- | :--- | :--- |
| `ztest` | Test Runner | Stacked test suites (unit/integration/E2E) + watch mode |
| `zmig` | Migrations | Migration runner, DB console, queries, seed data |
| `zapi` | API Dev | Server + request logs + test + schema |
| `zpipe` | Pipeline | Build, deploy, rollback, container logs, health checks |

### Infrastructure

| Command | Layout | What It's For |
| :--- | :--- | :--- |
| `zmon` | Monitor | btop + logs + Docker |
| `zdb` | Database | PostgreSQL + Redis |

### Language-Specific (commands start suspended — press ENTER to run)

| Command | Layout | What It's For |
| :--- | :--- | :--- |
| `znode` | Node.js | Dev server, vitest, lint, Drizzle migrations/studio, Docker |
| `zgo` | Go | go run, go test, vet, benchmarks, modules, Docker |

## AI Agents (Optional)

If you use AI coding tools, the repo includes agent configs for [OpenCode](https://github.com/anomalyco/opencode). These are optional — everything else works without them.

| Agent | Specialty | Invoke With |
| :--- | :--- | :--- |
| **Advisor** | Task routing & agent selection | `@agent-advisor` |
| **Architect** | System design & planning | `@planning-agent` |
| **Reviewer** | Code & architecture review | `@plan-reviewer` `@reviewer` |
| **Engineer** | Complex features & refactoring | `@engineer` |
| **Lead Dev** | Fast implementation & fixes | `@lead_dev` |
| **QA** | Test generation & execution | `@qa` `@test_generator` |
| **Security** | Vulnerability scanning | `@security` |
| **PM** | Linear integration & project mgmt | `@linear` |

Agent configs live in [`opencode/aig_agents/`](opencode/aig_agents/)

## Open-Source Projects of Interest

Tools from the community worth checking out:

| Project | What It Does |
| :--- | :--- |
| [**Grove**](https://github.com/thisguymartin/grove) | Terminal workspace for parallel git branches — AI agent + LazyGit + Zellij worktrees. |
| [**Promptfoo**](https://github.com/promptfoo/promptfoo) | LLM testing, evaluation & red-teaming. |
| [**Heretic**](https://github.com/p-e-w/heretic) | Transformer parameter optimization via directional ablation. |
| [**Impeccable**](https://github.com/pbakaus/impeccable) | Design skill for AI coding assistants — 17 commands + anti-patterns. |
| [**OpenViking**](https://github.com/volcengine/OpenViking) | Context database for AI agents — unified memory and skills management. |

## Installation

### Prerequisites

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Setup

**1. Clone this repository**

```bash
git clone https://github.com/YOUR_USERNAME/devkit.git ~/devkit
cd ~/devkit
```

**2. Install tools**

```bash
brew bundle --file=brewfile
```

**3. Link configurations**

```bash
# Shell
mv ~/.zshrc ~/.zshrc.backup 2>/dev/null || true
ln -sf ~/devkit/.zshrc ~/.zshrc

# Zellij layouts
mkdir -p ~/.config/zellij
ln -sf ~/devkit/zellij/layouts ~/.config/zellij/layouts

# Ghostty config
mkdir -p ~/.config/ghostty
ln -sf ~/devkit/.config/ghostty/config ~/.config/ghostty/config

# Git delta (syntax-highlighted diffs)
git config --global include.path ~/devkit/.config/git/delta.gitconfig

# Shell enhancements (zoxide, fzf+fd, eza aliases, layout aliases)
echo 'source ~/devkit/.config/shell/enhancements.zsh' >> ~/.zshrc
```

Or run the full setup script:

```bash
./scripts/setup-all.sh
```

**4. Reload shell**

```bash
source ~/.zshrc
```

## Usage

Pick a layout and go:

```bash
cd ~/my-api && znode   # Node.js project with pre-wired commands
cd ~/my-svc && zgo     # Go project with pre-wired commands
zdebug           # Debug workspace with log stacking
```

All tools are keyboard-driven. See [CHEATSHEET.md](CHEATSHEET.md) for keybindings and workflows.

## Documentation

| Doc | What's Inside |
| :--- | :--- |
| [SETUP.md](SETUP.md) | Complete installation, databases, SSL, services |
| [TOOLS.md](TOOLS.md) | Deep dive into every tool with examples |
| [CHEATSHEET.md](CHEATSHEET.md) | Keyboard shortcuts and quick commands |
| [TROUBLESHOOTING.md](TROUBLESHOOTING.md) | Common issues and solutions |
