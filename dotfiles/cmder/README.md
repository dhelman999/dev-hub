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
- **Theme:** Rose Pine Moon active (ColorTable + Palette4); also saved: Monokai (Palette1 in XML), Tokyo Night, Dracula (`themes/*.xml`)
- **Font:** Hack Nerd Font, Bold on (`FontName` = `Hack Nerd Font`, `FontBold` = `01`)
- **Login auto-start:** Startup-folder `Cmder.lnk` (created by `Apply-Cmder.ps1`)
- **Aliases:** `proj`, `programs`, `hub`, plus Cmder defaults

### Font install

`machine\Install-HackNerdFont.ps1` runs on Dev rebuild. Manual fallback: Hack.zip from nerd-fonts releases → user Fonts + HKCU Fonts registry, then `Apply-Cmder.ps1`.

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
- **Pane focus:** `Alt`+Arrows (not Win+Arrow - that is Windows Snap)
- **Cycle panes:** `Ctrl+]` next · `Ctrl+[` previous
- Pane maximize: `Apps`+Enter (or rebind under Hotkeys if no Apps key)

`Win`+Arrow is owned by Windows (snap/minimize). ConEmu's Win+Arrow resize is disabled in this config.

## After GUI tweaks

1. Settings → Save / Export (or just Apply)
2. Exit all Cmder windows
3. `Capture-Cmder.ps1` then commit `dotfiles/cmder` in `dev-hub`
