// 乐吧公益中心汇报 - 完整版
// Typst 0.13 | 大厂级排版

#set page(
  paper: "a4",
  margin: (top: 2cm, bottom: 2cm, left: 2.5cm, right: 2.5cm),
  header: [
    #set text(size: 8pt, fill: rgb("999999"))
    #h(1fr) 乐吧公益中心 · 社区服务成果汇报
    #line(length: 100%, stroke: 0.5pt + rgb("dddddd"))
  ],
  footer: [
    #set text(size: 8pt, fill: rgb("999999"))
    #line(length: 100%, stroke: 0.5pt + rgb("dddddd"))
    #h(1fr) #context[第 #counter(page).display() 页]
  ],
)

#set text(font: ("PingFang SC", "STHeiti", "Helvetica"), lang: "zh")
#set par(first-line-indent: 0pt, leading: 0.65em)

// ========== 样式 ==========
#show heading.where(level: 1): set text(size: 15pt, weight: "bold", fill: rgb("#4785a8"))
#show heading.where(level: 2): set text(size: 12pt, weight: "bold", fill: rgb("#333333"))
#show heading: set block(above: 1em, below: 0.3em)

#let brand-blue = rgb("#4785a8")
#let brand-light = rgb("#eef4f7")
#let gray-bg = rgb("#f8fafb")

// 卡片组件
#let card(body, bg: gray-bg, border-color: rgb("e0e0e0")) = {
  rect(fill: bg, stroke: 0.5pt + border-color, inset: 8pt, radius: 4pt, body)
}

// 品牌标签组件
#let tag(label, color: brand-blue) = {
  text(size: 8pt, fill: white, weight: "bold", rect(fill: color, inset: (x: 4pt, y: 1pt), radius: 2pt, label))
}

// 引用组件
#let quote(text) = {
  v(2pt)
  rect(stroke: (left: 3pt + brand-blue), fill: rgb("f5f9fc"), inset: (x: 8pt, y: 4pt), radius: 2pt, [
    #text(style: "italic", fill: rgb("#555555"), size: 9pt, [💬 #text])
  ])
}

// ==================== S1: 封面 ====================
#align(center + horizon)[
  #block(height: 3.5cm)
  #text(size: 28pt, weight: "bold", fill: brand-blue)[乐吧公益中心]
  #v(8pt)
  #text(size: 14pt, fill: rgb("#666666"))[入驻金水新苑二期 · 社区服务成果汇报]
  #v(6pt)
  #block(stroke: 2pt + brand-blue, width: 30%)
  #v(6pt)
  #text(size: 12pt, fill: brand-blue)[致：金水新苑二期居委会 · 陈书记]
  #v(20pt)
  #text(size: 10pt, fill: rgb("#888888"))[从开业到现在 · 做了什么 · 做到了什么 · 还能做什么]
  #v(4pt)
  #text(size: 9pt, fill: rgb("#aaaaaa"))[课后托管 · 作业辅导 · 心理辅导 · 生活实践 · 素质拓展 · 暑期早教 · AI自习室]
  #v(4cm)
  #text(size: 10pt, fill: rgb("#aaaaaa"))[上海奉贤 · 乐吧公益中心]
  #text(size: 10pt, fill: rgb("#aaaaaa"))[2026年7月]
]

#pagebreak()

// ==================== S2: 发展历程+服务进化 ====================
#rect(
  fill: rgb("#fff8e1"),
  stroke: (left: 4pt + rgb("#ffa000")),
  inset: 10pt,
  radius: 2pt,
  width: 100%,
)[
  *🏠 金水新苑二期居民主动提出需求* · 希望乐吧服务引入社区 \
  #text(size: 9pt, fill: rgb("#8d6e63"))[\"乐吧的孩子们每天都很开心，能不能也让我们小区的孩子享受到？\" —— 居民代表]
]

= 一、发展历程 · 从无到有

#grid(
  columns: (1fr, 1fr),
  gutter: 6pt,
  [
    #rect(fill: brand-light, stroke: (bottom: 2.5pt + brand-blue), inset: 6pt, radius: 3pt, height: 4.2cm)[
      *📅 初期 · 入驻金水新苑二期* \
      #text(size: 9pt)[从零起步 · 居民信任的种子] \
      #v(4pt)
      #text(size: 8.5pt, fill: rgb("#555"))[乐吧公益中心应居民呼声正式入驻。最初仅有数户家庭尝试，以基础课后看护为主，家长观望为主。]
    ]
  ],
  [
    #rect(fill: brand-light, stroke: (bottom: 2.5pt + brand-blue), inset: 6pt, radius: 3pt, height: 4.2cm)[
      *📅 稳步发展期* \
      #text(size: 9pt)[口碑传播 · 服务初步成型] \
      #v(4pt)
      #text(size: 8.5pt, fill: rgb("#555"))[随着第一批家长的满意反馈，口碑开始传播。服务从单一托管扩展至作业辅导、心理辅导，覆盖家庭逐步增长至十余户。]
    ]
  ],
  [
    #rect(fill: brand-light, stroke: (bottom: 2.5pt + brand-blue), inset: 6pt, radius: 3pt, height: 4.2cm)[
      *📅 服务完善期* \
      #text(size: 9pt)[服务升级 · AI系统引入] \
      #v(4pt)
      #text(size: 8.5pt, fill: rgb("#555"))[引入AI作业批改系统，提升辅导效率。新增生活实践、素质拓展课程，形成六大服务体系。家长满意度持续攀升。]
    ]
  ],
  [
    #rect(fill: brand-light, stroke: (bottom: 2.5pt + brand-blue), inset: 6pt, radius: 3pt, height: 4.2cm)[
      *📅 现在 · 稳定运营* \
      #text(size: 9pt)[规模成熟 · 居民主动推荐] \
      #v(4pt)
      #text(size: 9pt, weight: "bold", fill: brand-blue)[27名在册学生 · 22户家庭 · 满意度9.7 · 续费率100%] \
      #text(size: 8.5pt, fill: rgb("#555"))[居民从\"试试看\"变成\"主动推荐给邻居\"。]
    ]
  ],
)

= 二、服务进化 · 过去 vs 现在
对比开业初期与现在的服务能力，看乐吧的成长轨迹：

#text(size: 10pt, weight: "bold")[📊 规模对比]
#grid(columns: (1fr, 1fr), gutter: 6pt, [
  #rect(fill: rgb("#f5f5f5"), inset: 8pt, radius: 4pt, height: 3.2cm)[
    #text(size: 9pt, fill: rgb("#888"), weight: "bold")[◀ 开业初期] \
    #v(4pt)
    #text(size: 16pt, fill: rgb("#bbb"))[数户家庭] \
    #text(size: 8.5pt, fill: rgb("#666"))[仅有基本课后看护] \
    #text(size: 8.5pt, fill: rgb("#666"))[服务时间单一] \
    #text(size: 8.5pt, fill: rgb("#666"))[家长抱着\"试试看\"心态]
  ]
], [
  #rect(fill: brand-light, stroke: 0.5pt + brand-blue, inset: 8pt, radius: 4pt, height: 3.2cm)[
    #text(size: 9pt, fill: brand-blue, weight: "bold")[▶ 现在] \
    #v(4pt)
    #text(size: 16pt, weight: "bold", fill: brand-blue)[22户 · 27名学生] \
    #text(size: 8.5pt, fill: rgb("#555"))[六大服务体系全面覆盖] \
    #text(size: 8.5pt, fill: rgb("#555"))[早晚错峰+暑期全天] \
    #text(size: 8.5pt, fill: rgb("#555"))[居民自发推荐，100%续费]
  ]
])

#text(size: 10pt, weight: "bold")[📋 服务内容对比]
#grid(columns: (1fr, 1fr), gutter: 6pt, [
  #rect(fill: rgb("#f5f5f5"), inset: 8pt, radius: 4pt)[
    #text(size: 9pt, fill: rgb("#888"), weight: "bold")[◀ 开业初期] \
    #text(size: 8.5pt)[✅ 课后看护（基础）] \
    #text(size: 8.5pt, fill: rgb("#bbb"))[❌ 无作业辅导] \
    #text(size: 8.5pt, fill: rgb("#bbb"))[❌ 无心理辅导] \
    #text(size: 8.5pt, fill: rgb("#bbb"))[❌ 无素质课程] \
    #text(size: 8.5pt, fill: rgb("#bbb"))[❌ 无AI工具]
  ]
], [
  #rect(fill: brand-light, stroke: 0.5pt + brand-blue, inset: 8pt, radius: 4pt)[
    #text(size: 9pt, fill: brand-blue, weight: "bold")[▶ 现在] \
    #text(size: 8.5pt)[✅ 课后托管（安全签到）] \
    #text(size: 8.5pt)[✅ 作业辅导（AI批改）] \
    #text(size: 8.5pt)[✅ 心理辅导（每日记录）] \
    #text(size: 8.5pt)[✅ 生活实践（自理训练）] \
    #text(size: 8.5pt)[✅ 素质拓展（表达/社交）] \
    #text(size: 8.5pt)[✅ 暑期早教班]
  ]
])

#text(size: 10pt, weight: "bold")[⚙️ 管理模式对比]
#grid(columns: (1fr, 1fr), gutter: 6pt, [
  #rect(fill: rgb("#f5f5f5"), inset: 8pt, radius: 4pt)[
    #text(size: 9pt, fill: rgb("#888"), weight: "bold")[◀ 开业初期] \
    #text(size: 8.5pt)[手工签到签退] \
    #text(size: 8.5pt)[家长当面沟通] \
    #text(size: 8.5pt)[无系统化记录]
  ]
], [
  #rect(fill: brand-light, stroke: 0.5pt + brand-blue, inset: 8pt, radius: 4pt)[
    #text(size: 9pt, fill: brand-blue, weight: "bold")[▶ 现在] \
    #text(size: 8.5pt)[AI系统签到+家长端实时查看] \
    #text(size: 8.5pt)[每日心情记录+家长推送] \
    #text(size: 8.5pt)[完整成长档案+满意度追踪]
  ]
])

#v(6pt)
#align(center)[
  #grid(columns: (1fr, 1fr, 1fr, 1fr), gutter: 4pt, [
    #align(center)[#text(size: 22pt, weight: "bold", fill: brand-blue)[27]\ #text(size: 8pt, fill: rgb("#888"))[在册学生]]
  ], [
    #align(center)[#text(size: 22pt, weight: "bold", fill: brand-blue)[22]\ #text(size: 8pt, fill: rgb("#888"))[覆盖家庭]]
  ], [
    #align(center)[#text(size: 22pt, weight: "bold", fill: brand-blue)[9.7]\ #text(size: 8pt, fill: rgb("#888"))[满意度]]
  ], [
    #align(center)[#text(size: 22pt, weight: "bold", fill: brand-blue)[100%]\ #text(size: 8pt, fill: rgb("#888"))[续费率]]
  ])
]

#rect(fill: rgb("#e8f5e9"), stroke: 0.5pt + rgb("#a5d6a7"), inset: 8pt, radius: 4pt)[
  #text(size: 9.5pt, fill: rgb("#2e7d32"), weight: "bold")[💡 从开业到现在：] \
  #text(size: 9.5pt, fill: rgb("#2e7d32"))[从数户家庭起步，到覆盖22户 · 从单一看护，到六大服务体系 · 从人工操作，到AI系统管理]
]

#pagebreak()

// ==================== S3: 六大服务+照片+满意度 ====================
= 三、六大服务体系
经过逐步发展，乐吧目前已形成完整的六大服务矩阵：

#grid(columns: (1fr, 1fr, 1fr), gutter: 6pt, [
  #card[
    *📚 课后托管* \
    #text(size: 8.5pt)[每日放学后接至乐吧。安全签到签退，家长安心。]
  ]
], [
  #card[
    *📝 作业辅导* \
    #text(size: 8.5pt)[辅导暑假作业，AI辅助批改。] \
    #text(size: 7.5pt, fill: rgb("#999"))[※ 仅辅导假期作业，不涉及新学期课程]
  ]
], [
  #card[
    *🧠 心理辅导* \
    #text(size: 8.5pt)[每日心情记录，沟通引导。自信心培养，情绪管理。]
  ]
], [
  #card[
    *🌱 生活实践* \
    #text(size: 8.5pt)[自理能力训练，用餐礼仪。时间管理，安全意识。]
  ]
], [
  #card[
    *🌟 素质拓展* \
    #text(size: 8.5pt)[表达能力，团队合作。社交沟通，故事分享会。]
  ]
], [
  #card[
    *🎨 暑期早教班* \
    #text(size: 8.5pt)[暑假全天活动，参观游学。手工实践，户外探索。]
  ]
])

#v(4pt)
#text(size: 10pt, weight: "bold")[📸 活动掠影（暑期活动记录）]
#grid(columns: (1fr, 1fr, 1fr), gutter: 4pt, rows: 2.8cm, [
  image("report-assets/img_e53efe579868.jpg", width: 100%, height: 100%, fit: "cover")
], [
  image("report-assets/img_d5a579a6b536.jpg", width: 100%, height: 100%, fit: "cover")
], [
  image("report-assets/img_dab4704f84d7.jpg", width: 100%, height: 100%, fit: "cover")
], [
  image("report-assets/img_3f3c1e1968e6.jpg", width: 100%, height: 100%, fit: "cover")
], [
  image("report-assets/img_6b7fc27c483c.jpg", width: 100%, height: 100%, fit: "cover")
], [
  image("report-assets/img_8236bd15eef2.jpg", width: 100%, height: 100%, fit: "cover")
])

#v(4pt)
#text(size: 10pt, weight: "bold")[⭐ 家长满意度调查结果（15项 · 平均9.7/10分）]
#grid(columns: (1fr, 1fr, 1fr, 1fr, 1fr), gutter: 3pt, [
  #card(fill: white, border-color: rgb("e8e8e8"))[#text(size: 7pt, fill: brand-blue, weight: "bold")[习惯]\ #text(size: 8.5pt)[作业完成度]\ #h(1fr) #text(size: 10pt, weight: "bold", fill: brand-blue)[9.9]]
], [
  #card(fill: white, border-color: rgb("e8e8e8"))[#text(size: 7pt, fill: brand-blue, weight: "bold")[心理]\ #text(size: 8.5pt)[情绪状态]\ #h(1fr) #text(size: 10pt, weight: "bold", fill: brand-blue)[9.8]]
], [
  #card(fill: white, border-color: rgb("e8e8e8"))[#text(size: 7pt, fill: brand-blue, weight: "bold")[生活]\ #text(size: 8.5pt)[生活自理]\ #h(1fr) #text(size: 10pt, weight: "bold", fill: brand-blue)[9.7]]
], [
  #card(fill: white, border-color: rgb("e8e8e8"))[#text(size: 7pt, fill: brand-blue, weight: "bold")[素质]\ #text(size: 8.5pt)[社交沟通]\ #h(1fr) #text(size: 10pt, weight: "bold", fill: brand-blue)[9.6]]
], [
  #card(fill: white, border-color: rgb("e8e8e8"))[#text(size: 7pt, fill: brand-blue, weight: "bold")[习惯]\ #text(size: 8.5pt)[学习主动]\ #h(1fr) #text(size: 10pt, weight: "bold", fill: brand-blue)[9.7]]
], [
  #card(fill: white, border-color: rgb("e8e8e8"))[#text(size: 7pt, fill: brand-blue, weight: "bold")[生活]\ #text(size: 8.5pt)[时间管理]\ #h(1fr) #text(size: 10pt, weight: "bold", fill: brand-blue)[9.6]]
], [
  #card(fill: white, border-color: rgb("e8e8e8"))[#text(size: 7pt, fill: brand-blue, weight: "bold")[心理]\ #text(size: 8.5pt)[自信心]\ #h(1fr) #text(size: 10pt, weight: "bold", fill: brand-blue)[9.9]]
], [
  #card(fill: white, border-color: rgb("e8e8e8"))[#text(size: 7pt, fill: brand-blue, weight: "bold")[习惯]\ #text(size: 8.5pt)[阅读习惯]\ #h(1fr) #text(size: 10pt, weight: "bold", fill: brand-blue)[9.5]]
], [
  #card(fill: white, border-color: rgb("e8e8e8"))[#text(size: 7pt, fill: brand-blue, weight: "bold")[生活]\ #text(size: 8.5pt)[安全意识]\ #h(1fr) #text(size: 10pt, weight: "bold", fill: brand-blue)[9.8]]
], [
  #card(fill: white, border-color: rgb("e8e8e8"))[#text(size: 7pt, fill: brand-blue, weight: "bold")[素质]\ #text(size: 8.5pt)[团队合作]\ #h(1fr) #text(size: 10pt, weight: "bold", fill: brand-blue)[9.6]]
], [
  #card(fill: white, border-color: rgb("e8e8e8"))[#text(size: 7pt, fill: brand-blue, weight: "bold")[心理]\ #text(size: 8.5pt)[抗挫折]\ #h(1fr) #text(size: 10pt, weight: "bold", fill: brand-blue)[9.7]]
], [
  #card(fill: white, border-color: rgb("e8e8e8"))[#text(size: 7pt, fill: brand-blue, weight: "bold")[习惯]\ #text(size: 8.5pt)[专注力]\ #h(1fr) #text(size: 10pt, weight: "bold", fill: brand-blue)[9.5]]
], [
  #card(fill: white, border-color: rgb("e8e8e8"))[#text(size: 7pt, fill: brand-blue, weight: "bold")[生活]\ #text(size: 8.5pt)[用餐礼仪]\ #h(1fr) #text(size: 10pt, weight: "bold", fill: brand-blue)[9.8]]
], [
  #card(fill: white, border-color: rgb("e8e8e8"))[#text(size: 7pt, fill: brand-blue, weight: "bold")[素质]\ #text(size: 8.5pt)[表达能力]\ #h(1fr) #text(size: 10pt, weight: "bold", fill: brand-blue)[9.7]]
]

#pagebreak()

// ==================== S4: 满意度深度 ====================
= 四、居民怎么说（满意度深度报告）
调查对象：22户在册家庭 · 方式：一对一访谈+问卷 · 覆盖5大维度 · 每项均附家长原声

== 📖 维度一：暑假作业陪伴（平均 9.7 分）

#rect(fill: brand-blue, inset: 4pt, radius: 3pt)[#text(size: 9pt, weight: "bold", fill: white)[作业完成度 · 9.9]]
#card[
  #text(size: 8.5pt)[*调查了什么：*是否按时完成暑假作业、正确率变化、是否需要家长再辅导] \
  #text(size: 8.5pt)[*为什么满意：*老师现场辅导+AI辅助批改，家长回家不用再盯作业，亲子关系明显改善] \
  #text(size: 8.5pt)[*社区价值：*双职工下班晚→作业在乐吧已完成→回家就是纯粹的亲子时间]
]
#quote[\"以前回家第一件事就是盯作业，现在吃完饭就是亲子时间了\" —— 家长刘先生]

#rect(fill: brand-blue, inset: 4pt, radius: 3pt)[#text(size: 9pt, weight: "bold", fill: white)[学习主动性 · 9.7]]
#card[
  #text(size: 8.5pt)[*调查了什么：*孩子是否主动完成暑假作业、是否需要催促] \
  #text(size: 8.5pt)[*为什么满意：*积分激励机制+同伴氛围，孩子从\"要我做\"变成\"我要做\"]
]

#rect(fill: brand-blue, inset: 4pt, radius: 3pt)[#text(size: 9pt, weight: "bold", fill: white)[专注力提升 · 9.5]]
#card[
  #text(size: 8.5pt)[*调查了什么：*能持续专注完成作业的时间变化、分心频率] \
  #text(size: 8.5pt)[*为什么满意：*番茄钟+计时器+安静的环境+同伴效应]
]

== 🧠 维度二：心理辅导（平均 9.8 分）

#rect(fill: brand-blue, inset: 4pt, radius: 3pt)[#text(size: 9pt, weight: "bold", fill: white)[自信心提升 · 9.9]]
#card[
  #text(size: 8.5pt)[*调查了什么：*孩子在班级发言、与人交流、展示自己的积极程度] \
  #text(size: 8.5pt)[*为什么满意：*每日\"今日之星\"评选+上台分享环节，每个孩子轮流当主角] \
  #text(size: 8.5pt)[*社区价值：*老人带娃偏向\"吃饱穿暖不管心理\"→乐吧填补心理成长空白]
]
#quote[\"以前在班里不敢举手，现在回家抢着给我们表演今天学的\" —— 家长王女士]

#rect(fill: brand-blue, inset: 4pt, radius: 3pt)[#text(size: 9pt, weight: "bold", fill: white)[情绪状态改善 · 9.8]]
#card[
  #text(size: 8.5pt)[*调查了什么：*孩子是否更开朗、发脾气频率是否减少] \
  #text(size: 8.5pt)[*为什么满意：*老师每日记录心情+一对一沟通，及时识别和处理情绪问题]
]

#rect(fill: brand-blue, inset: 4pt, radius: 3pt)[#text(size: 9pt, weight: "bold", fill: white)[抗挫折能力 · 9.7]]
#card[
  #text(size: 8.5pt)[*调查了什么：*孩子遇到困难时是放弃还是想办法] \
  #text(size: 8.5pt)[*为什么满意：*游戏化PK让孩子自然面对输赢，老师引导正面看待失败]
]

== 🌱 维度三：生活实践（平均 9.7 分）

#rect(fill: brand-blue, inset: 4pt, radius: 3pt)[#text(size: 9pt, weight: "bold", fill: white)[生活自理能力 · 9.7]]
#card[
  #text(size: 8.5pt)[*调查了什么：*自己整理书包、收拾餐具、穿衣系鞋带等日常自理能力] \
  #text(size: 8.5pt)[*为什么满意：*\"自理小达人\"评比+老师示范，从\"老人代做\"到\"自己来做\"]
]
#quote[\"奶奶以前非要喂饭，现在孩子说'我自己来，老师在乐吧教过了'\" —— 家长张女士]

#rect(fill: brand-blue, inset: 4pt, radius: 3pt)[#text(size: 9pt, weight: "bold", fill: white)[时间管理 · 9.6]]
#card[#text(size: 8.5pt)[*调查了什么：*是否能按计划完成任务、不拖拉]]

#rect(fill: brand-blue, inset: 4pt, radius: 3pt)[#text(size: 9pt, weight: "bold", fill: white)[用餐礼仪 · 9.8]]
#card[#text(size: 8.5pt)[*调查了什么：*餐桌礼仪、不挑食、主动收拾餐具]]

== 🌟 维度四：素质拓展（平均 9.7 分）

#rect(fill: brand-blue, inset: 4pt, radius: 3pt)[#text(size: 9pt, weight: "bold", fill: white)[表达能力 · 9.7]]
#card[#text(size: 8.5pt)[*调查了什么：*能不能清晰说一件事、敢于在人前表达观点] \
  #text(size: 8.5pt)[*为什么满意：*每日\"故事分享会\"轮流向大家讲故事、分享见闻]]

#rect(fill: brand-blue, inset: 4pt, radius: 3pt)[#text(size: 9pt, weight: "bold", fill: white)[团队合作 · 9.6]]
#card[#text(size: 8.5pt)[*调查了什么：*和小朋友一起完成任务时的配合度、分享意识]]

#rect(fill: brand-blue, inset: 4pt, radius: 3pt)[#text(size: 9pt, weight: "bold", fill: white)[社交沟通 · 9.6]]
#card[
  #text(size: 8.5pt)[*调查了什么：*主动交朋友、解决同伴矛盾的能力] \
  #text(size: 8.5pt)[*社区价值：*独生子女+隔代带娃导致社交缺失→集体环境学会社交]
]
#quote[\"我儿子以前只跟电脑玩，现在交了好几个朋友，周末还约着出去玩\" —— 家长陈先生]

#pagebreak()

// ==================== S5: 未来规划 ====================
= 五、未来规划 · 从现在的成绩出发，还能做什么
在现有22户家庭、六大服务体系的基础上，乐吧已具备进一步扩大服务的能力。

== 🔭 现状 → 展望
#grid(columns: (1fr, 1fr), gutter: 6pt, [
  #rect(fill: rgb("#f5f5f5"), inset: 8pt, radius: 4pt)[
    #text(size: 9pt, fill: rgb("#888"), weight: "bold")[◀ 现在已做到] \
    #text(size: 8.5pt)[✅ 22户家庭稳定运营] \
    #text(size: 8.5pt)[✅ 六大服务体系成熟] \
    #text(size: 8.5pt)[✅ AI系统辅助管理] \
    #text(size: 8.5pt)[✅ 满意度9.7 · 续费率100%]
  ]
], [
  #rect(fill: brand-light, stroke: 0.5pt + brand-blue, inset: 8pt, radius: 4pt)[
    #text(size: 9pt, fill: brand-blue, weight: "bold")[▶ 还可以做到] \
    #text(size: 8.5pt)[→ 覆盖40~50户家庭] \
    #text(size: 8.5pt)[→ AI自习室（一房两用）] \
    #text(size: 8.5pt)[→ 早教班扩大招生] \
    #text(size: 8.5pt)[→ 老年智能手机课堂] \
    #text(size: 8.5pt)[→ 错峰利用社区空间]
  ]
])

== 🤖 AI自习室 · 一房两用方案
#rect(fill: rgb("#f0f6f9"), inset: 10pt, radius: 4pt, width: 100%)[
 将社区空置房间改造为多功能自主学习空间：
 #v(4pt)
 #text(size: 9pt)[▸ *硬件配置：*2~3台电脑 + 4~6个独立工位 + 高速网络]
 #text(size: 9pt)[▸ *AI辅助工具：*AI作业批改、AI口语陪练、AI编程入门、AI知识问答]
 #text(size: 9pt)[▸ *老师角色：*从\"辅导作业\"转为\"陪伴练习\"，管理秩序+解答个性化问题]
 #text(size: 9pt)[▸ *时间规划：*上午早教班 → 下午/晚上AI自习室 → 周末老年智能手机课堂]
 #text(size: 9pt)[▸ *运营模式：*公益低偿服务，仅收基本运维费，不增加家庭负担]
]

#grid(columns: (1fr, 1fr), gutter: 6pt, [
  #rect(fill: rgb("#f0f6f9"), inset: 8pt, radius: 4pt)[
    *👶 早教班扩大招生* \
    #text(size: 8.5pt)[覆盖更多低龄儿童，解决双职工家庭\"入托难\"问题]
  ]
], [
  #rect(fill: rgb("#f0f6f9"), inset: 8pt, radius: 4pt)[
    *👴 老年智能手机课堂* \
    #text(size: 8.5pt)[帮助社区老人学会使用智能手机，跨越数字鸿沟]
  ]
])

= 六、居委立场分析
#grid(columns: (1fr, 1fr), gutter: 6pt, [
  #rect(fill: rgb("#f0f6f9"), inset: 8pt, radius: 4pt)[
    #text(size: 9pt, weight: "bold", fill: brand-blue)[🏆 政绩线] \
    #text(size: 8.5pt)[社区创新治理案例，\"一小\"服务亮点。可申报优秀社区服务项目，为居委增加工作亮点。]
  ]
], [
  #rect(fill: rgb("#f0f6f9"), inset: 8pt, radius: 4pt)[
    #text(size: 9pt, weight: "bold", fill: brand-blue)[🛡️ 风险线] \
    #text(size: 8.5pt)[零预算零风险，乐吧全责运营管理。居委只需审批场地使用，无需承担任何运营风险。]
  ]
], [
  #rect(fill: rgb("#f0f6f9"), inset: 8pt, radius: 4pt)[
    #text(size: 9pt, weight: "bold", fill: brand-blue)[👥 民意线] \
    #text(size: 8.5pt)[居民主动提出需求，非机构推广。已有真实数据支撑，解决社区双职工家庭实际痛点。]
  ]
], [
  #rect(fill: rgb("#f0f6f9"), inset: 8pt, radius: 4pt)[
    #text(size: 9pt, weight: "bold", fill: brand-blue)[💰 资源线] \
    #text(size: 8.5pt)[不占用居委经费，充分利用空置房间资源，将闲置空间变为惠民服务空间。]
  ]
])

== 🎤 汇报流程（建议8步）
#grid(columns: (1fr, 1fr), gutter: 4pt, [
  #card[
    #text(size: 9pt, weight: "bold", fill: brand-blue)[第1步] \
    #text(size: 8.5pt)[*开场致谢* \"陈书记，感谢您在百忙之中……\"]
  ]
], [
  #card[
    #text(size: 9pt, weight: "bold", fill: brand-blue)[第2步] \
    #text(size: 8.5pt)[*破冰引入* \"最近有几位居民主动找到我们……\"]
  ]
], [
  #card[
    #text(size: 9pt, weight: "bold", fill: brand-blue)[第3步] \
    #text(size: 8.5pt)[*讲历程* 展示时间线+发展对比]
  ]
], [
  #card[
    #text(size: 9pt, weight: "bold", fill: brand-blue)[第4步] \
    #text(size: 8.5pt)[*晒成果* 27生·22户·9.7分·100%]
  ]
], [
  #card[
    #text(size: 9pt, weight: "bold", fill: brand-blue)[第5步] \
    #text(size: 8.5pt)[*亮方案* 空置房→一房两用]
  ]
], [
  #card[
    #text(size: 9pt, weight: "bold", fill: brand-blue)[第6步] \
    #text(size: 8.5pt)[*谈价值* 接娃难+带娃累+零经费]
  ]
], [
  #card[
    #text(size: 9pt, weight: "bold", fill: brand-blue)[第7步] \
    #text(size: 8.5pt)[*恳请审批* 批准深化服务]
  ]
], [
  #card[
    #text(size: 9pt, weight: "bold", fill: brand-blue)[第8步] \
    #text(size: 8.5pt)[*承诺* 全责运营，定期汇报]
  ]
])

== 💬 陈书记可能关心的5个问题
#grid(columns: (1fr,), gutter: 4pt, [
  #rect(inset: 6pt, radius: 3pt, stroke: 0.5pt + rgb("e0e0e0"))[
    #text(size: 9.5pt, weight: "bold", fill: brand-blue)[Q：你们有资质吗？安全怎么保证？] \
    #text(size: 9pt)[A：公益中心注册正在办理中，健康证须持证上岗，场地计划安装监控设备，购买意外保险。各项资质将逐步落实到位，绝不无证运营。]
  ]
], [
  #rect(inset: 6pt, radius: 3pt, stroke: 0.5pt + rgb("e0e0e0"))[
    #text(size: 9.5pt, weight: "bold", fill: brand-blue)[Q：你们教新课吗？合规吗？] \
    #text(size: 9pt)[A：只辅导暑假作业，不教任何新学期课程，完全符合双减政策要求。]
  ]
], [
  #rect(inset: 6pt, radius: 3pt, stroke: 0.5pt + rgb("e0e0e0"))[
    #text(size: 9.5pt, weight: "bold", fill: brand-blue)[Q：AI自习室具体怎么操作？] \
    #text(size: 9pt)[A：学生用AI工具自主学习，老师陪伴管理，电脑有内容过滤+时间管控。]
  ]
], [
  #rect(inset: 6pt, radius: 3pt, stroke: 0.5pt + rgb("e0e0e0"))[
    #text(size: 9.5pt, weight: "bold", fill: brand-blue)[Q：会不会影响其他居民？] \
    #text(size: 9pt)[A：严格控制人数，错峰使用，不扰民，正式引入前做居民意见征询。]
  ]
], [
  #rect(inset: 6pt, radius: 3pt, stroke: 0.5pt + rgb("e0e0e0"))[
    #text(size: 9.5pt, weight: "bold", fill: brand-blue)[Q：居委会要不要投钱？] \
    #text(size: 9pt)[A：零预算！乐吧自筹所有经费，只需批准场地使用，不给财政添负担。]
  ]
]

#v(20pt)
#align(center)[
  #rect(fill: brand-blue, inset: (x: 24pt, y: 8pt), radius: 4pt)[
    #text(size: 12pt, weight: "bold", fill: white)[感谢陈书记审阅]
  ]
  #v(8pt)
  #text(size: 9pt, fill: rgb("#999"))[乐吧公益中心 · 全心全意为社区服务]
  #text(size: 9pt, fill: rgb("#999"))[上海奉贤 · 金水新苑二期 · 2026年7月]
]
