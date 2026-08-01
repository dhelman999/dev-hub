#Requires -Version 5.1
<#
.SYNOPSIS
  Update Cmder-bundled Clink to the latest release and ensure themes\ is installed.

.DESCRIPTION
  Cmder ships an older Clink. The upstream updater has two sharp edges we hit on
  regenerate:

  1. Stale %LOCALAPPDATA%\Temp\clink\updater\vX.Y.Z -> "Temp path ... already exists"
  2. Jumping from pre-themes Clink (e.g. 1.6.x) to modern Clink fails once on
     themes\, then a second update (or manual copy) finishes the install.
     Clearing the expand dir between passes makes the second pass say
     "Already up-to-date" while themes\ is still missing - so we keep the expand
     dir until themes are present, then clean up.
#>
[CmdletBinding()]
param(
    [string]$CmderRoot = 'C:\Programs\cmder'
)

$ErrorActionPreference = 'Stop'

function Write-Step([string]$Message) {
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Get-ClinkExe([string]$Root) {
    $dir = Join-Path $Root 'vendor\clink'
    foreach ($name in @('clink_x64.exe', 'clink_arm64.exe', 'clink_x86.exe')) {
        $candidate = Join-Path $dir $name
        if (Test-Path -LiteralPath $candidate) { return $candidate }
    }
    return $null
}

function Get-ClinkUpdaterRoot {
    return (Join-Path $env:LOCALAPPDATA 'Temp\clink\updater')
}

function Clear-ClinkUpdaterTemp {
    $updater = Get-ClinkUpdaterRoot
    if (Test-Path -LiteralPath $updater) {
        Write-Host "Clearing stale Clink updater temp: $updater"
        Remove-Item -LiteralPath $updater -Recurse -Force -ErrorAction SilentlyContinue
    }
}

function Test-ClinkThemesPresent([string]$ClinkDir) {
    $themes = Join-Path $ClinkDir 'themes'
    if (-not (Test-Path -LiteralPath $themes)) { return $false }
    return (@(Get-ChildItem -LiteralPath $themes -File -ErrorAction SilentlyContinue).Count -gt 0)
}

function Find-ExpandedThemesDir {
    $updater = Get-ClinkUpdaterRoot
    if (-not (Test-Path -LiteralPath $updater)) { return $null }

    $match = Get-ChildItem -LiteralPath $updater -Directory -ErrorAction SilentlyContinue |
        Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'themes') } |
        Sort-Object Name -Descending |
        Select-Object -First 1

    if (-not $match) { return $null }
    return (Join-Path $match.FullName 'themes')
}

function Install-ClinkThemesFromExpanded([string]$ClinkDir) {
    $src = Find-ExpandedThemesDir
    if (-not $src) { return $false }

    $dst = Join-Path $ClinkDir 'themes'
    Write-Host "Copying Clink themes from expand dir -> $dst"
    New-Item -ItemType Directory -Path $dst -Force | Out-Null
    Copy-Item -Path (Join-Path $src '*') -Destination $dst -Force
    return (Test-ClinkThemesPresent -ClinkDir $ClinkDir)
}

function Invoke-ClinkUpdate([string]$Exe) {
    Write-Host "Running: $Exe update"
    & $Exe update 2>&1 | ForEach-Object { Write-Host $_ }
    return $LASTEXITCODE
}

$exe = Get-ClinkExe -Root $CmderRoot
if (-not $exe) {
    Write-Warning "Clink not found under $CmderRoot\vendor\clink - skip Update-Clink"
    return
}

$clinkDir = Split-Path -Parent $exe
Write-Step "Update Clink under $clinkDir"

$cmderProcs = Get-Process -Name 'Cmder', 'ConEmu64', 'ConEmu' -ErrorAction SilentlyContinue
if ($cmderProcs) {
    Write-Warning 'Cmder/ConEmu is running. Clink DLL update may be deferred until new sessions; themes copy still proceeds.'
}

$before = (& $exe --version 2>$null | Out-String).Trim()
if ($before) { Write-Host "Current Clink: $before" }

# Drop leftover expand/zip so the first update cannot hit "Temp path already exists".
Clear-ClinkUpdaterTemp

$null = Invoke-ClinkUpdate -Exe $exe

# Keep expand dir: second pass (or manual copy) needs themes\ from it.
if (-not (Test-ClinkThemesPresent -ClinkDir $clinkDir)) {
    Write-Host 'Themes missing after first update pass; running second pass...'
    $null = Invoke-ClinkUpdate -Exe $exe
}

if (-not (Test-ClinkThemesPresent -ClinkDir $clinkDir)) {
    if (-not (Install-ClinkThemesFromExpanded -ClinkDir $clinkDir)) {
        Write-Warning @'
Clink themes\ still missing after update passes.
Manual fix: extract themes\ from https://github.com/chrisant996/clink/releases/latest
into C:\Programs\cmder\vendor\clink\themes
'@
    }
}

$after = (& $exe --version 2>$null | Out-String).Trim()
if ($after) { Write-Host "Clink version: $after" }

if (Test-ClinkThemesPresent -ClinkDir $clinkDir) {
    $count = @(Get-ChildItem -LiteralPath (Join-Path $clinkDir 'themes') -File).Count
    Write-Host "OK Clink themes: $count files"
}
else {
    Write-Warning 'Clink themes directory is still incomplete.'
}

# Safe to clear now that themes are installed (or we gave up).
Clear-ClinkUpdaterTemp
Write-Step 'Update-Clink complete'
