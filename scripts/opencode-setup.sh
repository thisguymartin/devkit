#!/bin/bash
set -e

# OpenCode + Copilot Pro Setup
# Symlinks devkit agent configs and installs CLI tools

DEVKIT="${DEVKIT_PATH:-$HOME/personal-workspace/devkit}"

echo "Setting up OpenCode + Copilot Pro..."
echo "Using devkit at: $DEVKIT"

# --- Ensure config directory exists ---
mkdir -p ~/.config/opencode

# --- Clean up stale manual configs ---
BACKUP_DIR="$HOME/.config/opencode/.backup-$(date +%Y%m%d-%H%M%S)"
NEEDS_BACKUP=false

for stale in \
    "$HOME/.config/opencode/agent" \
    "$HOME/.config/opencode/agents" \
    "$HOME/.config/opencode/config.json" \
    "$HOME/.config/opencode/opencode.json"; do
    if [ -e "$stale" ] && [ ! -L "$stale" ]; then
        NEEDS_BACKUP=true
        break
    fi
done

if $NEEDS_BACKUP; then
    echo "Backing up stale configs to $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    for stale in \
        "$HOME/.config/opencode/agent" \
        "$HOME/.config/opencode/agents" \
        "$HOME/.config/opencode/config.json" \
        "$HOME/.config/opencode/opencode.json"; do
        if [ -e "$stale" ] && [ ! -L "$stale" ]; then
            mv "$stale" "$BACKUP_DIR/"
            echo "  Moved $(basename "$stale") → backup"
        fi
    done
fi

# Remove stale symlinks from previous script versions (wrong names)
for old_link in \
    "$HOME/.config/opencode/agent" \
    "$HOME/.config/opencode/config.json"; do
    if [ -L "$old_link" ]; then
        rm "$old_link"
        echo "  Removed stale symlink: $(basename "$old_link")"
    fi
done

# --- OpenCode Agents ---
if [ -L ~/.config/opencode/agents ]; then
    rm ~/.config/opencode/agents
fi
ln -sf "$DEVKIT/opencode/aig_agents" ~/.config/opencode/agents
echo "✓ Linked OpenCode agents → ~/.config/opencode/agents"

# --- OpenCode Config ---
if [ -L ~/.config/opencode/opencode.json ]; then
    rm ~/.config/opencode/opencode.json
fi
ln -sf "$DEVKIT/opencode.json" ~/.config/opencode/opencode.json
echo "✓ Linked OpenCode config → ~/.config/opencode/opencode.json"

# --- OpenCode TUI Config ---
if [ -L ~/.config/opencode/tui.json ]; then
    rm ~/.config/opencode/tui.json
fi
ln -sf "$DEVKIT/opencode/tui.json" ~/.config/opencode/tui.json
echo "✓ Linked OpenCode TUI config → ~/.config/opencode/tui.json"

# --- Repo Claude Rules ---
if [ -d "$DEVKIT/.claude/rules" ]; then
    ln -sf "../../skills/rules/cost-awareness.md" "$DEVKIT/.claude/rules/cost-awareness.md" 2>/dev/null || true
    ln -sf "../../skills/rules/personal-profile.md" "$DEVKIT/.claude/rules/personal-profile.md" 2>/dev/null || true
    echo "✓ Linked Claude rules → .claude/rules/"
fi

# --- Copilot CLI ---
if command -v gh &> /dev/null; then
    if ! gh extension list 2>/dev/null | grep -q "gh-copilot"; then
        echo "Installing GitHub Copilot CLI extension..."
        gh extension install github/gh-copilot 2>/dev/null || echo "⚠ Could not install gh-copilot (may need 'gh auth login' first)"
    else
        echo "✓ GitHub Copilot CLI already installed"
    fi
else
    echo "⚠ gh CLI not found. Install with: brew install gh"
fi

# --- Tokenscope Plugin ---
if command -v npm &> /dev/null; then
    if ! npm list -g @ramtinj95/opencode-tokenscope &> /dev/null; then
        echo "Installing opencode-tokenscope plugin..."
        npm install -g @ramtinj95/opencode-tokenscope 2>/dev/null || echo "⚠ Could not install tokenscope (npm required)"
    else
        echo "✓ opencode-tokenscope already installed"
    fi
else
    echo "⚠ npm not found. Install Node.js first (nvm install --lts)"
fi

# --- Verify ---
echo ""
echo "--- Setup Summary ---"
command -v opencode &> /dev/null && echo "✓ OpenCode installed" || echo "✗ OpenCode not found (brew install anomalyco/tap/opencode)"
command -v gh &> /dev/null && echo "✓ GitHub CLI installed" || echo "✗ GitHub CLI not found"
[ -L ~/.config/opencode/agents ] && echo "✓ Agents symlinked" || echo "✗ Agents not linked"
[ -L ~/.config/opencode/opencode.json ] && echo "✓ Config symlinked" || echo "✗ Config not linked"
[ -L ~/.config/opencode/tui.json ] && echo "✓ TUI config symlinked" || echo "✗ TUI config not linked"
echo ""
echo "OpenCode + Copilot Pro setup complete."
echo "Run 'opencode' to start, or use 'oc' alias after sourcing shell enhancements."
