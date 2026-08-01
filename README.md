# dev-hub

Reproducible Windows development + agentic engineering hub for [dhelman999](https://github.com/dhelman999).

One public repo, two apply **layers** (plus `All`):

| Target | What it does |
|--------|----------------|
| **Dev** | winget/scoop packages, Cmder install + Clink update + configs, Hack Nerd Font, classic context menu, Startup shortcut, PowerShell profile |
| **Agent** | Skills junctions, `AGENTS.md` hardlinks, optional personal skills, Cursor settings/rules, soft OpenWhispr check |
| **All** | Dev then Agent (default) |

Canonical paths:

- Tools: `C:\Programs\`
- Repos: `C:\Projects\` (this repo: `C:\Projects\dev-hub`)
- Shared AI assets: `C:\Projects\dev-hub\agent\`
- Optional private personal skills: `C:\Projects\dev-hub-personal` (see [docs/PERSONAL-HUB.md](docs/PERSONAL-HUB.md))

## Quick start

```powershell
cd C:\Projects\dev-hub
.\machine\bootstrap.ps1          # creates C:\Programs + C:\Projects; checks winget/scoop
.\machine\rebuild.ps1 -Target All
```

Scoop is optional. Without it, winget apps and Cmder still install; Scoop CLIs in `packages.yaml` (ripgrep, fd, jq, …) are skipped with a warning.

Configs / links only (no winget, scoop, Cmder download, Clink update, or font install):

```powershell
.\machine\rebuild.ps1 -Target All -SkipPackages
```

Optional private skills (if you have access):

```powershell
git clone https://github.com/dhelman999/dev-hub-personal.git C:\Projects\dev-hub-personal
.\machine\rebuild.ps1 -Target Agent -SkipPackages
```

Full clean-machine walkthrough: [docs/GETTING-STARTED.md](docs/GETTING-STARTED.md).

### Cmder

```powershell
.\machine\Capture-Cmder.ps1   # machine -> hub (prefer Cmder closed)
.\machine\Apply-Cmder.ps1     # hub -> machine + Startup shortcut
.\machine\Update-Clink.ps1    # refresh bundled Clink + themes (also via Install-Cmder)
```

Disable auto-start: delete `%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Cmder.lnk`  
or `.\machine\Apply-Cmder.ps1 -SkipAutostart` after removing the shortcut.

## Layout

| Doc | Topic |
|-----|--------|
| [docs/GETTING-STARTED.md](docs/GETTING-STARTED.md) | Clean machine + selective apply |
| [docs/PATHS.md](docs/PATHS.md) | Path conventions and known exceptions |
| [docs/TOOL-MAP.md](docs/TOOL-MAP.md) | Kun / macOS map → this hub |
| [docs/PERSONAL-HUB.md](docs/PERSONAL-HUB.md) | Private `dev-hub-personal` companion |

## Author

David Helman ([dhelman999](https://github.com/dhelman999))
