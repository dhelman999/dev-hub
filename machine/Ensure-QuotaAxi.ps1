#Requires -Version 5.1
<#
.SYNOPSIS
  Soft quota-axi check: Node/npx, sqlite3 (needed for Cursor provider), CLI reachable.
  No hard failure. Agents run `npx -y quota-axi --provider cursor --json` (skill usage-canvas).
#>
[CmdletBinding()]
param(
    [string]$HubRoot
)

$ErrorActionPreference = 'Continue'

if ([string]::IsNullOrWhiteSpace($HubRoot)) {
    $HubRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
}

function Write-Step([string]$Message) {
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Resolve-Winget {
    $cmd = Get-Command winget -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    $fallback = Join-Path $env:LOCALAPPDATA 'Microsoft\WindowsApps\winget.exe'
    if (Test-Path -LiteralPath $fallback) { return $fallback }
    return $null
}

Write-Step 'quota-axi / usage canvas (optional / soft)'

$skill = Join-Path $HubRoot 'agent\skills\usage-canvas\SKILL.md'
if (Test-Path -LiteralPath $skill) {
    Write-Host "OK usage-canvas skill: $skill"
}
else {
    Write-Warning "usage-canvas skill missing at $skill"
}

$node = Get-Command node -ErrorAction SilentlyContinue
if (-not $node) {
    Write-Host 'Node.js not on PATH - quota-axi needs Node for `npx -y quota-axi`.'
    Write-Host '  Install Node LTS, then re-run Agent rebuild.'
    return
}

Write-Host "OK Node: $($node.Source) ($(& node -v 2>$null))"

$sqlite = Get-Command sqlite3 -ErrorAction SilentlyContinue
if (-not $sqlite) {
    Write-Host 'sqlite3 not on PATH - Cursor quota reads need it (quota-axi state-vscdb).'
    $winget = Resolve-Winget
    if ($winget) {
        Write-Host "Attempting soft install: SQLite.SQLite via winget..."
        & $winget install -e --id SQLite.SQLite --accept-package-agreements --accept-source-agreements 2>&1 | Out-Host
        $env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' +
            [System.Environment]::GetEnvironmentVariable('Path', 'User')
        $sqlite = Get-Command sqlite3 -ErrorAction SilentlyContinue
    }

    if (-not $sqlite) {
        Write-Warning 'sqlite3 still missing - install winget package SQLite.SQLite (listed in packages.yaml).'
    }
}

if ($sqlite) {
    Write-Host "OK sqlite3: $($sqlite.Source)"
}

$npx = Get-Command npx -ErrorAction SilentlyContinue
if (-not $npx) {
    Write-Host 'npx not on PATH - install Node with npm.'
    return
}

Write-Host 'Checking quota-axi via npx (may download on first run)...'
$helpOut = & npx.cmd -y quota-axi --help 2>&1 | Out-String
$helpOut.Split("`n") | Select-Object -First 8 | ForEach-Object { Write-Host $_ }
if ($helpOut -match 'quota|provider|AXI|usage') {
    Write-Host 'OK quota-axi reachable via npx'
}
else {
    Write-Warning 'quota-axi help did not look healthy - agent can still try npx -y quota-axi when needed.'
}

Write-Host 'Usage: npx -y quota-axi --provider cursor --json'
Write-Host 'Docs: skill usage-canvas; /usage; GETTING-STARTED (usage canvas)'
