# devkit

> **A portable, reproducible terminal dev environment. Clone it, `brew bundle`, and your entire workflow — tools, layouts, configs, shell enhancements — is ready on any Mac.**



## What This Is

A single repo that carries your complete development workflow from machine to machine. Every package, shell config, terminal layout, and tool preference lives here. Clone it on a fresh Mac, run the setup, and you're productive in minutes — identical environment everywhere.

It includes curated CLI tools installed via Homebrew, 9 Zellij layouts for different workflows (testing, migrations, API work, debugging, CI/CD), modern replacements for standard Unix tools, shell enhancements, and optionally AI coding agents and assistant configs. For AI-powered worktree workspaces, see [Grove](https://github.com/thisguymartin/grove).

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

## AI Tools (Optional)

The repo includes configs for AI coding tools — these are entirely optional and nothing else depends on them.

### Dual-Tool Strategy: OpenCode + Copilot Pro

| Layer | Tool | Cost | What It Handles |
| :--- | :--- | :--- | :--- |
| Inline completions | Copilot Pro | $10/mo | Tab-complete in Neovim. Unlimited. |
| Quick chat | Copilot Pro | Included | Quick questions, explain errors (300 reqs). |
| PR review | Copilot | Included | Assign Copilot as reviewer on PRs. |
| Heavy agentic work | OpenCode + Zen | ~$90/mo | Architecture, multi-file refactors, autonomous coding. |

### OpenCode Agents (11 agents)

| Agent | Specialty | Model | Cost | Invoke With |
| :--- | :--- | :--- | :--- | :--- |
| **Architect** | System design, task breakdown, plan review | Gemini 3.1 Pro | $2/$12 | `@planning-agent` |
| **PM** | Linear integration | GPT-5-mini (OpenAI) | $0.25/$2 | `@linear` |
| **Engineer** | Premium builder (approval) | Gemini 3.1 Pro | $2/$12 | `@engineer` |
| **Coder** | Autonomous test-fix loops | GPT-5 (OpenAI) | $1.25/$10 | `@coder` |
| **Frontend** | UI/component development | Kimi K2.5 | $0.60/$3 | `@frontend` |
| **Reviewer** | Code quality review | Gemini 3.1 Pro | $2/$12 | `@reviewer` |
| **Security** | Vulnerability scanning | Gemini 3.1 Pro | $2/$12 | `@security` |
| **QA** | Test generation, execution, BDD | GPT-5-mini (OpenAI) | $0.25/$2 | `@qa` |
| **Docs** | Inline + external docs | Gemini 3 Flash | ~$0.50/$3 | `@docs_generator` |
| **Pickle Think** | Free triage & rough planning | Big Pickle | FREE | `@pickle-think` |
| **Pickle Implement** | Free low-risk code changes | Big Pickle | FREE | `@pickle-implement` |

`planning-agent` now includes plan review mode, `qa` now handles requirements-driven / BDD test generation, and `pickle-think` / `pickle-implement` provide a free first-pass lane on Big Pickle. The default OpenCode build lane in [`opencode.json`](opencode.json) now uses `MiniMax M2.5 Free`; `@engineer` remains the premium escalation path on Gemini 3.1 Pro. Agent configs live in [`opencode/aig_agents/`](opencode/aig_agents/). Rules live in [`skills/`](skills/) (symlinked into [`.claude/rules/`](.claude/rules/)) and [`.cursor/rules/`](.cursor/rules/).

For frontend design skills (`/audit`, `/polish`, `/critique`, `/animate`, `/frontend-design`, etc.), install [Impeccable](https://impeccable.style/):

```bash
npx skills add pbakaus/impeccable
```

## Open-Source Tools of Interest

Tools and projects from the community that complement this workflow:

| Project | What It Does |
| :--- | :--- |
| [**Grove**](https://github.com/thisguymartin/grove) | Terminal workspace for parallel git branches — AI agent + LazyGit + Zellij worktrees. |
| [**Promptfoo**](https://github.com/promptfoo/promptfoo) | LLM testing, evaluation & red-teaming. |
| [**Heretic**](https://github.com/p-e-w/heretic) | Transformer parameter optimization via directional ablation. |
| [**Impeccable**](https://github.com/pbakaus/impeccable) | Design skill for AI coding assistants — 17 commands + anti-patterns. Install into `~/.claude/skills/` for frontend design skills. |
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

**4. Set up OpenCode + Copilot (optional)**

```bash
./scripts/opencode-setup.sh
```

**5. Reload shell**

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

All tools are keyboard-driven. Layout aliases are defined in `.config/shell/enhancements.zsh`.
