#!/bin/bash
set -e

# Devkit Master Setup
# Clone, install, symlink, go.
#
# Usage:
#   ./scripts/setup.sh          # Full setup
#   ./scripts/setup.sh --check  # Verify only, no changes

DEVKIT="${DEVKIT_PATH:-$(cd "$(dirname "$0")/.." && pwd)}"
CHECK_ONLY=false

if [ "$1" = "--check" ]; then
    CHECK_ONLY=true
fi

ok()   { echo "  ✓ $1"; }
warn() { echo "  ⚠ $1"; }
fail() { echo "  ✗ $1"; }
step() { echo ""; echo "── $1 ──"; }

link_safe() {
    local src="$1"
    local dst="$2"
    local label="$3"

    if $CHECK_ONLY; then
        if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
            ok "$label (linked)"
        elif [ -e "$dst" ]; then
            warn "$label exists but is not a symlink to devkit"
        else
            fail "$label not linked"
        fi
        return
    fi

    mkdir -p "$(dirname "$dst")"
    if [ -L "$dst" ]; then
        rm "$dst"
    elif [ -e "$dst" ]; then
        echo "    Backing up existing $dst → ${dst}.bak"
        mv "$dst" "${dst}.bak"
    fi
    ln -sf "$src" "$dst"
    ok "$label"
}

# ─── Homebrew Packages ─────────────────────────────────────────────────────────

step "Homebrew packages"

if ! command -v brew &> /dev/null; then
    fail "Homebrew not installed (https://brew.sh)"
    exit 1
fi

if $CHECK_ONLY; then
    ok "Homebrew installed"
else
    echo "  Running brew bundle..."
    brew bundle --file="$DEVKIT/brewfile" --no-lock --quiet
    ok "Packages installed"
fi

# ─── Shell Enhancements ───────────────────────────────────────────────────────

step "Shell enhancements"

ZSHRC="$HOME/.zshrc"
SOURCE_LINE="source \"$DEVKIT/.config/shell/enhancements.zsh\""

if $CHECK_ONLY; then
    if [ -f "$ZSHRC" ] && grep -qF "enhancements.zsh" "$ZSHRC"; then
        ok "Shell enhancements sourced in .zshrc"
    else
        fail "Shell enhancements not in .zshrc"
    fi
else
    if [ -f "$ZSHRC" ] && grep -qF "enhancements.zsh" "$ZSHRC"; then
        ok "Already sourced in .zshrc"
    else
        echo "" >> "$ZSHRC"
        echo "# devkit shell enhancements" >> "$ZSHRC"
        echo "$SOURCE_LINE" >> "$ZSHRC"
        ok "Added source line to .zshrc"
    fi
fi

# ─── Ghostty ──────────────────────────────────────────────────────────────────

step "Ghostty terminal"

link_safe "$DEVKIT/.config/ghostty/config" "$HOME/.config/ghostty/config" "Ghostty config"

# ─── Starship Prompt ──────────────────────────────────────────────────────────

step "Starship prompt"

link_safe "$DEVKIT/.config/starship/starship.toml" "$HOME/.config/starship.toml" "Starship config"

# ─── Git Delta ────────────────────────────────────────────────────────────────

step "Git delta"

if $CHECK_ONLY; then
    if git config --global --get include.path 2>/dev/null | grep -q "delta.gitconfig"; then
        ok "Delta gitconfig included"
    else
        fail "Delta gitconfig not included in ~/.gitconfig"
    fi
else
    DELTA_PATH="$DEVKIT/.config/git/delta.gitconfig"
    if git config --global --get-all include.path 2>/dev/null | grep -qF "$DELTA_PATH"; then
        ok "Delta gitconfig already included"
    else
        git config --global --add include.path "$DELTA_PATH"
        ok "Added delta.gitconfig to git includes"
    fi
fi

# ─── Claude Code ──────────────────────────────────────────────────────────────

step "Claude Code"

# Settings
link_safe "$DEVKIT/.claude/settings.json" "$HOME/.claude/settings.json" "Claude settings"

# Rules (symlinks from skills/rules/ into .claude/rules/)
if $CHECK_ONLY; then
    RULE_COUNT=$(ls "$DEVKIT/.claude/rules/"*.md 2>/dev/null | wc -l | tr -d ' ')
    if [ "$RULE_COUNT" -gt 0 ]; then
        ok "Claude rules linked ($RULE_COUNT rules)"
    else
        fail "No Claude rules found"
    fi
else
    mkdir -p "$HOME/.claude/rules"
    for rule in "$DEVKIT/skills/rules/"*.md; do
        name=$(basename "$rule")
        link_safe "$rule" "$HOME/.claude/rules/$name" "Rule: $name"
    done
fi

# Skills (commands + plane)
if $CHECK_ONLY; then
    CMD_COUNT=$(ls "$HOME/.claude/skills/commands/"*.md 2>/dev/null | wc -l | tr -d ' ')
    PLANE_COUNT=$(ls "$HOME/.claude/skills/plane/"*.md 2>/dev/null | wc -l | tr -d ' ')
    ok "Claude skills: $CMD_COUNT commands, $PLANE_COUNT plane"
else
    link_safe "$DEVKIT/skills/commands" "$HOME/.claude/skills/commands" "Skills: commands"
    link_safe "$DEVKIT/skills/plane" "$HOME/.claude/skills/plane" "Skills: plane"
fi

# ─── OpenCode + Copilot Pro ───────────────────────────────────────────────────

step "OpenCode"

# Clean up stale files from previous manual installs or wrong script versions
if ! $CHECK_ONLY; then
    for old_link in "$HOME/.config/opencode/agent" "$HOME/.config/opencode/config.json"; do
        if [ -L "$old_link" ]; then
            rm "$old_link"
            ok "Removed stale symlink: $(basename "$old_link")"
        fi
    done
    if [ -d "$HOME/.config/opencode/agent" ] && [ ! -L "$HOME/.config/opencode/agent" ]; then
        mv "$HOME/.config/opencode/agent" "$HOME/.config/opencode/agent.bak"
        ok "Backed up stale agent/ directory"
    fi
    if [ -d "$HOME/.config/opencode/agents" ] && [ ! -L "$HOME/.config/opencode/agents" ]; then
        mv "$HOME/.config/opencode/agents" "$HOME/.config/opencode/agents.bak"
        ok "Backed up stale agents/ directory"
    fi
    if [ -f "$HOME/.config/opencode/opencode.json" ] && [ ! -L "$HOME/.config/opencode/opencode.json" ]; then
        mv "$HOME/.config/opencode/opencode.json" "$HOME/.config/opencode/opencode.json.bak"
        ok "Backed up stale opencode.json"
    fi
fi

# Agents
link_safe "$DEVKIT/opencode/aig_agents" "$HOME/.config/opencode/agents" "OpenCode agents"

# Config
link_safe "$DEVKIT/opencode.json" "$HOME/.config/opencode/opencode.json" "OpenCode config"

# TUI config (scroll acceleration, theme, keybinds)
link_safe "$DEVKIT/opencode/tui.json" "$HOME/.config/opencode/tui.json" "OpenCode TUI config"

step "Copilot CLI"

if command -v gh &> /dev/null; then
    if $CHECK_ONLY; then
        if gh extension list 2>/dev/null | grep -q "gh-copilot"; then
            ok "GitHub Copilot CLI extension installed"
        else
            fail "GitHub Copilot CLI extension not installed"
        fi
    else
        if ! gh extension list 2>/dev/null | grep -q "gh-copilot"; then
            gh extension install github/gh-copilot 2>/dev/null || warn "Could not install gh-copilot (run 'gh auth login' first)"
        else
            ok "GitHub Copilot CLI already installed"
        fi
    fi
else
    fail "gh CLI not found (should have been installed by brew bundle)"
fi


# ─── Verification Summary ────────────────────────────────────────────────────

step "Verification"

TOOLS=("opencode" "gh" "starship" "delta" "zoxide" "fzf" "fd" "bat" "eza")

for tool in "${TOOLS[@]}"; do
    if command -v "$tool" &> /dev/null; then
        ok "$tool"
    else
        fail "$tool not found"
    fi
done

# ─── Manual Steps ─────────────────────────────────────────────────────────────

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Setup complete. Manual steps remaining:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  Zen Account (opencode.ai):"
echo "    □ Add \$90 in Zen credits"
echo "    □ Set monthly limit to \$90"
echo "    □ Disable auto-reload (or cap at \$10)"
echo "    □ Disable unused models (Claude, GPT 5.4 Pro, old GPT variants)"
echo ""
echo "  GitHub:"
echo "    □ Run 'gh auth login' if not authenticated"
echo "    □ Enable Copilot as PR reviewer in repo settings"
echo ""
echo "  Shell:"
echo "    □ Restart your terminal or run: source ~/.zshrc"
echo ""
echo "  DEVKIT_PATH:"
echo "    □ If devkit is not at ~/personal-workspace/devkit,"
echo "      add to .zshrc: export DEVKIT_PATH=\"$DEVKIT\""
echo ""
