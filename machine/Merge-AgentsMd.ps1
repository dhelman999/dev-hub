#Requires -Version 5.1
<#
.SYNOPSIS
  Compose ~/AGENTS.md from public template + optional personal overlay.

  Overlay bullets are appended at the end of matching ## sections.
  Unknown overlay headings become new sections at the end.
  If the overlay file is missing, returns the public AGENTS.md path (no generate).

  Dot-source this script from link.ps1, or run it to print the live path.
#>

function Get-TrimmedLineList {
    param([AllowNull()][System.Collections.IList]$Lines)

    if ($null -eq $Lines -or $Lines.Count -eq 0) {
        return @()
    }

    $arr = @($Lines)
    $start = 0
    $end = $arr.Count - 1
    while ($start -le $end -and [string]::IsNullOrWhiteSpace([string]$arr[$start])) { $start++ }
    while ($end -ge $start -and [string]::IsNullOrWhiteSpace([string]$arr[$end])) { $end-- }
    if ($start -gt $end) { return @() }
    return @($arr[$start..$end])
}

function Test-MarkdownSectionHasContent {
    param([AllowNull()][System.Collections.IList]$Lines)

    foreach ($line in @($Lines)) {
        if (-not [string]::IsNullOrWhiteSpace([string]$line)) {
            return $true
        }
    }
    return $false
}

function ConvertTo-AgentsSectionMap {
    param([Parameter(Mandatory)][string]$Text)

    $preamble = New-Object System.Collections.Generic.List[string]
    $order = New-Object System.Collections.Generic.List[string]
    $map = @{}
    $current = $null

    foreach ($line in ($Text -split '\r?\n', -1)) {
        if ($line -match '^## (.+)$') {
            $current = $Matches[1].TrimEnd()
            if (-not $map.ContainsKey($current)) {
                $order.Add($current)
                $map[$current] = New-Object System.Collections.Generic.List[string]
            }
            continue
        }

        if ($null -eq $current) {
            $preamble.Add($line)
        }
        else {
            $map[$current].Add($line)
        }
    }

    return [pscustomobject]@{
        Preamble = $preamble
        Order    = $order
        Map      = $map
    }
}

function Merge-AgentsMarkdownText {
    param(
        [Parameter(Mandatory)][string]$PublicText,
        [Parameter(Mandatory)][string]$OverlayText,
        [string]$GeneratedComment
    )

    $public = ConvertTo-AgentsSectionMap -Text $PublicText
    $overlay = ConvertTo-AgentsSectionMap -Text $OverlayText

    $preamble = Get-TrimmedLineList -Lines $public.Preamble
    $preamble = @($preamble | Where-Object { $_ -notmatch '^\s*<!--\s*GENERATED:' })

    $sb = New-Object System.Text.StringBuilder
    if (-not [string]::IsNullOrWhiteSpace($GeneratedComment)) {
        [void]$sb.AppendLine($GeneratedComment.TrimEnd())
        [void]$sb.AppendLine()
    }

    foreach ($line in $preamble) {
        [void]$sb.AppendLine($line)
    }
    if ($preamble.Count -gt 0) {
        [void]$sb.AppendLine()
    }

    $seen = New-Object 'System.Collections.Generic.HashSet[string]'
    foreach ($heading in $public.Order) {
        [void]$seen.Add($heading)
        [void]$sb.AppendLine("## $heading")
        [void]$sb.AppendLine()
        $body = Get-TrimmedLineList -Lines $public.Map[$heading]
        foreach ($line in $body) {
            [void]$sb.AppendLine($line)
        }

        if ($overlay.Map.ContainsKey($heading) -and (Test-MarkdownSectionHasContent -Lines $overlay.Map[$heading])) {
            $extra = Get-TrimmedLineList -Lines $overlay.Map[$heading]
            if ($body.Count -gt 0) {
                [void]$sb.AppendLine()
            }
            foreach ($line in $extra) {
                [void]$sb.AppendLine($line)
            }
        }

        [void]$sb.AppendLine()
    }

    foreach ($heading in $overlay.Order) {
        if ($seen.Contains($heading)) { continue }
        if (-not (Test-MarkdownSectionHasContent -Lines $overlay.Map[$heading])) { continue }

        [void]$sb.AppendLine("## $heading")
        [void]$sb.AppendLine()
        foreach ($line in (Get-TrimmedLineList -Lines $overlay.Map[$heading])) {
            [void]$sb.AppendLine($line)
        }
        [void]$sb.AppendLine()
    }

    return $sb.ToString().TrimEnd() + "`n"
}

function Resolve-AgentsMdLivePath {
    param(
        [Parameter(Mandatory)][string]$HubRoot,
        [string]$PersonalHubRoot = 'C:\Projects\dev-hub-personal'
    )

    $publicPath = Join-Path $HubRoot 'agent\AGENTS.md'
    if (-not (Test-Path -LiteralPath $publicPath)) {
        throw "Public AGENTS.md missing: $publicPath"
    }

    $overlayPath = Join-Path $PersonalHubRoot 'agent\AGENTS.overlay.md'
    if (-not (Test-Path -LiteralPath $overlayPath)) {
        Write-Host "No personal AGENTS overlay at $overlayPath - linking public AGENTS.md"
        return (Resolve-Path -LiteralPath $publicPath).Path
    }

    $generatedDir = Join-Path $PersonalHubRoot 'generated'
    if (-not (Test-Path -LiteralPath $generatedDir)) {
        New-Item -ItemType Directory -Path $generatedDir -Force | Out-Null
    }

    $generatedPath = Join-Path $generatedDir 'AGENTS.md'
    $publicText = [IO.File]::ReadAllText($publicPath)
    $overlayText = [IO.File]::ReadAllText($overlayPath)
    $comment = "<!-- GENERATED: do not edit. Public: $publicPath  Overlay: $overlayPath  Apply: .\machine\rebuild.ps1 -Target Agent -SkipPackages -->"
    $merged = Merge-AgentsMarkdownText -PublicText $publicText -OverlayText $overlayText -GeneratedComment $comment
    [IO.File]::WriteAllText($generatedPath, $merged)
    Write-Host "Composed AGENTS.md -> $generatedPath"
    return (Resolve-Path -LiteralPath $generatedPath).Path
}

if ($MyInvocation.InvocationName -ne '.') {
    $scriptHub = Split-Path -Parent $PSScriptRoot
    if ([string]::IsNullOrWhiteSpace($scriptHub)) {
        $scriptHub = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
    }
    Resolve-AgentsMdLivePath -HubRoot $scriptHub
}
