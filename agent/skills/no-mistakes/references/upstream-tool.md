# Upstream no-mistakes (Go binary) — later

Kun Chen’s full tool: [kunchenguid/no-mistakes](https://github.com/kunchenguid/no-mistakes)

Docs: https://kunchenguid.github.io/no-mistakes/

## What it is

A **local git proxy**: `git push no-mistakes` instead of `origin`. It uses a
disposable worktree and an AI pipeline (review → test → docs → lint → push →
PR → CI). Agents drive it via `no-mistakes axi …` (TOON output). Official skill:
`skills/no-mistakes/SKILL.md` in that repo.

## Why not installed yet

- Needs a configured pipeline agent (`claude`, `codex`, `opencode`, etc.)
- Phase 2 backlog item; Cursor soft gate covers the discipline without the daemon

## When ready to install

1. Follow Windows install in their docs: https://kunchenguid.github.io/no-mistakes/start-here/installation/
2. Per repo: `no-mistakes init`
3. Prefer their official skill for `axi` commands over reinventing them here
4. Keep this soft-gate skill as the Cursor fallback when the binary is unavailable

Tracked in `agentic-harness` → `references/phase2-backlog.md`.
