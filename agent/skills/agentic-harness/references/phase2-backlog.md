# Phase 2 backlog

Document only for deferred installs — Phase 0–1 items below marked **Live** are in the hub.

| Tool / lane | Status | Why |
|-------------|--------|-----|
| context-engineering (skill) | **Live** | Cost/cache/retrieval playbook |
| captain-crew (skill) | **Live** | Cursor-native Firstmate bridge |
| lavish / lavish-axi | **Live** (Phase 1) | Interactive HTML annotate + agent feedback; `Ensure-Lavish.ps1` |
| quota-axi + usage canvas | Phase 2 — not installed | Local quota/usage visibility |
| treehouse | Phase 3 — not installed | Parallel worktree pool (Windows install exists) |
| no-mistakes (Go binary) | Soft gate skill first | Full git-proxy gate later; Cursor skill: `no-mistakes` |
| firstmate (full distro) | Phase 4 — deferred | Needs non-Cursor harness + mux backends; use `captain-crew` instead |
| gnhf | Phase 4 — deferred | Overnight long-running loops / batch lane |
| WezTerm / tmux / Neovim | Rejected for this machine | Cmder + IntelliJ + Notepad++ instead |
| Claude Design (claude.ai/design) | Optional manual | Design-system studio outside Cursor; not in rebuild |

**Cursor soft gate:** skill `no-mistakes` under `dev-hub/agent/skills/no-mistakes` — default-on before push/PR unless bypassed. Upstream binary docs: that skill’s `references/upstream-tool.md`.

Sources: https://www.youtube.com/watch?v=5N-okeDdIuI · https://www.youtube.com/watch?v=2TgYw9wXv5s · https://www.youtube.com/watch?v=kPN564Kol14 · https://axi.md/ · https://github.com/kunchenguid/lavish-axi
