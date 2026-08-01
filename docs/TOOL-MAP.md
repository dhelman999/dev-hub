# Kun Chen tool map → Windows (dev-hub)

Source video: https://www.youtube.com/watch?v=5N-okeDdIuI  
Dotfiles: https://github.com/kunchenguid/dotfiles  
Workflow writeup: https://blog.bytebytego.com/p/an-ex-meta-l8s-agentic-engineering

## Machine layer

| Kun (macOS) | This hub |
|-------------|----------|
| Nix + nix-darwin + Home Manager | `machine\*.ps1` + `packages.yaml` (winget/Scoop) |
| Homebrew | winget (apps) + Scoop (CLIs) |
| WezTerm | Cmder at `C:\Programs\cmder` |
| zsh + Starship | PowerShell (+ optional Starship) |
| Neovim | IntelliJ (dev) + Notepad++ (text); Cursor = AI UI |
| Shared AGENTS.md / skills symlinks | `agent\` + junctions/hardlinks via `link.ps1` |

## Workflow layer (Phase 2 backlog — not installed yet)

Lavish, gnhf, treehouse, firstmate, Go `no-mistakes` binary — see `agent\skills\agentic-harness\references\phase2-backlog.md`.

Out of scope for this machine: tmux, WezTerm, Neovim.

## Voice

Kun: OpenSuperWhisper. You: OpenWhispr Windows (`agent\OPENWHISPR-SETUP.md`).
