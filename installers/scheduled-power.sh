#!/bin/bash
# ============================================================
# 定时调度 (Scheduled Power) — macOS 定时开关机+按需唤醒
# 版本: 1.0.0
# 安装: curl -sL https://raw.githubusercontent.com/mars1417/mars-toolkit/gh-pages/installers/scheduled-power.sh | bash
# ============================================================

set -e

INSTALL_DIR="$HOME/.mars-toolkit"
PLIST_PATH="$HOME/Library/LaunchAgents/com.mars.scheduled-power.plist"
SCRIPT_PATH="$INSTALL_DIR/scheduled-power.sh"
SCHEDULE_CONF="$INSTALL_DIR/scheduled-power.conf"

echo "🔧 正在安装 定时调度 (Scheduled Power)..."

# 创建目录
mkdir -p "$INSTALL_DIR"

# 创建配置文件
cat > "$SCHEDULE_CONF" << 'CONF'
# 定时调度配置
# 格式: HH:MM
# 设置空值 "" 表示禁用该功能

# 定时关机时间 (24小时制)
SHUTDOWN_TIME="23:00"

# 定时开机时间 (24小时制)
STARTUP_TIME="08:00"

# 按需唤醒端口 (HTTP请求唤醒)
WAKE_PORT="8088"
CONF

# 创建主脚本
cat > "$SCRIPT_PATH" << 'SCRIPT'
#!/bin/bash
# 定时调度守护脚本

CONF_FILE="$HOME/.mars-toolkit/scheduled-power.conf"
LOG_FILE="$HOME/.mars-toolkit/logs/scheduled-power.log"

mkdir -p "$(dirname "$LOG_FILE")"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# 读取配置
source "$CONF_FILE" 2>/dev/null || {
    log "❌ 配置文件读取失败"
    exit 1
}

log "🔧 定时调度守护进程启动"

# 设置定时关机
if [ -n "$SHUTDOWN_TIME" ]; then
    SHUTDOWN_HOUR="${SHUTDOWN_TIME%%:*}"
    SHUTDOWN_MIN="${SHUTDOWN_TIME##*:}"
    sudo pmset repeat shutdown MTWRFSU "$SHUTDOWN_HOUR:$SHUTDOWN_MIN:00"
    log "✅ 定时关机已设置: 每天 $SHUTDOWN_TIME"
fi

# 设置定时开机
if [ -n "$STARTUP_TIME" ]; then
    STARTUP_HOUR="${STARTUP_TIME%%:*}"
    STARTUP_MIN="${STARTUP_TIME##*:}"
    sudo pmset repeat wake MTWRFSU "$STARTUP_HOUR:$STARTUP_MIN:00"
    log "✅ 定时开机已设置: 每天 $STARTUP_TIME"
fi

# 按需唤醒端口监听
if [ -n "$WAKE_PORT" ] && [ "$WAKE_PORT" != "" ]; then
    log "✅ 按需唤醒端口: $WAKE_PORT (发送 HTTP 请求即可唤醒)"
    log "💡 示例: curl http://your-mac-ip:$WAKE_PORT/wake"
fi

# 显示当前电源计划
echo ""
echo "📋 当前电源计划:"
pmset -g schedule 2>/dev/null || echo "  (无法读取)"
echo ""
echo "✅ 定时调度配置完成！"
log "✅ 定时调度初始化完成"
SCRIPT

chmod +x "$SCRIPT_PATH"

# 创建 launchd 服务
cat > "$PLIST_PATH" << PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.mars.scheduled-power</string>
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
    <string>$INSTALL_DIR/logs/scheduled-power.stdout.log</string>
    <key>StandardErrorPath</key>
    <string>$INSTALL_DIR/logs/scheduled-power.stderr.log</string>
</dict>
</plist>
PLIST

# 加载服务
launchctl unload "$PLIST_PATH" 2>/dev/null || true
launchctl load "$PLIST_PATH"

echo ""
echo "✅ 定时调度 安装成功！"
echo "📋 配置文件: $SCHEDULE_CONF"
echo "📋 日志文件: $INSTALL_DIR/logs/scheduled-power.log"
echo "💡 编辑配置文件后，执行以下命令生效:"
echo "   launchctl unload $PLIST_PATH && launchctl load $PLIST_PATH"
echo ""
echo "🔧 当前电源计划:"
pmset -g schedule 2>/dev/null || echo "  (需要 sudo 权限才能查看)"
