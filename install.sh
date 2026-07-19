#!/bin/bash
# Mars Toolkit — One-Click Installer
set -e

REPO_URL="https://github.com/mars1417/mars-toolkit.git"
INSTALL_DIR="$HOME/mars-toolkit"

echo "🛠️ Installing Mars Toolkit..."
echo ""

# Check OS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "⚠️  Some modules are macOS-specific."
    echo "   Common modules (service-check, auto-heal) will still work."
    echo ""
fi

# Clone or pull
if [ -d "$INSTALL_DIR" ]; then
    echo "📦 Updating existing installation..."
    cd "$INSTALL_DIR" && git pull
else
    echo "📦 Cloning to $INSTALL_DIR..."
    git clone "$REPO_URL" "$INSTALL_DIR"
fi

# Setup scripts
chmod +x "$INSTALL_DIR/scripts/"*.sh

# Install cron job (check every 5 minutes)
(crontab -l 2>/dev/null | grep -v "mars-toolkit"; echo "*/5 * * * * cd $INSTALL_DIR && bash scripts/watchdog/clean-sweep.sh") | crontab -

echo ""
echo "✅ Mars Toolkit installed!"
echo "   📍 $INSTALL_DIR"
echo "   ⏱  Auto-cleanup runs every 5 minutes"
echo ""
echo "Next: read the docs at $INSTALL_DIR/docs/"
