#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
src_file="$repo_dir/minimal/agent.cordis.yml"

if [ ! -f "$src_file" ]; then
    echo "错误: 未找到源文件: $src_file" >&2
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

target_dir="$dsh_dir/config/agent-presets/minimal"
target_file="$target_dir/agent.cordis.yml"

if [ ! -d "$target_dir" ]; then
    echo "错误: 目标目录不存在: $target_dir" >&2
    exit 1
fi

if [ -f "$target_file" ]; then
    backup="$target_dir/agent.cordis.yml.bak-$(date +%Y%m%d-%H%M%S)"
    cp "$target_file" "$backup"
    echo "已备份原配置 -> $backup"
fi

cp "$src_file" "$target_file"
echo "已复制新配置 -> $target_file"
echo "完成！重启 dsh 后选择极简模式。"
