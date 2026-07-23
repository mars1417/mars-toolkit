#!/bin/bash
# ============================================================
# 桌面整理 (Desktop Organizer) — 桌面文件自动分类归档
# 版本: 1.0.0
# 安装: curl -sL https://raw.githubusercontent.com/mars1417/mars-toolkit/gh-pages/installers/desktop-organizer.sh | bash
# ============================================================

set -e

INSTALL_DIR="$HOME/.mars-toolkit"
SCRIPT_PATH="$INSTALL_DIR/desktop-organizer.sh"
PLIST_PATH="$HOME/Library/LaunchAgents/com.mars.desktop-organizer.plist"
CONF_PATH="$INSTALL_DIR/desktop-organizer.conf"
LOG_DIR="$INSTALL_DIR/logs"

echo "🔧 正在安装 桌面整理 (Desktop Organizer)..."

mkdir -p "$INSTALL_DIR" "$LOG_DIR"

# 创建配置文件
cat > "$CONF_PATH" << CONF
# 桌面整理配置
# 目标桌面路径
DESKTOP_DIR="$HOME/Desktop"

# 自动运行模式: auto/manual
MODE="manual"

# 启用启动台自动整理 (true/false)
AUTO_ORGANIZE="false"

# 需要忽略的文件（逗号分隔）
IGNORE_FILES=".DS_Store,.localized"

# 文件分类规则
# 格式: 文件夹名:扩展名列表
CATEGORIES="_项目:git,github,code,xcodeproj,xcworkspace,swift,py,js,ts,html,css,go,rs
_文档合同:pdf,doc,docx,xls,xlsx,ppt,pptx,txt,md,csv,json,xml,yaml,yml
_素材视频:jpg,jpeg,png,gif,bmp,svg,webp,ico,mp4,mov,avi,mkv,mp3,wav,aac,psd,ai,fig,xd,sketch
_归档:zip,tar,gz,bz2,7z,rar,dmg,iso,pkg,bak,old,backup
_工具:app,workflow,shortcut,alfredworkflow
_知识库:epub,mobi,azw3,chm,djvu
CONF

# 创建主脚本
cat > "$SCRIPT_PATH" << 'SCRIPT'
#!/bin/bash
# 桌面整理守护脚本 — 自动分类归档桌面文件

CONF_FILE="$HOME/.mars-toolkit/desktop-organizer.conf"
LOG_FILE="$HOME/.mars-toolkit/logs/desktop-organizer.log"

mkdir -p "$(dirname "$LOG_FILE")"
source "$CONF_FILE" 2>/dev/null || { echo "❌ Config not found"; exit 1; }

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

organize_desktop() {
    log "📁 开始整理桌面文件..."
    echo "📁 正在整理桌面文件..."

    local sorted=0
    local skipped=0

    # 读取分类规则
    declare -A RULES
    IFS=$'\n'
    for line in $CATEGORIES; do
        folder="${line%%:*}"
        exts="${line#*:}"
        RULES["$folder"]="$exts"
    done

    # 遍历桌面文件
    for file in "$DESKTOP_DIR"/*; do
        [ -f "$file" ] || continue
        local basename=$(basename "$file")
        local ext="${basename##*.}"

        # 检查是否在忽略列表
        local ignore=false
        IFS=',' read -ra IGNORE <<< "$IGNORE_FILES"
        for ign in "${IGNORE[@]}"; do
            if [ "$basename" = "$ign" ]; then
                ignore=true
                break
            fi
        done
        $ignore && { skipped=$((skipped + 1)); continue; }

        # 查找匹配的分类
        local matched=false
        for folder in "${!RULES[@]}"; do
            IFS=',' read -ra exts_arr <<< "${RULES[$folder]}"
            for e in "${exts_arr[@]}"; do
                e=$(echo "$e" | xargs)  # trim
                [ "${ext,,}" = "${e,,}" ] || continue
                local target="$DESKTOP_DIR/$folder"
                mkdir -p "$target"
                cp "$file" "$target/" 2>/dev/null && rm "$file" 2>/dev/null
                log "   📄 $basename → $folder/"
                sorted=$((sorted + 1))
                matched=true
                break
            done
            $matched && break
        done

        if ! $matched; then
            # 无匹配，按名称猜测
            local target="$DESKTOP_DIR/_其他"
            mkdir -p "$target"
            cp "$file" "$target/" 2>/dev/null && rm "$file" 2>/dev/null
            log "   📄 $basename → _其他/"
            sorted=$((sorted + 1))
        fi
    done

    log "✅ 整理完成 — 处理了 $sorted 个文件（跳过 $skipped 个系统文件）"
    echo "✅ 整理完成！处理了 $sorted 个文件"
    [ "$skipped" -gt 0 ] && echo "⏭️ 跳过 $skipped 个系统文件"
}

show_stats() {
    echo "📊 桌面整理状态"
    echo "═══════════════════════"
    local total_files=0
    for f in "$DESKTOP_DIR"/*; do
        [ -f "$f" ] && total_files=$((total_files + 1))
    done
    echo "桌面文件总数: $total_files"

    echo ""
    echo "📂 分类文件夹:"
    IFS=$'\n'
    for line in $CATEGORIES; do
        folder="${line%%:*}"
        count=0
        [ -d "$DESKTOP_DIR/$folder" ] && count=$(ls -1 "$DESKTOP_DIR/$folder" 2>/dev/null | wc -l | tr -d ' ')
        echo "   $folder → $count 个文件"
    done
    echo ""

    # 检查桌面是否整洁
    local messy_files=0
    for f in "$DESKTOP_DIR"/*; do
        [ -f "$f" ] && messy_files=$((messy_files + 1))
    done
    if [ "$messy_files" -le 3 ]; then
        echo "✅ 桌面很整洁！"
    else
        echo "⚠️ 桌面还有 $messy_files 个散落文件"
    fi
}

# 主逻辑
case "${1:-organize}" in
    organize)
        organize_desktop
        show_stats
        ;;
    stats|status)
        show_stats
        ;;
    daemon|*)
        log "🚀 桌面整理守护进程启动"
        echo "✅ 桌面整理运行中..."
        echo "💡 整理桌面: bash $SCRIPT_PATH organize"
        echo "💡 查看状态: bash $SCRIPT_PATH stats"
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
    <string>com.mars.desktop-organizer</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>$SCRIPT_PATH</string>
        <string>daemon</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <false/>
    <key>StandardOutPath</key>
    <string>$LOG_DIR/desktop-organizer.stdout.log</string>
    <key>StandardErrorPath</key>
    <string>$LOG_DIR/desktop-organizer.stderr.log</string>
</dict>
</plist>
PLIST

# 加载服务
launchctl unload "$PLIST_PATH" 2>/dev/null || true
launchctl load "$PLIST_PATH"

echo ""
echo "✅ 桌面整理 安装成功！"
echo "📋 配置文件: $CONF_PATH"
echo "📋 日志文件: $LOG_DIR/desktop-organizer.log"
echo "💡 手动整理: bash $SCRIPT_PATH organize"
echo "💡 查看状态: bash $SCRIPT_PATH stats"
