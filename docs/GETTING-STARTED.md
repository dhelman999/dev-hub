# Getting started

## Clean machine

1. Install Git (and optionally GitHub CLI) if you do not already have them.
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

`rebuild -Target All` will:

| Layer | Auto |
|-------|------|
| Dev | winget/scoop packages (incl. Notepad++ under `C:\Programs\Notepad++` when possible), **Cmder** download to `C:\Programs\cmder` if missing, **Hack Nerd Font**, Apply-Cmder configs + Startup shortcut, classic Win11 context menu, PowerShell profile |
| Agent | skills junctions + `AGENTS.md` hardlinks, optional personal skills, Cursor settings/keybindings/rules from `dotfiles\cursor`, soft OpenWhispr check |

5. Optional: clone private personal skills (skip if you do not have access):

```powershell
git clone https://github.com/dhelman999/dev-hub-personal.git C:\Projects\dev-hub-personal
.\machine\rebuild.ps1 -Target Agent -SkipPackages
```

6. Still manual:

- **OpenWhispr** — install yourself; rebuild only detects and points at `agent\OPENWHISPR-SETUP.md`
- **IntelliJ / Toolbox** — install yourself; see [PATHS.md](PATHS.md)
- **Cursor Attribution / Agent Review** — set once in Cursor Settings (not automated)

## Selective apply

```powershell
.\machine\rebuild.ps1 -Target Dev     # machine/terminal only
.\machine\rebuild.ps1 -Target Agent   # AI skills/memory only
.\machine\rebuild.ps1 -Target Dev -SkipPackages   # configs/links only
```

## After editing skills or AGENTS.md

Edit files under `agent\` in this repo, then:

```powershell
.\machine\rebuild.ps1 -Target Agent -SkipPackages
```

Junctions already point here after the first Agent apply, so skill edits are live immediately.
