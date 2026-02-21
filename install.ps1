# =============================================================================
# Kimi-Mem 一键安装脚本 (Windows PowerShell)
# 用法: .\install.ps1 [-SkipObsidian]
# =============================================================================

param(
    [switch]$SkipObsidian
)

$ErrorActionPreference = "Stop"

# 颜色函数
function Write-Info($msg) { Write-Host "[INFO] $msg" -ForegroundColor Blue }
function Write-Success($msg) { Write-Host "[OK] $msg" -ForegroundColor Green }
function Write-Warning($msg) { Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-Error($msg) { Write-Host "[ERROR] $msg" -ForegroundColor Red }

# 检查依赖
function Test-Dependencies {
    Write-Info "检查依赖..."
    
    # 检查 Python
    try {
        $pythonVersion = python --version 2>&1
        Write-Success "Python 版本: $pythonVersion"
    } catch {
        Write-Error "Python 未安装，请先安装 Python 3.10+ (https://python.org)"
        exit 1
    }
    
    # 检查 Kimi CLI (可选)
    try {
        $kimiVersion = kimi --version 2>$null
        Write-Success "Kimi CLI 已安装"
    } catch {
        Write-Warning "Kimi CLI 未检测到，请确保已安装 (https://github.com/MoonshotAI/kimi-cli)"
    }
}

# 安装 Skill
function Install-Skill {
    Write-Info "安装 Kimi-Mem Skill..."
    
    $skillDir = "$env:USERPROFILE\.config\agents\skills\kimi-mem"
    $sourceDir = $PSScriptRoot  # 脚本所在目录
    
    # 检查是否已存在
    if (Test-Path $skillDir) {
        Write-Warning "Kimi-Mem 已存在"
        $response = Read-Host "是否覆盖? (y/n)"
        if ($response -notmatch '^[Yy]$') {
            Write-Info "跳过安装"
            return $false
        }
        # 备份
        $timestamp = Get-Date -Format "yyyyMMddHHmmss"
        $backupDir = "$env:USERPROFILE\.config\agents\skills\kimi-mem-backup-$timestamp"
        Write-Info "备份到: $backupDir"
        Move-Item -Path $skillDir -Destination $backupDir
    }
    
    # 创建目录
    New-Item -ItemType Directory -Force -Path $skillDir | Out-Null
    
    # 判断安装方式
    if (Test-Path "$sourceDir\SKILL.md") {
        # 方式 1: 从本地源码安装（脚本在 skill 目录中）
        Write-Info "从本地目录安装..."
        Copy-Item -Path "$sourceDir\*" -Destination $skillDir -Recurse -Force
    } elseif (Test-Path "$sourceDir\..\SKILL.md") {
        # 方式 2: 从项目根目录安装（脚本在 install/ 子目录）
        Write-Info "从项目目录安装..."
        Copy-Item -Path "$sourceDir\..\*" -Destination $skillDir -Recurse -Force
    } else {
        # 方式 3: 从 GitHub 下载
        Write-Info "从 GitHub 下载..."
        $tempDir = "$env:TEMP\kimi-mem-$(Get-Random)"
        git clone --depth 1 https://github.com/yourusername/kimi-mem.git $tempDir
        if (Test-Path $tempDir) {
            Copy-Item -Path "$tempDir\*" -Destination $skillDir -Recurse -Force
            Remove-Item -Recurse -Force $tempDir
        } else {
            Write-Error "下载失败，请检查网络或手动下载"
            exit 1
        }
    }
    
    Write-Success "Skill 文件已安装到: $skillDir"
    return $true
}

# 验证安装
function Test-Installation {
    param($SkillDir)
    
    Write-Info "验证安装..."
    
    $requiredFiles = @(
        "SKILL.md",
        "scripts\init.py",
        "scripts\storage.py",
        "scripts\cli.py"
    )
    
    $allOk = $true
    foreach ($file in $requiredFiles) {
        $path = Join-Path $SkillDir $file
        if (-not (Test-Path $path)) {
            Write-Error "缺少文件: $file"
            $allOk = $false
        }
    }
    
    if ($allOk) {
        Write-Success "文件验证通过"
    } else {
        Write-Error "安装不完整"
        exit 1
    }
}

# 初始化
function Initialize-KimiMem {
    param($SkillDir)
    
    Write-Info "初始化 Kimi-Mem..."
    
    $initScript = Join-Path $SkillDir "scripts\init.py"
    if (-not (Test-Path $initScript)) {
        Write-Error "初始化脚本不存在"
        exit 1
    }
    
    python $initScript
}

# 安装 Obsidian MCP
function Install-ObsidianMcp {
    if ($SkipObsidian) { return }
    
    Write-Info "是否安装 Obsidian MCP 集成? (y/n)"
    $response = Read-Host
    
    if ($response -match '^[Yy]$') {
        try {
            # 安装 MCP
            kimi mcp add --transport stdio obsidian -- npx -y obsidian-mcp@latest
            Write-Success "Obsidian MCP 已安装"
            
            # 配置 Vault 路径
            Write-Info "请输入 Obsidian Vault 路径 (例如: C:\Users\$env:USERNAME\Documents\Obsidian Vault)"
            Write-Info "留空可稍后配置"
            $vaultPath = Read-Host
            
            if ($vaultPath) {
                $configScript = "$env:USERPROFILE\.config\agents\skills\kimi-mem\scripts\config.py"
                python $configScript obsidian "$vaultPath"
                Write-Success "Vault 路径已配置"
            }
        } catch {
            Write-Warning "MCP 安装失败，请手动运行:"
            Write-Host "  kimi mcp add --transport stdio obsidian -- npx -y obsidian-mcp@latest"
        }
    }
}

# 完成提示
function Show-Completion {
    Write-Host ""
    Write-Host "=============================================================" -ForegroundColor Cyan
    Write-Host "  安装完成!" -ForegroundColor Green
    Write-Host "=============================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  快速开始:"
    Write-Host "    1. 在 Kimi 中运行: /flow:kimi-mem"
    Write-Host "    2. 保存记忆: /mem:save 你的重要内容"
    Write-Host "    3. 启动 Web UI:"
    Write-Host "       python $env:USERPROFILE\.config\agents\skills\kimi-mem\scripts\web_server.py --open"
    Write-Host ""
    Write-Host "  常用命令:"
    Write-Host "    搜索: python scripts/cli.py search `"关键词`""
    Write-Host "    统计: python scripts/cli.py stats"
    Write-Host "    配置: python scripts/config.py show"
    Write-Host ""
    Write-Host "  文档:"
    Write-Host "    • README.md - 完整指南"
    Write-Host "    • QUICKSTART.md - 快速参考"
    Write-Host "    • EXAMPLES.md - 使用示例"
    Write-Host ""
    Write-Host "=============================================================" -ForegroundColor Cyan
}

# 主流程
function Main {
    Write-Host "=============================================================" -ForegroundColor Cyan
    Write-Host "  Kimi-Mem 安装程序" -ForegroundColor Cyan
    Write-Host "=============================================================" -ForegroundColor Cyan
    Write-Host ""
    
    Test-Dependencies
    
    $installed = Install-Skill
    if (-not $installed) { return }
    
    $skillDir = "$env:USERPROFILE\.config\agents\skills\kimi-mem"
    Test-Installation -SkillDir $skillDir
    Initialize-KimiMem -SkillDir $skillDir
    Install-ObsidianMcp
    Show-Completion
}

# 运行
Main
