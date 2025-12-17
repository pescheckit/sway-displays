#!/bin/bash
set -euo pipefail

# Secure installer for sway-displays
# Usage: curl -fsSL https://raw.githubusercontent.com/pescheckit/sway-displays/main/install.sh | bash
#
# For extra security, download and verify manually:
#   curl -fsSL https://raw.githubusercontent.com/pescheckit/sway-displays/main/install.sh -o install.sh
#   curl -fsSL https://raw.githubusercontent.com/pescheckit/sway-displays/main/install.sh.sha256 -o install.sh.sha256
#   sha256sum -c install.sh.sha256
#   bash install.sh

REPO="pescheckit/sway-displays"
INSTALL_DIR="${HOME}/.local/bin"
SCRIPT_NAME="sway-displays"

echo "=== sway-displays installer ==="
echo ""

# Check dependencies
missing_deps=()
for cmd in jq bc; do
    if ! command -v "$cmd" &>/dev/null; then
        missing_deps+=("$cmd")
    fi
done

if ! command -v swaymsg &>/dev/null; then
    echo "Warning: 'swaymsg' not found. Make sure Sway is installed."
fi

if [ ${#missing_deps[@]} -gt 0 ]; then
    echo "Missing dependencies: ${missing_deps[*]}"
    echo "Install them with:"
    echo "  Debian/Ubuntu: sudo apt install ${missing_deps[*]}"
    echo "  Arch: sudo pacman -S ${missing_deps[*]}"
    echo "  Fedora: sudo dnf install ${missing_deps[*]}"
    echo ""
fi

# Create install directory
mkdir -p "$INSTALL_DIR"

# Get latest release info
echo "Fetching latest release..."
if command -v curl &>/dev/null; then
    LATEST=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" 2>/dev/null | grep '"tag_name"' | cut -d'"' -f4) || LATEST=""
elif command -v wget &>/dev/null; then
    LATEST=$(wget -qO- "https://api.github.com/repos/$REPO/releases/latest" 2>/dev/null | grep '"tag_name"' | cut -d'"' -f4) || LATEST=""
fi

# Fall back to main branch if no release
if [ -z "$LATEST" ]; then
    echo "No release found, using main branch..."
    DOWNLOAD_URL="https://raw.githubusercontent.com/$REPO/main/$SCRIPT_NAME"
    CHECKSUM_URL="https://raw.githubusercontent.com/$REPO/main/$SCRIPT_NAME.sha256"
else
    echo "Latest release: $LATEST"
    DOWNLOAD_URL="https://raw.githubusercontent.com/$REPO/$LATEST/$SCRIPT_NAME"
    CHECKSUM_URL="https://raw.githubusercontent.com/$REPO/$LATEST/$SCRIPT_NAME.sha256"
fi

# Download to temp file first
TEMP_FILE=$(mktemp)
TEMP_CHECKSUM=$(mktemp)
trap 'rm -f "$TEMP_FILE" "$TEMP_CHECKSUM"' EXIT

echo "Downloading $SCRIPT_NAME..."
if command -v curl &>/dev/null; then
    curl -fsSL "$DOWNLOAD_URL" -o "$TEMP_FILE"
    curl -fsSL "$CHECKSUM_URL" -o "$TEMP_CHECKSUM" 2>/dev/null || echo ""
elif command -v wget &>/dev/null; then
    wget -qO "$TEMP_FILE" "$DOWNLOAD_URL"
    wget -qO "$TEMP_CHECKSUM" "$CHECKSUM_URL" 2>/dev/null || echo ""
else
    echo "Error: curl or wget required"
    exit 1
fi

# Verify checksum if available
if [ -s "$TEMP_CHECKSUM" ]; then
    echo "Verifying checksum..."
    EXPECTED=$(awk '{print $1}' "$TEMP_CHECKSUM")
    ACTUAL=$(sha256sum "$TEMP_FILE" | awk '{print $1}')

    if [ "$EXPECTED" != "$ACTUAL" ]; then
        echo "ERROR: Checksum verification failed!"
        echo "Expected: $EXPECTED"
        echo "Got:      $ACTUAL"
        echo ""
        echo "The file may have been tampered with. Aborting."
        exit 1
    fi
    echo "Checksum verified OK"
else
    echo "Warning: No checksum file available. Skipping verification."
    echo "For production use, consider downloading the .deb package instead."
fi

# Verify it's a valid bash script
if ! head -1 "$TEMP_FILE" | grep -q '^#!/bin/bash'; then
    echo "ERROR: Downloaded file is not a valid bash script!"
    exit 1
fi

# Install
mv "$TEMP_FILE" "$INSTALL_DIR/$SCRIPT_NAME"
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

echo ""
echo "Installed to $INSTALL_DIR/$SCRIPT_NAME"

# Verify installation
VERSION=$("$INSTALL_DIR/$SCRIPT_NAME" --version 2>/dev/null || echo "unknown")
echo "Version: $VERSION"

# Check if in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo ""
    echo "Add this to your ~/.bashrc or ~/.zshrc:"
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
fi

echo ""
echo "Run '$SCRIPT_NAME help' to get started."
