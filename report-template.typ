// 乐吧公益中心汇报 - Typst模板
// 大厂级排版 · 绝对美观 · 中文原生支持

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
    #h(1fr) #context[#counter(page).display()]
  ],
)

#set text(font: ("PingFang SC", "STHeiti", "Helvetica"), lang: "zh")

#show heading: set block(above: 1.2em, below: 0.5em)
#show heading.where(level: 1): set text(size: 16pt, weight: "bold", fill: rgb("#4785a8"))
#show heading.where(level: 2): set text(size: 13pt, weight: "bold", fill: rgb("#333333"))
#show heading.where(level: 3): set text(size: 11pt, weight: "bold", fill: rgb("#555555"))

#set par(first-line-indent: 0pt, leading: 0.65em)
#set text(size: 10.5pt)

// ==================== 封面 ====================
#align(center)[
  #block(height: 3cm)
  #text(size: 28pt, weight: "bold", fill: rgb("#4785a8"))[乐吧公益中心]
  #v(8pt)
  #text(size: 14pt, fill: rgb("#666666"))[入驻金水新苑二期 · 社区服务成果汇报]
  #v(6pt)
  #line(length: 40%, stroke: 2pt + rgb("#4785a8"))
  #v(6pt)
  #text(size: 12pt, fill: rgb("#4785a8"))[致：金水新苑二期居委会 · 陈书记]
  #v(24pt)
  #rect(
    width: 80%,
    height: 0.5pt,
    fill: rgb("eeeeee"),
    stroke: none,
  )
  #v(12pt)
  #text(size: 10pt, fill: rgb("#888888"))[
    从开业到现在 · 做了什么 · 做到了什么 · 还能做什么
    
    #v(4pt)
    课后托管 · 作业辅导 · 心理辅导 · 生活实践 · 素质拓展 · 暑期早教 · AI自习室
  ]
  #v(4cm)
  #text(size: 10pt, fill: rgb("#aaaaaa"))[
    上海奉贤 · 乐吧公益中心
    
    2026年7月
  ]
]

#pagebreak()

// ==================== 正文开始 ====================

= 一、发展历程 · 从无到有

#rect(
  fill: rgb("#fff8e1"),
  stroke: (left: 4pt + rgb("#ffa000")),
  inset: 10pt,
  radius: 2pt,
)[
  *🏠 金水新苑二期多位居民主动联系*，希望将托管、早教等服务引入社区。陈书记高度重视，促成入驻。
]

#grid(
  columns: (1fr, 1fr),
  gutter: 8pt,
  [
    #block(stroke: (bottom: 2pt + rgb("#4785a8")))[*初期*]
    \ 最初数户家庭，基础看护为主
  ],
  [
    #block(stroke: (bottom: 2pt + rgb("#4785a8")))[*稳步期*]
    \ 扩展至作业辅导、心理辅导
  ],
  [
    #block(stroke: (bottom: 2pt + rgb("#4785a8")))[*完善期*]
    \ AI引入+生活实践+素质拓展
  ],
  [
    #block(stroke: (bottom: 2pt + rgb("#4785a8")))[*现在*]
    \ 27生·22户·9.7分·100%续费
  ],
)

= 二、服务进化 · 过去 vs 现在

#grid(
  columns: (1fr, 1fr),
  gutter: 8pt,
  [
    #rect(
      fill: rgb("#f5f5f5"),
      stroke: rgb("dddddd"),
      inset: 8pt,
      radius: 4pt,
    )[#text(size: 9pt, fill: rgb("#888888"))[◀ 开业初期]\ #text(size: 11pt)[数户家庭 · 单一看护 · 手工操作]]
  ],
  [
    #rect(
      fill: rgb("#eef4f7"),
      stroke: rgb("4785a8"),
      inset: 8pt,
      radius: 4pt,
    )[#text(size: 9pt, fill: rgb("#4785a8"))[▶ 现在]\ #text(size: 11pt, weight: "bold")[22户家庭 · 六大体系 · AI系统管理]]
  ],
)

#align(center)[
  #grid(
    columns: (1fr, 1fr, 1fr, 1fr),
    gutter: 4pt,
    [
      #align(center + horizon)[
        #text(size: 20pt, weight: "bold", fill: rgb("#4785a8"))[27]\
        #text(size: 8pt, fill: rgb("#888888"))[在册学生]
      ]
    ],
    [
      #align(center)[#text(size: 20pt, weight: "bold", fill: rgb("#4785a8"))[22]\ #text(size: 8pt, fill: rgb("#888888"))[户家庭]]
    ],
    [
      #align(center)[#text(size: 20pt, weight: "bold", fill: rgb("#4785a8"))[9.7]\ #text(size: 8pt, fill: rgb("#888888"))[满意度]]
    ],
    [
      #align(center)[#text(size: 20pt, weight: "bold", fill: rgb("#4785a8"))[100%]\ #text(size: 8pt, fill: rgb("#888888"))[续费率]]
    ],
  )
]

#v(4pt)
#rect(
  fill: rgb("#e8f5e9"),
  stroke: rgb("#a5d6a7"),
  inset: 8pt,
  radius: 4pt,
)[#text(size: 10pt, fill: rgb("#2e7d32"))[*从数户→22户，单一看护→六大体系，人工→AI系统。社区共建，零预算运作。*]]

= 三、六大服务体系

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 6pt,
  [
    #block(stroke: (top: 2pt + rgb("#4785a8")), inset: 4pt)[
      *📚 课后托管*\ 安全签到签退，家长安心
    ]
  ],
  [
    #block(stroke: (top: 2pt + rgb("#4785a8")), inset: 4pt)[
      *📝 作业辅导*\ AI批改辅助（不含新课）
    ]
  ],
  [
    #block(stroke: (top: 2pt + rgb("#4785a8")), inset: 4pt)[
      *🧠 心理辅导*\ 每日心情记录+自信培养
    ]
  ],
  [
    #block(stroke: (top: 2pt + rgb("#4785a8")), inset: 4pt)[
      *🌱 生活实践*\ 自理能力+用餐礼仪+安全
    ]
  ],
  [
    #block(stroke: (top: 2pt + rgb("#4785a8")), inset: 4pt)[
      *🌟 素质拓展*\ 表达力+合作力+社交力
    ]
  ],
  [
    #block(stroke: (top: 2pt + rgb("#4785a8")), inset: 4pt)[
      *🎨 暑期早教班*\ 全天活动+参观游学+手工
    ]
  ],
)

=== 家长满意度 · 15项均分 9.7/10

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 4pt,
  [
    #rect(fill: rgb("#f8fafb"), inset: 4pt, radius: 3pt)[
      #text(size: 8pt, fill: rgb("#4785a8"))[作业完成度]\ 
      #text(size: 10pt, weight: "bold")[9.9]
    ]
  ],
  [
    #rect(fill: rgb("#f8fafb"), inset: 4pt, radius: 3pt)[
      #text(size: 8pt, fill: rgb("#4785a8"))[自信心]\ 
      #text(size: 10pt, weight: "bold")[9.9]
    ]
  ],
  [
    #rect(fill: rgb("#f8fafb"), inset: 4pt, radius: 3pt)[
      #text(size: 8pt, fill: rgb("#4785a8"))[情绪状态]\ 
      #text(size: 10pt, weight: "bold")[9.8]
    ]
  ],
  [
    #rect(fill: rgb("#f8fafb"), inset: 4pt, radius: 3pt)[
      #text(size: 8pt, fill: rgb("#4785a8"))[安全意识]\ 
      #text(size: 10pt, weight: "bold")[9.8]
    ]
  ],
  [
    #rect(fill: rgb("#f8fafb"), inset: 4pt, radius: 3pt)[
      #text(size: 8pt, fill: rgb("#4785a8"))[用餐礼仪]\ 
      #text(size: 10pt, weight: "bold")[9.8]
    ]
  ],
  [
    #rect(fill: rgb("#f8fafb"), inset: 4pt, radius: 3pt)[
      #text(size: 8pt, fill: rgb("#4785a8"))[生活自理]\ 
      #text(size: 10pt, weight: "bold")[9.7]
    ]
  ],
  [
    #rect(fill: rgb("#f8fafb"), inset: 4pt, radius: 3pt)[
      #text(size: 8pt, fill: rgb("#4785a8"))[学习主动]\ 
      #text(size: 10pt, weight: "bold")[9.7]
    ]
  ],
  [
    #rect(fill: rgb("#f8fafb"), inset: 4pt, radius: 3pt)[
      #text(size: 8pt, fill: rgb("#4785a8"))[抗挫折]\ 
      #text(size: 10pt, weight: "bold")[9.7]
    ]
  ],
  [
    #rect(fill: rgb("#f8fafb"), inset: 4pt, radius: 3pt)[
      #text(size: 8pt, fill: rgb("#4785a8"))[表达能力]\ 
      #text(size: 10pt, weight: "bold")[9.7]
    ]
  ],
  [
    #rect(fill: rgb("#f8fafb"), inset: 4pt, radius: 3pt)[
      #text(size: 8pt, fill: rgb("#4785a8"))[社交沟通]\ 
      #text(size: 10pt, weight: "bold")[9.6]
    ]
  ],
  [
    #rect(fill: rgb("#f8fafb"), inset: 4pt, radius: 3pt)[
      #text(size: 8pt, fill: rgb("#4785a8"))[时间管理]\ 
      #text(size: 10pt, weight: "bold")[9.6]
    ]
  ],
  [
    #rect(fill: rgb("#f8fafb"), inset: 4pt, radius: 3pt)[
      #text(size: 8pt, fill: rgb("#4785a8"))[团队合作]\ 
      #text(size: 10pt, weight: "bold")[9.6]
    ]
  ],
  [
    #rect(fill: rgb("#f8fafb"), inset: 4pt, radius: 3pt)[
      #text(size: 8pt, fill: rgb("#4785a8"))[专注力]\ 
      #text(size: 10pt, weight: "bold")[9.5]
    ]
  ],
  [
    #rect(fill: rgb("#f8fafb"), inset: 4pt, radius: 3pt)[
      #text(size: 8pt, fill: rgb("#4785a8"))[阅读习惯]\ 
      #text(size: 10pt, weight: "bold")[9.5]
    ]
  ],
)

= 四、未来规划 · 从成绩出发

在22户家庭、六大体系基础上，乐吧具备进一步扩大的能力。

=== AI自习室 · 一房两用
+ 硬件：2~3台电脑 + 4~6工位 + 高速网络
+ AI工具：作业批改 · 口语陪练 · 编程入门
+ 老师角色：从"辅导作业"转"陪伴练习"
+ 时间：上午早教班 → 下午/晚上AI自习室 → 周末老年课堂
+ 运营：公益低偿，仅收运维费

=== 居委立场分析
#grid(
  columns: (1fr, 1fr),
  gutter: 4pt,
  [
    #rect(fill: rgb("#f0f6f9"), inset: 6pt, radius: 4pt)[
      #text(size: 8pt, fill: rgb("#4785a8"))[🏆 政绩线]\ 
      #text(size: 9.5pt)[社区治理创新，可申报优秀项目]
    ]
  ],
  [
    #rect(fill: rgb("#f0f6f9"), inset: 6pt, radius: 4pt)[
      #text(size: 8pt, fill: rgb("#4785a8"))[🛡️ 风险线]\ 
      #text(size: 9.5pt)[零预算零风险，乐吧全责运营]
    ]
  ],
  [
    #rect(fill: rgb("#f0f6f9"), inset: 6pt, radius: 4pt)[
      #text(size: 8pt, fill: rgb("#4785a8"))[👥 民意线]\ 
      #text(size: 9.5pt)[居民主动提出，数据支撑]
    ]
  ],
  [
    #rect(fill: rgb("#f0f6f9"), inset: 6pt, radius: 4pt)[
      #text(size: 8pt, fill: rgb("#4785a8"))[💰 资源线]\ 
      #text(size: 9.5pt)[不占经费，空置变惠民]
    ]
  ],
)

=== 陈书记关心的5个问题
#grid(
  columns: (1fr,),
  gutter: 4pt,
  [
    #rect(inset: 6pt, radius: 3pt, stroke: rgb("e0e0e0"))[
      #text(size: 9.5pt, weight: "bold", fill: rgb("#4785a8"))[Q：资质安全？]\ 
      #text(size: 9.5pt)[公益中心注册正在办理中，健康证须持证上岗，场地计划安装监控，购买意外保险。]
    ]
  ],
  [
    #rect(inset: 6pt, radius: 3pt, stroke: rgb("e0e0e0"))[
      #text(size: 9.5pt, weight: "bold", fill: rgb("#4785a8"))[Q：教什么内容？]\ 
      #text(size: 9.5pt)[只辅导暑假作业，完全符合双减政策。]
    ]
  ],
  [
    #rect(inset: 6pt, radius: 3pt, stroke: rgb("e0e0e0"))[
      #text(size: 9.5pt, weight: "bold", fill: rgb("#4785a8"))[Q：AI自习室怎么操作？]\ 
      #text(size: 9.5pt)[AI自主学习+老师陪伴+电脑内容过滤+时间管控。]
    ]
  ],
  [
    #rect(inset: 6pt, radius: 3pt, stroke: rgb("e0e0e0"))[
      #text(size: 9.5pt, weight: "bold", fill: rgb("#4785a8"))[Q：影响其他居民？]\ 
      #text(size: 9.5pt)[控人数，错峰使用，不扰民，事先征询居民意见。]
    ]
  ],
  [
    #rect(inset: 6pt, radius: 3pt, stroke: rgb("e0e0e0"))[
      #text(size: 9.5pt, weight: "bold", fill: rgb("#4785a8"))[Q：居委要投钱吗？]\ 
      #text(size: 9.5pt)[零预算！乐吧自筹所有经费，只批场地即可。]
    ]
  ],
)

#v(24pt)
#align(center)[
  #rect(
    fill: rgb("#4785a8"),
    inset: (x: 24pt, y: 8pt),
    radius: 4pt,
  )[
    #text(size: 10pt, weight: "bold", fill: white)[感谢陈书记审阅]
  ]
  
  #v(8pt)
  #text(size: 9pt, fill: rgb("#999999"))[
    乐吧公益中心 · 全心全意为社区服务
    
    上海奉贤 · 金水新苑二期 · 2026年7月
  ]
]
