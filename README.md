# 🛠️ Mars Toolkit

**Production-tested server skills for old/weak Macs.**

[![macOS](https://img.shields.io/badge/macOS-12.7%2B-lightgrey)](.)
[![Skills](https://img.shields.io/badge/skills-7-success)](./skills)
[![License](https://img.shields.io/badge/license-MIT-blue)](LICENSE)
[![Stars](https://img.shields.io/github/stars/mars1417/mars-toolkit)](.)

> Built and battle-tested on a **2015 MacBook Air (4GB RAM, 128GB SSD)** running **7 services for 2+ years** — with **$0 budget**.
>
> **2,937 watchdog runs. Zero manual reboots. Real production.**

---

## What you get

**7 self-healing skills** for keeping old Macs running as servers — no cloud, no budget, no manual maintenance.

| Pack | Skills | What it does |
|------|--------|-------------|
| 🍎 **[macOS Care Pack](./skills/macos-care-pack)** | 7 skills | Watchdog · SSD protection · Tunnel self-healing · Boot optimization · RAM cache · Desktop cleanup |

## Quick start

```bash
git clone https://github.com/mars1417/mars-toolkit.git
cd mars-toolkit

# Copy the skills you need
cp -r skills/macos-care-pack/* ~/.hermes/skills/

# Or run scripts directly
bash skills/macos-care-pack/scripts/publish.sh
```

## Why Mars Toolkit?

| Problem | Solution | Proof |
|---------|----------|-------|
| 💰 $0 budget | All free tools, no cloud bills | 2 years running |
| 🔧 Services keep dying | Auto-restart watchdog | **2,937 runs** 🔥 |
| 📉 Memory leaks on 4GB | Auto cleanup when pressure > 70% | ~674MB freed per cycle |
| 🌐 Tunnels break daily | Self-healing cpolar with auto URL update | Zero downtime |
| 💾 Old SSD dying | Write reduction + SMART monitoring | — |

## Who is this for?

- **You have an old Mac** (2012-2018) you want to use as a home server
- **You run Flask/Django/Node services** on a tight budget
- **You want zero-maintenance ops** — set it up once, forget it
- **You hate cloud vendor lock-in** and prefer self-hosting

## What makes this different

Most server toolkits assume modern hardware and paid infrastructure. Mars Toolkit was built **backwards**: starting from the constraint of a 4GB 2015 MacBook Air, and asking "what's the minimum you need to run production services reliably?"

The result is a toolkit that works on **anything** — because if it runs on a 4GB MacBook, it runs on anything.

## Skill Packs

| Pack | Status | Skills | 
|------|--------|--------|
| [macOS Care Pack](./skills/macos-care-pack) | ✅ v1.0.0 | 7 skills |

*More packs coming as the daily evolution pipeline produces them.*

## Pro Dashboard 🔒

Web-based control panel with real-time monitoring and multi-server support.

Coming soon — [Learn more](https://mars1417.github.io/mars-toolkit)

---

## License

MIT — free for personal and commercial use. Built for old machines that refuse to die.
