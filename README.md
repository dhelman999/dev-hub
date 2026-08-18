# dev-hub

Reproducible Windows development + agentic engineering hub.

One public repo, two apply **layers** (plus `All`):

| Target | Harness | What it does |
|--------|---------|----------------|
| **Dev** | Machine / terminal | winget/scoop packages, Cmder install + Clink update + configs, Hack Nerd Font, classic context menu, Startup shortcut, PowerShell profile |
| **Agent** | AI playbooks | Skills junctions, `AGENTS.md` hardlinks, optional personal skills, Cursor settings/rules/commands, soft OpenWhispr check |
| **All** | Both | Dev then Agent (default) |

**Dev harness** regenerates this Windows machine from scripts (`C:\Programs` tools, `C:\Projects` repos, Cmder, packages). Wipe and `rebuild` should get you back.

**Agent harness** is not a second IDE and not Kun Firstmate’s tmux distro. It is the skill + memory layer so Cursor (and Claude Code, if linked) follow the same playbooks: default **solo** Plan or Agent → implement → **no-mistakes** before push. Parallel work uses **captain-crew** on Cursor. PRD / spec / tickets (`/production-planning`) are **opt-in**, not the default. High-risk claims use **grounding** (look up or state the assumption).

Live playbooks sit under `agent\skills\`. Catalog: `/skills` in Cursor, or [docs/GETTING-STARTED.md](docs/GETTING-STARTED.md) “Where to edit what”. Kun/macOS map: [docs/TOOL-MAP.md](docs/TOOL-MAP.md). Deferred: full Firstmate, overnight `gnhf`, Go `no-mistakes` binary.

Canonical paths:

- Tools: `C:\Programs\`
- Repos: `C:\Projects\` (this repo: `C:\Projects\dev-hub`)
- Shared AI assets: `C:\Projects\dev-hub\agent\`
- Optional private personal skills: `C:\Projects\dev-hub-personal` (see [docs/PERSONAL-HUB.md](docs/PERSONAL-HUB.md))

## Quick start

```powershell
cd C:\Projects\dev-hub
.\machine\bootstrap.ps1          # creates C:\Programs + C:\Projects; checks winget/scoop
.\machine\rebuild.ps1 -Target All
```

Scoop is optional. Without it, winget apps and Cmder still install; Scoop CLIs in `packages.yaml` (ripgrep, fd, jq, …) are skipped with a warning.

Configs / links only (no winget, scoop, Cmder download, Clink update, or font install):

```powershell
.\machine\rebuild.ps1 -Target All -SkipPackages
```

Optional private skills (if you have access):

```powershell
git clone https://github.com/dhelman999/dev-hub-personal.git C:\Projects\dev-hub-personal
.\machine\rebuild.ps1 -Target Agent -SkipPackages
```

Full clean-machine walkthrough: [docs/GETTING-STARTED.md](docs/GETTING-STARTED.md).

### Cmder

```powershell
.\machine\Capture-Cmder.ps1   # machine -> hub (prefer Cmder closed)
.\machine\Apply-Cmder.ps1     # hub -> machine + Startup shortcut
.\machine\Update-Clink.ps1    # refresh bundled Clink + themes (also via Install-Cmder)
```

Disable auto-start: delete `%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Cmder.lnk`  
or `.\machine\Apply-Cmder.ps1 -SkipAutostart` after removing the shortcut.

## Layout

| Doc | Topic |
|-----|--------|
| [docs/GETTING-STARTED.md](docs/GETTING-STARTED.md) | Clean machine + selective apply |
| [docs/PATHS.md](docs/PATHS.md) | Path conventions and known exceptions |
| [docs/TOOL-MAP.md](docs/TOOL-MAP.md) | Kun / macOS map → this hub |
| [docs/PERSONAL-HUB.md](docs/PERSONAL-HUB.md) | Private `dev-hub-personal` companion |
| [docs/diagrams/](docs/diagrams/README.md) | Harness Excalidraw (two-loop, no-mistakes gate) |

## Credits

This hub is a Windows + Cursor port of [Kun Chen](https://github.com/kunchenguid)’s agentic-engineering setup, not a fork of his macOS/Nix tree.

**We run his tools (npx / installer, not reimplemented):**

| Tool | Upstream |
|------|----------|
| Lavish (HTML annotate review) | [kunchenguid/lavish-axi](https://github.com/kunchenguid/lavish-axi) (`npx -y lavish-axi`) |
| Quota meters | [kunchenguid/quota-axi](https://github.com/kunchenguid/quota-axi) |
| Worktree leases | [kunchenguid/treehouse](https://github.com/kunchenguid/treehouse) |

**We adapted the ideas; the Cursor playbooks here are ours:**

| Idea | His artifact | This hub |
|------|----------------|----------|
| Captain + crew | [kunchenguid/firstmate](https://github.com/kunchenguid/firstmate) | Skill `captain-crew` (tmux Firstmate not installed) |
| Pre-ship gate | [kunchenguid/no-mistakes](https://github.com/kunchenguid/no-mistakes) | Cursor skill `no-mistakes` (Go git-proxy not installed) |
| Skills + always-on memory | [dotfiles](https://github.com/kunchenguid/dotfiles), [AXI](https://axi.md/) | `agent\skills`, `AGENTS.md`, `rebuild.ps1` |

Talks that shaped the layout: [harness from scratch](https://www.youtube.com/watch?v=5N-okeDdIuI), [context engineering](https://www.youtube.com/watch?v=2TgYw9wXv5s), [full-stack agent workflow](https://www.youtube.com/watch?v=kPN564Kol14), [ByteByteGo writeup](https://blog.bytebytego.com/p/an-ex-meta-l8s-agentic-engineering). Line-by-line Windows map: [docs/TOOL-MAP.md](docs/TOOL-MAP.md).

Hub-original playbooks (not from Kun): `grounding`, opt-in `production-planning` / PRD / spec / tickets, `stack-context`.

## Author

David Helman ([dhelman999](https://github.com/dhelman999))
