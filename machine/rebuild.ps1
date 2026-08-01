#Requires -Version 5.1
<#
.SYNOPSIS
  Apply Dev and/or Agent layers from this hub.
.PARAMETER Target
  Dev = packages notes + Cmder/dotfiles
  Agent = skills/memory/Cursor links
  All = Dev then Agent
.PARAMETER SkipPackages
  Skip winget/scoop ensure (links only)
.PARAMETER SkipAutostart
  Do not create Cmder Startup shortcut
.PARAMETER PersonalHubRoot
  Optional private skills hub (default C:\Projects\dev-hub-personal). If missing, Agent apply skips personal skills.
#>
[CmdletBinding()]
param(
    [ValidateSet('Dev', 'Agent', 'All')]
    [string]$Target = 'All',

    [switch]$SkipPackages,
    [switch]$SkipAutostart,

    [string]$HubRoot,

    [string]$PersonalHubRoot = 'C:\Projects\dev-hub-personal'
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($HubRoot)) {
    $HubRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
}

function Write-Step([string]$Message) {
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Ensure-ScoopPackage([string]$Name) {
    $scoop = Get-Command scoop -ErrorAction SilentlyContinue
    if (-not $scoop) {
        Write-Warning "scoop missing; skip package $Name"
        return
    }

    $installed = & scoop list 6>$null | Select-String -SimpleMatch $Name
    if ($installed) {
        Write-Host "OK scoop: $Name"
        return
    }

    Write-Step "scoop install $Name"
    & scoop install $Name
}

function Ensure-WingetPackage([string]$Id) {
    $winget = Get-Command winget -ErrorAction SilentlyContinue
    if (-not $winget) {
        Write-Warning "winget missing; skip $Id"
        return
    }

    $list = & winget list --id $Id --accept-source-agreements 2>$null
    if ($list -match [regex]::Escape($Id)) {
        Write-Host "OK winget: $Id"
        return
    }

    Write-Step "winget install $Id"
    & winget install --id $Id -e --accept-package-agreements --accept-source-agreements
}

function Apply-Packages([string]$Section) {
    $yamlPath = Join-Path $HubRoot 'machine\packages.yaml'
    if (-not (Test-Path -LiteralPath $yamlPath)) {
        Write-Warning 'packages.yaml missing'
        return
    }

    $lines = Get-Content -LiteralPath $yamlPath
    $inSection = $false
    $mode = $null

    foreach ($raw in $lines) {
        $line = $raw.TrimEnd()
        if ($line -match '^\s*#' -or [string]::IsNullOrWhiteSpace($line)) { continue }

        if ($line -match "^${Section}:\s*$") {
            $inSection = $true
            $mode = $null
            continue
        }

        if ($inSection -and $line -match '^[a-zA-Z].*:') {
            if ($line -notmatch '^\s') {
                break
            }
        }

        if (-not $inSection) { continue }

        if ($line -match '^\s+winget:\s*$') { $mode = 'winget'; continue }
        if ($line -match '^\s+scoop:\s*$') { $mode = 'scoop'; continue }
        if ($line -match '^\s+manual:\s*$') { $mode = 'manual'; continue }

        if ($mode -eq 'winget' -and $line -match '^\s+-\s+id:\s+(\S+)') {
            Ensure-WingetPackage -Id $Matches[1]
        }
        elseif ($mode -eq 'scoop' -and $line -match '^\s+-\s+name:\s+(\S+)') {
            Ensure-ScoopPackage -Name $Matches[1]
        }
        elseif ($mode -eq 'manual' -and $line -match '^\s+-\s+name:\s+(\S+)') {
            Write-Host "Manual package (document/install yourself): $($Matches[1])"
        }
    }
}

function Invoke-Dev {
    Write-Step 'Target Dev'
    if (-not $SkipPackages) {
        Apply-Packages -Section 'dev'
    }

    $applyScript = Join-Path $PSScriptRoot 'Apply-Cmder.ps1'
    if ($SkipAutostart) {
        & $applyScript -HubRoot $HubRoot -SkipAutostart
    }
    else {
        & $applyScript -HubRoot $HubRoot
    }

    & (Join-Path $PSScriptRoot 'link.ps1') -Target Dev -HubRoot $HubRoot -PersonalHubRoot $PersonalHubRoot
}

function Invoke-Agent {
    Write-Step 'Target Agent'
    if (-not $SkipPackages) {
        Apply-Packages -Section 'agent'
    }
    & (Join-Path $PSScriptRoot 'link.ps1') -Target Agent -HubRoot $HubRoot -PersonalHubRoot $PersonalHubRoot
}

switch ($Target) {
    'Dev' { Invoke-Dev }
    'Agent' { Invoke-Agent }
    'All' {
        Invoke-Dev
        Invoke-Agent
    }
}

Write-Step "rebuild.ps1 complete ($Target)"
Write-Host "Hub: $HubRoot"
