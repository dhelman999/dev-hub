#Requires -Version 5.1
<#
.SYNOPSIS
  Install Hack Nerd Font (Regular/Bold/Italic/BoldItalic) for the current user if missing.
#>
[CmdletBinding()]
param(
    [string]$Version = 'v3.4.0'
)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

function Write-Step([string]$Message) {
    Write-Host "==> $Message" -ForegroundColor Cyan
}

Add-Type -AssemblyName System.Drawing
$existing = [System.Drawing.FontFamily]::Families | Where-Object { $_.Name -eq 'Hack Nerd Font' }
if ($existing) {
    Write-Host 'OK font: Hack Nerd Font'
    return
}

Write-Step "Installing Hack Nerd Font ($Version)"
$zip = Join-Path $env:TEMP 'HackNerdFont-dev-hub.zip'
$extract = Join-Path $env:TEMP 'HackNerdFont-dev-hub'
$url = "https://github.com/ryanoasis/nerd-fonts/releases/download/$Version/Hack.zip"
Invoke-WebRequest -Uri $url -OutFile $zip -UseBasicParsing

if (Test-Path $extract) { Remove-Item $extract -Recurse -Force }
Expand-Archive -Path $zip -DestinationPath $extract -Force

$dest = Join-Path $env:LOCALAPPDATA 'Microsoft\Windows\Fonts'
New-Item -ItemType Directory -Force -Path $dest | Out-Null
$regPath = 'HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts'

$map = [ordered]@{
    'HackNerdFont-Regular.ttf'    = 'Hack Nerd Font (TrueType)'
    'HackNerdFont-Bold.ttf'       = 'Hack Nerd Font Bold (TrueType)'
    'HackNerdFont-Italic.ttf'     = 'Hack Nerd Font Italic (TrueType)'
    'HackNerdFont-BoldItalic.ttf' = 'Hack Nerd Font Bold Italic (TrueType)'
}

foreach ($key in $map.Keys) {
    $src = Get-ChildItem -LiteralPath $extract -Recurse -Filter $key | Select-Object -First 1
    if (-not $src) {
        Write-Warning "Missing $key in Hack.zip"
        continue
    }

    $target = Join-Path $dest $key
    if (-not (Test-Path -LiteralPath $target)) {
        Copy-Item -LiteralPath $src.FullName -Destination $target -Force
    }

    New-ItemProperty -Path $regPath -Name $map[$key] -PropertyType String -Value $target -Force | Out-Null
    Write-Host "Installed $($map[$key])"
}

$verify = [System.Drawing.FontFamily]::Families | Where-Object { $_.Name -eq 'Hack Nerd Font' }
if (-not $verify) {
    Write-Warning 'Hack Nerd Font registered; may need a new process/session before ConEmu sees it.'
}
else {
    Write-Host 'OK font: Hack Nerd Font'
}
