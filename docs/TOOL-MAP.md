# Kun Chen tool map → Windows (dev-hub)

Source videos:

- Harness from scratch: https://www.youtube.com/watch?v=5N-okeDdIuI
- Cost / context engineering themes: https://www.youtube.com/watch?v=2TgYw9wXv5s
- Full-stack agent workflow: https://www.youtube.com/watch?v=kPN564Kol14
- Kun linktree: https://linktr.ee/kunchenguid · GitHub: https://github.com/kunchenguid

Dotfiles inspiration: https://github.com/kunchenguid/dotfiles  
Workflow writeup: https://blog.bytebytego.com/p/an-ex-meta-l8s-agentic-engineering

## Machine layer

| Kun (macOS) | This hub |
|-------------|----------|
| Nix + nix-darwin + Home Manager | `machine\*.ps1` + `packages.yaml` (winget/Scoop) |
| Homebrew | winget (apps) + Scoop (CLIs) |
| WezTerm | Cmder at `C:\Programs\cmder` (+ `Update-Clink.ps1` for bundled Clink) |
| zsh + Starship | PowerShell 7+ profile (+ optional Scoop Starship) |
| Neovim | IntelliJ (dev) + Notepad++ (text); Cursor = AI UI |
| Shared AGENTS.md / skills symlinks | `agent\` + junctions/hardlinks via `link.ps1` |

## Workflow layer

| Kun | This hub |
|-----|----------|
| Context / cost discipline | Skill `context-engineering` (**live**) |
| firstmate (captain + crew) | Skill `captain-crew` on Cursor (**live**); full Firstmate distro deferred |
| lavish-axi | Skill `lavish` + `Ensure-Lavish.ps1` (**live**); runtime `npx -y lavish-axi` |
| quota-axi / usage UI | Phase 2 — not installed yet |
| treehouse | Phase 3 — not installed yet |
| no-mistakes | Soft gate skill **live**; Go binary deferred |
| gnhf | Phase 4 — deferred |
| AXI principles | https://axi.md — adopt with tools in later phases |
| Claude Design | Optional manual lane (not in rebuild) |

Details: `agent\skills\agentic-harness\references\phase2-backlog.md`.

Out of scope for this machine: tmux, WezTerm, Neovim.

## Voice

Kun: OpenSuperWhisper. You: OpenWhispr Windows (`agent\OPENWHISPR-SETUP.md`).
