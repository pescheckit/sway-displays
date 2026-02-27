#!/bin/bash
# Script to automatically update PKGBUILD version from latest GitHub tag

set -e

REPO="pescheckit/sway-displays"
PKGBUILD_PATH="$(dirname "$0")/PKGBUILD"

echo "Fetching latest tag from GitHub..."
LATEST_TAG=$(curl -s "https://api.github.com/repos/$REPO/tags" | jq -r '.[0].name')

if [ -z "$LATEST_TAG" ]; then
    echo "Error: Could not fetch latest tag"
    exit 1
fi

echo "Latest tag: $LATEST_TAG"

# Update pkgver in PKGBUILD
sed -i "s/^pkgver=.*/pkgver=$LATEST_TAG/" "$PKGBUILD_PATH"

# Update pkgrel to 1 for new version
sed -i "s/^pkgrel=.*/pkgrel=1/" "$PKGBUILD_PATH"

echo "Updated PKGBUILD to version $LATEST_TAG"

# Generate checksums
cd "$(dirname "$0")"
echo "Generating checksums..."
updpkgsums 2>/dev/null || {
    echo "Warning: updpkgsums not available. You'll need to run 'updpkgsums' manually or keep sha256sums='SKIP'"
}

echo "Done! PKGBUILD updated to version $LATEST_TAG"
echo "Don't forget to:"
echo "  1. Review the changes"
echo "  2. Test the package with 'makepkg -si'"
echo "  3. Update the AUR with 'git add PKGBUILD .SRCINFO && git commit && git push'"
