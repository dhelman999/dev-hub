#Requires -Version 5.1
<#
.SYNOPSIS
  Soft OpenWhispr check: OK if installed; otherwise print manual install hint and continue.
  No hard failure. Config is app-local / Control Panel — see agent/OPENWHISPR-SETUP.md.
#>
[CmdletBinding()]
param(
    [string]$HubRoot
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($HubRoot)) {
    $HubRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
}

function Write-Step([string]$Message) {
    Write-Host "==> $Message" -ForegroundColor Cyan
}

Write-Step 'OpenWhispr (optional / soft)'

$exe = Join-Path $env:LOCALAPPDATA 'Programs\OpenWhispr\OpenWhispr.exe'
$checklist = Join-Path $HubRoot 'agent\OPENWHISPR-SETUP.md'

if (Test-Path -LiteralPath $exe) {
    Write-Host "OK OpenWhispr: $exe"
    Write-Host 'No hub-managed OpenWhispr config to copy (settings live in the app Control Panel).'
    if (Test-Path -LiteralPath $checklist) {
        Write-Host "Checklist: $checklist"
    }
    return
}

Write-Host 'OpenWhispr not installed - skipping (manual install).'
Write-Host '  Typical path: %LOCALAPPDATA%\Programs\OpenWhispr\OpenWhispr.exe'
if (Test-Path -LiteralPath $checklist) {
    Write-Host "  See: $checklist"
}
else {
    Write-Host '  See agentic-harness skill: references/voice-openwhispr.md'
}
