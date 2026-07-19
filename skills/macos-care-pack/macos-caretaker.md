---
name: macos-caretaker
absorbed:
  - caretaker-three-end-chain (archived 2026-07-19)
  - leba-pipeline-watchdog (archived 2026-07-19)
description: 【macOS看门狗】在低内存(4GB)Mac上保持多服务长期稳定运行。内存压力分级清理、三端主链保活、cpolar隧道管理+GitHub Pages自动跳转更新。零外部依赖纯shell实现。
version: 2.4.0
tags: [macos, memory, watchdog, caretaker, process-management, tunnel, github-pages, permanent-countermeasure]
---

# macOS Caretaker — 低内存服务器化看门狗

在4GB RAM Mac上24小时不关机运行多个Python Web服务时，用此看门狗实现自动化运维。

## 恒久对策5条铁律

本技能所有代码和流程遵守以下规则：

| # | 铁律 |
|:--|:-----|
| ① | 数据源必须先验证再提取（提取后检查长度/格式，不符合则fail） |
| ② | 失败必须发声（stderr不丢弃，exit code必须检查并写日志） |
| ③ | 前提条件在步骤内自行确保（用前先git clone/mkdir/创建） |
| ④ | 结果从远端独立验证（push后curl commit-specific raw URL，fallback到main分支） |
| ⑤ | 只保留一条已验证路径（不记录"备选方案"或"其他思路"） |

## 核心架构

```
┌──────────────────────────────────────────────────────────────────┐
│                        ⏰ Hermes Cron 调度层                        │
│  21个定时任务（scheduler.db） — 各司其职互不干扰                        │
├──────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────┐  ┌──────────────────────────────┐   │
│  │   hermes_watchdog.py    │  │      caretaker.sh            │   │
│  │   (5min 巡检, cron)     │  │   (每5min 巡检, cron)         │   │
│  │                         │  │                              │   │
│   │  • 检测 Hermes 网关（端口检测） ││  ① 内存分级清理              │   │
│  │  • 检测 Hermes Python   │  │  ② 三端保活（curl端口检测）   │   │
│  │  • 自动重启失败进程      │  │  ③ cpolar URL+保活           │   │
│  │  • 3次失败→邮件通知      │  │  ④ swap管控                 │   │
│  │  • 恢复→邮件通知         │  │  ⑤ V2Box保活（SOCKS5检测）   │   │
│  └─────────────────────────┘  └──────────────────────────────┘   │
│         ↑ Hermes挂了也能发邮件 (no_agent=true, /usr/bin/mail)       │
├──────────────────────────────────────────────────────────────────┤
│                      🚀 冷启动恢复层                                │
│  com.leba.startup (LaunchAgent) → leba-startup.sh                 │
│   ① 等待V2Box拨通（最多2min）                                      │
│   ② cpolar启动                                                   │
│   ③ 三端启动（19999/8510/18888）                                   │
│   ④ 相册服务                                                     │
│   ⑤ Hermes CLI 就绪等待（最多30s）                                  │
│   ⑥ 端口验证                                                     │
├──────────────────────────────────────────────────────────────────┤
│                      🧰 桌面保底层                                  │
│  乐吧一键恢复.command（手动兜底）                                    │
│  乐吧内存优化.command（双击释放~200MB）                               │
└──────────────────────────────────────────────────────────────────┘

## 每周轮换（v2.1新增）

... (full content available in Hermes Agent)
