#!/bin/bash

# Development Environment Cleanup Script
# Removes caches, orphaned dependencies, and reclaims disk space

set -e

echo "Dev Environment Cleanup Starting..."
echo "======================================="

# Track space before
SPACE_BEFORE=$(df -h ~ | awk 'NR==2 {print $4}')
echo "Free space before: $SPACE_BEFORE"

# --- NPM Cleanup ---
if command -v npm &> /dev/null; then
  echo "\nNPM Cleanup..."
  echo " -> Clearing npm cache..."
  npm cache clean --force 2>/dev/null || true
  echo " -> Checking for extraneous global packages..."
  npm ls -g --depth=0 2>/dev/null || true
fi

# --- Bun Cleanup ---
if command -v bun &> /dev/null; then
  echo "\nBun Cleanup..."
  BUN_CACHE="${HOME}/.bun/install/cache"
  if [ -d "$BUN_CACHE" ]; then
    echo " -> Clearing bun install cache..."
    rm -rf "$BUN_CACHE"/*
  fi
fi

# --- pnpm Cleanup ---
if command -v pnpm &> /dev/null; then
  echo "\npnpm Cleanup..."
  pnpm store prune 2>/dev/null || true
fi

# --- Yarn Cleanup ---
if command -v yarn &> /dev/null; then
  echo "\nYarn Cleanup..."
  yarn cache clean 2>/dev/null || true
fi

# --- Go Cleanup ---
if command -v go &> /dev/null; then
  echo "\nGo Cleanup..."
  echo " -> Cleaning go module cache..."
  go clean -modcache 2>/dev/null || true
  echo " -> Cleaning go build cache..."
  go clean -cache 2>/dev/null || true
fi

# --- Docker Cleanup ---
if command -v docker &> /dev/null; then
  echo "\nDocker Cleanup..."
  echo " -> Removing dangling images and build cache..."
  docker system prune -f 2>/dev/null || true
fi

# --- Remove common junk files ---
echo "\nRemoving common junk files..."
find ~ -name ".DS_Store" -type f -delete 2>/dev/null || true
find ~ -name "Thumbs.db" -type f -delete 2>/dev/null || true

# Track space after
SPACE_AFTER=$(df -h ~ | awk 'NR==2 {print $4}')

echo "\n======================================="
echo "Cleanup complete!"
echo "Free space before: $SPACE_BEFORE"
echo "Free space after: $SPACE_AFTER"
echo "======================================="

echo "\nTip: To remove old node_modules from inactive projects, run:"
echo ' find ~/Projects -name "node_modules" -type d -mtime +30 -prune -exec rm -rf {} +'
