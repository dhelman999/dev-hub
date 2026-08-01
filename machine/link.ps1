#Requires -Version 5.1
<#
.SYNOPSIS
  Create/repair Agent junctions and hardlinks, and optional Dev config links.
#>
[CmdletBinding()]
param(
    [ValidateSet('Dev', 'Agent', 'All')]
    [string]$Target = 'All',

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

function Ensure-Dir([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

function Set-DirectoryJunction {
    param(
        [Parameter(Mandatory)][string]$LinkPath,
        [Parameter(Mandatory)][string]$TargetPath
    )

    if (-not (Test-Path -LiteralPath $TargetPath)) {
        throw "Junction target missing: $TargetPath"
    }

    if (Test-Path -LiteralPath $LinkPath) {
        $item = Get-Item -LiteralPath $LinkPath -Force
        $isJunction = ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0

        if ($isJunction) {
            $current = $item.Target
            if ($current -is [array]) { $current = $current[0] }

            if ($current -and ((Resolve-Path -LiteralPath $current).Path -eq (Resolve-Path -LiteralPath $TargetPath).Path)) {
                Write-Host "OK junction: $LinkPath"
                return
            }

            Write-Step "Replacing junction: $LinkPath"
            cmd /c "rmdir `"$LinkPath`""
            if ($LASTEXITCODE -ne 0) { throw "Failed to remove junction: $LinkPath" }
        }
        else {
            throw "Refusing to replace non-junction path: $LinkPath"
        }
    }
    else {
        Ensure-Dir (Split-Path -Parent $LinkPath)
    }

    cmd /c "mklink /J `"$LinkPath`" `"$TargetPath`""
    if ($LASTEXITCODE -ne 0) { throw "mklink /J failed for $LinkPath" }
    Write-Host "Created junction: $LinkPath -> $TargetPath"
}

function Set-FileHardLink {
    param(
        [Parameter(Mandatory)][string]$LinkPath,
        [Parameter(Mandatory)][string]$TargetPath
    )

    if (-not (Test-Path -LiteralPath $TargetPath)) {
        throw "Hardlink target missing: $TargetPath"
    }

    Ensure-Dir (Split-Path -Parent $LinkPath)

    if (Test-Path -LiteralPath $LinkPath) {
        Remove-Item -LiteralPath $LinkPath -Force
    }

    New-Item -ItemType HardLink -Path $LinkPath -Target $TargetPath | Out-Null
    Write-Host "Hardlinked: $LinkPath -> $TargetPath"
}

function Link-PersonalSkills {
    param(
        [string]$PublicSkillsDir,
        [string]$PersonalRoot
    )

    if ([string]::IsNullOrWhiteSpace($PersonalRoot)) {
        $PersonalRoot = 'C:\Projects\dev-hub-personal'
    }

    $personalSkills = Join-Path $PersonalRoot 'skills'
    if (-not (Test-Path -LiteralPath $personalSkills)) {
        Write-Host "Personal hub not found at $PersonalRoot (optional) - skipping personal skills"
        return
    }

    Write-Step "Optional personal skills from $PersonalRoot"
    $names = Get-ChildItem -LiteralPath $personalSkills -Directory -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty Name

    if (-not $names) {
        Write-Host 'Personal skills folder is empty'
        return
    }

    foreach ($name in $names) {
        $target = Join-Path $personalSkills $name
        $link = Join-Path $PublicSkillsDir $name
        Set-DirectoryJunction -LinkPath $link -TargetPath $target
    }
}

function Link-Agent {
    $skills = Join-Path $HubRoot 'agent\skills'
    $agentsMd = Join-Path $HubRoot 'agent\AGENTS.md'

    Write-Step 'Agent skills junctions'
    Set-DirectoryJunction -LinkPath (Join-Path $env:USERPROFILE '.cursor\skills') -TargetPath $skills
    Set-DirectoryJunction -LinkPath (Join-Path $env:USERPROFILE '.claude\skills') -TargetPath $skills
    Set-DirectoryJunction -LinkPath (Join-Path $env:USERPROFILE '.agents\skills') -TargetPath $skills

    Link-PersonalSkills -PublicSkillsDir $skills -PersonalRoot $PersonalHubRoot

    Write-Step 'Agent memory hardlinks'
    Ensure-Dir (Join-Path $env:USERPROFILE '.claude')
    Set-FileHardLink -LinkPath (Join-Path $env:USERPROFILE 'AGENTS.md') -TargetPath $agentsMd
    Set-FileHardLink -LinkPath (Join-Path $env:USERPROFILE '.claude\CLAUDE.md') -TargetPath $agentsMd
    Set-FileHardLink -LinkPath (Join-Path $env:USERPROFILE '.claude\AGENTS.md') -TargetPath $agentsMd

    $cursorSettingsSrc = Join-Path $HubRoot 'dotfiles\cursor\settings.json'
    $cursorSettingsDst = Join-Path $env:APPDATA 'Cursor\User\settings.json'

    if (Test-Path -LiteralPath $cursorSettingsSrc) {
        Write-Step 'Cursor settings.json'
        Ensure-Dir (Split-Path -Parent $cursorSettingsDst)

        if (Test-Path -LiteralPath $cursorSettingsDst) {
            $backup = "$cursorSettingsDst.dev-hub-backup"
            if (-not (Test-Path -LiteralPath $backup)) {
                Copy-Item -LiteralPath $cursorSettingsDst -Destination $backup -Force
            }
        }

        Copy-Item -LiteralPath $cursorSettingsSrc -Destination $cursorSettingsDst -Force
        Write-Host "Copied Cursor settings -> $cursorSettingsDst"
    }

    $keySrc = Join-Path $HubRoot 'dotfiles\cursor\keybindings.json'
    $keyDst = Join-Path $env:APPDATA 'Cursor\User\keybindings.json'

    if (Test-Path -LiteralPath $keySrc) {
        Copy-Item -LiteralPath $keySrc -Destination $keyDst -Force
        Write-Host "Copied Cursor keybindings -> $keyDst"
    }

    $rulesSrcDir = Join-Path $HubRoot 'dotfiles\cursor\rules'
    $rulesDstDir = Join-Path $env:USERPROFILE '.cursor\rules'
    if (Test-Path -LiteralPath $rulesSrcDir) {
        Write-Step 'Cursor rules (.mdc)'
        Ensure-Dir $rulesDstDir
        Get-ChildItem -LiteralPath $rulesSrcDir -File -Filter '*.mdc' | ForEach-Object {
            $dst = Join-Path $rulesDstDir $_.Name
            Copy-Item -LiteralPath $_.FullName -Destination $dst -Force
            Write-Host "Copied Cursor rule -> $dst"
        }
    }
}

function Link-Dev {
    Write-Step 'Dev profile links'

    $profileSrc = Join-Path $HubRoot 'dotfiles\powershell\Microsoft.PowerShell_profile.ps1'

    if (Test-Path -LiteralPath $profileSrc) {
        $profileDir = Join-Path $env:USERPROFILE 'Documents\PowerShell'
        Ensure-Dir $profileDir
        $profileDst = Join-Path $profileDir 'Microsoft.PowerShell_profile.ps1'
        Copy-Item -LiteralPath $profileSrc -Destination $profileDst -Force
        Write-Host "Copied PowerShell profile -> $profileDst"
    }
    else {
        Write-Host 'No PowerShell profile in hub (optional)'
    }
}

switch ($Target) {
    'Dev' { Link-Dev }
    'Agent' { Link-Agent }
    'All' {
        Link-Dev
        Link-Agent
    }
}

Write-Step "link.ps1 complete ($Target)"
