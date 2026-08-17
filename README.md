# dsh-minimal-turbo

Deepseek Harness 极简模式 / 许愿模式 Windows 适配，享用满血 Deepseek-V4 系列模型。

## 背景

经多次验证，`Let me` 思考链并不是"拉"的原因，`We need` 思考链同样会产出"拉"的结果。真正的原因大概是首轮思考直接进入雷霆思考（长时间思考），陷入闭门造车工作流。

基于这个现象开发了**许愿模式**：工具链沿用官方基准模式，提示词使用"专武"强化，添加了首轮思考约束，使首轮高概率以最简短方式思考；再结合一些 PUA，让模型多想、多想、多想。

> **注意**：覆盖保存后，记得**重启 dsh**，再选择对应模式重新开任务。
>
> **已知问题**：一 shot 可能会报错（语法错误或引用错误），把报错复制给模型，第二轮基本直接成功。

## 模式对比

| 特性 | minimal（极简模式） | wish（许愿模式） |
| --- | --- | --- |
| 基于 | 官方极简模式配置，兼容 Windows | 官方标准模式工具链，新增独立模式 |
| 核心思路 | 最少开销、最快响应 | 打断首次思考，防止直接雷霆思考 |
| 思考链 | 无上下文压缩，思考轮次少 | 系统提示词约束首轮快速跳过，`Let me` 起手不影响效果 |
| 适用场景 | 纯文件编辑 / 命令行操作的简单任务 | 复杂、多步骤任务，追求高质量输出 |
| 安装方式 | 覆盖官方预设 | 新增目录，不影响官方预设 |

## 快速开始

### 一键安装脚本

自动定位 dsh 安装目录（优先 npm 全局安装目录，回退到当前目录 `node_modules`），备份现有配置后，将本仓库配置复制到运行环境对应目录。

**Windows（PowerShell）**

```powershell
powershell -ExecutionPolicy Bypass -File scripts\install-minimal.ps1
powershell -ExecutionPolicy Bypass -File scripts\install-wish.ps1
```

**Linux（bash）**

```bash
bash ./scripts/install-minimal.sh   # 覆盖官方极简模式
bash ./scripts/install-wish.sh      # 安装许愿模式
```

安装目录不在默认位置时：

```powershell
# Windows
powershell -ExecutionPolicy Bypass -File scripts\install-minimal.ps1 -DshPath "D:\path\to\dsh"
powershell -ExecutionPolicy Bypass -File scripts\install-wish.ps1 -DshPath "D:\path\to\dsh"
```

```bash
# Linux
DSH_PATH=/path/to/dsh bash ./scripts/install-minimal.sh
DSH_PATH=/path/to/dsh bash ./scripts/install-wish.sh
```

脚本执行时会自动将原 `agent.cordis.yml`（wish 脚本含 `preset.yml`）备份为 `*.bak-<时间戳>`（位于原目录），可随时手动恢复。

### 手动安装

**minimal**

1. 进入 nodejs 包管理目录 `node_modules`
2. 打开 `@deepseek-ai\dsh\config\agent-presets\minimal`
3. 用本仓库 [`minimal/agent.cordis.yml`](minimal/agent.cordis.yml) 的内容覆盖 `agent.cordis.yml`

**wish（许愿模式）**

1. 将本仓库 [`wish`](wish) 目录整个复制到 `node_modules\@deepseek-ai\dsh\config\agent-presets\` 下
2. 确认目录结构为 `node_modules\@deepseek-ai\dsh\config\agent-presets\wish\`，内含 `agent.cordis.yml` 和 `preset.yml`
3. 重启 dsh 后，在模式选择中即可看到「许愿模式」

## 效果展示

许愿模式下完成的真实案例（见 [`wish-demo`](wish-demo) 目录，含单文件 HTML 成品与原始 prompt）：

| 案例 | Flash Max | Pro Max |
| --- | --- | --- |
| Kerr-Newman 黑洞 WebGL 渲染（raymarching + 体积吸积盘 + 后处理） | [查看](wish-demo/kerr-newman-with-flash-max/kerr_newman.html) | [查看](wish-demo/kerr-newman-with-pro-max/kerr_newman.html) |
| 我的世界风格 3D 游戏 | [查看](wish-demo/minecraft-with-flash-max/minecraft.html) | [查看](wish-demo/minecraft-with-pro-max/minecraft.html) |

## 目录结构

```
dsh-minimal-turbo/
├── minimal/                 # 极简模式配置（覆盖官方 minimal 预设）
│   └── agent.cordis.yml
├── wish/                    # 许愿模式配置（独立新增预设）
│   ├── agent.cordis.yml
│   └── preset.yml
├── scripts/                 # 一键安装脚本（Windows / Linux）
├── wish-demo/               # 许愿模式效果展示案例
└── README.md
```

## License

[MIT](LICENSE)
