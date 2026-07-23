#!/bin/bash
# ============================================================
# 开机加速 (Startup Optimizer) — 管理登录启动项
# 版本: 1.0.0
# 安装: curl -sL https://raw.githubusercontent.com/mars1417/mars-toolkit/gh-pages/installers/startup-optimizer.sh | bash
# ============================================================

set -e

INSTALL_DIR="$HOME/.mars-toolkit"
SCRIPT_PATH="$INSTALL_DIR/startup-optimizer.sh"
PLIST_PATH="$HOME/Library/LaunchAgents/com.mars.startup-optimizer.plist"
CONF_PATH="$INSTALL_DIR/startup-optimizer.conf"
LOG_DIR="$INSTALL_DIR/logs"

echo "🔧 正在安装 开机加速 (Startup Optimizer)..."

mkdir -p "$INSTALL_DIR" "$LOG_DIR"

# 创建配置文件
cat > "$CONF_PATH" << CONF
# 开机加速配置
# 自动运行模式: auto/check-only/disabled
MODE="auto"

# 是否自动禁用已知非关键服务 (true/false)
AUTO_DISABLE="false"

# 启用开机提醒 (true/false)
ENABLE_NOTIFICATION="true"
CONF

# 创建主脚本
cat > "$SCRIPT_PATH" << 'SCRIPT'
#!/bin/bash
# 开机加速守护脚本 — 管理登录启动项

CONF_FILE="$HOME/.mars-toolkit/startup-optimizer.conf"
LOG_FILE="$HOME/.mars-toolkit/logs/startup-optimizer.log"

mkdir -p "$(dirname "$LOG_FILE")"
source "$CONF_FILE" 2>/dev/null || { echo "❌ Config not found"; exit 1; }

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

list_login_items() {
    echo "📋 当前登录启动项:"
    osascript -e 'tell application "System Events" to get name of every login item' 2>/dev/null | tr ',' '\n' | while read item; do
        echo "   • $item"
    done

    echo ""
    echo "📋 当前 LaunchAgents:"
    ls ~/Library/LaunchAgents/ 2>/dev/null | while read item; do
        echo "   • $item"
    done
}

check_performance_impact() {
    local impact_count=0
    local recommendations=""

    # 检查已知可禁用的非关键服务
    for item in "Spotify" "SpotifyWebHelper"; do
        if osascript -e "tell application \"System Events\" to exists login item \"$item\"" 2>/dev/null; then
            impact_count=$((impact_count + 1))
            recommendations="$recommendations\n   • $item — 非必要，建议禁用 (~40MB)"
        fi
    done

    echo "📊 检测结果:"
    if [ "$impact_count" -gt 0 ]; then
        echo "   ⚠️ 发现 $impact_count 个可优化的启动项:"
        echo -e "$recommendations"
    else
        echo "   ✅ 当前登录项已优化，无需调整"
    fi
}

analyze_launch_agents() {
    echo "🔍 LaunchAgents 分析:"
    local agents_dir="$HOME/Library/LaunchAgents"
    local total=0
    local noncritical=0

    for plist in "$agents_dir"/*.plist 2>/dev/null; do
        [ -f "$plist" ] || continue
        total=$((total + 1))
        local label=$(plutil -p "$plist" 2>/dev/null | grep Label | awk -F'"' '{print $4}' || basename "$plist" .plist)
        local program=$(plutil -p "$plist" 2>/dev/null | grep -E "Program|ProgramArguments" | head -1 | sed 's/.*"\(.*\)".*/\1/' || echo "unknown")

        # 检查是否可能是非关键服务
        case "$(basename "$program" 2>/dev/null)" in
            Spotify*|Adobe*|Microsoft*|.*updater*)
                echo "   ⚠️ $label — 非关键，可考虑禁用"
                noncritical=$((noncritical + 1))
                ;;
            *)
                echo "   ✅ $label — 保留"
                ;;
        esac
    done

    if [ "$total" -eq 0 ]; then
        echo "   (空)"
    fi
    echo "   📊 共 $total 个 LaunchAgents，其中 $noncritical 个可优化"
}

optimize_startup() {
    log "🚀 开始启动项优化..."

    local disabled=0

    # 禁用已知非关键登录项
    for item in "SpotifyWebHelper" "Spotify"; do
        if osascript -e "tell application \"System Events\" to exists login item \"$item\"" 2>/dev/null; then
            osascript -e "tell application \"System Events\" to delete login item \"$item\"" 2>/dev/null
            log "   ✅ $item 已从登录项移除"
            disabled=$((disabled + 1))
        fi
    done

    # 禁用已知非关键 LaunchAgents
    for plist in "$HOME/Library/LaunchAgents/com.spotify*" "$HOME/Library/LaunchAgents/com.adobe*" "$HOME/Library/LaunchAgents/com.microsoft*"; do
        [ -f "$plist" ] 2>/dev/null || continue
        launchctl unload "$plist" 2>/dev/null || true
        log "   ✅ $(basename "$plist") 已卸载"
        disabled=$((disabled + 1))
    done

    log "✅ 启动项优化完成 — 处理了 $disabled 个项目"
    echo "✅ 已处理 $disabled 个启动项"
}

show_report() {
    echo ""
    echo "═══════════════════════════════════════"
    echo "  📊 开机加速 · 优化报告"
    echo "═══════════════════════════════════════"
    list_login_items
    echo ""
    check_performance_impact
    echo ""
    analyze_launch_agents
}

# 主逻辑
case "${1:-report}" in
    report)
        show_report
        ;;
    optimize)
        optimize_startup
        ;;
    list)
        list_login_items
        ;;
    analyze)
        analyze_launch_agents
        check_performance_impact
        ;;
    daemon|*)
        log "🚀 开机加速守护进程启动"
        echo "✅ 开机加速运行中..."
        echo "💡 使用: bash $SCRIPT_PATH report — 查看启动项报告"
        echo "💡 使用: bash $SCRIPT_PATH optimize — 执行优化"
        echo "💡 使用: bash $SCRIPT_PATH list — 列出登录项"
        ;;
esac
SCRIPT

chmod +x "$SCRIPT_PATH"

# 创建 launchd 服务（开机时运行一次检查）
cat > "$PLIST_PATH" << PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.mars.startup-optimizer</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>$SCRIPT_PATH</string>
        <string>report</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>StandardOutPath</key>
    <string>$LOG_DIR/startup-optimizer.stdout.log</string>
    <key>StandardErrorPath</key>
    <string>$LOG_DIR/startup-optimizer.stderr.log</string>
</dict>
</plist>
PLIST

# 加载服务
launchctl unload "$PLIST_PATH" 2>/dev/null || true
launchctl load "$PLIST_PATH"

echo ""
echo "✅ 开机加速 安装成功！"
echo "📋 配置文件: $CONF_PATH"
echo "📋 日志文件: $LOG_DIR/startup-optimizer.log"
echo "💡 报告启动项: bash $SCRIPT_PATH report"
echo "💡 执行优化: bash $SCRIPT_PATH optimize"
echo "💡 列出登录项: bash $SCRIPT_PATH list"
