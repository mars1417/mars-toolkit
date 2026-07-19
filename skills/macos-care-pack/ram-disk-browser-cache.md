---
name: ram-disk-browser-cache
description: 【RAM Disk浏览器缓存】当需要把Chrome/Safari缓存从SSD迁移到内存时使用。减少SSD写入、加速浏览，适合老Mac/小内存机器。支持128-256MB RAM Disk，含launchd plist开机自动加载
---

# RAM Disk 浏览器缓存

## 用途
将浏览器缓存从物理 SSD 迁移到内存（RAM Disk），减少 SSD 写入磨损，同时提升浏览速度。

## 适用场景
- 老Mac（2015年前后）SSD写入寿命有限
- 4GB-8GB内存机器，浏览器频繁写缓存
- 24小时不关机的服务器型Mac

## 操作步骤

### 1. 创建和挂载RAM Disk（手动测试）
```bash
RAMDISK_SIZE=128  # MB，建议128-256
RAMDISK_NAME="BrowserCache"
MOUNT_POINT="/Volumes/$RAMDISK_NAME"

# 创建RAM Disk (128MB)
DEVICE=$(hdiutil attach -nomount ram://$((RAMDISK_SIZE * 2048)) | awk '{print $1}')
diskutil erasevolume HFS+ "$RAMDISK_NAME" "$DEVICE"

# 创建缓存目录
mkdir -p "$MOUNT_POINT/Google" "$MOUNT_POINT/Safari"

# 软链Chrome / Safari 缓存
rm -rf ~/Library/Caches/Google
ln -sf "$MOUNT_POINT/Google" ~/Library/Caches/Google
rm -rf ~/Library/Caches/com.apple.Safari
ln -sf "$MOUNT_POINT/Safari" ~/Library/Caches/com.apple.Safari
```

### 2. 创建自启动Launchd plist
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>local.ramdisk.browsercache</string>
    <key>ProgramArguments</key>
    <array>
        <string>/path/to/ramdisk-browser-cache.sh</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <false/>
</dict>
</plist>
```

### 3. 安装并加载
```bash
launchctl load ~/Library/LaunchAgents/local.ramdisk.browsercache.plist
... (full content available in Hermes Agent)
