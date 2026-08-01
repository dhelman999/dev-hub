# Getting started

## Clean machine

1. Install Git (and optionally GitHub CLI).
2. Create roots:
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

5. Optional: clone private personal skills (skip if you do not have access):

```powershell
git clone https://github.com/dhelman999/dev-hub-personal.git C:\Projects\dev-hub-personal
.\machine\rebuild.ps1 -Target Agent -SkipPackages
```

6. Install Cmder under `C:\Programs\cmder` if missing, then:

```powershell
.\machine\Apply-Cmder.ps1
```

7. OpenWhispr / Cursor / IntelliJ: follow [PATHS.md](PATHS.md) and `agent\OPENWHISPR-SETUP.md`.

## Selective apply

```powershell
.\machine\rebuild.ps1 -Target Dev     # machine/terminal only
.\machine\rebuild.ps1 -Target Agent   # AI skills/memory only
```

## After editing skills or AGENTS.md

Edit files under `agent\` in this repo, then:

```powershell
.\machine\rebuild.ps1 -Target Agent -SkipPackages
```

Junctions already point here after the first Agent apply, so skill edits are live immediately.
