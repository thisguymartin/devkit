#!/usr/bin/env bash
# Launch a Zellij workspace with one pane per Mochi worktree.
#
# Usage:
#   ./launch-mochi.sh                          # Uses .mochi_manifest.json in cwd
#   ./launch-mochi.sh /path/to/manifest.json   # Explicit manifest path
#   ./launch-mochi.sh --layout-only            # Print generated layout to stdout (no launch)
#
# This script reads the Mochi manifest file, generates a dynamic Zellij KDL
# layout with one lazygit pane + one shell pane per worktree, and launches
# a Zellij session named "mochi-workspace".
#
# Requirements: zellij, jq, lazygit (optional but recommended)

set -euo pipefail

MANIFEST="${1:-.mochi_manifest.json}"
LAYOUT_ONLY=false
SESSION_NAME="mochi-workspace"

if [[ "$MANIFEST" == "--layout-only" ]]; then
    LAYOUT_ONLY=true
    MANIFEST=".mochi_manifest.json"
fi

if [[ ! -f "$MANIFEST" ]]; then
    echo "Error: manifest not found at $MANIFEST"
    echo "Run 'mochi --keep-worktrees' first to generate worktrees."
    exit 1
fi

if ! command -v jq &>/dev/null; then
    echo "Error: jq is required. Install with: brew install jq (macOS) or apt install jq (Linux)"
    exit 1
fi

if ! command -v zellij &>/dev/null; then
    echo "Error: zellij is required. Install from https://zellij.dev"
    exit 1
fi

# Parse manifest entries
SLUGS=($(jq -r 'keys[]' "$MANIFEST"))
PATHS=($(jq -r '.[].path' "$MANIFEST"))
BRANCHES=($(jq -r '.[].branch' "$MANIFEST"))

if [[ ${#SLUGS[@]} -eq 0 ]]; then
    echo "Error: no worktrees found in $MANIFEST"
    exit 1
fi

# Generate dynamic KDL layout
generate_layout() {
    cat <<'HEADER'
layout {
    default_tab_template {
        children
        pane size=1 borderless=true {
            plugin location="zellij:compact-bar"
        }
    }

    tab name="Worktrees" {
        pane split_direction="vertical" {
            pane split_direction="horizontal" size="40%" {
HEADER

    # Left column: lazygit per worktree
    for i in "${!SLUGS[@]}"; do
        local slug="${SLUGS[$i]}"
        local path="${PATHS[$i]}"
        if command -v lazygit &>/dev/null; then
            echo "                pane command=\"lazygit\" name=\"git: ${slug}\" {"
            echo "                    cwd \"${path}\""
            echo "                }"
        else
            echo "                pane name=\"git: ${slug}\" {"
            echo "                    command \"git\""
            echo "                    args \"log\" \"--oneline\" \"-20\""
            echo "                    cwd \"${path}\""
            echo "                }"
        fi
    done

    cat <<'MIDDLE'
            }

            pane split_direction="horizontal" size="60%" {
MIDDLE

    # Right column: shell per worktree
    local first=true
    for i in "${!SLUGS[@]}"; do
        local slug="${SLUGS[$i]}"
        local path="${PATHS[$i]}"
        local branch="${BRANCHES[$i]}"
        echo "                pane name=\"${slug} (${branch})\" {"
        echo "                    cwd \"${path}\""
        if $first; then
            echo "                    focus true"
            first=false
        fi
        echo "                }"
    done

    cat <<'FOOTER'
            }
        }
    }

    tab name="Manifest" {
        pane command="watch" name="Mochi Status" {
            args "-n" "2" "cat" ".mochi_manifest.json"
        }
    }
}
FOOTER
}

LAYOUT_CONTENT=$(generate_layout)

if $LAYOUT_ONLY; then
    echo "$LAYOUT_CONTENT"
    exit 0
fi

# Write layout to temp file and launch
LAYOUT_FILE=$(mktemp /tmp/mochi-layout-XXXXXX.kdl)
echo "$LAYOUT_CONTENT" > "$LAYOUT_FILE"

echo "Launching Zellij workspace with ${#SLUGS[@]} worktree(s)..."
for i in "${!SLUGS[@]}"; do
    echo "  ${SLUGS[$i]} -> ${PATHS[$i]} (${BRANCHES[$i]})"
done
echo ""
echo "Session: $SESSION_NAME"
echo "Attach later with: zellij attach $SESSION_NAME"
echo ""

zellij --layout "$LAYOUT_FILE" --session "$SESSION_NAME"
