---
name: intranet-penetration
description: "【内网穿透】当需要把本地服务暴露到公网让外部用户访问时使用。涵盖cpolar/natapp等穿透工具、反向代理合并多服务、看门狗自动恢复、永久入口URL（GitHub Pages重定向）、多工具对比、4GB Mac OOM应对。触发词: 内网穿透, 公网访问, cpolar, natapp, 隧道, tunnel, 外网访问, 域名变化, 固定入口, 家长远程访问"
version: 3.0.0
author: agent
license: MIT
metadata:
  hermes:
    tags: [devops, network, tunnel, cpolar, natapp, github-pages, redirect, intranet-penetration, url-shortener]
    category: devops
    related_skills: [leba-knowledge-base, gateway-platform-operations]
---

# 内网穿透（Intranet Penetration）

将本地服务（localhost）暴露到公网，让外部用户通过 URL 访问。适合给家长展示签到数据、给客户展示开发中的项目等场景。

## 通用流程

1. 确认本地服务已在运行（`curl localhost:端口` 返回 200）
2. 选择穿透工具并安装
3. 注册账号获取 authtoken
4. 启动隧道，得到公网 URL
5. 验证公网可访问

## cpolar（推荐 · 国内服务 · 免费）

> ⚠️ **国内节点 `--region cn` + HTTPS 是唯一默认方案。**
> 海外节点(`.cpolar.top`)已弃用。所有cpolar操作必须加 `--region cn`，所有公网URL必须用HTTPS。
> V2Box环境下HTTP 100%超时，HTTPS 100%可用。

cpolar 是群晖旗下的内网穿透服务，国内速度快，免费版够用。

### 安装

```bash
# 下载（macOS Intel）
curl -L "https://www.cpolar.com/static/downloads/releases/3.3.12/cpolar-stable-darwin-amd64.zip" -o /tmp/cpolar.zip
unzip /tmp/cpolar.zip -d /tmp
sudo cp /tmp/cpolar /usr/local/bin/cpolar
sudo chmod +x /usr/local/bin/cpolar
```

ARM Mac 用 `darwin-arm64` 版。

### 注册 & 获取 Token

1. 打开 https://dashboard.cpolar.com/get-started
2. 注册/登录账号
3. 复制 Authtoken

### 配置 Token

```bash
cpolar authtoken <你的token>
```

### 国内节点 vs 海外节点

cpolar 支持指定区域服务器。**国内节点是唯一默认方案，海外节点已弃用。**

... (full content available in Hermes Agent)
