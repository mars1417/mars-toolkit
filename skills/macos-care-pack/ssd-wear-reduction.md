---
name: ssd-wear-reduction
description: 【SSD寿命保护】当需要延长MacBook内置SSD寿命时使用。通过减少不必要的写入操作来保护10年老SSD。涵盖SMART诊断、写入源分析、RAM Disk/日志降级/swap优化三层方案，已集成diagnostic-log-cleanup、ram-disk-browser-cache、swap-optimization-4gb的内容
---

## 用途

> 📦 本skill已吸收（已归档至 .archive/）：memory-pressure-monitoring, swap-optimization-4gb, diagnostic-log-cleanup, system-cache-maintenance, background-process-audit

2015 MacBook Air 的 SSD 已服役 ~10年（APPLE SSD SM0128G, 128GB TLC NAND）。
通过系统性减少不必要的磁盘写入来延长寿命。SMART 诊断确认健康度 → 定位写入源 → 制定A/B/C三级方案。

## 触发场景
- 用户问"磁盘健康"、"SSD寿命"、"磁盘写入"、"延长SSD"、"保护硬盘"
- Mac运行卡顿且有磁盘IO瓶颈
- 怀疑日志/浏览器/swap在大量写盘

## 第一步：SMART健康诊断

```bash
# 1. 安装 smartctl（如未安装）
brew install smartmontools

# 2. 读取SMART信息
smartctl -a /dev/disk0

# 3. 关键指标解读
#    Wear_Leveling_Count: Apple SSD归一化值，新盘=200(或100)，阈值=100
#      计算寿命消耗: (起点值 - 当前值) / (起点值 - 阈值)
#      例: 186/200 → (200-186)/(200-100) = 14% 消耗 → 86%剩余
#    Host_Writes_MiB: 总主机写入量(MiB)
#    Reallocated_Sector_Ct: 坏道数，应为0
#    Current_Pending_Sector: 待映射扇区，应为0
#    Temperature_Celsius: 当前温度，超过60°C加速老化

# 4. 总写入量换算
#   Host_Writes_MiB ÷ 1024 = GiB
#   Host_Writes_MiB ÷ 1024 ÷ 1024 = TiB

# 5. 写入速率计算
#   Power_On_Hours = 运行时长
#   日均写入 = Total_Writes_GiB / (Power_On_Hours / 24)
#   年化写入 = 日均 × 365
```

### 寿命估算公式
```
对于 Apple SSD SM0128G (TLC):
  保守总寿命 ≈ Host_Writes_MiB ÷ (消耗比例)
  例: 13.3TB ÷ 14% ≈ 95 TBW

  剩余年限 = (1 - 消耗比例) × 总寿命 ÷ 年化写入
  例: 86% × 95TBW ÷ 12TB/年 ≈ 6.8年
```

**重要**: 2015年SSD的时间老化（NAND电荷泄漏）不可逆，即使写入很少也建议2027-2028年考虑替换。

## 第二步：写入源分析

### 收集数据
```bash
... (full content available in Hermes Agent)
