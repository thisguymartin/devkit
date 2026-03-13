#!/bin/bash

# Database Setup Script
# Initializes local PostgreSQL and Redis for development

set -e

echo "🗄️  Setting up local databases..."

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# PostgreSQL Setup
echo -e "${BLUE}PostgreSQL${NC}"
if ! command -v psql &> /dev/null; then
    echo "Installing PostgreSQL..."
    brew install postgresql@15
fi

echo "Starting PostgreSQL service..."
brew services start postgresql@15 || brew services restart postgresql@15

sleep 2

# Check if database exists
if psql -lqt | cut -d \| -f 1 | grep -qw mydeveloper; then
    echo -e "${GREEN}✓ mydeveloper database already exists${NC}"
else
    echo "Creating mydeveloper database..."
    createdb mydeveloper
fi

# Check if user exists
if psql -tAc "SELECT 1 FROM pg_user WHERE usename = 'devuser'" | grep -q 1; then
    echo -e "${GREEN}✓ devuser already exists${NC}"
else
    echo "Creating devuser..."
    createuser devuser -P
    psql -d mydeveloper -c "GRANT ALL PRIVILEGES ON DATABASE mydeveloper TO devuser;"
fi

echo -e "${GREEN}✓ PostgreSQL ready at localhost:5432${NC}\n"

# Redis Setup
echo -e "${BLUE}Redis${NC}"
if ! command -v redis-cli &> /dev/null; then
    echo "Installing Redis..."
    brew install redis
fi

echo "Starting Redis service..."
brew services start redis || brew services restart redis

sleep 2

# Test Redis connection
if redis-cli ping | grep -q PONG; then
    echo -e "${GREEN}✓ Redis ready at localhost:6379${NC}\n"
else
    echo "⚠️  Redis connection failed. Check installation."
fi

# Summary
echo -e "${GREEN}✓ Database setup complete!${NC}"
echo ""
echo "Connection strings:"
echo "  PostgreSQL: psql -d mydeveloper -U devuser"
echo "  Redis: redis-cli"
echo ""
echo "📝 Save these in your .env file for projects"
