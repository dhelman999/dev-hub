# dev-hub

Reproducible Windows development + agentic engineering hub for [dhelman999](https://github.com/dhelman999).

One repo, two apply targets:

| Target | What it does |
|--------|----------------|
| **Dev** | Packages (incl. Notepad++), Cmder install+configs, Hack Nerd Font, classic context menu, Startup shortcut, PowerShell profile |
| **Agent** | Skills junctions, `AGENTS.md` hardlinks, Cursor settings/rules, soft OpenWhispr check |
| **All** | Dev then Agent (default for this machine) |

Canonical paths:

- Tools: `C:\Programs\`
- Repos: `C:\Projects\` (this repo: `C:\Projects\dev-hub`)
- Shared AI assets: `C:\Projects\dev-hub\agent\`
- Optional private personal skills: `C:\Projects\dev-hub-personal` (see [docs/PERSONAL-HUB.md](docs/PERSONAL-HUB.md))

## Quick start

```powershell
cd C:\Projects\dev-hub
.\machine\bootstrap.ps1
.\machine\rebuild.ps1 -Target All
```

Links only (skip winget/scoop):

```powershell
.\machine\rebuild.ps1 -Target All -SkipPackages
```

Optional private skills (if you have access):

```powershell
git clone https://github.com/dhelman999/dev-hub-personal.git C:\Projects\dev-hub-personal
.\machine\rebuild.ps1 -Target Agent -SkipPackages
```

### Cmder

```powershell
.\machine\Capture-Cmder.ps1   # machine -> hub (prefer Cmder closed)
.\machine\Apply-Cmder.ps1     # hub -> machine + Startup shortcut
```

Disable auto-start: delete `%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Cmder.lnk`  
or `.\machine\Apply-Cmder.ps1 -SkipAutostart` after removing the shortcut.

## Layout

See [docs/GETTING-STARTED.md](docs/GETTING-STARTED.md), [docs/PATHS.md](docs/PATHS.md), [docs/TOOL-MAP.md](docs/TOOL-MAP.md), [docs/PERSONAL-HUB.md](docs/PERSONAL-HUB.md).

## Author

David Helman ([dhelman999](https://github.com/dhelman999))
