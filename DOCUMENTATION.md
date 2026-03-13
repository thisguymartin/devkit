# Documentation Index

Welcome to the complete documentation for devkit. Start here to understand what's available.

## 🚀 Getting Started

**New to this environment?** Start here:

1. **[SETUP.md](SETUP.md)** - Complete installation and configuration guide
   - Initial installation steps
   - Database setup (PostgreSQL, Redis)
   - SSL certificate generation
   - Environment variable configuration

2. **Run the setup script** (after cloning):
   ```bash
   ./scripts/setup-all.sh
   ```

---

## 📚 Core Documentation

### [README.md](README.md)
**Project Overview**
- What this environment is
- Core stack overview
- AI agent workforce
- Quick installation summary

### [SETUP.md](SETUP.md)
**Complete Setup Guide**
- Step-by-step installation
- Local database setup
  - PostgreSQL configuration
  - Redis setup
  - MongoDB (optional)
- SSL certificate generation
- Local services management
- Environment variable setup
- Development helpers
- Troubleshooting initial setup

### [TOOLS.md](TOOLS.md)
**Tool Reference Guide**
- Deep dive into each tool
- Command reference for every tool
- Keyboard shortcuts
- Common workflows
- Performance tips
- Quick reference tables

### [CHEATSHEET.md](CHEATSHEET.md)
**Keyboard Shortcuts & Quick Commands**
- Terminal keybindings
- Zellij pane management
- LazyGit navigation
- Common aliases

### [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
**Problem Solving**
- Installation issues
- Tool-specific problems
- Database troubleshooting
- Shell configuration issues
- Performance optimization
- SSL/TLS debugging
- System health checks

---

## 🛠 Helper Scripts

All scripts are in `/scripts/` and copied to `~/.local/bin/` during setup.

### Setup Scripts

```bash
# Complete setup (runs all below)
setup-all.sh

# Database setup
setup-db.sh
# Initializes PostgreSQL and Redis

# SSL certificates
setup-ssl.sh
# Generates self-signed certificates for HTTPS development

# Service management
start-services.sh    # Start PostgreSQL, Redis, Docker
stop-services.sh     # Stop all services
```

### Make Scripts Executable

```bash
chmod +x ~/.local/bin/*.sh
```

### Usage Examples

```bash
# Setup from scratch
~/devkit/scripts/setup-all.sh

# Setup just databases
~/.local/bin/setup-db.sh

# Generate SSL certs
~/.local/bin/setup-ssl.sh

# Start services
~/.local/bin/start-services.sh

# Stop services
~/.local/bin/stop-services.sh
```

---

## 📋 Configuration Files

### `.env.example`
Template for environment variables. Copy to `~/.env` and fill in values.

**Includes:**
- Database connection strings
- API keys (OpenAI, Anthropic, Gemini, GitHub)
- SSL certificate paths
- Application configuration

```bash
cp .env.example ~/.env
nano ~/.env  # Edit with your values
```

### `.config/ghostty/config`
Ghostty terminal configuration. Includes:
- Font size and styling
- Mouse behavior
- Reload config keybinding
- Theme (Catppuccin)
- Cursor style (bar, no blink)
- Window padding and state persistence
- Copy-on-select

### `.config/git/delta.gitconfig`
Git delta configuration for syntax-highlighted diffs. Includes:
- Side-by-side diffs with line numbers
- Catppuccin Mocha syntax theme
- Navigate mode (n/N to jump between files)
- Histogram diff algorithm
- zdiff3 merge conflict style

### `.config/shell/enhancements.zsh`
Shell enhancements (source in .zshrc). Includes:
- Zoxide init (smart cd with `z` and `zi`)
- FZF + fd integration (fast file/dir search with previews)
- Catppuccin Mocha colors for fzf
- eza aliases (ls, ll, la, tree)
- Quick navigation (.., ..., ....)
- Zellij layout aliases (ztest, zmig, zapi, zpipe, zdebug, zmon, zdb)

### `zellij/` directory
Zellij window manager configuration and layouts:
- `layouts/monitor.kdl` - Monitor layout (btop + logs + Docker)
- `layouts/database.kdl` - Database layout (PostgreSQL + Redis)
- `config.kdl` - Zellij keybindings and settings

### `.zshrc` (if present)
Shell configuration with:
- Tool initialization
- Aliases
- Functions
- Environment setup

---

## 🚀 Quick Start Commands

```bash
# Clone and setup
git clone <repo> ~/devkit
cd ~/devkit
./scripts/setup-all.sh

# Edit environment variables
nano ~/.env

# Reload shell
source ~/.zshrc

# Start services
start-services.sh

# Launch a layout
ztest

# Check service status
brew services list
```

---

## 📱 Daily Workflows

### Starting Your Dev Session

```bash
# Start all services
start-services.sh

# Launch a Zellij layout
ztest   # Test runner
zapi    # API dev workspace
```

### Checking Database Status

```bash
# PostgreSQL
psql -d mydeveloper -U devuser

# Redis
redis-cli

# MongoDB (if setup)
mongosh
```

### Stopping Everything

```bash
# Stop services
stop-services.sh

# Exit Zellij
exit  # In Zellij pane
```

---

## 🔧 Advanced Configuration

### Custom Aliases

Add to `.zshrc`:

```bash
alias db-start='brew services start postgresql@15'
alias db-stop='brew services stop postgresql@15'
alias redis-start='brew services start redis'
alias dev='cd ~/projects && zdev'
alias logs='tail -f ~/.local/var/logs/dev.log'
```

### Custom Zellij Layouts

Create layout in `~/.config/zellij/layouts/custom.kdl`:

```kdl
layout {
    pane split_direction="horizontal" {
        pane command="zsh"
        pane command="lazygit" size="30%"
    }
}
```

Use with: `zellij --layout ~/.config/zellij/layouts/custom.kdl`

### Environment-Specific Setup

Create environment-specific `.env` files:

```bash
.env                 # Local development (git-ignored)
.env.production      # Production config
.env.staging         # Staging config
.env.test            # Test database
```

---

## 📊 Documentation Map

```
PROJECT/
├── README.md                    ← Project overview
├── SETUP.md                     ← Installation & config
├── TOOLS.md                     ← Tool reference
├── CHEATSHEET.md                ← Keyboard shortcuts
├── TROUBLESHOOTING.md           ← Problem solving
├── DOCUMENTATION.md             ← This file
│
├── scripts/
│   ├── setup-all.sh            ← Master setup
│   ├── setup-db.sh             ← Database setup
│   ├── setup-ssl.sh            ← SSL generation
│   ├── start-services.sh        ← Start services
│   └── stop-services.sh         ← Stop services
│
├── .env.example                 ← Environment template
├── .zshrc (if present)          ← Shell config
├── .config/
│   ├── ghostty/config           ← Terminal config
│   ├── git/delta.gitconfig      ← Git delta config
│   └── shell/enhancements.zsh  ← Shell enhancements
│
└── zellij/
    ├── config.kdl               ← Zellij config
    └── layouts/
        ├── testrunner.kdl       ← Test runner + watch
        ├── migrations.kdl       ← DB migrations + queries
        ├── api.kdl              ← API development
        ├── pipeline.kdl         ← CI/CD + deploy
        ├── debug.kdl            ← Debug + floating notes
        ├── monitor.kdl          ← System monitor
        └── database.kdl         ← Database consoles
```

---

## 🤖 AI Agents

See [`opencode/aig_agents/`](opencode/aig_agents/) for specialized AI agents.

Current agents:
- **Advisor** - Task routing
- **Architect** - System design
- **Engineer** - Feature implementation
- **Lead Dev** - Fast fixes
- **QA** - Test generation
- **Reviewer** - Code review
- **Security** - Vulnerability scanning
- **Linear** - Project management

Invoke with: `@agent-name` in OpenCode

---

## 🔗 External Resources

### Tool Documentation
- [Ghostty](https://ghostty.org/docs)
- [Zellij](https://zellij.dev/documentation)
- [LazyGit](https://github.com/jesseduffield/lazygit)
- [Yazi](https://yazi-rs.github.io/)
- [Ripgrep](https://github.com/BurntSushi/ripgrep)

### Database Docs
- [PostgreSQL](https://www.postgresql.org/docs/)
- [Redis](https://redis.io/documentation)
- [MongoDB](https://docs.mongodb.com/)

### Language Docs
- [Node.js](https://nodejs.org/docs/)
- [Python](https://docs.python.org/)
- [Go](https://go.dev/doc/)
- [.NET](https://learn.microsoft.com/en-us/dotnet/)
- [Rust](https://doc.rust-lang.org/)

---

## 📝 File Structure by Purpose

### For Installation
1. Start: [SETUP.md](SETUP.md)
2. Run: `./scripts/setup-all.sh`
3. Configure: Edit `~/.env`

### For Daily Use
1. Reference: [TOOLS.md](TOOLS.md)
2. Shortcuts: [CHEATSHEET.md](CHEATSHEET.md)
3. Workflow: Use Zellij panes

### For Troubleshooting
1. First: [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
2. Then: Check [SETUP.md](SETUP.md) relevant section
3. Last: Search tool's GitHub issues

### For Learning
1. Overview: [README.md](README.md)
2. Details: [TOOLS.md](TOOLS.md)
3. Deep Dive: Tool's official docs

---

## ✅ Setup Checklist

After running `setup-all.sh`, verify:

- [ ] All Homebrew tools installed: `brew list | grep -E "(zellij|lazygit|yazi|starship|btop|bat|ripgrep|eza|fd|fzf|zoxide|git-delta|jq|tldr|dust)"`
- [ ] PostgreSQL running: `brew services list | grep postgresql`
- [ ] Redis running: `redis-cli ping`
- [ ] SSL certificates generated: `ls ~/.local/etc/ssl/`
- [ ] Environment file created: `ls ~/.env`
- [ ] Configurations symlinked: `ls -l ~/.config/zellij ~/.config/ghostty`
- [ ] Shell reloaded: `echo $SHELL` should be `/bin/zsh`
- [ ] Scripts executable: `ls -la ~/.local/bin/*.sh`

---

## 🆘 Getting Help

**For setup issues:**
1. Read [SETUP.md](SETUP.md) - Step-by-step guide
2. Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Common solutions

**For tool questions:**
1. Read [TOOLS.md](TOOLS.md) - Complete reference
2. Check [CHEATSHEET.md](CHEATSHEET.md) - Keyboard shortcuts
3. Visit tool's official documentation (links in [TOOLS.md](TOOLS.md))

**For workflow issues:**
1. Check [CHEATSHEET.md](CHEATSHEET.md) for shortcuts
2. Read relevant section in [TOOLS.md](TOOLS.md)
3. Try command: `man <toolname>`

---

## 🎯 Where to Go Next

- **Want to start?** → [SETUP.md](SETUP.md)
- **Need help using tools?** → [TOOLS.md](TOOLS.md)
- **Forgot a shortcut?** → [CHEATSHEET.md](CHEATSHEET.md)
- **Something broke?** → [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- **Quick reference?** → [TOOLS.md](TOOLS.md)

---

Last updated: 2026-03-13
