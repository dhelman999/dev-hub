# Getting started

## Clean machine

1. Install Git (and optionally [GitHub CLI](https://cli.github.com/)) if you do not already have them.
2. Create roots (or let bootstrap do it):
   - `C:\Programs`
   - `C:\Projects`
3. Clone this repo:

```powershell
git clone https://github.com/dhelman999/dev-hub.git C:\Projects\dev-hub
cd C:\Projects\dev-hub
```

4. Bootstrap and apply:

```powershell
.\machine\bootstrap.ps1
.\machine\rebuild.ps1 -Target All
```

`bootstrap.ps1` creates the roots, checks for winget, and prints an optional Scoop install tip. Scoop is **not** required for Cmder / Cursor / skills.

`rebuild -Target All` (without `-SkipPackages`) will:

| Layer | Auto |
|-------|------|
| Dev | winget packages from `packages.yaml` (Notepad++ prefers `C:\Programs\Notepad++`, often falls back to Program Files); Scoop CLIs if Scoop is installed; **Cmder** to `C:\Programs\cmder` if missing; **Update-Clink** (latest Clink + `themes\`); **Hack Nerd Font**; Apply-Cmder configs + Startup shortcut; classic Win11 context menu; PowerShell 7+ profile copy |
| Agent | skills junctions + `AGENTS.md` hardlinks; optional personal skill junctions; Cursor `settings.json` + `rules\*.mdc` (and `keybindings.json` if present in the hub); soft OpenWhispr check |

5. Optional: clone private personal skills (skip if you do not have access):

```powershell
git clone https://github.com/dhelman999/dev-hub-personal.git C:\Projects\dev-hub-personal
.\machine\rebuild.ps1 -Target Agent -SkipPackages
```

Details: [PERSONAL-HUB.md](PERSONAL-HUB.md).

6. Still manual:

| Item | Notes |
|------|--------|
| **OpenWhispr** | Install yourself; rebuild only detects and points at `agent\OPENWHISPR-SETUP.md` |
| **IntelliJ / Toolbox** | Install yourself; see [PATHS.md](PATHS.md) |
| **Cursor Attribution / Agent Review** | Set once in Cursor Settings (not automated) |
| **Scoop** | Optional; `irm get.scoop.sh \| iex` then re-run Dev without `-SkipPackages` for ripgrep/fd/jq/… |

## Selective apply

```powershell
.\machine\rebuild.ps1 -Target Dev     # machine/terminal (packages + Cmder + font + configs)
.\machine\rebuild.ps1 -Target Agent   # AI skills/memory + Cursor files
.\machine\rebuild.ps1 -Target Dev -SkipPackages   # Apply-Cmder + profile/links only
.\machine\rebuild.ps1 -Target Agent -SkipPackages # junctions/hardlinks/Cursor copy only
```

`-SkipPackages` skips winget, scoop, `Install-Cmder` (and therefore **Update-Clink**), and Hack Nerd Font. To refresh Clink without a full package pass:

```powershell
.\machine\Update-Clink.ps1
```

## Where to edit what

| Change | Edit here | Then |
|--------|-----------|------|
| Public skill or `AGENTS.md` | `dev-hub\agent\` | Usually live via junctions/hardlinks; re-run Agent apply if links were never created |
| Personal / PII skill | `dev-hub-personal\skills\<name>\` | Live via junction; re-run Agent apply only when **adding a new skill folder** |
| Cmder look / aliases | tweak live Cmder, then `Capture-Cmder.ps1` | Commit `dotfiles\cmder` |
| Cursor always-on rules | `dotfiles\cursor\rules\` | `rebuild -Target Agent -SkipPackages` |

## After editing skills or AGENTS.md

Edit under `agent\` in this repo. Junctions already point here after the first Agent apply, so skill body edits are live immediately.

```powershell
.\machine\rebuild.ps1 -Target Agent -SkipPackages   # repair links / re-copy Cursor files
```
