# Layout and linking

```
C:\Projects\dev-hub\
  agent\
    AGENTS.md              # slim global memory (canonical)
    skills\                # all personal + installed skills
    OPENWHISPR-SETUP.md
    LINKING.md
  machine\                 # bootstrap / rebuild / link / Cmder helpers
  dotfiles\                # cmder, cursor, powershell, intellij
  docs\
```

## Skills junctions

| Path | Target |
|------|--------|
| `~\.cursor\skills` | `C:\Projects\dev-hub\agent\skills` |
| `~\.claude\skills` | same |
| `~\.agents\skills` | same |

Recreate with `mklink /J <link> C:\Projects\dev-hub\agent\skills` or:

```powershell
C:\Projects\dev-hub\machine\rebuild.ps1 -Target Agent -SkipPackages
```

## Memory hard links

| Path | Target |
|------|--------|
| `~\AGENTS.md` | `dev-hub\agent\AGENTS.md` |
| `~\.claude\CLAUDE.md` | same |
| `~\.claude\AGENTS.md` | same |

True file symlinks need Windows Developer Mode. See `C:\Projects\dev-hub\agent\LINKING.md`.
