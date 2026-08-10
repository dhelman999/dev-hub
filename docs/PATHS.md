# Path conventions

## Canonical roots

| Path | Purpose |
|------|---------|
| `C:\Programs` | User/custom **dev tools** and portable apps (not games; not forced OS installs) |
| `C:\Projects` | All **git clones / project repos** |
| `C:\Projects\dev-hub` | Public hub (machine + shared agent layers) |
| `C:\Projects\dev-hub-personal` | Optional **private** personal skills (PII); may be absent |

## Rules for agents

1. New developer tools → install under `C:\Programs\<tool>` when the installer allows a custom path.
2. New repos / clones → always under `C:\Projects\<name>`.
3. Never park tools or repos on Desktop, Documents, or bare home root.

## Known exceptions (document when installing)

| Tool | Actual / preferred path | Why |
|------|-------------------------|-----|
| Cmder | `C:\Programs\cmder` via `Install-Cmder.ps1` | Portable full zip from GitHub releases |
| Hack Nerd Font | `%LOCALAPPDATA%\Microsoft\Windows\Fonts` | `Install-HackNerdFont.ps1` |
| Notepad++ | Prefer `C:\Programs\Notepad++` (`winget --location`); often `C:\Program Files\Notepad++` | winget may ignore `--location` |
| OpenWhispr | `%LOCALAPPDATA%\Programs\OpenWhispr\OpenWhispr.exe` | Electron / vendor installer |
| Lavish CLI | `npx -y lavish-axi` (Node) | Soft-checked by `Ensure-Lavish.ps1`; skill in `agent\skills\lavish` |
| quota-axi | `npx -y quota-axi` (Node) | Soft-checked by `Ensure-QuotaAxi.ps1`; skill `usage-canvas` |
| sqlite3 | WinGet `SQLite.SQLite` | Required for Cursor quota via quota-axi |
| treehouse | `%LOCALAPPDATA%\treehouse\treehouse.exe` | Soft-installed by `Ensure-Treehouse.ps1`; pool under `~\.treehouse\` |
| Cursor | Typical user install under Local AppData / Program Files | Vendor installer |
| IntelliJ / Toolbox | Often Program Files or Toolbox-managed paths | JetBrains layout |

## AI link targets (after Agent apply)

| Consumer | Points at |
|----------|-----------|
| `~\.cursor\skills` | `C:\Projects\dev-hub\agent\skills` (directory junction) |
| `~\.claude\skills` | same |
| `~\.agents\skills` | same |
| `~\AGENTS.md` | `C:\Projects\dev-hub\agent\AGENTS.md` (hardlink) |
| `~\.claude\CLAUDE.md` | same hardlink |
| `~\.claude\AGENTS.md` | same hardlink |
| `~\.cursor\rules\*.mdc` | copied from `dotfiles\cursor\rules\` |

When `dev-hub-personal` is present, each personal skill is an **extra** junction:

`dev-hub\agent\skills\<name>` → `dev-hub-personal\skills\<name>`

Those names therefore appear under `~\.cursor\skills\` via the skills-folder junction. They must not be committed into the public `dev-hub` git tree (junctions/reparse points are local).

## Windows QoL

| Item | Notes |
|------|-------|
| Classic full right-click menu | Applied automatically on Dev rebuild (`Enable-ClassicContextMenu.ps1`). Re-run with `-RestartExplorer` if Explorer still shows the compact menu. |

## Deprecated

`~\agent-hub` — superseded by `C:\Projects\dev-hub\agent`. Safe to ignore or delete after confirming skills/memory live under `dev-hub`.
