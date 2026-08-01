# Linking notes (dev-hub agent layer)

Canonical root: `C:\Projects\dev-hub\agent`

Prefer:

```powershell
.\machine\rebuild.ps1 -Target Agent -SkipPackages
```

(or `-Target All`). Manual commands below are only for repair when scripts are unavailable.

## Skills directories (junctions)

| Path | Target |
|------|--------|
| `~\.cursor\skills` | `C:\Projects\dev-hub\agent\skills` |
| `~\.claude\skills` | same |
| `~\.agents\skills` | same |

Optional personal skills (when `C:\Projects\dev-hub-personal` exists) are **extra** junctions inside that folder:

`agent\skills\<name>` → `dev-hub-personal\skills\<name>`

Manual recreate (run from an elevated or Developer Mode shell if needed; junctions usually work without Developer Mode):

```bat
mklink /J "%USERPROFILE%\.cursor\skills" "C:\Projects\dev-hub\agent\skills"
mklink /J "%USERPROFILE%\.claude\skills" "C:\Projects\dev-hub\agent\skills"
mklink /J "%USERPROFILE%\.agents\skills" "C:\Projects\dev-hub\agent\skills"
```

## Memory hard links

| Path | Target |
|------|--------|
| `~\AGENTS.md` | `C:\Projects\dev-hub\agent\AGENTS.md` |
| `~\.claude\CLAUDE.md` | same |
| `~\.claude\AGENTS.md` | same |

```powershell
$src = 'C:\Projects\dev-hub\agent\AGENTS.md'
New-Item -ItemType HardLink -Path "$env:USERPROFILE\AGENTS.md" -Target $src -Force
New-Item -ItemType Directory -Path "$env:USERPROFILE\.claude" -Force | Out-Null
New-Item -ItemType HardLink -Path "$env:USERPROFILE\.claude\CLAUDE.md" -Target $src -Force
New-Item -ItemType HardLink -Path "$env:USERPROFILE\.claude\AGENTS.md" -Target $src -Force
```

True file **symlinks** need Windows Developer Mode. Junctions and hard links do not.
