# 📚 Kimi-Mem 使用示例集

> 这里收集了各种实际使用场景，帮助你快速上手 Kimi-Mem

---

## 📖 目录

- [场景 1: 开发中的知识积累](#场景-1开发中的知识积累)
- [场景 2: Bug 排查记录](#场景-2bug-排查记录)
- [场景 3: 项目架构决策](#场景-3项目架构决策)
- [场景 4: 学习笔记整理](#场景-4学习笔记整理)
- [场景 5: 跨会话上下文恢复](#场景-5跨会话上下文恢复)

---

## 场景 1:开发中的知识积累

### 💡 场景描述

你正在开发一个 Python Web 项目，遇到了一些配置问题，解决后希望记录下来以便下次参考。

### 📝 实际操作

**步骤 1**: 解决问题
```
你: 运行 Flask 应用时报错 "ModuleNotFoundError: No module named 'flask'"

Kimi: 看起来是 Flask 没有安装。运行: pip install flask

你: 可以了！还有其他依赖吗？

Kimi: 建议安装: pip install flask flask-sqlalchemy flask-login
```

**步骤 2**: 手动保存重要信息
```
/mem:save Flask 项目基础依赖: flask, flask-sqlalchemy, flask-login
```

**步骤 3**: 自动记录操作
Kimi-Mem 自动记录了：
- Shell 命令: `pip install flask`
- 文件操作: 修改了 `requirements.txt`
- 对话内容: 依赖列表

### 🔍 后续使用

一周后，你忘记了依赖列表：
```python
mem_search(query="Flask 依赖")
```

返回结果：
```
📝 手动记忆:
  ID:5 | [general] Flask 项目基础依赖 | 2025-02-14T10:30:00
```

---

## 场景 2:Bug 排查记录

### 💡 场景描述

你遇到了一个复杂的数据库连接错误，经过一番排查后解决了，希望记录完整过程。

### 📝 实际操作

**排查过程** (Kimi-Mem 自动记录):

| 时间 | 操作 | 结果 |
|:---:|:---|:---|
| 10:00 | 运行应用 | ❌ 报错: Connection refused |
| 10:05 | 检查端口 | Shell: `netstat -tlnp` |
| 10:08 | 发现端口被占 | 输出: MySQL 占用 3306 |
| 10:10 | 修改配置 | 文件: `config.py` 端口改为 3307 |
| 10:12 | 重启应用 | ✅ 成功 |
| 10:15 | 保存经验 | `/mem:save MySQL 端口冲突解决` |

### 🔍 一个月后再次遇到

```python
# Step 1: 搜索
mem_search(query="数据库连接 refused", limit=5)

# 返回:
# ID:42 | 2025-02-14T10:00:00 | shell | netstat

# Step 2: 查看时间线
mem_timeline(observation_id=42, window_minutes=15)

# Step 3: 获取完整命令
mem_get(ids=[42, 43, 44])
```

### 📊 查看记录

在 Web UI 中查看：
```bash
python ~/.config/agents/skills/kimi-mem/scripts/web_server.py --open
```

搜索 "refused"，可以看到完整的时间线和命令。

---

## 场景 3:项目架构决策

### 💡 场景描述

团队讨论后决定使用微服务架构，需要记录决策原因和具体方案。

### 📝 实际操作

**步骤 1**: 讨论过程 (自动记录)
```
你: 我们在讨论新的电商项目架构，单体还是微服务？

Kimi: 建议考虑以下因素...
[详细讨论内容]

你: 我们决定使用微服务，选哪个框架？

Kimi: 推荐选择:
- Java: Spring Cloud
- Go: Go Micro
- Python: FastAPI + Consul

你: 我们用 Python 方案
```

**步骤 2**: 保存决策
```python
mem_save(
    title="电商项目架构决策",
    content="""
    ## 决策结果
    采用微服务架构，Python 技术栈
    
    ## 技术选型
    - API 网关: Kong
    - 服务注册: Consul
    - 服务框架: FastAPI
    - 消息队列: RabbitMQ
    - 数据库: PostgreSQL + Redis
    
    ## 决策原因
    1. 团队熟悉 Python
    2. FastAPI 性能优秀
    3. 生态成熟
    """,
    tags=["decision", "architecture", "microservices"],
    category="decision"
)
```

**步骤 3**: 查看 Obsidian

打开 Obsidian，在 `kimi-mem/memories/decision/` 下找到：
- 📄 `电商项目架构决策.md`

包含完整的决策内容和元数据。

---

## 场景 4:学习笔记整理

### 💡 场景描述

你正在学习 Docker，希望记录常用的命令和技巧。

### 📝 实际操作

**步骤 1**: 学习过程
```
你: 教我 Docker 常用命令

Kimi: [详细解释各种命令]
```

**步骤 2**: 整理保存
```bash
# 保存为学习笔记
python ~/.config/agents/skills/kimi-mem/scripts/cli.py save \
  "Docker 常用命令清单" \
  "docker ps - 查看运行容器
docker images - 查看镜像
docker-compose up -d - 后台启动
..." \
  --tags docker,cheatsheet \
  --category learning
```

**步骤 3**: 在 Obsidian 中复习

```markdown
# Docker 常用命令清单

**时间**: 2025-02-21 10:30  
**分类**: learning  
**标签**: docker, cheatsheet

---

docker ps - 查看运行容器
docker images - 查看镜像
docker-compose up -d - 后台启动
...

---

[[Docker-基础]] | [[容器化]]
```

---

## 场景 5:跨会话上下文恢复

### 💡 场景描述

三天前你开发了一个功能，今天想继续，但记不清具体进展。

### 📝 实际操作

**三天前** (Kimi-Mem 自动记录):
```
会话: feature/user-authentication
- 10:00: 开始开发用户认证
- 10:30: 完成登录接口
- 11:00: 实现 JWT 生成
- 11:30: 待完成: 刷新 token 机制
```

**今天**:

```bash
# 查看最近会话
python ~/.config/agents/skills/kimi-mem/scripts/cli.py stats
```

```
总会话数: 15
观察记录: 234
手动记忆: 12
今日记录: 0
```

```python
# 搜索之前的认证相关记录
mem_search(query="JWT token 认证", type="observations", limit=10)

# 找到相关记录 ID: 156, 157, 158

# 获取时间线
mem_timeline(observation_id=156, window_minutes=30)
```

Kimi 回复：
```
基于之前的记录，我看到您三天前开发了用户认证功能：

✅ 已完成:
   - 登录接口 (/api/login)
   - JWT Token 生成
   - 密码加密验证

⏳ 待完成:
   - Token 刷新机制
   - 登出接口
   - 权限验证装饰器

需要我继续完成刷新 token 功能吗？
```

---

## 🎨 进阶技巧

### 技巧 1: 批量保存代码片段

```python
# 保存多个相关记忆
codesnippets = [
    ("Python 列表推导式", "[x*2 for x in range(10)]"),
    ("Python 字典合并", "{**dict1, **dict2}"),
    ("Python 装饰器模板", "@wraps(func)"),
]

manager = get_manager()
for title, content in codesnippets:
    memory = Memory(
        session_id=str(uuid.uuid4()),
        timestamp=datetime.now().isoformat(),
        title=title,
        content=content,
        tags=["python", "snippet"],
        category="learning"
    )
    manager.save_memory(memory)
```

### 技巧 2: 定期生成报告

```bash
#!/bin/bash
# weekly-report.sh

echo "# 本周开发报告" > weekly.md
echo "生成时间: $(date)" >> weekly.md
echo "" >> weekly.md

echo "## 统计" >> weekly.md
python ~/.config/agents/skills/kimi-mem/scripts/cli.py stats >> weekly.md

echo "" >> weekly.md
echo "## 重要记忆" >> weekly.md
python ~/.config/agents/skills/kimi-mem/scripts/cli.py search "决策" --type memories >> weekly.md
```

### 技巧 3: 与 Obsidian 双向链接

在 Obsidian 中编辑记忆文件时，添加链接：

```markdown
# 用户认证实现

...

## 相关
- [[JWT-原理]]
- [[密码安全最佳实践]]
- [[API-设计规范]]
```

下次 Kimi 搜索时，这些链接也会被考虑。

---

## 📌 总结

Kimi-Mem 的核心价值：

1. **🔄 自动记录**: 无需手动干预，专注开发
2. **🔍 智能检索**: 快速找到历史信息
3. **📝 多格式存储**: 数据库查询 + Markdown 阅读
4. **🔗 知识关联**: Obsidian 双向链接
5. **🌐 可视化**: Web UI 直观查看

---

<p align="center">
  💡 有更多使用技巧？欢迎分享！
</p>
