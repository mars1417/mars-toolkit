#!/bin/bash
# ============================================================
# 系统清理 (Clean Sweep) — 一键内存回收+缓存清理
# 版本: 1.0.0
# 安装: curl -sL https://raw.githubusercontent.com/mars1417/mars-toolkit/gh-pages/installers/clean-sweep.sh | bash
# ============================================================

set -e

INSTALL_DIR="$HOME/.mars-toolkit"
SCRIPT_PATH="$INSTALL_DIR/clean-sweep.sh"
PLIST_PATH="$HOME/Library/LaunchAgents/com.mars.clean-sweep.plist"
CONF_PATH="$INSTALL_DIR/clean-sweep.conf"
LOG_DIR="$INSTALL_DIR/logs"

echo "🔧 正在安装 系统清理 (Clean Sweep)..."

mkdir -p "$INSTALL_DIR" "$LOG_DIR"

# 创建配置文件
cat > "$CONF_PATH" << CONF
# 系统清理配置
# 自动清理时间 (24小时制, 空值=禁用)
CLEAN_TIME="02:00"

# 内存阈值 (可用内存低于此值MB时触发清理)
MEM_THRESHOLD_MB=512

# 自动清理的浏览器 (chrome/safari/all/none)
CLEAN_BROWSER="chrome"

# 是否清理系统日志 (true/false)
CLEAN_LOGS="false"

# 是否清理废纸篓 (true/false)
CLEAN_TRASH="false"
CONF

# 创建主脚本
cat > "$SCRIPT_PATH" << 'SCRIPT'
#!/bin/bash
# 系统清理守护脚本 — 自动内存回收 + 缓存清理

CONF_FILE="$HOME/.mars-toolkit/clean-sweep.conf"
LOG_FILE="$HOME/.mars-toolkit/logs/clean-sweep.log"

mkdir -p "$(dirname "$LOG_FILE")"
source "$CONF_FILE" 2>/dev/null || { echo "❌ Config not found"; exit 1; }

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

clean_memory() {
    log "🧹 开始内存清理..."

    # 跳过清理条件: V2Box运行中
    if pgrep -f "v2ray\|V2Box" > /dev/null 2>&1; then
        log "⏭️ V2Box running — skipping app close"
    else
        # 关闭内存大户
        for app in "WPS" "Stocks" "Warp"; do
            pid=$(pgrep -f "$app" 2>/dev/null | head -1)
            if [ -n "$pid" ]; then
                kill "$pid" 2>/dev/null
                log "   🧹 $app closed (PID $pid)"
            fi
        done
    fi

    # Chrome 内存管理 — 关闭窗口不杀进程
    if pgrep -x "Google Chrome" > /dev/null; then
        osascript -e 'tell application "Google Chrome" to close every window' 2>/dev/null
        log "   🧹 Chrome windows closed (process kept)"
    fi

    # 内存释放
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # 尝试不带sudo的purge
        sudo purge 2>/dev/null && log "   💨 Memory purged (sudo)"
        # 强制刷新DNS缓存 (顺便清理系统缓存)
        dscacheutil -flushcache 2>/dev/null || true
    fi

    # 显示清理结果
    if [[ "$OSTYPE" == "darwin"* ]]; then
        free=$(vm_stat | awk '/Pages free/ {print $3}' | tr -d '.')
        inactive=$(vm_stat | awk '/Pages inactive/ {print $3}' | tr -d '.')
        page=$(vm_stat | awk '/page size of/ {print $8}' | tr -d '.')
        [ -z "$page" ] && page=16384
        available=$(( (free + inactive) * page / 1048576 ))
        log "✅ 内存清理完成 — 可用: ~${available}MB"
        echo "📊 可用内存: ~${available}MB"
    fi
}

clean_cache() {
    log "🧹 开始缓存清理..."

    # 清理浏览器缓存
    if [ "$CLEAN_BROWSER" = "chrome" ] || [ "$CLEAN_BROWSER" = "all" ]; then
        rm -rf "$HOME/Library/Caches/Google/Chrome/Default/Cache"/* 2>/dev/null || true
        rm -rf "$HOME/Library/Caches/Google/Chrome/Default/Code Cache"/* 2>/dev/null || true
        log "   ✅ Chrome 缓存已清理"
    fi
    if [ "$CLEAN_BROWSER" = "safari" ] || [ "$CLEAN_BROWSER" = "all" ]; then
        rm -rf "$HOME/Library/Caches/com.apple.Safari"/* 2>/dev/null || true
        log "   ✅ Safari 缓存已清理"
    fi

    # 清理系统临时文件
    rm -rf "$HOME/Library/Caches/com.apple.helpd"/* 2>/dev/null || true
    rm -rf "$HOME/Library/Caches/com.apple.appstore"/* 2>/dev/null || true

    # 清理系统日志
    if [ "$CLEAN_LOGS" = "true" ]; then
        sudo rm -rf /Library/Logs/* 2>/dev/null || true
        log "   ✅ 系统日志已清理"
    fi

    # 清理废纸篓
    if [ "$CLEAN_TRASH" = "true" ]; then
        rm -rf "$HOME/.Trash"/* 2>/dev/null || true
        log "   ✅ 废纸篓已清理"
    fi

    # 磁盘空间报告
    df -h / | awk 'NR==2 {print "💾 磁盘使用: " $3 "/" $2 " (" $5 ")"}'
    log "✅ 缓存清理完成"
}

# 内存阈值监控
monitor_memory() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        free=$(vm_stat | awk '/Pages free/ {print $3}' | tr -d '.')
        inactive=$(vm_stat | awk '/Pages inactive/ {print $3}' | tr -d '.')
        page=$(vm_stat | awk '/page size of/ {print $8}' | tr -d '.')
        [ -z "$page" ] && page=16384
        available=$(( (free + inactive) * page / 1048576 ))

        if [ "$available" -lt "$MEM_THRESHOLD_MB" ] 2>/dev/null; then
            log "⚠️ 内存低于阈值 (${available}MB < ${MEM_THRESHOLD_MB}MB)，触发清理"
            clean_memory
        fi
    fi
}

# 主逻辑
case "${1:-daemon}" in
    clean)
        # 单次清理模式
        clean_memory
        clean_cache
        ;;
    monitor)
        # 监控模式 (仅检查内存)
        monitor_memory
        ;;
    daemon|*)
        # 守护模式
        log "🚀 系统清理守护进程启动"
        echo "✅ 系统清理守护运行中..."

        # 如果设置了定时清理，显示
        if [ -n "$CLEAN_TIME" ]; then
            echo "⏰ 定时清理: 每天 $CLEAN_TIME"
            log "⏰ 定时清理: 每天 $CLEAN_TIME"
        fi

        # 初次运行
        clean_memory
        echo "📊 清理完成，守护进程保持运行"
        ;;
esac
SCRIPT

chmod +x "$SCRIPT_PATH"

# 创建 launchd 服务
cat > "$PLIST_PATH" << PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.mars.clean-sweep</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>$SCRIPT_PATH</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>$LOG_DIR/clean-sweep.stdout.log</string>
    <key>StandardErrorPath</key>
    <string>$LOG_DIR/clean-sweep.stderr.log</string>
    <key>StartCalendarInterval</key>
    <array>
        <dict>
            <key>Hour</key>
            <integer>2</integer>
            <key>Minute</key>
            <integer>0</integer>
        </dict>
    </array>
</dict>
</plist>
PLIST

# 加载服务
launchctl unload "$PLIST_PATH" 2>/dev/null || true
launchctl load "$PLIST_PATH"

echo ""
echo "✅ 系统清理 安装成功！"
echo "📋 配置文件: $CONF_PATH"
echo "📋 日志文件: $LOG_DIR/clean-sweep.log"
echo "💡 手动运行: bash $SCRIPT_PATH clean"
echo "📊 查看内存: bash $SCRIPT_PATH monitor"
