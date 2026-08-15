#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
src_dir="$repo_dir/wish"

if [ ! -d "$src_dir" ]; then
    echo "错误: 未找到源目录: $src_dir" >&2
    exit 1
fi

dsh_dir="${DSH_PATH:-}"
if [ -z "$dsh_dir" ]; then
    prefix="$(npm prefix -g 2>/dev/null || true)"
    if [ -n "$prefix" ] && [ -d "$prefix/node_modules/@deepseek-ai/dsh" ]; then
        dsh_dir="$prefix/node_modules/@deepseek-ai/dsh"
    fi
fi
if [ -z "$dsh_dir" ] && [ -d "$(pwd)/node_modules/@deepseek-ai/dsh" ]; then
    dsh_dir="$(pwd)/node_modules/@deepseek-ai/dsh"
fi
if [ -z "$dsh_dir" ]; then
    echo "错误: 未找到 dsh 安装目录，可通过 DSH_PATH 环境变量指定" >&2
    exit 1
fi

target_dir="$dsh_dir/config/agent-presets/wish"

if [ -d "$target_dir" ]; then
    ts="$(date +%Y%m%d-%H%M%S)"
    for f in "$target_dir"/*; do
        [ -f "$f" ] || continue
        mv "$f" "$f.bak-$ts"
        echo "已备份原文件 -> $f.bak-$ts"
    done
else
    mkdir -p "$target_dir"
fi

cp "$src_dir/agent.cordis.yml" "$src_dir/preset.yml" "$target_dir/"
echo "已复制 -> $target_dir"
echo "完成！重启 dsh 后选择许愿模式。"
