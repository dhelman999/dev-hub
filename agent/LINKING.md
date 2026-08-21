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

Optional personal skills (when `C:\Projects\dev-hub-personal` exists) are **extra** junctions inside that folder, except skills with `hide-from-catalog: true` (those stay in the personal hub only):

`agent\skills\<name>` → `dev-hub-personal\skills\<name>`

Manual recreate (run from an elevated or Developer Mode shell if needed; junctions usually work without Developer Mode):

```bat
mklink /J "%USERPROFILE%\.cursor\skills" "C:\Projects\dev-hub\agent\skills"
mklink /J "%USERPROFILE%\.claude\skills" "C:\Projects\dev-hub\agent\skills"
mklink /J "%USERPROFILE%\.agents\skills" "C:\Projects\dev-hub\agent\skills"
```

## Memory hard links

Cursor loads `~\AGENTS.md` only. It does not read the overlay file.

| Path | Target |
|------|--------|
| `~\AGENTS.md` | `dev-hub-personal\generated\AGENTS.md` if `agent\AGENTS.overlay.md` exists; else public `dev-hub\agent\AGENTS.md` |
| `~\.claude\CLAUDE.md` | same |
| `~\.claude\AGENTS.md` | same |

`generated\AGENTS.md` is gitignored. Overlay bullets are appended into matching `##` sections at Agent apply (`machine\Merge-AgentsMd.ps1`). Do not edit `~\AGENTS.md` by hand.

True file **symlinks** need Windows Developer Mode. Junctions and hard links do not.
