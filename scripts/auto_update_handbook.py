#!/usr/bin/env python3
"""周三/周五手册自动更新脚本
由cron调用：自动从products.yaml生成MD+DOCX
被调用时不输出任何信息（静默运行），除非报错
"""
import os, sys, subprocess

scripts_dir = os.path.expanduser('~/Desktop/_项目/mars-toolkit/scripts')

try:
    # 生成MD
    r1 = subprocess.run(['python3', os.path.join(scripts_dir, 'gen_handbook.py')],
                       capture_output=True, text=True, timeout=30)
    if r1.returncode != 0:
        print(f'MD生成失败: {r1.stderr}')
        sys.exit(1)
    
    # 生成DOCX
    r2 = subprocess.run(['python3', os.path.join(scripts_dir, 'gen_handbook_docx.py')],
                       capture_output=True, text=True, timeout=30)
    if r2.returncode != 0:
        print(f'DOCX生成失败: {r2.stderr}')
        sys.exit(1)
    
    print(f'✅ 手册自动更新完成 ({r1.stdout.strip()})')
except Exception as e:
    print(f'手册更新异常: {e}')
    sys.exit(1)
