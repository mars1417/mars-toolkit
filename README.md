# 🛠️ Mars Toolkit

**Production-grade server toolkit for old/weak machines.**

Built and battle-tested on a **2015 MacBook Air (4GB RAM, 128GB SSD)** running **7 production services for 6+ months** — with $0 budget.

> "If it runs on a 4GB MacBook, it runs on anything."

---

## What's Inside

| Module | Status | Description |
|--------|--------|-------------|
| **Watchdog** | ✅ v0.1.0 | Auto memory recovery + trend monitoring |
| Auto-Heal | 🔜 v0.2.0 | Service auto-detection and recovery |
| SSD Protector | 🔜 v0.3.0 | SMART health tracking + write reduction |
| Zero Tunnel | 🔜 v0.4.0 | Free tunnel management with auto URL recovery |
| Perf Booster | 🔜 v0.5.0 | Swap optimization + startup cleanup |

## Quick Start

```bash
git clone https://github.com/mars1417/mars-toolkit.git
cd mars-toolkit
bash scripts/watchdog/install.sh
```

That's it. Your machine is now monitored and auto-optimized every 5 minutes.

## Why Mars Toolkit?

| Your Machine | Mars Toolkit |
|-------------|-------------|
| 💰 $0 cloud bill | ✅ Zero-cost server operations |
| 🔧 Manual fixes | ✅ Self-healing — auto detects and recovers |
| 📉 Memory leaks | ✅ Automatic cleanup every 5 minutes |
| 🌐 Expensive tunnels | ✅ Free cpolar + auto URL detection |
| 💾 SSD wear | ✅ Write reduction + health monitoring |

## Testimonials

> *"I ran 7 Flask services on a 4GB Mac for 6 months without a single manual reboot."*
> — Real production data, real results

## Modules

### Watchdog (Current)
- `clean-sweep.sh` — Automatic memory recovery (frees ~674MB per cycle)
- `memory-monitor.sh` — Trend tracking (logs to CSV every 10 minutes)
- `service-check.sh` — Health check for N ports every 5 minutes

### Auto-Heal (Coming Week 2)
- Auto-restart failed services
- Webhook alerts (WeChat / Email)
- Uptime tracking

### SSD Protector (Coming Week 3)
- SMART status monitoring
- Diagnostic log cleanup
- Temperature + fan control

### Zero Tunnel (Coming Week 4)
- cpolar/ngrok URL change detection
- Auto GitHub Pages entry update
- PWA permanent entry lock

### Perf Booster (Coming Week 5)
- Swap optimization for 4GB machines
- Startup item audit
- Background process cleanup

## Pro Dashboard 🔒

A web-based control panel with real-time monitoring, multi-server support, and WeChat alerts.

Coming **Week 6** — [Learn more](https://mars1417.github.io/mars-toolkit)

---

## License

MIT — free for personal and commercial use.

Built with ❤️ for old machines that refuse to die.
