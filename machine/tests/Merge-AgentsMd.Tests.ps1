#Requires -Version 5.1
$ErrorActionPreference = 'Stop'
$failed = 0

function Assert-True {
    param([bool]$Condition, [string]$Message)
    if (-not $Condition) {
        $script:failed++
        Write-Host "FAIL: $Message" -ForegroundColor Red
    }
    else {
        Write-Host "OK: $Message" -ForegroundColor Green
    }
}

. (Join-Path $PSScriptRoot '..\Merge-AgentsMd.ps1')

$public = @"
# Global agent memory

Keep this short.

## Communication

- Prefer dashes.

## How to work with me

- Prefer outcomes.

## Project pointers

- Use skills.
"@

$overlay = @"
# Personal AGENTS overlay

Intro that must not appear in output.

## Communication

- Live pipeline names: Contoso, Fabrikam.

## How to work with me

## Extra section

- Overlay-only heading.
"@

$merged = Merge-AgentsMarkdownText -PublicText $public -OverlayText $overlay -GeneratedComment '<!-- GENERATED: test -->'

Assert-True ($merged.Contains('<!-- GENERATED: test -->')) 'generated comment present'
Assert-True (-not $merged.Contains('Intro that must not appear')) 'overlay preamble omitted'
Assert-True ($merged.Contains('- Prefer dashes.')) 'public Communication kept'
Assert-True ($merged.Contains('- Live pipeline names: Contoso, Fabrikam.')) 'overlay Communication appended'
$commIdx = $merged.IndexOf('- Prefer dashes.')
$pipeIdx = $merged.IndexOf('- Live pipeline names:')
Assert-True ($commIdx -ge 0 -and $pipeIdx -gt $commIdx) 'overlay Communication comes after public bullet'
Assert-True ($merged.Contains('- Prefer outcomes.')) 'empty overlay section is a no-op'
Assert-True (($merged.Split([string[]]@('## How to work with me'), [StringSplitOptions]::None).Count -eq 2)) 'empty overlay does not duplicate heading'
Assert-True ($merged.Contains('## Extra section')) 'unknown overlay heading appended at end'
Assert-True ($merged.Contains('- Overlay-only heading.')) 'unknown overlay body included'
$projIdx = $merged.IndexOf('## Project pointers')
$extraIdx = $merged.IndexOf('## Extra section')
Assert-True ($extraIdx -gt $projIdx) 'unknown overlay heading is after public sections'

$tmp = Join-Path ([IO.Path]::GetTempPath()) ("agents-md-" + [guid]::NewGuid().ToString('n'))
$hub = Join-Path $tmp 'hub'
$personal = Join-Path $tmp 'personal'
New-Item -ItemType Directory -Path (Join-Path $hub 'agent') -Force | Out-Null
[IO.File]::WriteAllText((Join-Path $hub 'agent\AGENTS.md'), "# Public only`n`n## Communication`n`n- Public.`n")

$noOverlay = Resolve-AgentsMdLivePath -HubRoot $hub -PersonalHubRoot $personal
$publicExpected = (Resolve-Path -LiteralPath (Join-Path $hub 'agent\AGENTS.md')).Path
Assert-True ($noOverlay -eq $publicExpected) 'missing overlay returns public path'
Assert-True (-not (Test-Path -LiteralPath (Join-Path $personal 'generated\AGENTS.md'))) 'missing overlay does not write generated'

New-Item -ItemType Directory -Path (Join-Path $personal 'agent') -Force | Out-Null
[IO.File]::WriteAllText((Join-Path $personal 'agent\AGENTS.overlay.md'), "# Overlay`n`n## Communication`n`n- Private.`n")
$withOverlay = Resolve-AgentsMdLivePath -HubRoot $hub -PersonalHubRoot $personal
$gen = (Resolve-Path -LiteralPath (Join-Path $personal 'generated\AGENTS.md')).Path
Assert-True ($withOverlay -eq $gen) 'overlay returns generated path'
$genText = [IO.File]::ReadAllText($gen)
Assert-True ($genText -match 'Private\.') 'generated contains overlay bullet'
Assert-True ($genText -match 'Public\.') 'generated contains public bullet'

Remove-Item -LiteralPath $tmp -Recurse -Force -ErrorAction SilentlyContinue

if ($failed -gt 0) {
    Write-Host "$failed assertion(s) failed" -ForegroundColor Red
    exit 1
}

Write-Host 'Merge-AgentsMd tests passed'
exit 0
