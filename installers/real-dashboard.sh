#!/bin/bash
# ============================================================
# 实机看板 (Real Dashboard) — 本机运行数据实时网页展示
# 版本: 1.0.0
# 安装: curl -sL https://raw.githubusercontent.com/mars1417/mars-toolkit/gh-pages/installers/real-dashboard.sh | bash
# ============================================================

set -e

INSTALL_DIR="$HOME/.mars-toolkit"
SCRIPT_PATH="$INSTALL_DIR/real-dashboard.sh"
PLIST_PATH="$HOME/Library/LaunchAgents/com.mars.real-dashboard.plist"
DASHBOARD_PORT="8080"

echo "🔧 正在安装 实机看板 (Real Dashboard)..."

mkdir -p "$INSTALL_DIR" "$INSTALL_DIR/logs" "$INSTALL_DIR/dashboard"

# 创建数据采集脚本
cat > "$SCRIPT_PATH" << 'SCRIPT'
#!/bin/bash
# 实机看板 — 数据采集 + HTTP服务

PORT="${DASHBOARD_PORT:-8080}"
DATA_FILE="$HOME/.mars-toolkit/dashboard/data.json"
LOG_FILE="$HOME/.mars-toolkit/logs/real-dashboard.log"

mkdir -p "$(dirname "$DATA_FILE")" "$(dirname "$LOG_FILE")"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

collect_data() {
    # CPU 温度
    CPU_TEMP=$(sudo powermetrics --samplers smc -i 1 -n 1 2>/dev/null | grep "CPU die" | awk '{print $NF}' | sed 's/C//' || echo "N/A")

    # 内存使用
    MEM_TOTAL=$(sysctl -n hw.memsize)
    MEM_USED=$(vm_stat | awk '/Pages active/ {a=$NF} /Pages wired/ {w=$NF} END {printf "%.0f", (a+w)*4096/1024/1024}')
    MEM_FREE=$(vm_stat | awk '/Pages free/ {print $NF}' | sed 's/\.//')
    MEM_PERCENT=$(echo "scale=0; $MEM_USED * 100 / (($MEM_TOTAL/1024/1024))" | bc 2>/dev/null || echo "0")

    # 磁盘
    DISK_INFO=$(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')

    # 运行时间
    UPTIME=$(uptime | awk -F'up' '{print $2}' | awk -F',' '{print $1}' | xargs)

    # 电池
    BATTERY_CYCLES=$(system_profiler SPPowerDataType 2>/dev/null | grep "Cycle Count" | awk '{print $3}' || echo "N/A")
    BATTERY_HEALTH=$(system_profiler SPPowerDataType 2>/dev/null | grep "Condition" | awk '{print $2}' || echo "N/A")

    # 进程数
    PROCESSES=$(ps aux | wc -l | tr -d ' ')

    # CPU 负载
    CPU_LOAD=$(uptime | awk -F'load averages:' '{print $2}' | xargs)

    # 创建JSON
    cat > "$DATA_FILE" << EOF
{
  "timestamp": "$(date '+%Y-%m-%d %H:%M:%S')",
  "uptime": "$UPTIME",
  "cpu_temp": "$CPU_TEMP",
  "cpu_load": "$CPU_LOAD",
  "memory_used_mb": "$MEM_USED",
  "memory_percent": "$MEM_PERCENT",
  "disk": "$DISK_INFO",
  "battery_cycles": "$BATTERY_CYCLES",
  "battery_health": "$BATTERY_HEALTH",
  "processes": "$PROCESSES"
}
EOF
}

# 启动 HTTP 服务
serve_http() {
    log "📊 实机看板 HTTP 服务启动于端口 $PORT"

    while true; do
        # 每30秒采集一次数据
        collect_data

        # 用 nc 做简易 HTTP 服务
        echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/html; charset=utf-8\r\nAccess-Control-Allow-Origin: *\r\n\r\n$(cat << 'HTML'
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>实机看板 — Mac 状态监控</title>
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI','PingFang SC',Roboto,sans-serif;background:#0d0f1a;color:#e8e8f0;padding:24px}
h1{font-size:28px;margin-bottom:20px;color:#4785a8}
.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:16px}
.card{background:rgba(255,255,255,0.03);border:1px solid rgba(255,255,255,0.06);border-radius:16px;padding:20px}
.card .label{font-size:11px;color:rgba(255,255,255,0.3);text-transform:uppercase;letter-spacing:1px}
.card .value{font-size:24px;font-weight:700;margin-top:4px;color:#fff}
.card .value.green{color:#34c759}
.card .value.blue{color:#4785a8}
.card .value.gold{color:#ffd700}
.refresh{text-align:center;margin-top:20px;color:rgba(255,255,255,0.2);font-size:12px}
</style>
</head>
<body>
<h1>📊 实机看板</h1>
<div class="grid" id="data-grid">
  <div class="card"><div class="label">运行时间</div><div class="value blue" id="uptime">-</div></div>
  <div class="card"><div class="label">CPU 温度</div><div class="value gold" id="cpu-temp">-</div></div>
  <div class="card"><div class="label">CPU 负载</div><div class="value" id="cpu-load">-</div></div>
  <div class="card"><div class="label">内存使用</div><div class="value green" id="memory">-</div></div>
  <div class="card"><div class="label">磁盘</div><div class="value" id="disk">-</div></div>
  <div class="card"><div class="label">电池循环</div><div class="value blue" id="battery-cycles">-</div></div>
  <div class="card"><div class="label">电池健康</div><div class="value green" id="battery-health">-</div></div>
  <div class="card"><div class="label">进程数</div><div class="value" id="processes">-</div></div>
</div>
<div class="refresh">🔄 每30秒自动刷新 · 最后更新: <span id="last-update">-</span></div>
<script>
function fetchData() {
  fetch('/data.json').then(r=>r.json()).then(d=>{
    document.getElementById('uptime').textContent = d.uptime || '-';
    document.getElementById('cpu-temp').textContent = d.cpu_temp ? d.cpu_temp + '°C' : '-';
    document.getElementById('cpu-load').textContent = d.cpu_load || '-';
    document.getElementById('memory').textContent = d.memory_percent ? d.memory_percent + '% (' + d.memory_used_mb + 'MB)' : '-';
    document.getElementById('disk').textContent = d.disk || '-';
    document.getElementById('battery-cycles').textContent = d.battery_cycles || '-';
    document.getElementById('battery-health').textContent = d.battery_health || '-';
    document.getElementById('processes').textContent = d.processes || '-';
    document.getElementById('last-update').textContent = d.timestamp || '-';
  }).catch(()=>{});
}
fetchData();
setInterval(fetchData, 30000);
</script>
</body>
</html>
)" | nc -l -p "$PORT" -q 1 2>/dev/null || true
    done
}

serve_http
SCRIPT

chmod +x "$SCRIPT_PATH"

# 创建 launchd 服务
cat > "$PLIST_PATH" << PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.mars.real-dashboard</string>
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
    <string>$INSTALL_DIR/logs/real-dashboard.stdout.log</string>
    <key>StandardErrorPath</key>
    <string>$INSTALL_DIR/logs/real-dashboard.stderr.log</string>
</dict>
</plist>
PLIST

# 加载服务
launchctl unload "$PLIST_PATH" 2>/dev/null || true
launchctl load "$PLIST_PATH"

echo ""
echo "✅ 实机看板 安装成功！"
echo "📋 数据文件: $DATA_FILE"
echo "💡 浏览器打开: http://localhost:$PORT"
echo "📋 日志文件: $INSTALL_DIR/logs/real-dashboard.log"
