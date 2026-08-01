#Requires -Version 5.1
<#
.SYNOPSIS
  Ensure Cmder exists at C:\Programs\cmder (download latest full zip if missing).
#>
[CmdletBinding()]
param(
    [string]$CmderRoot = 'C:\Programs\cmder',
    [string]$ReleaseTag
)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

function Write-Step([string]$Message) {
    Write-Host "==> $Message" -ForegroundColor Cyan
}

$exe = Join-Path $CmderRoot 'Cmder.exe'
if (Test-Path -LiteralPath $exe) {
    Write-Host "OK Cmder: $exe"
    return
}

Write-Step "Cmder missing at $CmderRoot - downloading"

$parent = Split-Path -Parent $CmderRoot
New-Item -ItemType Directory -Path $parent -Force | Out-Null

if ([string]::IsNullOrWhiteSpace($ReleaseTag)) {
    $api = Invoke-RestMethod -Uri 'https://api.github.com/repos/cmderdev/cmder/releases/latest' -Headers @{
        'User-Agent' = 'dev-hub-rebuild'
    }
    $ReleaseTag = $api.tag_name
    $asset = $api.assets | Where-Object { $_.name -eq 'cmder.zip' } | Select-Object -First 1
    if (-not $asset) { throw 'cmder.zip not found on latest GitHub release' }
    $url = $asset.browser_download_url
}
else {
    $url = "https://github.com/cmderdev/cmder/releases/download/$ReleaseTag/cmder.zip"
}

$zip = Join-Path $env:TEMP ("cmder-{0}.zip" -f $ReleaseTag)
$extract = Join-Path $env:TEMP ("cmder-extract-{0}" -f $ReleaseTag)
Write-Host "Downloading $url"
Invoke-WebRequest -Uri $url -OutFile $zip -UseBasicParsing

if (Test-Path $extract) { Remove-Item $extract -Recurse -Force }
Expand-Archive -Path $zip -DestinationPath $extract -Force

# Zip may be root files or a single top-level folder
$cmderExeFound = Get-ChildItem -LiteralPath $extract -Recurse -Filter 'Cmder.exe' | Select-Object -First 1
if (-not $cmderExeFound) { throw "Cmder.exe not found inside $zip" }

$sourceRoot = $cmderExeFound.Directory.FullName
if (Test-Path -LiteralPath $CmderRoot) {
    Remove-Item -LiteralPath $CmderRoot -Recurse -Force
}
New-Item -ItemType Directory -Path $CmderRoot -Force | Out-Null
Copy-Item -Path (Join-Path $sourceRoot '*') -Destination $CmderRoot -Recurse -Force

if (-not (Test-Path -LiteralPath $exe)) {
    throw "Install failed; still missing $exe"
}

Write-Host "Installed Cmder $ReleaseTag -> $CmderRoot"
