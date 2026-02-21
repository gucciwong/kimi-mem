# 🚀 Kimi-Mem 快速参考卡

## 安装 (30秒)

```bash
# 1. 安装 skill
git clone https://github.com/yourusername/kimi-mem.git ~/.config/agents/skills/kimi-mem

# 2. 初始化
python ~/.config/agents/skills/kimi-mem/scripts/init.py

# 3. 开始使用
/flow:kimi-mem
```

---

## 常用命令速查

| 操作 | 命令 |
|:---|:---|
| 🎬 **启动 Flow** | `/flow:kimi-mem` |
| 💾 **保存记忆** | `/mem:save 你的重要内容` |
| 🔍 **搜索** | `python scripts/cli.py search "关键词"` |
| 📊 **统计** | `python scripts/cli.py stats` |
| 🌐 **Web UI** | `python scripts/web_server.py --open` |
| ⚙️ **配置** | `python scripts/config.py show` |

---

## MCP 工具速查

```python
# 搜索 (低成本)
mem_search(query="错误信息", limit=10)

# 时间线
mem_timeline(observation_id=123, window_minutes=5)

# 详情 (高成本，筛选后用)
mem_get(ids=[123, 456])

# 保存
mem_save(title="标题", content="内容", tags=["tag"])
```

---

## 文件位置速查

| 类型 | 路径 |
|:---|:---|
| 📁 **Skill 目录** | `~/.config/agents/skills/kimi-mem/` |
| 🗄️ **SQLite 数据库** | `~/.kimi/kimi-mem/memory.db` |
| 📝 **Markdown Vault** | `~/kimi-mem-vault/` |
| ⚙️ **配置文件** | `~/.kimi/kimi-mem/config.json` |
| 🔗 **MCP 配置** | `~/.kimi/mcp.json` |

---

## Obsidian 配置 (1分钟)

```bash
# 1. 安装 MCP
kimi mcp add --transport stdio obsidian -- npx -y obsidian-mcp@latest

# 2. 设置 Vault 路径
python scripts/config.py obsidian "/path/to/Obsidian Vault"

# 3. 测试
kimi mcp test obsidian
```

---

## 隐私标记

```
<private>
敏感内容不会被记录
</private>
```

---

## 需要帮助？

- 📖 完整文档：[README.md](README.md)
- 🐛 提交 Issue：[GitHub Issues](https://github.com/yourusername/kimi-mem/issues)
- 💬 讨论：[GitHub Discussions](https://github.com/yourusername/kimi-mem/discussions)

---

<p align="center">⚡ 打印此页，随时查阅 ⚡</p>
