# Tools Reference Guide

Deep dive into each tool in the AI-native development environment.

## Table of Contents

1. [Terminal & Shell](#terminal--shell)
2. [Window Management](#window-management)
3. [Git & Version Control](#git--version-control)
4. [File Management](#file-management)
5. [Development Languages](#development-languages)
6. [Databases & Caching](#databases--caching)
7. [API & HTTP Tools](#api--http-tools)
8. [Containers](#containers)
9. [Monitoring & Observability](#monitoring--observability)
10. [AI & LLM Tools](#ai--llm-tools)

---

## Terminal & Shell

### Ghostty
**GPU-accelerated terminal emulator**

```bash
# Open config
open ~/.config/ghostty/config

# Reload config without restart
keybind: super+r=reload_config

# Fast startup
ghostty --working-directory ~/projects
```

**Why it matters:** Fast, modern, GPU-accelerated rendering with great font rendering.

---

### Starship
**Smart shell prompt**

```bash
# Initialize (auto-loaded in .zshrc)
eval "$(starship init zsh)"

# Customize
edit ~/.config/starship.toml

# Configuration options:
# - Git branch and status
# - Command exit code
# - Execution time
# - Environment variables
```

**Why it matters:** Instant visual feedback on git status, errors, and directory context.

---

## Window Management

### Zellij
**Terminal multiplexer (like tmux/screen)**

```bash
# Start default session
zellij

# Start with specific layout
zellij --layout ~/devkit/zellij/layouts/main.kdl

# Key commands (default prefix is Ctrl+g):
#   Ctrl+g + n: New pane
#   Ctrl+g + x: Close pane
#   Ctrl+g + t: New tab
#   Ctrl+g + h: Left pane
#   Ctrl+g + l: Right pane
#   Ctrl+g + j: Down pane
#   Ctrl+g + k: Up pane
#   Ctrl+g + e: Resize mode

# Create custom layout
edit ~/.config/zellij/layouts/custom.kdl
```

**Why it matters:** Never lose context. Multiple panes run simultaneously without tab switching.

---

## Git & Version Control

### LazyGit
**TUI for Git**

```bash
# Open LazyGit
lazygit

# Key commands (with mouse support):
# Staging:
#   Space: Stage/unstage file
#   A: Stage all
#   C: Commit
#   P: Push
#   L: Pull

# Navigation:
#   Tab: Switch between panels
#   ↑/↓: Navigate
#   Enter: Drill into item

# Diffs:
#   V: View commit details
#   D: Discard changes
```

**Workflow:**
1. Open LazyGit in right Zellij pane
2. Stage files with Space
3. Review diff before commit
4. Write message with C
5. Push with P

---

## File Management

### Yazi
**Terminal file manager with image previews**

```bash
# Open file manager
yazi

# Key commands:
#   j/k or ↑/↓: Navigate
#   h/l or ←/→: Enter/exit directory
#   Space: Select file/folder
#   y: Copy selected
#   d: Cut selected
#   p: Paste
#   x: Delete (with confirmation)
#   r: Rename
#   :shell <cmd>: Run shell command on selected

# Open file in editor
# Select file and press e
```

**Why it matters:** Visual file browsing with image previews—much faster than `ls` + `cd`.

---

### Bat
**Syntax-highlighted cat replacement**

```bash
# View file with syntax highlighting
bat README.md

# Pipe to less
bat --paging=always largedata.json

# Print specific lines
bat --line-range 10:20 script.sh

# Show non-visible characters
bat -A file.txt

# Set as MANPAGER
export MANPAGER="sh -c 'sed -u 's/./[1m&/2g' | bat -p -lman'"
man ls
```

---

## Development Languages

### Node Version Manager (nvm)
**Switch between Node versions**

```bash
# List installed versions
nvm list

# Install specific version
nvm install 20
nvm install 18

# Use version
nvm use 20

# Set default
nvm alias default 20

# Check current
node --version
```

---

### Python (uv)
**Fast Python package installer**

```bash
# Install Python version
uv python install 3.11

# Create virtual environment
uv venv

# Activate
source .venv/bin/activate

# Install dependencies
uv pip install -r requirements.txt

# Add package
uv pip add requests
```

---

### Go
**Golang support**

```bash
# Check installation
go version

# Create module
go mod init github.com/user/project

# Run code
go run main.go

# Build
go build -o myapp

# Format code
go fmt ./...

# Lint
go vet ./...
```

---

### .NET
**C# and .NET development**

```bash
# Check version
dotnet --version

# Create project
dotnet new console -n MyApp
cd MyApp

# Run
dotnet run

# Build
dotnet build

# Publish
dotnet publish -c Release
```

---

### Rust
**Rust programming language**

```bash
# Check installation
rustc --version
cargo --version

# Create project
cargo new myproject

# Run
cargo run

# Build release
cargo build --release

# Run tests
cargo test
```

---

## Databases & Caching

### PostgreSQL
**Relational database**

```bash
# Connect to database
psql -d mydeveloper -U devuser

# List databases
\l

# Connect to database
\c mydeveloper

# List tables
\dt

# Describe table
\d table_name

# Run query
SELECT * FROM users LIMIT 10;

# Exit
\q

# Backup database
pg_dump -d mydeveloper -U devuser > backup.sql

# Restore database
psql -d mydeveloper -U devuser < backup.sql
```

**GUI Client:** Use Postico 2 for visual browsing and management.

---

### Redis
**In-memory data store**

```bash
# Connect
redis-cli

# Set value
SET key "value"

# Get value
GET key

# List keys
KEYS *

# Delete key
DEL key

# Set expiration
EXPIRE key 3600

# View all data
MONITOR

# Exit
exit or quit
```

---

## API & HTTP Tools

### Yaak
**REST API client (similar to Postman)**

```bash
# Open Yaak
open -a Yaak

# Features:
# - Request history
# - Environment variables
# - Pre/post request scripts
# - Response pretty-printing
# - API documentation
```

**Workflow:**
1. Create workspace for your project
2. Add environment with variables (API keys, URLs)
3. Create requests with variables
4. Test and debug responses

---

## Containers

### Docker
**Containerization platform**

```bash
# Check installation
docker --version

# Run container
docker run -it ubuntu bash

# List containers
docker ps -a

# Build image
docker build -t myimage .

# Push to registry
docker push myimage

# Docker Compose
docker-compose up -d
docker-compose logs -f
docker-compose down
```

---

### OrbStack
**Mac-native Docker alternative**

```bash
# Open OrbStack dashboard
open /Applications/OrbStack.app

# Use as docker replacement
docker ps

# Manage VMs
orbctl machine list
```

**Why:** Better performance on Apple Silicon, integrated with macOS.

---

## Monitoring & Observability

### Btop
**Resource monitor**

```bash
# Open resource monitor
btop

# Key commands:
#   q: Quit
#   + / -: Increase/decrease refresh rate
#   p: Process menu
#   l: Processes list sorting
```

**What it shows:**
- CPU usage per core
- Memory (RAM) usage
- Disk I/O
- Running processes
- Temperature (if available)

---

### Eza
**Modern ls replacement**

```bash
# List files with icons
eza --icons

# Long listing with git status
eza -l --icons --git

# Show all (including hidden)
eza -la --icons --git

# Tree view
eza --tree --icons --level=3
```

**Why it matters:** Color-coded file types, git status integration, and icons make directory listings instantly readable.

---

### fd
**Modern find replacement**

```bash
# Find files by name
fd "config"

# Find specific file types
fd -e js

# Find hidden files too
fd --hidden "env"

# Exclude directories
fd --exclude node_modules "test"

# Execute command on results
fd -e log --exec rm {}
```

**Why it matters:** Respects `.gitignore`, sensible defaults, and integrates with fzf for instant file search.

---

### Zoxide
**Smart directory jumping**

```bash
# Jump to a frequently used directory
z projects

# Interactive selection with fzf
zi

# Add a directory manually
zoxide add ~/projects/myapp

# List known directories
zoxide query --list
```

**Why it matters:** Learns your most-visited directories. `z proj` jumps to `~/projects` without typing the full path.

---

### Git Delta
**Syntax-highlighted git diffs**

```bash
# Automatically used via gitconfig (core.pager = delta)
git diff
git log -p
git show

# Navigate between diff sections
# n = next file, N = previous file (when navigate = true)
```

**Why it matters:** Side-by-side diffs with syntax highlighting, line numbers, and Catppuccin theme. LazyGit picks it up automatically.

---

### jq
**Command-line JSON processor**

```bash
# Pretty-print JSON
cat data.json | jq '.'

# Extract a field
curl -s api/endpoint | jq '.data.name'

# Filter arrays
jq '.items[] | select(.status == "active")' data.json

# Transform output
jq '{name: .user.name, email: .user.email}' response.json
```

**Why it matters:** Essential for working with APIs and JSON config files.

---

### tldr
**Simplified man pages**

```bash
# Get quick examples
tldr tar
tldr git-rebase
tldr docker-compose

# Update local cache
tldr --update
```

**Why it matters:** Shows practical examples instead of 2000 lines of man page.

---

### dust
**Visual disk usage analyzer**

```bash
# Show disk usage for current directory
dust

# Show specific depth
dust -d 2

# Show specific directory
dust ~/projects

# Show number of files
dust -f
```

**Why it matters:** Quickly find what's eating disk space (node_modules, docker images, etc).

---

### FZF
**Fuzzy finder**

```bash
# Find files (Ctrl+T in shell)
# Jump to directory (Alt+C in shell)
# Search command history (Ctrl+R in shell)

# Pipe anything into fzf
git branch | fzf
ls | fzf

# Preview files while searching
fzf --preview 'bat --color=always {}'
```

**Why it matters:** Instant fuzzy search for files, directories, command history, and more. Integrates with fd for speed.

---

### Ripgrep
**Fast text search**

```bash
# Search for pattern
rg "search term"

# Search in specific file type
rg "pattern" -t js

# Search with context
rg -C 3 "pattern"  # 3 lines before and after

# Count matches
rg --count "pattern"

# Show only filenames
rg -l "pattern"

# Case-insensitive
rg -i "pattern"

# Regex search
rg "^\s*function" -t js

# Exclude directories
rg "pattern" --glob !node_modules
```

---

## Browsers

### Brave Browser
**Privacy-focused browser**

```bash
# Open from CLI
open -a Brave

# Features:
# - Built-in adblocker
# - Tracker blocking
# - HTTPS everywhere
# - Tor private windows
# - Developer tools (Chrome-compatible)
```

---

### VS Code
**Code editor**

```bash
# Open project
code ~/projects/myapp

# Open in VS Code from CLI
code -r .

# Useful extensions:
# - Copilot
# - GitLens
# - Thunder Client (API testing)
# - Database extensions
# - Language-specific extensions
```

---

## AI & LLM Tools

### Promptfoo
**LLM testing, evaluation & red-teaming**

```bash
# Install (already in brewfile, or via npm)
brew install promptfoo

# Initialize in your project
promptfoo init

# Run evaluations
promptfoo eval

# Open the web UI to compare results
promptfoo view

# Red-team your LLM app
promptfoo redteam init
promptfoo redteam run
```

**Why it matters:** Test prompts across models, catch regressions, and scan for vulnerabilities before shipping AI features.

- [GitHub](https://github.com/promptfoo/promptfoo)

---

### Heretic
**LLM parameter optimization tool**

```bash
# Install via pip
pip install heretic

# Run with a model name
heretic <model-name>

# Save modified model
# Test interactively after optimization
```

A research CLI tool that applies directional ablation techniques to transformer models for parameter optimization. Supports most dense and MoE architectures with automated tuning via Optuna.

- [GitHub](https://github.com/p-e-w/heretic)

---

### Impeccable
**Design skill for AI coding assistants**

```bash
# Install into your AI assistant's config
# Copy skill files into your project or tool config directory

# Available commands (in AI assistant):
# /audit    - Review UI for design issues
# /polish   - Refine typography, spacing, color
# /critique - Get design feedback
# /animate  - Add motion design
```

A skill package (not a CLI) that enhances AI code assistants with 17 design commands and curated anti-patterns. Covers typography, color, spacing, motion, interaction, responsive design, and UX writing. Fights common LLM design biases.

- [GitHub](https://github.com/pbakaus/impeccable)

---

### OpenViking
**Context database for AI agents**

```bash
# Install via pip
pip install openviking

# Start the server
openviking-server

# CLI interaction
ov_cli <command>

# Python SDK usage
from openviking import Client
client = Client()
```

A unified context management system for AI agents — consolidates memory, resources, and skills into a file-system-like architecture. Supports hierarchical context organization, semantic search, tiered context loading, and automatic session management.

- [GitHub](https://github.com/volcengine/OpenViking)

---

## Quick Reference

### Common Workflows

**Start development session:**
```bash
zdev  # Starts Zellij with 3 panes (AI + Git + Shell)
```

**Check database:**
```bash
psql -d mydeveloper -U devuser
SELECT count(*) FROM users;
\q
```

**View recent changes:**
```bash
lazygit  # In right pane of Zellij
```

**Monitor system:**
```bash
btop  # Open in separate pane
```

**Search codebase:**
```bash
rg "todo" --type js
```

---

## Keyboard Shortcuts

### Terminal (Ghostty)
| Action | Shortcut |
|--------|----------|
| Reload config | Cmd+R |
| New window | Cmd+N |
| New tab | Cmd+T |
| Close tab | Cmd+W |

### Zellij
| Action | Shortcut |
|--------|----------|
| New pane (vertical) | Ctrl+G + N |
| Zoom pane | Ctrl+G + Z |
| Close pane | Ctrl+G + X |
| Move to next pane | Ctrl+G + L/H |
| Resize pane | Ctrl+G + E (then arrow keys) |

### LazyGit (in Zellij)
| Action | Shortcut |
|--------|----------|
| Stage file | Space |
| Stage all | A |
| Commit | C |
| Push | P |
| Pull | L |
| View diff | D |
| Discard changes | D (in unstaged) |

---

## Performance Tips

1. **Use ripgrep instead of grep** — Much faster
2. **Use bat instead of cat** — Syntax highlighting is free
3. **Use lazygit instead of git CLI** — Faster workflow
4. **Use yazi instead of Finder** — Terminal-native navigation
5. **Keep Zellij panes organized** — Don't open too many at once

---

## Resources

- [Ghostty Docs](https://ghostty.org/docs)
- [Zellij Docs](https://zellij.dev/)
- [LazyGit GitHub](https://github.com/jesseduffield/lazygit)
- [Yazi GitHub](https://github.com/soimort/yazi)
- [PostgreSQL Docs](https://www.postgresql.org/docs/)
- [Redis Docs](https://redis.io/documentation)
- [Promptfoo](https://github.com/promptfoo/promptfoo)
- [Heretic](https://github.com/p-e-w/heretic)
- [Impeccable](https://github.com/pbakaus/impeccable)
- [OpenViking](https://github.com/volcengine/OpenViking)
