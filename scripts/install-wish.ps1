param(
    [string]$DshPath = $null
)

try { chcp 65001 > $null } catch {}
$ErrorActionPreference = 'Stop'
$repoDir = Split-Path -Parent $PSScriptRoot
$srcDir = Join-Path $repoDir 'wish'

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

if (-not (Test-Path -LiteralPath $srcDir)) {
    Write-Error "未找到源目录: $srcDir"
    exit 1
}

$dshDir = Resolve-DshDir
if (-not $dshDir) {
    Write-Error "未找到 dsh 安装目录，可通过 -DshPath 参数指定"
    exit 1
}

$targetDir = Join-Path $dshDir 'config\agent-presets\wish'

if (Test-Path -LiteralPath $targetDir) {
    $ts = Get-Date -Format 'yyyyMMdd-HHmmss'
    Get-ChildItem -LiteralPath $targetDir -File | ForEach-Object {
        $bak = "$($_.FullName).bak-$ts"
        Copy-Item -LiteralPath $_.FullName -Destination $bak
        Write-Host "已备份原文件 -> $bak"
    }
} else {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
}

Copy-Item -Path (Join-Path $srcDir '*') -Destination $targetDir -Recurse -Force
Write-Host "已复制 -> $targetDir"
Write-Host "完成！重启 dsh 后选择许愿模式。"
