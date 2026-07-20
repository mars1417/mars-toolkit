#!/bin/bash
# Retry GitHub Pages deployment - runs until deploy succeeds
REPO_DIR="$HOME/Desktop/_项目/mars-toolkit"
cd "$REPO_DIR" || exit 1

# Check if pages is serving the latest content (has "立即购买")
LIVE_CONTENT=$(curl -s "https://mars1417.github.io/mars-toolkit/index.html")
if echo "$LIVE_CONTENT" | grep -q "立即购买"; then
  echo "✅ VPN Auto-Pilot already live on Pages!"
  exit 0
fi

# Trigger a rebuild
git checkout gh-pages
git commit --allow-empty -m "retry: Pages deploy (GH outage recovery)"
git push origin gh-pages
git checkout main
echo "🔄 Retry triggered - Pages deploy attempted"
