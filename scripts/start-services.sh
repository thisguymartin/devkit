#!/bin/bash

# Start Local Development Services
# Starts PostgreSQL, Redis, and Docker services

set -e

echo "🚀 Starting local development services..."

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to start service
start_service() {
    local service=$1
    local brew_service=$2

    echo -n "Starting $service... "

    if brew services start "$brew_service" 2>/dev/null; then
        echo -e "${GREEN}✓${NC}"
        return 0
    elif brew services restart "$brew_service" 2>/dev/null; then
        echo -e "${GREEN}✓ (restarted)${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠️ (not installed)${NC}"
        return 1
    fi
}

# Start services
start_service "PostgreSQL" "postgresql@15"
start_service "Redis" "redis"
start_service "Docker" "docker" || true  # Docker is optional

echo ""

# Wait for services to start
sleep 2

# Verify connections
echo -e "${BLUE}Verifying services...${NC}"

# PostgreSQL
if command -v psql &> /dev/null; then
    if psql -d mydeveloper -U devuser -c "SELECT 1" &>/dev/null; then
        echo -e "${GREEN}✓ PostgreSQL${NC} (localhost:5432)"
    else
        echo -e "${YELLOW}⚠️ PostgreSQL${NC} (not responding)"
    fi
fi

# Redis
if command -v redis-cli &> /dev/null; then
    if redis-cli ping 2>/dev/null | grep -q PONG; then
        echo -e "${GREEN}✓ Redis${NC} (localhost:6379)"
    else
        echo -e "${YELLOW}⚠️ Redis${NC} (not responding)"
    fi
fi

echo ""
echo -e "${GREEN}✓ Services started!${NC}"
echo ""
echo "To stop services, run: stop-services.sh"
echo "To check status, run: brew services list"
