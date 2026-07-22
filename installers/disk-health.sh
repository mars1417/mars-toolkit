#!/bin/bash
# ============================================================
# 磁盘健康 (Disk Health) — SSD寿命监控+磁盘空间分析
# 版本: 1.0.0
# 安装: curl -sL https://raw.githubusercontent.com/mars1417/mars-toolkit/gh-pages/installers/disk-health.sh | bash
# ============================================================

set -e

INSTALL_DIR="$HOME/.mars-toolkit"
SCRIPT_PATH="$INSTALL_DIR/disk-health.sh"
PLIST_PATH="$HOME/Library/LaunchAgents/com.mars.disk-health.plist"
CONF_PATH="$INSTALL_DIR/disk-health.conf"
LOG_DIR="$INSTALL_DIR/logs"

echo "🔧 正在安装 磁盘健康 (Disk Health)..."

mkdir -p "$INSTALL_DIR" "$LOG_DIR"

# 创建配置文件
cat > "$CONF_PATH" << CONF
# 磁盘健康配置
# 磁盘使用率预警阈值 (百分比)
DISK_WARN_PERCENT=85

# 检查频率 (分钟)
CHECK_INTERVAL=60

# 是否启用S.M.A.R.T.监控 (true/false)
SMART_MONITOR="true"
CONF

# 创建主脚本
cat > "$SCRIPT_PATH" << 'SCRIPT'
#!/bin/bash
# 磁盘健康监控守护脚本

CONF_FILE="$HOME/.mars-toolkit/disk-health.conf"
LOG_FILE="$HOME/.mars-toolkit/logs/disk-health.log"
REPORT_FILE="$HOME/.mars-toolkit/logs/disk-report.txt"

mkdir -p "$(dirname "$LOG_FILE")"
source "$CONF_FILE" 2>/dev/null || { echo "❌ Config not found"; exit 1; }

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

check_disk_smart() {
    log "💿 检查磁盘S.M.A.R.T.状态..."
    local report=""

    # 获取所有物理磁盘
    local disks
    disks=$(diskutil list internal physical 2>/dev/null | grep "^/dev/" || echo "")

    if [ -z "$disks" ]; then
        # fallback: 获取主设备
        disks=$(df / | tail -1 | awk '{print $1}')
    fi

    for disk in $disks; do
        local disk_name
        disk_name=$(basename "$disk")
        local info

        # 使用 diskutil info 获取健康信息
        info=$(diskutil info "$disk" 2>/dev/null)

        local smart_status
        smart_status=$(echo "$info" | grep "SMART Status" | awk -F':' '{print $2}' | xargs)

        local trim_status
        trim_status=$(echo "$info" | grep "TRIM.*Enabled\|Firmware.*TRIM" | awk -F':' '{print $2}' | xargs)

        if [ -z "$trim_status" ]; then
            trim_status=$(system_profiler SPNVMeDataType 2>/dev/null | grep "TRIM.*Yes" | head -1 | awk '{print "Yes"}')
            [ -z "$trim_status" ] && trim_status="Unknown"
        fi

        local media_name
        media_name=$(echo "$info" | grep "Media Name" | awk -F':' '{print $2}' | xargs)
        [ -z "$media_name" ] && media_name="$disk"

        SMART=${smart_status:-"Not Supported"}
        TRIM=${trim_status:-"Unknown"}

        report="$report📀 $media_name
   S.M.A.R.T.: $SMART
   TRIM: $TRIM
"
        log "💿 $media_name — SMART: $SMART, TRIM: $TRIM"
    done

    echo "$report"
}

check_disk_space() {
    log "💿 检查磁盘空间..."
    local warn=$DISK_WARN_PERCENT
    [ -z "$warn" ] && warn=85

    # 检查根分区
    local usage
    usage=$(df -h / | tail -1 | awk '{print $5}' | sed 's/%//')
    local used
    used=$(df -h / | tail -1 | awk '{print $3}')
    local total
    total=$(df -h / | tail -1 | awk '{print $2}')

    log "💾 磁盘使用: ${used}/${total} (${usage}%)"

    local alert=""
    if [ "$usage" -gt "$warn" ] 2>/dev/null; then
        alert="⚠️ 磁盘使用率 ${usage}% 超过预警阈值 ${warn}%!"
        log "$alert"
    fi

    echo "$used/$total ($usage%)"
    [ -n "$alert" ] && echo "$alert"
}

find_large_files() {
    local top_dir="${1:-$HOME}"
    local limit="${2:-5}"

    echo "📂 最大的 $limit 个文件 (>100MB):"
    find "$top_dir" -type f -size +100M 2>/dev/null | head -"$limit" | while read -r f; do
        size=$(ls -lh "$f" 2>/dev/null | awk '{print $5}')
        echo "   $size  $f"
    done
}

# 生成综合报告
generate_report() {
    log "📋 生成磁盘健康报告..."
    {
        echo "========================================"
        echo "  磁盘健康报告 — $(date '+%Y-%m-%d %H:%M')"
        echo "========================================"
        echo ""
        echo "📊 S.M.A.R.T. 状态:"
        check_disk_smart
        echo ""
        echo "💾 磁盘使用情况:"
        df -h / | awk 'NR==1 || NR==2'
        echo ""
        check_disk_space
        echo ""
        find_large_files "$HOME" 5
        echo ""
        echo "--- END ---"
    } > "$REPORT_FILE"

    log "✅ 磁盘健康报告已保存到 $REPORT_FILE"
}

case "${1:-daemon}" in
    check)
        check_disk_smart
        check_disk_space
        ;;
    report)
        generate_report
        cat "$REPORT_FILE"
        ;;
    find)
        shift
        find_large_files "${1:-$HOME}" "${2:-10}"
        ;;
    daemon|*)
        log "🚀 磁盘健康守护进程启动"
        generate_report
        echo "✅ 磁盘健康守护运行中"
        echo "📋 报告文件: $REPORT_FILE"
        echo "⏰ 检查频率: 每 ${CHECK_INTERVAL:-60} 分钟"
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
    <string>com.mars.disk-health</string>
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
    <string>$LOG_DIR/disk-health.stdout.log</string>
    <key>StandardErrorPath</key>
    <string>$LOG_DIR/disk-health.stderr.log</string>
</dict>
</plist>
PLIST

# 加载服务
launchctl unload "$PLIST_PATH" 2>/dev/null || true
launchctl load "$PLIST_PATH"

echo ""
echo "✅ 磁盘健康 安装成功！"
echo "📋 配置文件: $CONF_PATH"
echo "📋 报告文件: $REPORT_FILE"
echo "💡 手动检查: bash $SCRIPT_PATH check"
echo "📋 完整报告: bash $SCRIPT_PATH report"
