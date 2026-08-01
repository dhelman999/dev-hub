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

| Tool | Actual path | Why |
|------|-------------|-----|
| Cmder | `C:\Programs\cmder` | Portable under Programs (preferred) |
| OpenWhispr | `%LOCALAPPDATA%\Programs\OpenWhispr\OpenWhispr.exe` | Electron / vendor installer |
| Cursor | Typical user install under Local AppData / Program Files | Vendor installer |
| IntelliJ / Toolbox | Often Program Files or Toolbox-managed paths | JetBrains layout |
| Notepad++ | Prefer `C:\Programs\Notepad++` if custom path offered | Otherwise Program Files |

## AI link targets (after Agent apply)

| Consumer | Points at |
|----------|-----------|
| `~\.cursor\skills` | `C:\Projects\dev-hub\agent\skills` |
| `~\.claude\skills` | same |
| `~\.agents\skills` | same |
| `~\AGENTS.md` | `C:\Projects\dev-hub\agent\AGENTS.md` (hardlink) |
| `~\.claude\CLAUDE.md` | same hardlink |
| `~\.claude\AGENTS.md` | same hardlink |

## Deprecated

`C:\Users\dhelm\agent-hub` — superseded by `C:\Projects\dev-hub\agent`. Stub README only after migration.
