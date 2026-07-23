#!/bin/bash
# ============================================================
# VPN分流路由 (VPN Split Routing) — 域名级智能分流
# 版本: 1.0.0
# 安装: curl -sL https://raw.githubusercontent.com/mars1417/mars-toolkit/gh-pages/installers/vpn-split-routing.sh | bash
# ============================================================

set -e

INSTALL_DIR="$HOME/.mars-toolkit"
SCRIPT_PATH="$INSTALL_DIR/vpn-split-routing.sh"
PLIST_PATH="$HOME/Library/LaunchAgents/com.mars.vpn-split-routing.plist"
CONF_PATH="$INSTALL_DIR/vpn-split-routing.conf"
LOG_DIR="$INSTALL_DIR/logs"

echo "🔧 正在安装 VPN分流路由 (VPN Split Routing)..."

mkdir -p "$INSTALL_DIR" "$LOG_DIR"

# 创建配置文件
cat > "$CONF_PATH" << CONF
# VPN分流路由配置

# VPN接口名称 (留空自动检测)
VPN_INTERFACE=""

# 直连域名列表（逗号分隔）
DIRECT_DOMAINS="weather.com.cn,baidu.com,taobao.com,jd.com,weibo.com,qq.com,163.com,sina.com.cn,sohu.com"

# VPN域名列表（走VPN的域名，逗号分隔）
VPN_DOMAINS="api.deepseek.com,openrouter.ai,api.nvidia.com,api.github.com,raw.githubusercontent.com,pypi.org,api.openai.com"

# V2Box leaf.conf 路径 (留空自动检测)
V2BOX_LEAF_CONF=""
CONF

# 创建主脚本
cat > "$SCRIPT_PATH" << 'SCRIPT'
#!/bin/bash
# VPN分流路由脚本 — 域名级智能分流

CONF_FILE="$HOME/.mars-toolkit/vpn-split-routing.conf"
LOG_FILE="$HOME/.mars-toolkit/logs/vpn-split-routing.log"

mkdir -p "$(dirname "$LOG_FILE")"
source "$CONF_FILE" 2>/dev/null || { echo "❌ Config not found"; exit 1; }

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

detect_vpn() {
    # 检测VPN接口
    local interfaces=$(ifconfig 2>/dev/null | grep -E "^utun" | awk '{print $1}' | sed 's/://')
    if [ -n "$interfaces" ]; then
        echo "🔍 检测到VPN接口:"
        for iface in $interfaces; do
            local ip=$(ifconfig "$iface" 2>/dev/null | grep "inet " | awk '{print $2}')
            echo "   • $iface → IP: ${ip:-N/A}"
        done
        return 0
    else
        echo "⚠️ 未检测到VPN接口"
        return 1
    fi
}

test_connectivity() {
    echo "🌐 连通性测试:"
    IFS=',' read -ra VPN_LIST <<< "$VPN_DOMAINS"
    for domain in "${VPN_LIST[@]}"; do
        domain=$(echo "$domain" | xargs)
        if nc -z -w3 "$domain" 443 2>/dev/null; then
            echo "   ✅ $domain:443 — 可达"
        else
            echo "   ❌ $domain:443 — 不可达（可能需要分流）"
        fi
    done

    IFS=',' read -ra DIRECT_LIST <<< "$DIRECT_DOMAINS"
    for domain in "${DIRECT_LIST[@]}"; do
        domain=$(echo "$domain" | xargs)
        if nc -z -w3 "$domain" 443 2>/dev/null; then
            echo "   ✅ $domain:443 — 可达"
        else
            echo "   ⚠️ $domain:443 — 不可达（可能被VPN误拦截）"
        fi
    done
}

detect_v2box_conf() {
    # 自动检测 V2Box leaf.conf 路径
    local paths=(
        "$HOME/Library/Group Containers/group.hossin.asaadi.V2Box/leaf.conf"
        "$HOME/Library/Containers/group.hossin.asaadi.V2Box/Data/leaf.conf"
        "/tmp/leaf.conf"
    )
    for p in "${paths[@]}"; do
        if [ -f "$p" ]; then
            echo "$p"
            return 0
        fi
    done
    return 1
}

configure_v2box() {
    echo "🔧 配置 V2Box 分流规则..."

    # 自动检测 leaf.conf
    local leaf_conf="${V2BOX_LEAF_CONF:-$(detect_v2box_conf)}"
    if [ -z "$leaf_conf" ] || [ ! -f "$leaf_conf" ]; then
        echo "❌ 找不到 V2Box leaf.conf"
        echo "   请手动设置 V2BOX_LEAF_CONF 路径"
        return 1
    fi

    echo "📋 找到 leaf.conf: $leaf_conf"

    # 备份原始配置
    local backup="$leaf_conf.backup.$(date '+%Y%m%d%H%M%S')"
    cp "$leaf_conf" "$backup"
    echo "✅ 已备份: $backup"

    # 添加直连域名规则
    local added=0
    IFS=',' read -ra DOMAINS <<< "$DIRECT_DOMAINS"
    for domain in "${DOMAINS[@]}"; do
        domain=$(echo "$domain" | xargs)
        if ! grep -q "DOMAIN-SUFFIX, $domain, direct" "$leaf_conf" 2>/dev/null; then
            sed -i '' "/^\\[Rule\\]/a\\
# 直连域名（由 VPN Split Routing 管理）\\
DOMAIN-SUFFIX, $domain, direct
" "$leaf_conf" 2>/dev/null || {
                # 如果 sed 失败，直接追加到文件末尾
                echo "DOMAIN-SUFFIX, $domain, direct" >> "$leaf_conf"
            }
            log "   ✅ $domain → direct"
            added=$((added + 1))
        fi
    done

    # 添加VPN域名规则
    IFS=',' read -ra VDOMAINS <<< "$VPN_DOMAINS"
    for domain in "${VDOMAINS[@]}"; do
        domain=$(echo "$domain" | xargs)
        if ! grep -q "DOMAIN-SUFFIX, $domain, proxy" "$leaf_conf" 2>/dev/null; then
            echo "DOMAIN-SUFFIX, $domain, proxy" >> "$leaf_conf"
            log "   ✅ $domain → proxy"
            added=$((added + 1))
        fi
    done

    log "✅ 配置完成 — 添加了 $added 条规则"
    echo "✅ 配置完成！添加了 $added 条规则"

    # 提示重启V2Box
    echo ""
    echo "💡 重启 V2Box 让新规则生效"
    echo "   手动重启或运行: killall V2Box && open -a V2Box"
}

show_status() {
    echo "═══════════════════════════════════════"
    echo "  🌐 VPN分流路由 · 状态报告"
    echo "═══════════════════════════════════════"
    detect_vpn
    echo ""
    test_connectivity

    # 检查 V2Box 配置
    local leaf_conf="${V2BOX_LEAF_CONF:-$(detect_v2box_conf)}"
    if [ -n "$leaf_conf" ] && [ -f "$leaf_conf" ]; then
        local rules=$(grep -c "^DOMAIN-SUFFIX" "$leaf_conf" 2>/dev/null || echo "0")
        echo ""
        echo "📋 V2Box 分流规则: $rules 条"
    fi
}

# 主逻辑
case "${1:-status}" in
    status)
        show_status
        ;;
    configure)
        configure_v2box
        ;;
    test)
        test_connectivity
        ;;
    detect)
        detect_vpn
        ;;
    daemon|*)
        log "🚀 VPN分流路由守护进程启动"
        echo "✅ VPN分流路由运行中..."
        echo "💡 查看状态: bash $SCRIPT_PATH status"
        echo "💡 配置V2Box: bash $SCRIPT_PATH configure"
        echo "💡 测试连接: bash $SCRIPT_PATH test"
        echo "💡 检测VPN: bash $SCRIPT_PATH detect"
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
    <string>com.mars.vpn-split-routing</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>$SCRIPT_PATH</string>
        <string>daemon</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>StandardOutPath</key>
    <string>$LOG_DIR/vpn-split-routing.stdout.log</string>
    <key>StandardErrorPath</key>
    <string>$LOG_DIR/vpn-split-routing.stderr.log</string>
</dict>
</plist>
PLIST

# 加载服务
launchctl unload "$PLIST_PATH" 2>/dev/null || true
launchctl load "$PLIST_PATH"

echo ""
echo "✅ VPN分流路由 安装成功！"
echo "📋 配置文件: $CONF_PATH"
echo "📋 日志文件: $LOG_DIR/vpn-split-routing.log"
echo "💡 查看状态: bash $SCRIPT_PATH status"
echo "💡 配置V2Box: bash $SCRIPT_PATH configure"
echo "💡 测试连接: bash $SCRIPT_PATH test"
