#!/usr/bin/env bash
# install_kickass.sh
# Downloads KickAssembler and installs a 'kickass' wrapper on PATH.
# Usage: bash install_kickass.sh

set -e

INSTALL_DIR="$HOME/tools/kickass"
WRAPPER="/usr/local/bin/kickass"
ZIP_URL="http://theweb.dk/KickAssembler/KickAssembler.zip"
ZIP_TMP="/tmp/KickAssembler.zip"

# ── 1. Check Java ────────────────────────────────────────────────────────────
if ! command -v java &>/dev/null; then
    echo "ERROR: Java is not installed. Install it with:"
    echo "  sudo apt install default-jre"
    exit 1
fi
echo "Java found: $(java -version 2>&1 | head -1)"

# ── 2. Download ──────────────────────────────────────────────────────────────
echo "Downloading KickAssembler from $ZIP_URL ..."
curl -# -L -o "$ZIP_TMP" "$ZIP_URL"

# ── 3. Install ───────────────────────────────────────────────────────────────
mkdir -p "$INSTALL_DIR"
echo "Extracting to $INSTALL_DIR ..."
unzip -o "$ZIP_TMP" -d "$INSTALL_DIR"
rm -f "$ZIP_TMP"

# Locate the jar (may be in a subdirectory)
JAR_PATH=$(find "$INSTALL_DIR" -name "KickAss.jar" | head -1)
if [[ -z "$JAR_PATH" ]]; then
    echo "ERROR: KickAss.jar not found after extraction. Contents of $INSTALL_DIR:"
    find "$INSTALL_DIR" -type f
    exit 1
fi
echo "Jar located at: $JAR_PATH"

# ── 4. Create wrapper script ─────────────────────────────────────────────────
echo "Installing wrapper to $WRAPPER (requires sudo) ..."
sudo tee "$WRAPPER" > /dev/null << EOF
#!/bin/bash
exec java -jar "$JAR_PATH" "\$@"
EOF
sudo chmod +x "$WRAPPER"

# ── 5. Verify ────────────────────────────────────────────────────────────────
echo ""
echo "Installation complete. Testing..."
kickass 2>&1 | head -3

echo ""
echo "Build your project with:"
echo "  cd $(dirname "$0")"
echo "  make"
