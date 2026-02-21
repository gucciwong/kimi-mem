@echo off
chcp 65001
echo === GitHub 推送修复 ===
cd /d "%~dp0"

echo.
echo [1] 检查 Git 状态...
git status

echo.
echo [2] 尝试切换到 SSH 推送...
git remote set-url origin git@github.com:gucciwong/kimi-mem.git
git remote -v

echo.
echo [3] 推送...
git push -u origin main

if %errorlevel% == 0 (
    echo.
    echo 推送成功！
    echo 访问: https://github.com/gucciwong/kimi-mem
    pause
    exit /b 0
) else (
    echo.
    echo SSH 推送失败，恢复 HTTPS...
    git remote set-url origin https://github.com/gucciwong/kimi-mem.git
    
    echo.
    echo 请尝试以下方法：
    echo 1. 检查网络连接是否能访问 github.com
    echo 2. 使用 GitHub Desktop 图形界面工具
    echo 3. 稍后重试
    
    pause
)
