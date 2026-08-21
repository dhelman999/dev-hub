#Requires -Version 5.1
<#
.SYNOPSIS
  Merge hub dictionary words and snippets into the local OpenWhispr SQLite DB.
  Reads the portable public list plus the optional private list in dev-hub-personal
  (employer / recruiter / pipeline names live there, never in the public hub).

  Official mechanism: Custom Dictionary words are passed to Whisper as an initial-prompt
  hint. This is not a separate keyword-spotting engine.
  Docs: https://docs.openwhispr.com/help/customise/custom-dictionary

  Soft: missing app or DB skips. SQLite lock (app open) is a warning, not a hard fail.
#>
[CmdletBinding()]
param(
    [string]$HubRoot,
    [string]$PersonalHubRoot = 'C:\Projects\dev-hub-personal',
    [string]$DbPath,
    [string]$DictionaryPath
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($HubRoot)) {
    $HubRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
}

if ([string]::IsNullOrWhiteSpace($DbPath)) {
    $DbPath = Join-Path $env:APPDATA 'open-whispr\transcriptions.db'
}

if ([string]::IsNullOrWhiteSpace($DictionaryPath)) {
    $DictionaryPath = Join-Path $HubRoot 'agent\openwhispr-dictionary.txt'
}

$personalDictionary = $null
if (-not [string]::IsNullOrWhiteSpace($PersonalHubRoot)) {
    $personalDictionary = Join-Path $PersonalHubRoot 'agent\openwhispr-dictionary.txt'
}

function Write-Step([string]$Message) {
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Get-Sqlite3 {
    $cmd = Get-Command sqlite3 -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }

    $winget = Get-ChildItem (Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Packages') -Recurse -Filter sqlite3.exe -ErrorAction SilentlyContinue |
        Select-Object -First 1 -ExpandProperty FullName
    if ($winget) { return $winget }
    return $null
}

function Read-DictionaryFile([string]$Path) {
    $words = New-Object System.Collections.Generic.List[string]
    $snippets = New-Object System.Collections.Generic.List[hashtable]

    if (-not (Test-Path -LiteralPath $Path)) {
        return @{ Words = @($words); Snippets = @($snippets) }
    }

    foreach ($line in Get-Content -LiteralPath $Path) {
        $t = $line.Trim()
        if ([string]::IsNullOrWhiteSpace($t)) { continue }
        if ($t.StartsWith('#')) { continue }

        # Snippets are exact post-transcript replacements, not prompt hints.
        if ($t -match '^(.+?)\s*=>\s*(.+)$') {
            $snippets.Add(@{ Trigger = $Matches[1].Trim(); Replacement = $Matches[2].Trim() })
            continue
        }

        $words.Add($t)
    }

    return @{ Words = @($words); Snippets = @($snippets) }
}

Write-Step 'OpenWhispr dictionary merge (official Whisper prompt hints)'

if (-not (Test-Path -LiteralPath $DbPath)) {
    Write-Host "OpenWhispr DB not found ($DbPath) - skipping dictionary merge"
    return
}

$sqlite = Get-Sqlite3
if (-not $sqlite) {
    Write-Warning 'sqlite3 not on PATH - skip dictionary merge. Install SQLite.SQLite or paste agent/openwhispr-dictionary.txt in Dictionary sidebar.'
    return
}

$public = Read-DictionaryFile -Path $DictionaryPath
$personal = Read-DictionaryFile -Path $personalDictionary

$words = @($public.Words + $personal.Words | Where-Object { $_ } | Select-Object -Unique)
$snippets = @($public.Snippets + $personal.Snippets)

if ($words.Count -eq 0 -and $snippets.Count -eq 0) {
    Write-Host "No dictionary entries in $DictionaryPath"
    return
}

$wordSql = New-Object System.Collections.Generic.List[string]
foreach ($w in $words) {
    $esc = $w.Replace("'", "''")
    $wordSql.Add("INSERT OR IGNORE INTO custom_dictionary (word, source, sync_status) VALUES ('$esc', 'manual', 'pending');")
}

$snipSql = New-Object System.Collections.Generic.List[string]
foreach ($s in $snippets) {
    $t = $s.Trigger.Replace("'", "''")
    $r = $s.Replacement.Replace("'", "''")
    $snipSql.Add(@"
INSERT INTO snippets (trigger, replacement, sync_status)
SELECT '$t', '$r', 'pending'
WHERE NOT EXISTS (
  SELECT 1 FROM snippets WHERE deleted_at IS NULL AND lower(trigger) = lower('$t')
);
"@)
}

$sqlFile = Join-Path ([IO.Path]::GetTempPath()) ("openwhispr-dict-" + [guid]::NewGuid().ToString('n') + '.sql')
@(
    'BEGIN;'
    $wordSql
    $snipSql
    'COMMIT;'
) | Set-Content -LiteralPath $sqlFile -Encoding ascii

try {
    $out = & $sqlite $DbPath ".read $sqlFile" 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "OpenWhispr dictionary merge failed (is the app open and locking the DB?): $out"
        Write-Host 'Paste agent/openwhispr-dictionary.txt via Dictionary -> Import a list instead.'
        return
    }
}
catch {
    Write-Warning "OpenWhispr dictionary merge failed: $_"
    return
}
finally {
    Remove-Item -LiteralPath $sqlFile -Force -ErrorAction SilentlyContinue
}

$sources = @($DictionaryPath)
if ($personalDictionary -and (Test-Path -LiteralPath $personalDictionary)) {
    $sources += $personalDictionary
}

Write-Host "Merged $($words.Count) dictionary hints and $($snippets.Count) snippets into $DbPath"
Write-Host "Sources: $($sources -join ', ')"
Write-Host 'Restart OpenWhispr if it is running so the Control Panel list refreshes.'
Write-Host 'Official docs: https://docs.openwhispr.com/help/customise/custom-dictionary'
