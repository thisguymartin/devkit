#!/usr/bin/env bash
# Launch zellij with lazyai layout
# Usage:
#   ./launch-lazyai.sh          # Uses opencode (default)
#   ./launch-lazyai.sh claude   # Uses claude
#   ./launch-lazyai.sh opencode # Uses opencode explicitly

# Set the AI editor (default to opencode)
export AI_EDITOR="${1:-opencode}"

# Choose layout variant
LAYOUT="${2:-lazyai.kdl}"

echo "🚀 Launching zellij with AI_EDITOR=$AI_EDITOR using layout: $LAYOUT"

# Launch zellij with the layout
zellij --layout "$(dirname "$0")/layouts/$LAYOUT"
