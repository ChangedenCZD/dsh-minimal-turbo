# dsh-minimal-turbo
Deepseek Harness 极简模式/许愿模式 Windows适配，享用满血Deepseek-V4系列模型。

1. 意在兼容Windows
2. 一并强化了所有系统的极简模式流程，减少了思考轮次（因为有足够工具可以调用，不再啰嗦）

由于是直接改的官方极简模式配置，因此不会干预整个Harness工作流程。

**注意：覆盖保存后，记得重启dsh，再选择对应模式重新开任务**

**已知MCP、SKILL等会影响到首轮思考，建议关闭相关配置后测试**

## 模式介绍

### minimal（极简模式）

- 基于官方极简模式配置新增兼容Windows环境
- 增加高效文件处理工具
- 无上下文压缩（Context compaction absent），思考轮次少，响应干脆
- 适合：纯文件编辑/命令行操作的简单任务，追求最少开销和最快响应

#### 思考链效果

<img width="1779" height="1215" alt="image" src="https://github.com/user-attachments/assets/7a24d9d7-874f-4816-b58a-2dbde5adfd59" />

<img width="2399" height="1011" alt="image" src="https://github.com/user-attachments/assets/31a4080d-781f-47de-8226-77a7db7ed3c6" />

<img width="2435" height="1166" alt="image" src="https://github.com/user-attachments/assets/0efdbe16-68eb-492d-b0cb-6345e51c8784" />

### wish（许愿模式）

- 基于官方标准模式工具链新增自定义模式
- 核心思想是打断模型首次思考，防止直接雷霆思考
- 通过系统提示词约束思考行为

## 使用方式

### minimal（覆盖官方极简模式）

1. 进入nodejs包管理目录`node_modules`
2. 打开`@deepseek-ai\dsh\config\agent-presets\minimal`
3. 用本仓库`minimal\agent.cordis.yml`的内容覆盖`agent.cordis.yml`

> 直接复制本仓库中的 [`minimal/agent.cordis.yml`](minimal/agent.cordis.yml) 文件内容，覆盖 `node_modules\@deepseek-ai\dsh\config\agent-presets\minimal\agent.cordis.yml` 即可。

### wish（许愿模式）

新增独立模式，可直接复用整个目录，不影响官方预设。

1. 将本仓库 [`wish`](wish) 目录整个复制到 `node_modules\@deepseek-ai\dsh\config\agent-presets\` 下
2. 确认目录结构为 `node_modules\@deepseek-ai\dsh\config\agent-presets\wish\`，内含 `agent.cordis.yml` 和 `preset.yml`

> 重启dsh后，在模式选择中即可看到「许愿模式」。

## 一键安装脚本

自动定位 dsh 安装目录（优先 npm 全局安装目录，回退到当前目录 `node_modules`），备份现有配置后，将本仓库配置复制到运行环境对应目录。

### Windows（PowerShell）

安装极简模式配置：

```powershell
powershell -ExecutionPolicy Bypass -File scripts\install-minimal.ps1
```

安装许愿模式（新增目录，不影响官方预设）：

```powershell
powershell -ExecutionPolicy Bypass -File scripts\install-wish.ps1
```

dsh 安装目录不在默认位置时，用 `-DshPath` 参数指定：

```powershell
powershell -ExecutionPolicy Bypass -File scripts\install-minimal.ps1 -DshPath "D:\path\to\dsh"
powershell -ExecutionPolicy Bypass -File scripts\install-wish.ps1 -DshPath "D:\path\to\dsh"
```

### Linux（bash）

```bash
chmod +x scripts/install-minimal.sh scripts/install-wish.sh
./scripts/install-minimal.sh   # 覆盖官方极简模式
./scripts/install-wish.sh      # 安装许愿模式
```

dsh 安装目录不在默认位置时，用 `DSH_PATH` 环境变量指定：

```bash
DSH_PATH=/path/to/dsh ./scripts/install-minimal.sh
DSH_PATH=/path/to/dsh ./scripts/install-wish.sh
```

脚本执行时自动将原 `agent.cordis.yml`（wish脚本含`preset.yml`）备份为 `*.bak-<时间戳>`（位于原目录），可随时手动恢复。

