#Requires -Version 5.1
<#
.SYNOPSIS
  Soft treehouse check: CLI on PATH or under %LOCALAPPDATA%\treehouse; soft-install
  via official Windows zip if missing. No hard failure.
#>
[CmdletBinding()]
param(
    [string]$HubRoot,
    [switch]$SkipInstall
)

$ErrorActionPreference = 'Continue'

if ([string]::IsNullOrWhiteSpace($HubRoot)) {
    $HubRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
}

function Write-Step([string]$Message) {
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Get-TreehouseExe {
    $cmd = Get-Command treehouse -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    $local = Join-Path $env:LOCALAPPDATA 'treehouse\treehouse.exe'
    if (Test-Path -LiteralPath $local) { return $local }
    return $null
}

function Install-TreehouseOfficial {
    $repo = 'kunchenguid/treehouse'
    $installDir = Join-Path $env:LOCALAPPDATA 'treehouse'
    $arch = if ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64') { 'arm64' } else { 'amd64' }

    Write-Host "Downloading latest treehouse release (windows/$arch)..."
    $release = Invoke-RestMethod -Uri "https://api.github.com/repos/$repo/releases/latest"
    $version = $release.tag_name
    $versionNum = $version.TrimStart('v')
    $filename = "treehouse-v$versionNum-windows-$arch.zip"
    $url = "https://github.com/$repo/releases/download/$version/$filename"

    $tmpDir = Join-Path ([System.IO.Path]::GetTempPath()) ("treehouse-install-" + [guid]::NewGuid().ToString('n'))
    New-Item -ItemType Directory -Path $tmpDir -Force | Out-Null
    try {
        $zipPath = Join-Path $tmpDir $filename
        Invoke-WebRequest -Uri $url -OutFile $zipPath -UseBasicParsing
        Expand-Archive -Path $zipPath -DestinationPath $tmpDir -Force
        New-Item -ItemType Directory -Path $installDir -Force | Out-Null
        $exeSrc = Join-Path $tmpDir 'treehouse.exe'
        if (-not (Test-Path -LiteralPath $exeSrc)) {
            throw "treehouse.exe missing from release zip $filename"
        }
        Move-Item -Path $exeSrc -Destination (Join-Path $installDir 'treehouse.exe') -Force

        $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
        if ($userPath -notlike "*$installDir*") {
            [Environment]::SetEnvironmentVariable('Path', "$userPath;$installDir", 'User')
            Write-Host "Added $installDir to user PATH (restart shells to pick up)."
        }
        $env:Path = "$installDir;" + $env:Path
        Write-Host "OK treehouse $version installed to $installDir\treehouse.exe"
    }
    finally {
        Remove-Item -Recurse -Force $tmpDir -ErrorAction SilentlyContinue
    }
}

Write-Step 'treehouse (optional / soft)'

$exe = Get-TreehouseExe
if (-not $exe -and -not $SkipInstall) {
    try {
        Install-TreehouseOfficial
        $exe = Get-TreehouseExe
    }
    catch {
        Write-Warning "treehouse soft-install failed: $($_.Exception.Message)"
        Write-Host '  Manual: irm https://kunchenguid.github.io/treehouse/install.ps1 | iex'
    }
}

if (-not $exe) {
    Write-Warning 'treehouse not on PATH - parallel worktree leasing unavailable until installed.'
    Write-Host '  Docs: captain-crew references/treehouse-lease.md; PATHS.md'
    return
}

Write-Host "OK treehouse: $exe"
try {
    $ver = & $exe --version 2>&1 | Out-String
    Write-Host ($ver.Trim())
}
catch {
    Write-Host '(version flag unavailable; binary present)'
}

Write-Host 'Agents: treehouse get --lease [--json] [--lease-holder <label>] ; treehouse return <path>'
Write-Host 'Skill: captain-crew -> references/treehouse-lease.md'
