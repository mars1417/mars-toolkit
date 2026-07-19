#!/bin/bash
# 每周发布打包脚本 - mars-toolkit publish pipeline
# Usage: bash publish.sh "release-notes.md"

REPO_DIR=~/Desktop/_项目/mars-toolkit
SKILLS_DIR=~/Desktop/_项目/mars-toolkit/skills

echo "📦 mars-toolkit 发布流水线"
echo "========================"

# 1. 收集本周新增/改进的skill
echo ""
echo "🔍 扫描本周新技能..."

# 2. 确保每个包有英文README
for pack in "$SKILLS_DIR"/*/; do
  name=$(basename "$pack")
  if [ ! -f "$pack/README.md" ]; then
    echo "   ⚠️  $name 缺少README.md"
  else
    echo "   ✅ $name README OK"
  fi
done

# 3. git操作
echo ""
echo "🚀 发布到 GitHub..."
cd "$REPO_DIR" || exit 1

# 检查是否有变化
if [ -z "$(git status --porcelain)" ]; then
  echo "   没有新变化，跳过发布"
  exit 0
fi

git add -A
git commit -m "release: $(date +%Y-%m-%d)"
git push origin main

echo "   ✅ 发布完成！"
echo ""
echo "📊 查看: https://github.com/mars1417/mars-toolkit"
