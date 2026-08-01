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

function Get-RemoteLength([string]$Url) {
    try {
        $resp = Invoke-WebRequest -Uri $Url -Method Head -UseBasicParsing
        $len = $resp.Headers['Content-Length']
        if ($len) { return [int64]$len }
    }
    catch { }
    return $null
}

function Save-UrlToFile {
    param(
        [string]$Url,
        [string]$OutFile,
        [Nullable[int64]]$ExpectedLength
    )

    if ((Test-Path -LiteralPath $OutFile) -and $ExpectedLength -and ((Get-Item -LiteralPath $OutFile).Length -eq $ExpectedLength)) {
        Write-Host "Reusing existing download ($([math]::Round($ExpectedLength/1MB,1)) MB): $OutFile"
        return
    }

    $curl = Get-Command curl.exe -ErrorAction SilentlyContinue
    if ($curl) {
        Write-Host "Downloading with curl (progress below)..."
        & curl.exe -L --fail --retry 3 --retry-delay 2 -o $OutFile $Url
        if ($LASTEXITCODE -ne 0) { throw "curl download failed (exit $LASTEXITCODE)" }
        return
    }

    Write-Host "Downloading with Invoke-WebRequest (no live bar; large zip ~150MB+ can take several minutes)..."
    Invoke-WebRequest -Uri $Url -OutFile $OutFile -UseBasicParsing
}

$exe = Join-Path $CmderRoot 'Cmder.exe'
if (Test-Path -LiteralPath $exe) {
    Write-Host "OK Cmder: $exe"
    & (Join-Path $PSScriptRoot 'Update-Clink.ps1') -CmderRoot $CmderRoot
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
    $expected = [int64]$asset.size
}
else {
    $url = "https://github.com/cmderdev/cmder/releases/download/$ReleaseTag/cmder.zip"
    $expected = Get-RemoteLength -Url $url
}

$zip = Join-Path $env:TEMP ("cmder-{0}.zip" -f $ReleaseTag)
$extract = Join-Path $env:TEMP ("cmder-extract-{0}" -f $ReleaseTag)
Write-Host "URL: $url"
if ($expected) { Write-Host "Expected size: $([math]::Round($expected/1MB,1)) MB" }

Save-UrlToFile -Url $url -OutFile $zip -ExpectedLength $expected
$actual = (Get-Item -LiteralPath $zip).Length
Write-Host "Download complete: $([math]::Round($actual/1MB,1)) MB -> $zip"

Write-Host "Expanding archive (can take 1-3 minutes, no progress bar)..."
if (Test-Path $extract) { Remove-Item $extract -Recurse -Force }
Expand-Archive -Path $zip -DestinationPath $extract -Force
Write-Host "Expand complete."

$cmderExeFound = Get-ChildItem -LiteralPath $extract -Recurse -Filter 'Cmder.exe' | Select-Object -First 1
if (-not $cmderExeFound) { throw "Cmder.exe not found inside $zip" }

$sourceRoot = $cmderExeFound.Directory.FullName
Write-Host "Copying into $CmderRoot ..."
if (Test-Path -LiteralPath $CmderRoot) {
    Remove-Item -LiteralPath $CmderRoot -Recurse -Force
}
New-Item -ItemType Directory -Path $CmderRoot -Force | Out-Null
Copy-Item -Path (Join-Path $sourceRoot '*') -Destination $CmderRoot -Recurse -Force

if (-not (Test-Path -LiteralPath $exe)) {
    throw "Install failed; still missing $exe"
}

Write-Host "Installed Cmder $ReleaseTag -> $CmderRoot"

# Cmder bundles an older Clink; bring it current (themes\ two-pass fix included).
& (Join-Path $PSScriptRoot 'Update-Clink.ps1') -CmderRoot $CmderRoot
