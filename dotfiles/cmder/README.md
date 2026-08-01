# Cmder (Dev target)

Install root: `C:\Programs\cmder`

## Files in this folder

| File | Purpose |
|------|---------|
| `user-ConEmu.xml` | ConEmu UI settings (2x2 startup, opacity, fonts, hotkeys) |
| `user_aliases.cmd` | Cmd aliases |
| `user_profile.cmd` | Cmd startup |
| `user_profile.ps1` | PowerShell task startup (optional) |

## Capture / apply

```powershell
# Prefer Cmder closed after Settings Export/Save
C:\Projects\dev-hub\machine\Capture-Cmder.ps1
C:\Projects\dev-hub\machine\Apply-Cmder.ps1
```

Apply also creates Startup shortcut:

`%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Cmder.lnk`

## Useful ConEmu hotkeys

- Settings: `Win+Alt+P` · Hotkeys: `Win+Alt+K` · Tasks: `Win+Alt+T`
- Split down/right: `Ctrl+Shift+O` / `Ctrl+Shift+E`
- Pane focus: `Apps`+Arrows (rebind to Alt+Arrows if no Apps key)
- Pane maximize: `Apps`+Enter

## QoL checklist (Phase D)

1. Startup Task = 2x2 grid; task dir `C:\Projects`
2. Opacity fully opaque (your preference)
3. Save settings → Capture into this folder → commit
