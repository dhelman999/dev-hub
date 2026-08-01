# Linking notes (dev-hub agent layer)

Canonical root: `C:\Projects\dev-hub\agent`

Prefer: `.\machine\rebuild.ps1 -Target Agent -SkipPackages` (or `-Target All`).

## Skills directories (junctions)

| Path | Target |
|------|--------|
| `~\.cursor\skills` | `C:\Projects\dev-hub\agent\skills` |
| `~\.claude\skills` | same |
| `~\.agents\skills` | same |

Manual recreate:

```bat
mklink /J C:\Users\dhelm\.cursor\skills C:\Projects\dev-hub\agent\skills
mklink /J C:\Users\dhelm\.claude\skills C:\Projects\dev-hub\agent\skills
mklink /J C:\Users\dhelm\.agents\skills C:\Projects\dev-hub\agent\skills
```

## Memory hard links

| Path | Target |
|------|--------|
| `~\AGENTS.md` | `C:\Projects\dev-hub\agent\AGENTS.md` |
| `~\.claude\CLAUDE.md` | same |
| `~\.claude\AGENTS.md` | same |

```powershell
New-Item -ItemType HardLink -Path "$env:USERPROFILE\AGENTS.md" -Target "C:\Projects\dev-hub\agent\AGENTS.md"
New-Item -ItemType HardLink -Path "$env:USERPROFILE\.claude\CLAUDE.md" -Target "C:\Projects\dev-hub\agent\AGENTS.md"
New-Item -ItemType HardLink -Path "$env:USERPROFILE\.claude\AGENTS.md" -Target "C:\Projects\dev-hub\agent\AGENTS.md"
```

True file symlinks need Windows Developer Mode. Junctions and hard links do not.
