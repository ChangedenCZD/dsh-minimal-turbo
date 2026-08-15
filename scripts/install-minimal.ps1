param(
    [string]$DshPath = $null
)

try { chcp 65001 > $null } catch {}
$ErrorActionPreference = 'Stop'
$repoDir = Split-Path -Parent $PSScriptRoot
$srcFile = Join-Path $repoDir 'minimal\agent.cordis.yml'

function Resolve-DshDir {
    if ($DshPath) { return $DshPath }
    $prefix = (npm prefix -g 2>$null | Select-Object -First 1)
    if ($prefix) {
        $candidate = Join-Path (Join-Path $prefix 'node_modules') '@deepseek-ai\dsh'
        if (Test-Path -LiteralPath $candidate) { return $candidate }
    }
    $local = Join-Path (Get-Location) 'node_modules\@deepseek-ai\dsh'
    if (Test-Path -LiteralPath $local) { return $local }
    return $null
}

if (-not (Test-Path -LiteralPath $srcFile)) {
    Write-Error "未找到源文件: $srcFile"
    exit 1
}

$dshDir = Resolve-DshDir
if (-not $dshDir) {
    Write-Error "未找到 dsh 安装目录，可通过 -DshPath 参数指定"
    exit 1
}

$targetDir = Join-Path $dshDir 'config\agent-presets\minimal'
$targetFile = Join-Path $targetDir 'agent.cordis.yml'

if (-not (Test-Path -LiteralPath $targetDir)) {
    Write-Error "目标目录不存在: $targetDir"
    exit 1
}

if (Test-Path -LiteralPath $targetFile) {
    $backup = Join-Path $targetDir ("agent.cordis.yml.bak-" + (Get-Date -Format 'yyyyMMdd-HHmmss'))
    Copy-Item -LiteralPath $targetFile -Destination $backup
    Write-Host "已备份原配置 -> $backup"
}

Copy-Item -LiteralPath $srcFile -Destination $targetFile -Force
Write-Host "已复制新配置 -> $targetFile"
Write-Host "完成！重启 dsh 后选择极简模式。"
