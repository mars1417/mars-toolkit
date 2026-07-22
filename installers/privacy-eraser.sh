#!/bin/bash
# ============================================================
# 隐私擦除 (Privacy Eraser) — 一键清除隐私数据
# 版本: 1.0.0
# 安装: curl -sL https://raw.githubusercontent.com/mars1417/mars-toolkit/gh-pages/installers/privacy-eraser.sh | bash
# ============================================================

set -e

INSTALL_DIR="$HOME/.mars-toolkit"
SCRIPT_PATH="$INSTALL_DIR/privacy-eraser.sh"
PLIST_PATH="$HOME/Library/LaunchAgents/com.mars.privacy-eraser.plist"
CONF_PATH="$INSTALL_DIR/privacy-eraser.conf"
LOG_DIR="$INSTALL_DIR/logs"

echo "🔧 正在安装 隐私擦除 (Privacy Eraser)..."

mkdir -p "$INSTALL_DIR" "$LOG_DIR"

# 创建配置文件
cat > "$CONF_PATH" << CONF
# 隐私擦除配置
# 每次清理的项目 (true/false)

# 浏览器缓存
CLEAR_CHROME_CACHE="true"
CLEAR_SAFARI_CACHE="true"

# 最近文档
CLEAR_RECENT_DOCS="true"

# 剪贴板
CLEAR_CLIPBOARD="true"

# 系统日志
CLEAR_SYSTEM_LOGS="false"

# 下载记录
CLEAR_DOWNLOAD_HISTORY="false"

# 废纸篓
CLEAR_TRASH="false"
CONF

# 创建主脚本
cat > "$SCRIPT_PATH" << 'SCRIPT'
#!/bin/bash
# 隐私擦除脚本 — 一键清除Mac上的隐私痕迹

CONF_FILE="$HOME/.mars-toolkit/privacy-eraser.conf"
LOG_FILE="$HOME/.mars-toolkit/logs/privacy-eraser.log"

mkdir -p "$(dirname "$LOG_FILE")"
source "$CONF_FILE" 2>/dev/null || {
    echo "❌ 配置文件不存在，使用默认配置"
    CLEAR_CHROME_CACHE="true"
    CLEAR_SAFARI_CACHE="true"
    CLEAR_RECENT_DOCS="true"
    CLEAR_CLIPBOARD="true"
    CLEAR_SYSTEM_LOGS="false"
    CLEAR_DOWNLOAD_HISTORY="false"
    CLEAR_TRASH="false"
}

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
    echo "$1"
}

clear_chrome() {
    if [ "$CLEAR_CHROME_CACHE" != "true" ]; then return; fi
    log "   🧹 Chrome 缓存..."
    rm -rf "$HOME/Library/Caches/Google/Chrome/Default/Cache"/* 2>/dev/null || true
    rm -rf "$HOME/Library/Caches/Google/Chrome/Default/Code Cache"/* 2>/dev/null || true
    rm -rf "$HOME/Library/Caches/Google/Chrome/Default/GPUCache"/* 2>/dev/null || true
    rm -rf "$HOME/Library/Application Support/Google/Chrome/Default/Cookies" 2>/dev/null || true
    log "   ✅ Chrome 清理完成"
}

clear_safari() {
    if [ "$CLEAR_SAFARI_CACHE" != "true" ]; then return; fi
    log "   🧹 Safari 缓存..."
    rm -rf "$HOME/Library/Caches/com.apple.Safari"/* 2>/dev/null || true
    rm -rf "$HOME/Library/Caches/com.apple.WebKit.WebContent"/* 2>/dev/null || true
    rm -rf "$HOME/Library/Safari/LocalStorage"/* 2>/dev/null || true
    # 清除最近搜索
    defaults write com.apple.Safari RecentSearchStrings -array 2>/dev/null || true
    log "   ✅ Safari 清理完成"
}

clear_recent_docs() {
    if [ "$CLEAR_RECENT_DOCS" != "true" ]; then return; fi
    log "   🧹 最近文档..."
    # Finder最近文档
    defaults write com.apple.finder FXRecentFolders -array 2>/dev/null || true
    # 清空最近项目 (macOS Ventura+)
    mdfind "kMDItemLastUsedDate > \$time.today(-7)" -onlyin "$HOME" 2>/dev/null | head -1 > /dev/null || true
    # 清空NSGlobalDomain的最近项目列表
    defaults write NSGlobalDomain NSNavRecentPlaces -array 2>/dev/null || true
    # 清空各个应用的最近文档
    for app in "com.apple.TextEdit" "com.apple.Preview" "com.apple.iCal" "com.apple.Safari"; do
        defaults write "$app" NSRecentDocumentRecords -array 2>/dev/null || true
    done
    log "   ✅ 最近文档已清空"
}

clear_clipboard() {
    if [ "$CLEAR_CLIPBOARD" != "true" ]; then return; fi
    log "   🧹 剪贴板..."
    echo "" | pbcopy
    log "   ✅ 剪贴板已清空"
}

clear_system_logs() {
    if [ "$CLEAR_SYSTEM_LOGS" != "true" ]; then return; fi
    log "   🧹 系统日志..."
    # 清除用户日志
    rm -rf "$HOME/Library/Logs"/*.log 2>/dev/null || true
    # 清除诊断报告
    rm -rf "$HOME/Library/Logs/DiagnosticReports"/* 2>/dev/null || true
    log "   ✅ 系统日志已清理"
}

clear_download_history() {
    if [ "$CLEAR_DOWNLOAD_HISTORY" != "true" ]; then return; fi
    log "   🧹 下载记录..."
    sqlite3 "$HOME/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV2" "DELETE FROM LSQuarantineEvent" 2>/dev/null || true
    log "   ✅ 下载记录已清理"
}

# 主流程
echo ""
echo "🔐 隐私擦除 — 开始清理..."
echo "━━━━━━━━━━━━━━━━━━━━━━"
log "🚀 开始隐私数据清理..."

clear_chrome
clear_safari
clear_recent_docs
clear_clipboard
clear_system_logs
clear_download_history

echo "━━━━━━━━━━━━━━━━━━━━━━"
log "✅ 隐私擦除完成！"
echo ""
echo "📋 已清理项目:"
[ "$CLEAR_CHROME_CACHE" = "true" ] && echo "   ✓ Chrome 缓存/Cookie"
[ "$CLEAR_SAFARI_CACHE" = "true" ] && echo "   ✓ Safari 缓存"
[ "$CLEAR_RECENT_DOCS" = "true" ] && echo "   ✓ 最近文档列表"
[ "$CLEAR_CLIPBOARD" = "true" ] && echo "   ✓ 剪贴板"
[ "$CLEAR_SYSTEM_LOGS" = "true" ] && echo "   ✓ 系统日志"
echo ""
echo "📋 日志: $LOG_FILE"
SCRIPT

chmod +x "$SCRIPT_PATH"

# 创建 launchd 服务 (每天凌晨3点自动清理)
cat > "$PLIST_PATH" << PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.mars.privacy-eraser</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>$SCRIPT_PATH</string>
    </array>
    <key>RunAtLoad</key>
    <false/>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>3</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
    <key>StandardOutPath</key>
    <string>$LOG_DIR/privacy-eraser.stdout.log</string>
    <key>StandardErrorPath</key>
    <string>$LOG_DIR/privacy-eraser.stderr.log</string>
</dict>
</plist>
PLIST

# 加载服务 (但不立即执行)
launchctl unload "$PLIST_PATH" 2>/dev/null || true
launchctl load "$PLIST_PATH"

echo ""
echo "✅ 隐私擦除 安装成功！"
echo "📋 配置文件: $CONF_PATH"
echo "📋 日志文件: $LOG_DIR/privacy-eraser.log"
echo "💡 手动运行: bash $SCRIPT_PATH"
echo "⏰ 自动清理: 每天凌晨3:00"
