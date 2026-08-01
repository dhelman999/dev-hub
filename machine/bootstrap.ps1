#Requires -Version 5.1
<#
.SYNOPSIS
  One-time prerequisites for a clean Windows machine before rebuild.ps1.
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

Write-Step "Hub root: $HubRoot"

foreach ($dir in @('C:\Programs', 'C:\Projects')) {
    if (-not (Test-Path -LiteralPath $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "Created $dir"
    }
    else {
        Write-Host "OK $dir"
    }
}

$winget = Get-Command winget -ErrorAction SilentlyContinue
if ($winget) {
    Write-Host "OK winget: $($winget.Source)"
}
else {
    Write-Warning 'winget not on PATH. Install App Installer from Microsoft Store, then re-open the shell.'
}

$scoop = Get-Command scoop -ErrorAction SilentlyContinue
if ($scoop) {
    Write-Host "OK scoop: $($scoop.Source)"
}
else {
    Write-Host 'Scoop not installed. Optional for CLI tools in packages.yaml.'
    Write-Host 'Install: irm get.scoop.sh | iex'
}

$personal = 'C:\Projects\dev-hub-personal'
if (Test-Path -LiteralPath $personal) {
    Write-Host "OK optional personal hub: $personal"
}
else {
    Write-Host "Optional: clone private personal skills hub if you use it:"
    Write-Host "  git clone https://github.com/dhelman999/dev-hub-personal.git $personal"
    Write-Host '  (skipped when absent - public Agent apply still works)'
}

Write-Host ''
Write-Host 'Symlink tip: Settings > System > For developers > Developer Mode (needed for file symlinks; junctions/hardlinks work without it).'
Write-Host ''
Write-Step 'Bootstrap complete. Next: .\machine\rebuild.ps1 -Target All'
