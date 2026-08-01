#Requires -Version 5.1
<#
.SYNOPSIS
  Restore the full classic Windows 11 right-click menu (skip "Show more options").

.DESCRIPTION
  Windows 11 hides many shell extensions (e.g. Open with Notepad++) behind
  "Show more options". This HKCU registry tweak forces the classic full menu.
  Restart Explorer (or sign out) for it to take effect.

  Undo:
    reg.exe delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f
#>
[CmdletBinding()]
param(
    [switch]$RestartExplorer
)

$ErrorActionPreference = 'Stop'

$key = 'HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32'
Write-Host "==> Enabling classic context menu ($key)" -ForegroundColor Cyan
& reg.exe add $key /f /ve | Out-Null
if ($LASTEXITCODE -ne 0) {
    throw "reg.exe add failed with exit $LASTEXITCODE"
}

$verify = Get-ItemProperty -LiteralPath 'HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32' -ErrorAction Stop
Write-Host "InprocServer32 (Default) = '$($verify.'(default)')' (empty string expected)"

if ($RestartExplorer) {
    Write-Host '==> Restarting Explorer' -ForegroundColor Cyan
    Get-Process -Name explorer -ErrorAction SilentlyContinue | Stop-Process -Force
    Start-Sleep -Seconds 1
    if (-not (Get-Process -Name explorer -ErrorAction SilentlyContinue)) {
        Start-Process explorer.exe
    }
    Write-Host 'Explorer restarted. Right-click should show the full classic menu.'
}
else {
    Write-Host 'Done. Restart Explorer (or re-run with -RestartExplorer) for the menu to update.'
}
