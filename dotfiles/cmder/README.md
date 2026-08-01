# Cmder (Dev target)

Install root: `C:\Programs\cmder`

## Files in this folder

| File | Purpose |
|------|---------|
| `user-ConEmu.xml` | ConEmu UI settings (startup task, opacity, fonts, hotkeys) |
| `user_aliases.cmd` | Cmd aliases (`proj`, `programs`, `hub`, …) |
| `user_profile.cmd` | Cmd startup |
| `user_profile.ps1` | PowerShell task startup |

## Saved defaults (Phase D)

- **Startup task:** `{Shells::Projects 2x2}` - four Cmder consoles in a 2x2 grid
- **Working directory:** `C:\Projects` (task GuiArgs `/dir`)
- **Opacity:** fully opaque (`AlphaValue` / `AlphaValueInactive` = `FF`)
- **Login auto-start:** Startup-folder `Cmder.lnk` (created by `Apply-Cmder.ps1`)
- **Aliases:** `proj`, `programs`, `hub`, plus Cmder defaults

## Capture / apply

Prefer Cmder **closed** after Settings Export/Save in the GUI.

```powershell
C:\Projects\dev-hub\machine\Capture-Cmder.ps1   # machine -> hub
C:\Projects\dev-hub\machine\Apply-Cmder.ps1     # hub -> machine + Startup shortcut
# or
C:\Projects\dev-hub\machine\rebuild.ps1 -Target Dev -SkipPackages
```

Disable auto-start: delete `%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Cmder.lnk`

## Useful ConEmu hotkeys

- Settings: `Win+Alt+P` · Hotkeys: `Win+Alt+K` · Tasks: `Win+Alt+T`
- Split down/right: `Ctrl+Shift+O` / `Ctrl+Shift+E`
- Pane focus: `Apps`+Arrows (rebind to Alt+Arrows if no Apps key)
- Pane maximize: `Apps`+Enter

## After GUI tweaks

1. Settings → Save / Export (or just Apply)
2. Exit all Cmder windows
3. `Capture-Cmder.ps1` then commit `dotfiles/cmder` in `dev-hub`
