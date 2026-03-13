#!/bin/bash

# Stop Local Development Services
# Stops PostgreSQL, Redis, and Docker services

set -e

echo "🛑 Stopping local development services..."

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to stop service
stop_service() {
    local service=$1
    local brew_service=$2

    echo -n "Stopping $service... "

    if brew services stop "$brew_service" 2>/dev/null; then
        echo -e "${GREEN}✓${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠️ (not running)${NC}"
        return 1
    fi
}

# Stop services
stop_service "PostgreSQL" "postgresql@15"
stop_service "Redis" "redis"
stop_service "Docker" "docker" || true

echo ""
echo -e "${GREEN}✓ All services stopped${NC}"
