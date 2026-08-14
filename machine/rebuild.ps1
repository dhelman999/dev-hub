#Requires -Version 5.1
<#
.SYNOPSIS
  Apply Dev and/or Agent layers from this hub.
.PARAMETER Target
  Dev = machine/terminal: packages, Cmder, font, PowerShell profile
  Agent = AI playbooks: skills/memory/Cursor links (not a second IDE)
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

function Resolve-Winget {
    $cmd = Get-Command winget -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }

    $fallback = Join-Path $env:LOCALAPPDATA 'Microsoft\WindowsApps\winget.exe'
    if (Test-Path -LiteralPath $fallback) { return $fallback }
    return $null
}

function Ensure-WingetPackage {
    param(
        [Parameter(Mandatory)][string]$Id,
        [string]$Location
    )

    $winget = Resolve-Winget
    if (-not $winget) {
        Write-Warning "winget missing; skip $Id"
        return
    }

    $list = & $winget list --id $Id --accept-source-agreements 2>$null | Out-String
    if ($list -match [regex]::Escape($Id)) {
        Write-Host "OK winget: $Id"
        return
    }

    Write-Step "winget install $Id"
    $args = @('install', '--id', $Id, '-e', '--accept-package-agreements', '--accept-source-agreements')
    if (-not [string]::IsNullOrWhiteSpace($Location)) {
        $args += @('--location', $Location)
    }
    & $winget @args
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
    $pendingId = $null
    $pendingLocation = $null

    foreach ($raw in $lines) {
        $line = $raw.TrimEnd()
        if ($line -match '^\s*#' -or [string]::IsNullOrWhiteSpace($line)) { continue }

        if ($line -match "^${Section}:\s*$") {
            if ($pendingId) {
                Ensure-WingetPackage -Id $pendingId -Location $pendingLocation
                $pendingId = $null
                $pendingLocation = $null
            }
            $inSection = $true
            $mode = $null
            continue
        }

        if ($inSection -and $line -match '^[a-zA-Z].*:' -and $line -notmatch '^\s') {
            if ($pendingId) {
                Ensure-WingetPackage -Id $pendingId -Location $pendingLocation
                $pendingId = $null
                $pendingLocation = $null
            }
            break
        }

        if (-not $inSection) { continue }

        if ($line -match '^\s+winget:\s*$') {
            if ($pendingId) {
                Ensure-WingetPackage -Id $pendingId -Location $pendingLocation
                $pendingId = $null
                $pendingLocation = $null
            }
            $mode = 'winget'
            continue
        }
        if ($line -match '^\s+scoop:\s*$') {
            if ($pendingId) {
                Ensure-WingetPackage -Id $pendingId -Location $pendingLocation
                $pendingId = $null
                $pendingLocation = $null
            }
            $mode = 'scoop'
            continue
        }
        if ($line -match '^\s+manual:\s*$') {
            if ($pendingId) {
                Ensure-WingetPackage -Id $pendingId -Location $pendingLocation
                $pendingId = $null
                $pendingLocation = $null
            }
            $mode = 'manual'
            continue
        }

        if ($mode -eq 'winget' -and $line -match '^\s+-\s+id:\s+(\S+)') {
            if ($pendingId) {
                Ensure-WingetPackage -Id $pendingId -Location $pendingLocation
            }
            $pendingId = $Matches[1]
            $pendingLocation = $null
            continue
        }

        if ($mode -eq 'winget' -and $pendingId -and $line -match '^\s+location:\s+(.+)$') {
            $pendingLocation = $Matches[1].Trim().Trim('"')
            continue
        }

        if ($mode -eq 'winget' -and $pendingId -and ($line -match '^\s+notes:' -or $line -match '^\s+optional:')) {
            continue
        }

        if ($mode -eq 'scoop' -and $line -match '^\s+-\s+name:\s+(\S+)') {
            Ensure-ScoopPackage -Name $Matches[1]
        }
        elseif ($mode -eq 'manual' -and $line -match '^\s+-\s+name:\s+(\S+)') {
            Write-Host "Manual / scripted package note: $($Matches[1])"
        }
    }

    if ($pendingId) {
        Ensure-WingetPackage -Id $pendingId -Location $pendingLocation
    }
}

function Invoke-Dev {
    Write-Step 'Target Dev'
    if (-not $SkipPackages) {
        Apply-Packages -Section 'dev'
        & (Join-Path $PSScriptRoot 'Install-Cmder.ps1')
        & (Join-Path $PSScriptRoot 'Install-HackNerdFont.ps1')
    }

    $applyScript = Join-Path $PSScriptRoot 'Apply-Cmder.ps1'
    if ($SkipAutostart) {
        & $applyScript -HubRoot $HubRoot -SkipAutostart
    }
    else {
        & $applyScript -HubRoot $HubRoot
    }

    & (Join-Path $PSScriptRoot 'Enable-ClassicContextMenu.ps1')
    & (Join-Path $PSScriptRoot 'link.ps1') -Target Dev -HubRoot $HubRoot -PersonalHubRoot $PersonalHubRoot
}

function Invoke-Agent {
    Write-Step 'Target Agent'
    if (-not $SkipPackages) {
        Apply-Packages -Section 'agent'
    }

    & (Join-Path $PSScriptRoot 'Ensure-OpenWhispr.ps1') -HubRoot $HubRoot
    & (Join-Path $PSScriptRoot 'Ensure-Lavish.ps1') -HubRoot $HubRoot
    & (Join-Path $PSScriptRoot 'Ensure-QuotaAxi.ps1') -HubRoot $HubRoot
    & (Join-Path $PSScriptRoot 'Ensure-Treehouse.ps1') -HubRoot $HubRoot
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
