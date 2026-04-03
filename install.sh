#!/usr/bin/env bash
set -euo pipefail

# relay-manager installer
# Usage: curl -fsSL https://raw.githubusercontent.com/YOUR_USER/relay-manager/main/install.sh | sudo bash

REPO="vsyaco/relay-manager"
BRANCH="main"
INSTALL_PATH="/usr/local/bin/relay"

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BOLD}${CYAN}"
echo "  ┌─────────────────────────────────────┐"
echo "  │   relay-manager — installer          │"
echo "  └─────────────────────────────────────┘"
echo -e "${NC}"

# Check root
if [[ $EUID -ne 0 ]]; then
  echo -e "${RED}✖${NC}  Please run as root: curl ... | sudo bash"
  exit 1
fi

# Download
echo -e "${CYAN}ℹ${NC}  Downloading relay..."
curl -fsSL "https://raw.githubusercontent.com/${REPO}/${BRANCH}/relay" -o "$INSTALL_PATH"
chmod +x "$INSTALL_PATH"

echo -e "${GREEN}✔${NC}  Installed to ${INSTALL_PATH}"
echo ""
echo -e "  Run ${BOLD}relay init${NC} to get started"
echo ""
