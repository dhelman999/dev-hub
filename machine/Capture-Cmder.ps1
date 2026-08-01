#Requires -Version 5.1
<#
.SYNOPSIS
  Capture live Cmder configs into hub dotfiles/cmder (prefer Cmder closed).
#>
[CmdletBinding()]
param(
    [string]$HubRoot,
    [string]$CmderRoot = 'C:\Programs\cmder'
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($HubRoot)) {
    $HubRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
}

function Write-Step([string]$Message) {
    Write-Host "==> $Message" -ForegroundColor Cyan
}

$dstDir = Join-Path $HubRoot 'dotfiles\cmder'
New-Item -ItemType Directory -Path $dstDir -Force | Out-Null

$cmderProcs = Get-Process -Name 'Cmder','ConEmu64','ConEmu' -ErrorAction SilentlyContinue
if ($cmderProcs) {
    Write-Warning 'Cmder/ConEmu is running. Capture may miss unsaved Settings changes. Prefer Export/Save, exit Cmder, then re-run.'
}

Write-Step 'Capturing Cmder configs'
$configDir = Join-Path $CmderRoot 'config'
$vendorXml = Join-Path $CmderRoot 'vendor\conemu-maximus5\ConEmu.xml'
$userXml = Join-Path $configDir 'user-ConEmu.xml'

# Prefer live vendor XML (what ConEmu actually uses). config\user-ConEmu.xml is a
# launch-time backup and can lag behind recent Settings/Apply edits.
if (Test-Path -LiteralPath $vendorXml) {
    Copy-Item -LiteralPath $vendorXml -Destination (Join-Path $dstDir 'user-ConEmu.xml') -Force
    Write-Host "Captured live ConEmu.xml from vendor\ -> user-ConEmu.xml"
    Copy-Item -LiteralPath $vendorXml -Destination $userXml -Force
    Write-Host "Synced config\user-ConEmu.xml from vendor\"
}
elseif (Test-Path -LiteralPath $userXml) {
    Copy-Item -LiteralPath $userXml -Destination (Join-Path $dstDir 'user-ConEmu.xml') -Force
    Write-Host "Captured user-ConEmu.xml from config\ (vendor missing)"
}
else {
    Write-Warning 'No ConEmu XML found to capture'
}

foreach ($name in @('user_aliases.cmd', 'user_profile.cmd', 'user_profile.ps1')) {
    $src = Join-Path $configDir $name
    if (Test-Path -LiteralPath $src) {
        Copy-Item -LiteralPath $src -Destination (Join-Path $dstDir $name) -Force
        Write-Host "Captured $name"
    }
}

Write-Step "Capture-Cmder complete -> $dstDir"
