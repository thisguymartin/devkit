# Troubleshooting Guide

Common issues and solutions for the AI-native development environment.

## Table of Contents

1. [Installation Issues](#installation-issues)
2. [Tool-Specific Issues](#tool-specific-issues)
3. [Database Problems](#database-problems)
4. [Shell & Configuration](#shell--configuration)
5. [Performance Issues](#performance-issues)
6. [SSL/TLS Issues](#ssltls-issues)

---

## Installation Issues

### Homebrew Installation Fails

**Problem:** `brew install` fails with permission errors

**Solution:**
```bash
# Fix Homebrew permissions
sudo chown -R $(whoami) /opt/homebrew
sudo chown -R $(whoami) /opt/homebrew/Cellar
chmod u+w /opt/homebrew
chmod u+w /opt/homebrew/Cellar

# Re-run install
brew install packagename
```

---

### Brew Bundle Fails

**Problem:** `brew bundle` fails on some packages

**Solution:**
```bash
# Install Homebrew taps if needed
brew tap homebrew/cask-fonts
brew tap homebrew/services

# Run bundle again
brew bundle --file=Brewfile

# Or install packages individually
brew install zellij
brew install lazygit
# etc...
```

---

### M1/M2 Apple Silicon Issues

**Problem:** Some tools don't work on Apple Silicon

**Solution:**
```bash
# Check architecture
uname -m

# For Intel-only apps, use Rosetta 2
# Homebrew handles this automatically for most packages

# Check if app is running under Rosetta
sysctl sysctl.proc_translated
```

---

## Tool-Specific Issues

### Zellij Won't Start

**Problem:** Zellij exits immediately or won't open

**Solution:**
```bash
# Check if zellij is installed
which zellij

# Reinstall
brew uninstall zellij
brew install zellij

# Check for config issues
rm -rf ~/.config/zellij
mkdir -p ~/.config/zellij
ln -sf ~/devkit/zellij ~/.config/zellij

# Start with default layout
zellij
```

---

### LazyGit Keybindings Not Working

**Problem:** Arrow keys or keybindings don't work in LazyGit

**Solution:**
```bash
# Check terminal settings
echo $TERM

# Set to xterm-256color
export TERM=xterm-256color

# Add to .zshrc
echo 'export TERM=xterm-256color' >> ~/.zshrc
source ~/.zshrc

# Reset LazyGit config
rm -rf ~/.config/lazygit
lazygit  # Will regenerate config
```

---

### Yazi File Preview Not Working

**Problem:** Images/previews not showing in Yazi

**Solution:**
```bash
# Install image preview dependencies
brew install ffmpeg imagemagick

# Restart Yazi
yazi

# Enable preview in config
edit ~/.config/yazi/yazi.toml
# Set: [preview] enabled = true
```

---

### Ghostty Config Not Loading

**Problem:** Ghostty ignores config changes

**Solution:**
```bash
# Check config location
cat ~/.config/ghostty/config

# Reload config
# Use: Cmd+R (if set in config) or restart Ghostty

# If symlink issue:
rm ~/.config/ghostty/config
ln -sf ~/devkit/.config/ghostty/config ~/.config/ghostty/config
```

---

## Database Problems

### PostgreSQL Won't Start

**Problem:** `brew services start postgresql@15` fails

**Solution:**
```bash
# Check status
brew services list | grep postgresql

# Check logs
tail -f /opt/homebrew/var/log/postgresql@15.log

# Full restart
brew services stop postgresql@15
sleep 2
brew services start postgresql@15

# If still fails, reset database
rm -rf /opt/homebrew/var/postgresql@15
brew services restart postgresql@15

# Reinitialize
initdb -D /opt/homebrew/var/postgresql@15
```

---

### PostgreSQL Connection Refused

**Problem:** `psql: could not connect to server`

**Solution:**
```bash
# Check if service is running
brew services list | grep postgresql

# Verify port
lsof -i :5432

# Check socket directory
ls /tmp/.s.PGSQL.5432

# Connect with explicit host
psql -h localhost -d mydeveloper -U devuser

# Or use socket
psql -d mydeveloper -U devuser
```

---

### Redis Connection Issues

**Problem:** `redis-cli: Could not connect to Redis`

**Solution:**
```bash
# Verify Redis is running
brew services list | grep redis

# Check port
redis-cli ping

# If no response, restart
brew services restart redis

# Check port in use
lsof -i :6379

# Kill and restart if needed
kill -9 <PID>
brew services start redis
```

---

### Database Already Exists Error

**Problem:** `createdb: error: database "mydeveloper" already exists`

**Solution:**
```bash
# List databases
psql -l | grep mydeveloper

# Drop and recreate
dropdb mydeveloper
createdb mydeveloper

# Or just use existing database
psql -d mydeveloper -U devuser
```

---

### Wrong Database Credentials

**Problem:** `psql: FATAL: role "devuser" does not exist`

**Solution:**
```bash
# Connect as default user
psql -d postgres

# Create user
CREATE USER devuser WITH PASSWORD 'your_password';

# Grant privileges
GRANT ALL PRIVILEGES ON DATABASE mydeveloper TO devuser;

# Try again
psql -d mydeveloper -U devuser
```

---

## Shell & Configuration

### .zshrc Not Loading

**Problem:** Shell config doesn't apply on new terminal

**Solution:**
```bash
# Check .zshrc exists
ls -la ~/.zshrc

# Verify it's being sourced
echo $SHELL  # Should be /bin/zsh

# Reload
source ~/.zshrc

# Or restart terminal
exec zsh

# Check for syntax errors
zsh -n ~/.zshrc
```

---

### Symlinks Not Working

**Problem:** Configuration symlinks broken

**Solution:**
```bash
# Check symlink
ls -l ~/.zshrc
# Should show: ~/.zshrc -> ~/devkit/.zshrc

# Fix broken symlink
rm ~/.zshrc
ln -sf ~/devkit/.zshrc ~/.zshrc

# Verify
ls -l ~/.zshrc
```

---

### Path Issues

**Problem:** Commands not found (e.g., `zellij`, `lazygit`)

**Solution:**
```bash
# Check PATH
echo $PATH

# Verify Homebrew is in PATH
which brew

# If not, add to .zshrc
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
source ~/.zshrc

# Verify installation
which zellij
which lazygit
```

---

## Performance Issues

### High CPU Usage

**Problem:** Zellij or terminal using lots of CPU

**Solution:**
```bash
# Check what's using CPU
btop

# Close unnecessary panes in Zellij
# Press Ctrl+g + X to close pane

# Reduce update frequency
# In Zellij config, reduce refresh rate

# Restart Zellij
exit
zellij
```

---

### Terminal Slow When Listing Files

**Problem:** `ls` or `yazi` is slow

**Solution:**
```bash
# Use ripgrep instead for searching
rg "pattern" --type js

# Use yazi instead of ls
yazi

# Check for slow disk
iostat -w 1

# Exclude slow directories from monitoring
# In ripgrep: rg --glob !node_modules
```

---

### Memory Leak in Services

**Problem:** PostgreSQL or Redis using excessive memory

**Solution:**
```bash
# Check memory usage
btop

# Restart service
brew services restart postgresql@15
brew services restart redis

# Check for large databases
psql -d mydeveloper -U devuser
SELECT schemaname, tablename, pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) FROM pg_tables ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

# Clear old logs
rm -rf /opt/homebrew/var/log/*.log
```

---

## SSL/TLS Issues

### Certificate Not Trusted

**Problem:** Browser shows certificate warning

**Solution:**
```bash
# Regenerate certificate
~/.local/bin/setup-ssl.sh

# Add to Keychain manually
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain \
  $HOME/.local/etc/ssl/localhost.crt

# Restart browser to clear cache
```

---

### Certificate Expired

**Problem:** SSL certificate is expired

**Solution:**
```bash
# Check expiration
openssl x509 -in ~/.local/etc/ssl/localhost.crt -noout -dates

# Regenerate (valid for 10 years)
~/.local/bin/setup-ssl.sh

# Update environment variables
export SSL_CERT=$HOME/.local/etc/ssl/localhost.crt
export SSL_KEY=$HOME/.local/etc/ssl/localhost.key
```

---

### Port Already in Use

**Problem:** `Address already in use` error

**Solution:**
```bash
# Find process using port
lsof -i :3000

# Kill the process
kill -9 <PID>

# Or use different port
PORT=3001 npm run dev

# Check what services are using ports
netstat -an | grep LISTEN
```

---

## General Debugging

### Enable Debug Mode

```bash
# For most tools
DEBUG=true zellij

# For Node.js apps
DEBUG=* npm run dev

# For Python apps
python -m pdb script.py

# For shell scripts
bash -x script.sh
```

---

### Check System Health

```bash
# Overall system
system_profiler SPSoftwareDataType

# Disk usage
df -h

# Memory usage
free -h  # or use btop

# Open files/connections
lsof | wc -l

# Check uptime
uptime
```

---

### Collect System Info for Help

When asking for help, run this to get system info:

```bash
echo "=== System ===" && \
sw_vers && \
echo "=== Homebrew ===" && \
brew config && \
echo "=== Tools ===" && \
zellij --version && \
lazygit --version && \
psql --version && \
redis-cli --version && \
echo "=== Node ===" && \
node --version && \
echo "=== Python ===" && \
python --version
```

---

## Getting Help

If issues persist:

1. Check tool documentation (links in [TOOLS.md](TOOLS.md))
2. Search GitHub issues for the tool
3. Post to the tool's community/forum
4. Run diagnostics script above and share output

Common help resources:
- **Zellij:** https://github.com/zellij-org/zellij/issues
- **LazyGit:** https://github.com/jesseduffield/lazygit/issues
- **PostgreSQL:** https://stackoverflow.com/questions/tagged/postgresql
- **Redis:** https://github.com/redis/redis/issues
