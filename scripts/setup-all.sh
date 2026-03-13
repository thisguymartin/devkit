#!/bin/bash

# Master Setup Script
# Runs all setup tasks in sequence

set -e

echo "╔════════════════════════════════════════════════════════╗"
echo "║  devkit - Complete Setup                                ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$( dirname "$SCRIPT_DIR" )"

# Step 1: Install tools
echo -e "${BLUE}Step 1: Installing tools via Homebrew...${NC}"
echo "This may take a few minutes on first run."
echo ""

cd "$PROJECT_DIR"
if ! brew bundle --file=Brewfile; then
    echo -e "${YELLOW}⚠️  Some packages may not have installed. Continuing...${NC}"
fi

echo -e "${GREEN}✓ Tools installed${NC}\n"

# Step 2: Setup databases
echo -e "${BLUE}Step 2: Setting up local databases...${NC}"
$SCRIPT_DIR/setup-db.sh
echo ""

# Step 3: Setup SSL
echo -e "${BLUE}Step 3: Setting up SSL certificates...${NC}"
$SCRIPT_DIR/setup-ssl.sh
echo ""

# Step 4: Create directories
echo -e "${BLUE}Step 4: Creating project directories...${NC}"
mkdir -p ~/.local/bin
mkdir -p ~/.local/etc
mkdir -p ~/.local/var/logs
mkdir -p ~/projects

# Copy scripts to ~/.local/bin
cp $SCRIPT_DIR/setup-db.sh ~/.local/bin/
cp $SCRIPT_DIR/setup-ssl.sh ~/.local/bin/
cp $SCRIPT_DIR/start-services.sh ~/.local/bin/
cp $SCRIPT_DIR/stop-services.sh ~/.local/bin/

chmod +x ~/.local/bin/*.sh

echo -e "${GREEN}✓ Directories created${NC}\n"

# Step 5: Setup environment file
echo -e "${BLUE}Step 5: Setting up environment variables...${NC}"
if [ ! -f ~/.env ]; then
    cp $PROJECT_DIR/.env.example ~/.env
    echo -e "${GREEN}✓ Created ~/.env (fill in your API keys)${NC}"
else
    echo -e "${YELLOW}ℹ  ~/.env already exists (skipped)${NC}"
fi
echo ""

# Step 6: Link configurations
echo -e "${BLUE}Step 6: Linking configurations...${NC}"

# Shell
if [ -f ~/.zshrc ] && [ ! -L ~/.zshrc ]; then
    mv ~/.zshrc ~/.zshrc.backup
    echo "  Backed up existing .zshrc"
fi
ln -sf $PROJECT_DIR/.zshrc ~/.zshrc 2>/dev/null || true

# Zellij
mkdir -p ~/.config/zellij
ln -sf $PROJECT_DIR/zellij/* ~/.config/zellij/ 2>/dev/null || true

# Ghostty
mkdir -p ~/.config/ghostty
ln -sf $PROJECT_DIR/.config/ghostty/config ~/.config/ghostty/config 2>/dev/null || true

# Git delta config
if command -v delta &> /dev/null; then
    git config --global include.path "$PROJECT_DIR/.config/git/delta.gitconfig"
    echo "  Linked git delta config"
fi

# Shell enhancements (zoxide, fzf+fd, eza aliases)
if [ -f ~/.zshrc ]; then
    if ! grep -q "enhancements.zsh" ~/.zshrc 2>/dev/null; then
        echo "" >> ~/.zshrc
        echo "# devkit shell enhancements" >> ~/.zshrc
        echo "source $PROJECT_DIR/.config/shell/enhancements.zsh" >> ~/.zshrc
        echo "  Added shell enhancements to .zshrc"
    fi
fi

echo -e "${GREEN}✓ Configurations linked${NC}\n"

# Final summary
echo "╔════════════════════════════════════════════════════════╗"
echo "║  ✓ Setup Complete!                                     ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""
echo "📝 Next steps:"
echo ""
echo "1. Edit ~/.env with your API keys and passwords:"
echo "   nano ~/.env"
echo ""
echo "2. Edit ~/.zshrc if needed:"
echo "   nano ~/.zshrc"
echo ""
echo "3. Reload shell:"
echo "   source ~/.zshrc"
echo ""
echo "4. Start services (optional):"
echo "   start-services.sh"
echo ""
echo "5. Launch development environment:"
echo "   zdev"
echo ""
echo "📚 Documentation:"
echo "  - SETUP.md - Complete setup guide"
echo "  - TOOLS.md - Tool reference guide"
echo "  - CHEATSHEET.md - Keyboard shortcuts"
echo "  - TROUBLESHOOTING.md - Common issues"
echo ""
echo "Happy hacking! 🚀"
