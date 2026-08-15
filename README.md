# dsh-minimal-agent-cordis
Deepseek Harness 极简模式 Windows适配，享用满血Deepseek-V4系列模型。

意在兼容Windows，并顺带减少流程的轮次（有足够工具可以调研，不再啰嗦）。

## 使用方式

1. 进入nodejs包管理目录`node_modules`
2. 打开`@deepseek-ai\dsh\config\agent-presets\minimal`
3. 编辑`agent.cordis.yml`，复制如下内容覆盖该文件

覆盖`agent.cordis.yml`内容
```yaml
# The `minimal` agent preset: a fixed-prompt, two-tool coding-agent composition.
#
# The persona is the complete system prompt, so global identity, Web orientation,
# tool guidance, and later assembly listeners cannot add prompt text. Runtime
# context snapshots are suppressed for this preset, and the model composes only
# persistent `bash` and `str_replace_editor`. Context compaction is absent.

- id: persona
  name: '@deepseek-ai/dsh-persona'
  config:
    text: You are a helpful software engineer assistant.
    complete: true
    includeRuntimeContext: false

# The PTY registry is an agent-owned service, so it lives in an entry-local
# realm. The backend still consumes the host sandbox policy and subprocess
# implementation, while the tool registers into this agent's scoped catalog.
- id: persistent-shell
  name: cordis:group
  group: true
  isolate:
    terminals: true
  config:
    - id: pty
      name: '@deepseek-ai/dsh-terminal'

    - id: terminal-bash
      name: '@deepseek-ai/dsh-terminal-bash'
      config:
        timeoutMs: 300000

    - id: persistent-bash
      name: '@deepseek-ai/dsh-tool-bash-persistent'
      config:
        timeoutMs: 300000
        description: |-
          Run commands in a bash shell
          * When invoking this tool, the contents of the "command" parameter does NOT need to be XML-escaped.
          * You don't have access to the internet via this tool.
          * You do have access to a mirror of common linux and python packages via apt and pip.
          * State is persistent across command calls and discussions with the user.
          * To inspect a particular line range of a file, e.g. lines 10-25, try 'sed -n 10,25p /path/to/the/file'.
          * Please avoid commands that may produce a very large amount of output.
          * Please run long lived commands in the background, e.g. 'sleep 10 &' or start a server in the background.

# The bare local filesystem shadows the host's sandboxed provider only for this
# preset. The editor shares that realm and requires absolute paths.
- id: filesystem
  name: cordis:group
  group: true
  isolate:
    fs: true
  config:
    - id: fs-local
      name: '@deepseek-ai/dsh-fs-local'
      config:
        cwd: !!js process.env.DSH_CWD ?? process.cwd()

    - id: str-replace-editor
      name: '@deepseek-ai/dsh-tool-str-replace-editor'
      config:
        maxOutputChars: 16000


- id: tool-pwsh
  name: '@deepseek-ai/dsh-tool-pwsh'
  disabled: !!js process.platform !== 'win32'

- id: tool-goal
  name: '@deepseek-ai/dsh-tool-goal'

- id: tool-todo
  name: '@deepseek-ai/dsh-tool-todo'
  config:
    allowParallelInProgress: true

# The `web` service and its search provider stay in the host composition; only
# the model-facing tool is per-session.
- id: tool-web
  name: '@deepseek-ai/dsh-tool-web'
  config:
    fetch: false
    searchTimeoutMs: 60000
```

## 思考链效果

<img width="1779" height="1215" alt="image" src="https://github.com/user-attachments/assets/7a24d9d7-874f-4816-b58a-2dbde5adfd59" />

<img width="2399" height="1011" alt="image" src="https://github.com/user-attachments/assets/31a4080d-781f-47de-8226-77a7db7ed3c6" />

<img width="2435" height="1166" alt="image" src="https://github.com/user-attachments/assets/0efdbe16-68eb-492d-b0cb-6345e51c8784" />


