#!/bin/bash

# SSL Certificate Setup Script
# Generates self-signed certificates for local development

set -e

echo "🔐 Setting up SSL certificates for local development..."

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

SSL_DIR="$HOME/.local/etc/ssl"
CERT_FILE="$SSL_DIR/localhost.crt"
KEY_FILE="$SSL_DIR/localhost.key"

# Create SSL directory
mkdir -p "$SSL_DIR"
chmod 700 "$SSL_DIR"

# Check if certificates already exist
if [ -f "$CERT_FILE" ] && [ -f "$KEY_FILE" ]; then
    echo -e "${YELLOW}⚠️  SSL certificates already exist at $SSL_DIR${NC}"
    read -p "Do you want to regenerate them? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipping generation..."
        exit 0
    fi
    rm -f "$CERT_FILE" "$KEY_FILE"
fi

echo "Generating SSL certificate and key..."

# Generate private key (2048-bit RSA)
openssl genrsa -out "$KEY_FILE" 2048

# Generate self-signed certificate (valid for 10 years)
openssl req -new -x509 -key "$KEY_FILE" -out "$CERT_FILE" -days 3650 \
    -subj "/C=US/ST=California/L=Local/O=Development/CN=localhost"

chmod 644 "$CERT_FILE"
chmod 600 "$KEY_FILE"

echo -e "${GREEN}✓ Certificates generated:${NC}"
echo "  Private Key: $KEY_FILE"
echo "  Certificate: $CERT_FILE"
echo ""

# Add to macOS Keychain (requires sudo)
echo -e "${BLUE}Adding certificate to macOS Keychain...${NC}"
echo "⚠️  You may be prompted for your password"

sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain "$CERT_FILE" 2>/dev/null || {
    echo -e "${YELLOW}⚠️  Could not add to Keychain (permission denied)${NC}"
    echo "You can manually add it later:"
    echo "  sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain $CERT_FILE"
}

echo ""
echo -e "${GREEN}✓ SSL setup complete!${NC}"
echo ""
echo "📝 Use in your projects:"
echo ""
echo "Node.js (Express):"
echo "  const https = require('https');"
echo "  const fs = require('fs');"
echo "  https.createServer({"
echo "    key: fs.readFileSync('$KEY_FILE'),"
echo "    cert: fs.readFileSync('$CERT_FILE')"
echo "  }, app).listen(3443);"
echo ""
echo "Python (Flask):"
echo "  app.run(ssl_context=("
echo "    '$CERT_FILE',"
echo "    '$KEY_FILE'"
echo "  ))"
echo ""
echo "Environment variable:"
echo "  export SSL_CERT=$CERT_FILE"
echo "  export SSL_KEY=$KEY_FILE"
