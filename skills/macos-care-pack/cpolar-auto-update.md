---
name: cpolar-auto-update
description: 【cpolar公网隧道URL监控+自动更新+PWA锁死入口+健康检测】cpolar免费版隧道重启域名变更时自动检测+更新GitHub Pages门户入口页。三层防御：①GP Pages点击前健康检测 ②5分钟gp_sync自动修复 ③PWA安装到主屏幕永久锁死。支持双入口策略(GP Pages+cpolar直连)。吸收了gp-pages-entry-guarantee(SW缓存陷阱诊断+用户沟通铁律)+cpolar-restart-healing(重启后验证协议)
version: 4.1.0
tags: [cpolar, tunnel, github-pages, auto-update, devops, permanent-countermeasure]
permanent_countermeasure: true
---

## CDN缓存爆破机制（v4.1新增）

每次cpolar URL变化时，gp_sync.sh 在推送的 index.html 中嵌入一个 **BUILD 时间戳**（`<!-- BUILD:YYYYMMDDHHMMSS -->`），强制GH Pages CDN的etag变化，缩短缓存窗口到5分钟以内。

```bash
# gp_sync.sh Step 4 中的缓存爆破
BUILD_TS=$(date '+%Y%m%d%H%M%S')
sed -i '' "s|<!-- BUILD:[0-9]* -->|<!-- BUILD:$BUILD_TS -->|" "$REPO_DIR/index.html"
grep -q "BUILD:" "$REPO_DIR/index.html" || \
  sed -i '' "s|<html>|<html>\\n<!-- BUILD:$BUILD_TS -->|" "$REPO_DIR/index.html"
```

**原理：** BUILD时间戳每次更新改变文件内容→Git检测到变更→GH Pages部署新版本→CDN etag变化→客户端SDN缓存无效。

**注意事项：** 空commit推送给GH Pages**不会**改变文件last-modified时间，因此无效。必须通过实际内容变化（BUILD时间戳或target URL）触发。

> **v4.0 以上：所有URL同步由 `gp_sync.sh` 自动完成，每5分钟cron运行。**
> 以下 Step 1-8 保留作为**参考**（理解gp_sync.sh内部逻辑），**不要手动执行**。
> 如需手动触发：`bash ~/.hermes/scripts/gp_sync.sh`

**永远不要手动执行以下步骤。** 全部由 `gp_sync.sh` 自动完成，每5分钟cron运行。

如需手动触发：
```bash
bash ~/.hermes/scripts/gp_sync.sh
```

### gp_sync.sh 内部流程（参考，不改脚本内容）

1. 从cpolar dashboard（4040/4041/4042）获取当前公网URL
2. 对比 `~/.cpolar/current_url.txt`（单一真值）
3. URL变化 → 更新 `/tmp/lebacenter/index.html` → git push
4. 远端验证（curl raw.githubusercontent.com）
5. 同步三方状态文件（current_url.txt + current_url.json，**不覆盖桌面HTML**）
6. 标记健康状态

### gp_sync.sh脚本位置

`~/.hermes/scripts/gp_sync.sh` — **不要修改此脚本的逻辑**，除非你确认sync_state_files()的方向正确（desktop→repo，不是反的）。

### Cron配置

| 任务 | 频率 | 脚本 |
|:----|:----:|:-----|
| cpolar URL同步·gp_sync | **每5分钟** | `bash ~/.hermes/scripts/gp_sync.sh` |
| 看门狗巡检 | 每60分钟 | `caretaker.sh`（内部也调gp_sync.sh） |
| 0点系统维护 | 每天0点 | `midnight_maintenance.sh` |

## 架构总览 v4.0 — 「gp_sync.sh统一 + 三层防御」

cpolar免费版每次进程重启会换随机子域名。v4.0核心升级：**统一URL同步脚本 + GP Pages自带健康检测 + PWA锁死入口**。

```
... (full content available in Hermes Agent)
