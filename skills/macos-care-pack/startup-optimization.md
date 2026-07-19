---
name: startup-optimization
description: 【开机启动优化】当需要加速Mac开机速度、减少登录项时使用。管理Login Items和Launch Agents，适用于24小时不关机的服务器型Mac
---

# 开机启动优化

## 用途
减少不必要的登录启动项，加速开机（或少占用后台资源）。特别是24小时不关机的机器，每个多余进程都是持续的负担。

## 检查登录项
```bash
# 系统偏好设置中的登录项
osascript -e 'tell application "System Events" to get name of every login item'

# LaunchAgents
ls ~/Library/LaunchAgents/
```

## 管理策略

### 对24小时不关机的Mac（如本机）
很多开机启动项没有意义，因为机器从不关机重启：
- 自动更新检查器（Chrome/Spotify/Adobe）→ 可禁用，手动更新
- 菜单栏工具（如smcFanControl）→ 需保留（风扇控制）
- V2Box → 需保留（代理服务）

### 常用可禁用的登录项
| 项目 | 影响 | 
|------|------|
| SpotifyWebHelper | 占~40MB内存，不用即可禁用 |
| Google Updater | 占~30MB，可手动更新 |
| Adobe Creative Cloud | 占~150MB！超大户，可关 |
| Microsoft AutoUpdate | 占~20MB，可关 |

## 禁用方法
```bash
# 从登录项移除
osascript -e 'tell application "System Events" to delete login item "Spotify"'

# 或直接通过System Preferences → Users & Groups → Login Items
```

## 注意事项
- smcFanControl、V2Box等基础设施不要禁用
- 禁用自动更新后记得定期手动更新以保安全

