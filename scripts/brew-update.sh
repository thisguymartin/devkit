#!/bin/bash

# Homebrew Update & Upgrade Script
# Run periodically to keep everything current

set -e

echo "Homebrew Maintenance Starting..."
echo "=================================="

# Update Homebrew itself
echo "\nUpdating Homebrew..."
brew update

# Show outdated packages before upgrading
echo "\nOutdated packages:"
brew outdated || echo "All packages up to date!"

# Upgrade all packages
echo "\nUpgrading packages..."
brew upgrade

# Upgrade casks (GUI applications)
echo "\nUpgrading casks..."
brew upgrade --cask --greedy

# Cleanup old versions and cache
echo "\nCleaning up..."
brew cleanup -s
brew autoremove

# Check for issues
echo "\nRunning diagnostics..."
brew doctor || true

# Show disk space recovered
echo "\nHomebrew maintenance complete!"
echo "=================================="
