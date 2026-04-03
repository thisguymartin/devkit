#!/bin/bash
set -e

# OpenCode + Copilot Pro Setup
# Symlinks devkit agent configs and installs CLI tools

DEVKIT="${DEVKIT_PATH:-$HOME/personal-workspace/devkit}"

echo "Setting up OpenCode + Copilot Pro..."
echo "Using devkit at: $DEVKIT"

# --- OpenCode Agents ---
# Symlink agent definitions (single source of truth in devkit repo)
mkdir -p ~/.config/opencode
if [ -L ~/.config/opencode/agents ]; then
    rm ~/.config/opencode/agents
fi
ln -sf "$DEVKIT/opencode/aig_agents" ~/.config/opencode/agents
echo "✓ Linked OpenCode agents → ~/.config/opencode/agents"

# --- OpenCode Config ---
# Symlink opencode.json for global defaults (model routing, MCP servers)
if [ -L ~/.config/opencode/config.json ]; then
    rm ~/.config/opencode/config.json
fi
ln -sf "$DEVKIT/opencode.json" ~/.config/opencode/config.json
echo "✓ Linked OpenCode config → ~/.config/opencode/config.json"

# --- Cost-Awareness Rule ---
# Symlink to .claude/rules/ (follows existing devkit pattern)
if [ -d "$DEVKIT/.claude/rules" ]; then
    ln -sf "../../skills/rules/cost-awareness.md" "$DEVKIT/.claude/rules/cost-awareness.md" 2>/dev/null || true
    echo "✓ Linked cost-awareness rule → .claude/rules/"
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
[ -L ~/.config/opencode/config.json ] && echo "✓ Config symlinked" || echo "✗ Config not linked"
echo ""
echo "OpenCode + Copilot Pro setup complete."
echo "Run 'opencode' to start, or use 'oc' alias after sourcing shell enhancements."
