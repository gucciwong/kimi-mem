#!/bin/bash
# =============================================================================
# Kimi-Mem 一键安装脚本
# =============================================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印函数
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查依赖
check_dependencies() {
    print_info "检查依赖..."
    
    # 检查 Python
    if ! command -v python3 &> /dev/null; then
        if ! command -v python &> /dev/null; then
            print_error "Python 未安装，请先安装 Python 3.10+"
            exit 1
        fi
    fi
    
    PYTHON_CMD=$(command -v python3 || command -v python)
    PYTHON_VERSION=$($PYTHON_CMD --version 2>&1 | awk '{print $2}')
    print_success "Python 版本: $PYTHON_VERSION"
    
    # 检查 Kimi CLI
    if ! command -v kimi &> /dev/null; then
        print_warning "Kimi CLI 未检测到，请确保已安装"
    else
        print_success "Kimi CLI 已安装"
    fi
}

# 安装 Skill
install_skill() {
    print_info "安装 Kimi-Mem Skill..."
    
    SKILL_DIR="$HOME/.config/agents/skills/kimi-mem"
    
    # 检查是否已存在
    if [ -d "$SKILL_DIR" ]; then
        print_warning "Kimi-Mem 已存在，是否覆盖？(y/n)"
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            print_info "跳过安装"
            return
        fi
        rm -rf "$SKILL_DIR"
    fi
    
    # 创建目录
    mkdir -p "$SKILL_DIR"
    
    # 复制文件（假设脚本在 skill 目录中运行）
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    if [ -f "$SCRIPT_DIR/SKILL.md" ]; then
        # 从源码安装
        cp -r "$SCRIPT_DIR"/* "$SKILL_DIR/"
    else
        # 从 GitHub 下载
        print_info "从 GitHub 下载..."
        git clone --depth 1 https://github.com/yourusername/kimi-mem.git "$SKILL_DIR"
    fi
    
    print_success "Skill 文件已安装到: $SKILL_DIR"
}

# 初始化
initialize() {
    print_info "初始化 Kimi-Mem..."
    
    SKILL_DIR="$HOME/.config/agents/skills/kimi-mem"
    
    if [ ! -f "$SKILL_DIR/scripts/init.py" ]; then
        print_error "初始化脚本不存在"
        exit 1
    fi
    
    $PYTHON_CMD "$SKILL_DIR/scripts/init.py"
}

# 安装 Obsidian MCP (可选)
install_obsidian_mcp() {
    print_info "是否安装 Obsidian MCP 集成？(y/n)"
    read -r response
    
    if [[ "$response" =~ ^[Yy]$ ]]; then
        if command -v kimi &> /dev/null; then
            kimi mcp add --transport stdio obsidian -- npx -y obsidian-mcp@latest
            print_success "Obsidian MCP 已安装"
            
            print_info "请输入 Obsidian Vault 路径 (留空跳过):"
            read -r vault_path
            
            if [ -n "$vault_path" ]; then
                $PYTHON_CMD "$HOME/.config/agents/skills/kimi-mem/scripts/config.py" obsidian "$vault_path"
                print_success "Vault 路径已配置"
            fi
        else
            print_warning "Kimi CLI 未安装，请手动运行:"
            echo "  kimi mcp add --transport stdio obsidian -- npx -y obsidian-mcp@latest"
        fi
    fi
}

# 完成提示
finish() {
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo "  🎉 Kimi-Mem 安装完成！"
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
    echo "  快速开始:"
    echo "    1. 启动 Flow: /flow:kimi-mem"
    echo "    2. 保存记忆: /mem:save 你的重要内容"
    echo "    3. 查看 Web UI: python ~/.config/agents/skills/kimi-mem/scripts/web_server.py --open"
    echo ""
    echo "  文档:"
    echo "    • 完整指南: README.md"
    echo "    • 快速参考: QUICKSTART.md"
    echo "    • 架构说明: ARCHITECTURE.md"
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
}

# 主流程
main() {
    echo "═══════════════════════════════════════════════════════════════"
    echo "  🧠 Kimi-Mem 安装程序"
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
    
    check_dependencies
    install_skill
    initialize
    install_obsidian_mcp
    finish
}

# 运行
main "$@"
