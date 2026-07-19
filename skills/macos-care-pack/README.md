# 🍎 macOS Care Pack

> **Production-tested server toolkit for old/weak Macs.**
> 7 self-healing skills proven on a 4GB Mac running 24/7 for 2+ years.

[![macOS](https://img.shields.io/badge/macOS-12.7%2B-lightgrey)](https://www.apple.com/macos)
[![License](https://img.shields.io/badge/license-MIT-blue)](LICENSE)
[![Skills](https://img.shields.io/badge/skills-7-success)](.)

## Why this exists

Most server tools assume you have a beefy machine with unlimited budget. But what if you only have:

- **4GB RAM** MacBook running 24/7
- **Zero budget** for cloud services
- **Old SSD** you want to keep alive
- **No monitor** — runs headless, lid closed

This pack was built for exactly that scenario. Every skill here was born from real operations: **2,937 watchdog runs, 2 years of uptime, $0 infrastructure cost.**

## What's inside

| # | Skill | What it does | Tried & tested |
|---|-------|-------------|----------------|
| 1 | **macos-caretaker** | Auto-restart failed services, memory pressure management, cold boot recovery | 2,937 runs 🔥 |
| 2 | **ssd-wear-reduction** | Reduce unnecessary disk writes, extend old SSD life | Production proof |
| 3 | **intranet-penetration** | Self-healing cpolar tunnel with automatic reconnection | 2 years uptime |
| 4 | **cpolar-auto-update** | Auto-detect tunnel URL changes, update GitHub Pages | Self-healing |
| 5 | **startup-optimization** | Trim login items, speed up boot on old Macs | — |
| 6 | **ram-disk-browser-cache** | Move browser cache to RAM, reduce SSD wear | — |
| 7 | **desktop-file-organization** | Auto-sort desktop clutter into organized folders | — |

## Quick start

```bash
# Hermes Agent
git clone https://github.com/mars1417/mars-toolkit.git
cp -r skills/macos-care-pack/* ~/.hermes/skills/
```

```bash
# Standalone (any agent)
cp -r skills/macos-care-pack/scripts/* /usr/local/bin/
```

## How it works

```
┌─────────────────────────────────────────────────┐
│                  macOS Care Pack                 │
├─────────────────────────────────────────────────┤
│  macos-caretaker  ←  watchdog loop (every 5min)  │
│  ├─ Health check: CRM(8501) / Sign-in(19999)     │
│  ├─ Memory: auto purge when pressure > 70%      │
│  ├─ Tunnel: verify cpolar, reconnect if dead    │
│  └─ Cold boot: full recovery on restart          │
├─────────────────────────────────────────────────┤
│  ssd-wear-reduction   ←  weekly maintenance      │
│  intranet-penetration  ←  on-demand              │
│  cpolar-auto-update    ←  on tunnel change        │
│  startup-optimization  ←  one-time setup          │
│  ram-disk-browser-cache ←  one-time setup         │
│  desktop-file-organization ←  daily cron          │
└─────────────────────────────────────────────────┘
```

## Requirements

- macOS 12.7+
- 4-8GB RAM recommended
- For tunnel skills: cpolar (free tier) or similar
- Hermes Agent (optional — scripts work standalone)

## Why you might NOT need this

- If you have a modern Mac with 16GB+ RAM and fast SSD → you probably don't need SSD protection
- If you use paid cloud services (DigitalOcean, AWS) → tunneling is irrelevant
- If you're fine with occasional manual maintenance → these skills automate what you could do manually

This pack is for people who want **zero-maintenance servers on old hardware** — the kind of setup you deploy and forget for months.

## License

MIT — do whatever you want, just don't blame us if your old Mac finally gives up.
