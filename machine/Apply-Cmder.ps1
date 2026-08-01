#Requires -Version 5.1
<#
.SYNOPSIS
  Apply hub Cmder configs to C:\Programs\cmder and ensure login auto-start shortcut.
#>
[CmdletBinding()]
param(
    [string]$HubRoot,
    [string]$CmderRoot = 'C:\Programs\cmder',
    [switch]$SkipAutostart
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($HubRoot)) {
    $HubRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
}

function Write-Step([string]$Message) {
    Write-Host "==> $Message" -ForegroundColor Cyan
}

$srcDir = Join-Path $HubRoot 'dotfiles\cmder'
$exe = Join-Path $CmderRoot 'Cmder.exe'

if (-not (Test-Path -LiteralPath $exe)) {
    Write-Warning "Cmder not found at $exe - skip apply"
    return
}

$cmderProcs = Get-Process -Name 'Cmder','ConEmu64','ConEmu' -ErrorAction SilentlyContinue
if ($cmderProcs) {
    Write-Warning 'Cmder/ConEmu appears to be running. Close it, then re-run Apply-Cmder.ps1 for a clean XML write.'
}

$configDir = Join-Path $CmderRoot 'config'
$vendorXml = Join-Path $CmderRoot 'vendor\conemu-maximus5\ConEmu.xml'
New-Item -ItemType Directory -Path $configDir -Force | Out-Null

Write-Step 'Applying Cmder curated files'
$files = @(
    @{ Name = 'user-ConEmu.xml'; Dests = @((Join-Path $configDir 'user-ConEmu.xml'), $vendorXml) },
    @{ Name = 'user_aliases.cmd'; Dests = @((Join-Path $configDir 'user_aliases.cmd')) },
    @{ Name = 'user_profile.cmd'; Dests = @((Join-Path $configDir 'user_profile.cmd')) },
    @{ Name = 'user_profile.ps1'; Dests = @((Join-Path $configDir 'user_profile.ps1')) }
)

foreach ($entry in $files) {
    $src = Join-Path $srcDir $entry.Name
    if (-not (Test-Path -LiteralPath $src)) { continue }

    foreach ($dst in $entry.Dests) {
        $parent = Split-Path -Parent $dst
        if (-not (Test-Path -LiteralPath $parent)) {
            New-Item -ItemType Directory -Path $parent -Force | Out-Null
        }
        Copy-Item -LiteralPath $src -Destination $dst -Force
        Write-Host "Copied $($entry.Name) -> $dst"
    }
}

if (-not $SkipAutostart) {
    Write-Step 'Ensuring Startup shortcut'
    $startup = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs\Startup'
    New-Item -ItemType Directory -Path $startup -Force | Out-Null
    $lnkPath = Join-Path $startup 'Cmder.lnk'

    $wsh = New-Object -ComObject WScript.Shell
    $shortcut = $wsh.CreateShortcut($lnkPath)
    $shortcut.TargetPath = $exe
    $shortcut.WorkingDirectory = $CmderRoot
    $shortcut.WindowStyle = 1
    $shortcut.Description = 'Cmder (dev-hub Dev target)'
    $shortcut.Save()
    Write-Host "Startup shortcut: $lnkPath"
}

Write-Step 'Apply-Cmder complete'
