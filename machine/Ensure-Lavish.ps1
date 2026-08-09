#Requires -Version 5.1
<#
.SYNOPSIS
  Soft Lavish (lavish-axi) check: Node present; CLI reachable via npx; skill in hub.
  No hard failure. Agents run `npx -y lavish-axi` on demand (see agent/skills/lavish).
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

Write-Step 'Lavish / lavish-axi (optional / soft)'

$skill = Join-Path $HubRoot 'agent\skills\lavish\SKILL.md'
if (Test-Path -LiteralPath $skill) {
    Write-Host "OK Lavish skill: $skill"
}
else {
    Write-Warning "Lavish skill missing at $skill - restore from hub or re-vendor from kunchenguid/lavish-axi"
}

$node = Get-Command node -ErrorAction SilentlyContinue
if (-not $node) {
    Write-Host 'Node.js not on PATH - Lavish CLI needs Node for `npx -y lavish-axi`.'
    Write-Host '  Install Node LTS (winget: OpenJS.NodeJS.LTS), then re-run Agent rebuild.'
    return
}

Write-Host "OK Node: $($node.Source) ($(& node -v 2>$null))"

$npx = Get-Command npx -ErrorAction SilentlyContinue
if (-not $npx) {
    Write-Host 'npx not on PATH - install Node with npm, or use a global `npm i -g lavish-axi`.'
    return
}

# Cheap reachability check (may download package first time).
Write-Host 'Checking lavish-axi via npx (may download on first run)...'
$helpOut = & npx.cmd -y lavish-axi --help 2>&1 | Out-String
$helpOut.Split("`n") | Select-Object -First 8 | ForEach-Object { Write-Host $_ }
if ($helpOut -match 'lavish|description|playbooks') {
    Write-Host 'OK lavish-axi reachable via npx'
}
else {
    Write-Warning "lavish-axi help did not look healthy - agent can still try npx -y lavish-axi when needed."
}

Write-Host 'Optional: npm i -g lavish-axi ; lavish-axi setup plugin  (Cursor plugin registration)'
Write-Host 'Docs: skill lavish; GETTING-STARTED (Lavish vs Canvas)'
