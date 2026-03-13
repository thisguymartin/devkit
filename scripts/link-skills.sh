#!/bin/bash

# Link AI Skills to a Target Project
# Usage: link-skills.sh /path/to/your/project [tools...]
# Example: link-skills.sh ~/projects/myapp cursor claude copilot
# Default: links all tools

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SOURCE_DIR="$( dirname "$SCRIPT_DIR" )"
TARGET_DIR="${1:-.}"

if [ "$TARGET_DIR" = "." ]; then
    TARGET_DIR="$(pwd)"
fi

if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: $TARGET_DIR is not a directory"
    exit 1
fi

# Determine which tools to link
shift 2>/dev/null || true
TOOLS="${@:-cursor claude copilot opencode}"

echo "Linking AI skills to: $TARGET_DIR"
echo "Tools: $TOOLS"
echo ""

for tool in $TOOLS; do
    case $tool in
        cursor)
            echo -e "${BLUE}Cursor${NC}"
            mkdir -p "$TARGET_DIR/.cursor/rules"
            for rule in "$SOURCE_DIR/.cursor/rules/"*.mdc; do
                if [ -f "$rule" ]; then
                    ln -sf "$rule" "$TARGET_DIR/.cursor/rules/$(basename "$rule")"
                    echo "  Linked $(basename "$rule")"
                fi
            done
            # Link impeccable frontend-design skills
            mkdir -p "$TARGET_DIR/.cursor/skills/frontend-design"
            ln -sf "$SOURCE_DIR/skills/frontend-design/SKILL.md" "$TARGET_DIR/.cursor/skills/frontend-design/SKILL.md"
            if [ -d "$SOURCE_DIR/skills/frontend-design/reference" ]; then
                ln -sf "$SOURCE_DIR/skills/frontend-design/reference" "$TARGET_DIR/.cursor/skills/frontend-design/reference"
                echo "  Linked frontend-design skill + references"
            fi
            # Link command skills
            for cmd_dir in "$SOURCE_DIR/skills/"*/; do
                cmd_name=$(basename "$cmd_dir")
                if [ "$cmd_name" != "frontend-design" ] && [ -f "$cmd_dir/SKILL.md" ]; then
                    mkdir -p "$TARGET_DIR/.cursor/skills/$cmd_name"
                    ln -sf "$cmd_dir/SKILL.md" "$TARGET_DIR/.cursor/skills/$cmd_name/SKILL.md"
                    echo "  Linked $cmd_name command"
                fi
            done
            echo -e "${GREEN}  Done${NC}\n"
            ;;

        claude)
            echo -e "${BLUE}Claude Code${NC}"
            mkdir -p "$TARGET_DIR/.claude/rules"
            for rule in "$SOURCE_DIR/.claude/rules/"*.md; do
                if [ -f "$rule" ]; then
                    ln -sf "$rule" "$TARGET_DIR/.claude/rules/$(basename "$rule")"
                    echo "  Linked $(basename "$rule")"
                fi
            done
            echo -e "${GREEN}  Done${NC}\n"
            ;;

        copilot)
            echo -e "${BLUE}GitHub Copilot${NC}"
            mkdir -p "$TARGET_DIR/.github"
            ln -sf "$SOURCE_DIR/.github/copilot-instructions.md" "$TARGET_DIR/.github/copilot-instructions.md"
            echo "  Linked copilot-instructions.md"
            echo -e "${GREEN}  Done${NC}\n"
            ;;

        opencode)
            echo -e "${BLUE}OpenCode${NC}"
            mkdir -p "$TARGET_DIR/opencode/aig_agents"
            for agent in "$SOURCE_DIR/opencode/aig_agents/"*.md; do
                if [ -f "$agent" ]; then
                    ln -sf "$agent" "$TARGET_DIR/opencode/aig_agents/$(basename "$agent")"
                    echo "  Linked $(basename "$agent")"
                fi
            done
            echo -e "${GREEN}  Done${NC}\n"
            ;;

        *)
            echo -e "${YELLOW}Unknown tool: $tool (skipped)${NC}"
            ;;
    esac
done

echo -e "${GREEN}All skills linked!${NC}"
echo ""
echo "Skills are symlinked from: $SOURCE_DIR"
echo "Updates to the source will automatically apply to all linked projects."
