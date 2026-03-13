# Complete Setup Guide

This guide covers everything needed to set up this AI-native development environment from scratch, including local databases, SSL certificates, and common services.

## Table of Contents

1. [Initial Installation](#initial-installation)
2. [Local Databases](#local-databases)
3. [SSL Certificates](#ssl-certificates)
4. [Local Services](#local-services)
5. [Development Helpers](#development-helpers)
6. [Troubleshooting](#troubleshooting)

---

## Initial Installation

### Step 1: Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Step 2: Clone & Setup

```bash
git clone https://github.com/YOUR_USERNAME/devkit.git ~/devkit
cd ~/devkit
```

### Step 3: Install All Tools

```bash
# Install from Brewfile
brew bundle --file=Brewfile

# Install Node version manager (nvm)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Install Python version manager (uv)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install Rust (if using Rust)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### Step 4: Link Configurations

```bash
# Shell configuration
mkdir -p ~/.config/zsh
ln -sf ~/devkit/.zshrc ~/.zshrc

# Zellij
mkdir -p ~/.config/zellij
ln -sf ~/devkit/zellij/config.kdl ~/.config/zellij/config.kdl
ln -sf ~/devkit/zellij/layouts ~/.config/zellij/layouts

# Ghostty
mkdir -p ~/.config/ghostty
ln -sf ~/devkit/.config/ghostty/config ~/.config/ghostty/config

# Git delta (syntax-highlighted diffs)
# Add to your ~/.gitconfig:
git config --global include.path ~/devkit/.config/git/delta.gitconfig

# Shell enhancements (zoxide, fzf+fd, eza aliases)
# Add to your .zshrc:
echo 'source ~/devkit/.config/shell/enhancements.zsh' >> ~/.zshrc

# SSH (if applicable)
mkdir -p ~/.ssh
chmod 700 ~/.ssh
# Copy any SSH keys if needed
```

### Step 5: Setup Directories

```bash
# Create project workspace
mkdir -p ~/projects
mkdir -p ~/.local/bin
mkdir -p ~/.local/etc

# Copy helper scripts
cp ~/devkit/scripts/* ~/.local/bin/
chmod +x ~/.local/bin/*
```

### Step 6: Verify Installation

```bash
# Check all tools are installed
zellij --version
ghostty --version
lazygit --version
yazi --version
bat --version
rg --version

# Verify new tools
eza --version
fd --version
fzf --version
zoxide --version
delta --version
jq --version
tldr --version
dust --version

# Verify node/python/go
node --version
python --version
go version
```

---

## Local Databases

### PostgreSQL

#### Installation & Setup

```bash
# Install PostgreSQL
brew install postgresql@15

# Start PostgreSQL service
brew services start postgresql@15

# Verify installation
psql --version
```

#### Create Development Database

```bash
# Create a default development database
createdb mydeveloper
createuser devuser -P  # Will prompt for password

# Grant permissions
psql -d mydeveloper -c "GRANT ALL PRIVILEGES ON DATABASE mydeveloper TO devuser;"
```

#### Connection Details

```
Host: localhost
Port: 5432
User: devuser
Password: (your choice)
Database: mydeveloper
```

#### GUI Client

Use **Postico 2** (already in Brewfile) to browse databases visually.

```bash
open -a Postico\ 2
```

---

### Redis

#### Installation & Setup

```bash
# Install Redis
brew install redis

# Start Redis service
brew services start redis

# Verify installation
redis-cli ping
# Expected output: PONG
```

#### Test Connection

```bash
# Connect to Redis
redis-cli

# In the Redis CLI:
SET testkey "Hello Redis"
GET testkey
```

---

### MongoDB (Optional)

```bash
# Install MongoDB
brew install mongodb-community

# Start MongoDB
brew services start mongodb-community

# Verify connection
mongosh

# In mongosh:
db.adminCommand('ping')
```

---

## SSL Certificates

### Generate Self-Signed Certificates

For local development, use the provided script:

```bash
~/.local/bin/setup-ssl.sh

# Or manually:
mkdir -p ~/.local/etc/ssl
cd ~/.local/etc/ssl

# Generate private key
openssl genrsa -out localhost.key 2048

# Generate certificate (10 years)
openssl req -new -x509 -key localhost.key -out localhost.crt -days 3650 \
  -subj "/C=US/ST=State/L=City/O=Dev/CN=localhost"
```

### Add Certificate to macOS Keychain

```bash
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ~/.local/etc/ssl/localhost.crt
```

### Use in Local Development

```bash
# For Node.js
const https = require('https');
const fs = require('fs');

const options = {
  key: fs.readFileSync(process.env.HOME + '/.local/etc/ssl/localhost.key'),
  cert: fs.readFileSync(process.env.HOME + '/.local/etc/ssl/localhost.crt')
};

https.createServer(options, app).listen(3000);
```

```python
# For Python (Flask)
from flask import Flask
app = Flask(__name__)

if __name__ == '__main__':
    app.run(ssl_context=(
        os.path.expanduser('~/.local/etc/ssl/localhost.crt'),
        os.path.expanduser('~/.local/etc/ssl/localhost.key')
    ))
```

---

## Local Services

### Quick Start All Services

```bash
# Start all services at once
~/.local/bin/start-services.sh

# Or individually:
brew services start postgresql@15
brew services start redis
brew services start docker
```

### Stop Services

```bash
~/.local/bin/stop-services.sh

# Or individually:
brew services stop postgresql@15
brew services stop redis
brew services stop docker
```

### Check Service Status

```bash
brew services list
```

---

## Development Helpers

### Environment Variables

Copy the template and customize:

```bash
cp ~/devkit/.env.example ~/.env
source ~/.env
```

Example `.env` file:

```bash
# Database
DB_HOST=localhost
DB_PORT=5432
DB_USER=devuser
DB_PASSWORD=your_password
DB_NAME=mydeveloper

# Redis
REDIS_URL=redis://localhost:6379

# Development
NODE_ENV=development
PYTHON_ENV=development
DEBUG=true

# API Keys (populate as needed)
OPENAI_API_KEY=
ANTHROPIC_API_KEY=
GEMINI_API_KEY=

# Local Services
SSL_CERT=$HOME/.local/etc/ssl/localhost.crt
SSL_KEY=$HOME/.local/etc/ssl/localhost.key
```

### Quick Aliases

Add to your shell config (`.zshrc`):

```bash
alias db-connect='psql -d mydeveloper -U devuser'
alias db-dump='pg_dump -d mydeveloper -U devuser > ~/backup.sql'
alias db-restore='psql -d mydeveloper -U devuser < ~/backup.sql'
alias redis-cli='redis-cli -h localhost -p 6379'
alias services-status='brew services list'
alias dev-logs='tail -f ~/.local/var/logs/dev.log'
```

### Port Management

Common development ports:

| Service | Port | Start Command |
|---------|------|---------------|
| PostgreSQL | 5432 | `brew services start postgresql@15` |
| Redis | 6379 | `brew services start redis` |
| Node.js App | 3000 | `npm run dev` |
| Python App | 8000 | `python -m uvicorn app:app` |
| Docker | 2375 | `brew services start docker` |
| Local HTTPS | 3443 | `node server.js` |

### Check if Port is in Use

```bash
lsof -i :3000  # Check if port 3000 is in use
kill -9 <PID>  # Kill process if needed
```

---

## Troubleshooting

### PostgreSQL Won't Start

```bash
# Check if already running
brew services list | grep postgresql

# Restart
brew services restart postgresql@15

# Check logs
tail -f /opt/homebrew/var/log/postgresql@15.log
```

### Redis Connection Issues

```bash
# Verify Redis is running
redis-cli ping

# Check if port 6379 is in use
lsof -i :6379

# Restart
brew services restart redis
```

### SSL Certificate Not Trusted

```bash
# Re-add to keychain
sudo security delete-certificate -c "localhost" /Library/Keychains/System.keychain
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ~/.local/etc/ssl/localhost.crt
```

### Zellij Layout Issues

```bash
# Reload layout
zellij action new-tab --layout ~/devkit/zellij/layouts/main.kdl

# Reset to default
rm -rf ~/.config/zellij
ln -sf ~/devkit/zellij ~/.config/zellij
```

### Port Already in Use

```bash
# Find and kill process
lsof -i :PORT_NUMBER
kill -9 <PID>

# Or use different port in development
```

---

## Environment-Specific Setup

### For Python Projects

```bash
# Install Python version
uv python install 3.11

# Create virtual environment
uv venv

# Activate
source .venv/bin/activate
```

### For Node Projects

```bash
# Install Node version
nvm install 20

# Use it
nvm use 20

# Verify
node --version
```

### For Go Projects

```bash
# Verify Go installation
go version

# Initialize module
go mod init github.com/yourusername/projectname
```

### For .NET Projects

```bash
# Verify .NET installation
dotnet --version

# Create new project
dotnet new console -n MyProject
cd MyProject
dotnet run
```

---

## Next Steps

1. **Read [TOOLS.md](TOOLS.md)** — Deep dive into each tool
2. **Check [CHEATSHEET.md](CHEATSHEET.md)** — Keyboard shortcuts and workflows
3. **Review [TROUBLESHOOTING.md](TROUBLESHOOTING.md)** — Common issues
4. **Explore AI Agents** — See [`opencode/aig_agents/`](opencode/aig_agents/) for agent configs

Happy hacking! 🚀
