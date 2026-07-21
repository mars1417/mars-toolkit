#!/bin/bash
# ============================================================
# 网络唤醒 (Wake-on-LAN) — 远程唤醒休眠中的Mac
# 版本: 1.0.0
# 安装: curl -sL https://raw.githubusercontent.com/mars1417/mars-toolkit/gh-pages/installers/wake-on-lan.sh | bash
# ============================================================

set -e

INSTALL_DIR="$HOME/.mars-toolkit"
SCRIPT_PATH="$INSTALL_DIR/wake-on-lan.sh"
PLIST_PATH="$HOME/Library/LaunchAgents/com.mars.wake-on-lan.plist"
CONF_PATH="$INSTALL_DIR/wake-on-lan.conf"
WOL_PORT="8888"

echo "🔧 正在安装 网络唤醒 (Wake-on-LAN)..."

mkdir -p "$INSTALL_DIR" "$INSTALL_DIR/logs"

# 获取本机MAC地址
MAC_ADDR=$(ifconfig en0 2>/dev/null | awk '/ether/{print $2}' || echo "00:00:00:00:00:00")

# 创建配置文件
cat > "$CONF_PATH" << CONF
# 网络唤醒配置
# 本机 MAC 地址 (用于远程唤醒)
MAC_ADDRESS="$MAC_ADDR"

# 唤醒监听端口
LISTEN_PORT="$WOL_PORT"

# 唤醒安全密钥 (设置为空字符串禁用)
SECRET_KEY="mymac"
CONF

# 创建主脚本
cat > "$SCRIPT_PATH" << 'SCRIPT'
#!/bin/bash
# 网络唤醒守护脚本

CONF_FILE="$HOME/.mars-toolkit/wake-on-lan.conf"
LOG_FILE="$HOME/.mars-toolkit/logs/wake-on-lan.log"
STATUS_FILE="$HOME/.mars-toolkit/logs/wol-status.txt"

mkdir -p "$(dirname "$LOG_FILE")"
source "$CONF_FILE" 2>/dev/null || { echo "Config not found"; exit 1; }

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

enable_wol() {
    # 启用网络唤醒
    sudo pmset -a womp 1
    log "✅ WOL (Wake on Magic Packet) 已启用"

    # 记录网络配置
    ifconfig en0 2>/dev/null | grep "inet " >> "$LOG_FILE"
}

wake_listener() {
    log "🔍 WOL 监听端口: $LISTEN_PORT"
    log "📡 MAC 地址: $MAC_ADDRESS"

    echo "WOL Active: 端口 $LISTEN_PORT" > "$STATUS_FILE"
    echo "MAC: $MAC_ADDRESS" >> "$STATUS_FILE"

    # 简易监听循环
    while true; do
        # 接收WOL请求
        local request
        request=$(echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\nWOL Listener Active\nMAC: $MAC_ADDRESS\nPort: $LISTEN_PORT\n" | nc -l -p "$LISTEN_PORT" -q 1 2>/dev/null)
        if [ -n "$request" ]; then
            log "📩 收到唤醒请求"
        fi
        sleep 1
    done
}

# 执行
enable_wol
wake_listener
SCRIPT

chmod +x "$SCRIPT_PATH"

# 创建 launchd 服务
cat > "$PLIST_PATH" << PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.mars.wake-on-lan</string>
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
    <string>$INSTALL_DIR/logs/wake-on-lan.stdout.log</string>
    <key>StandardErrorPath</key>
    <string>$INSTALL_DIR/logs/wake-on-lan.stderr.log</string>
</dict>
</plist>
PLIST

# 加载服务
launchctl unload "$PLIST_PATH" 2>/dev/null || true
launchctl load "$PLIST_PATH"

echo ""
echo "✅ 网络唤醒 安装成功！"
echo "📋 配置文件: $CONF_PATH"
echo "📋 本机 MAC: $MAC_ADDR"
echo "💡 发送 WOL Magic Packet 到此 MAC 地址即可唤醒"
echo "📋 日志文件: $INSTALL_DIR/logs/wake-on-lan.log"
