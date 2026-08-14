---
name: agentic-harness
description: >-
  David Helman's agentic engineering hub on Windows: C:\Projects\dev-hub layout,
  Dev/Agent rebuild targets, shared AGENTS.md memory, OpenWhispr voice, npx skills
  install policy, reproducibility (hub + scripts for wipe/regenerate), context-engineering /
  captain-crew skills, and Phase 2+ backlog (lavish, quota-axi/usage-canvas, treehouse live;
  firstmate, gnhf, Go no-mistakes deferred). Use when the user asks about agent setup, skills folders,
  junctions/symlinks, global memory, voice dictation, installing skills, Cmder hub
  configs, regenerating the environment, or the L8/Kun-style harness — even if they
  only say "where are my skills" or "how do I add a skill." Prefer this over inventing
  a new skills layout.
---

# Agentic Harness (dev-hub)

Canonical hub: `C:\Projects\dev-hub\`

- **Dev target** — machine/terminal (`dotfiles\`, `machine\`, Cmder, packages)
- **Agent target** — AI skills/memory (`agent\`)

Captain + crew model (Kun Chen L8 workflow), adapted for Windows + Cursor. Details live in references — load only what the question needs.

## When to load references

| Question | Read |
|----------|------|
| Paths, junctions, hard links, Developer Mode | `references/layout-and-linking.md` |
| OpenWhispr install / hotkey / local models | `references/voice-openwhispr.md` |
| npx skills commands, security policy, hub skill list | `references/skills-policy.md` |
| Phase 2+ backlog (lavish, quota, treehouse, firstmate, …) | `references/phase2-backlog.md` |
| Cursor usage / quota canvas | Skill `usage-canvas` (`/usage`) |
| Parallel worktree leases | Skill `captain-crew` → `references/treehouse-lease.md` |
| Cost / cache / retrieval / model phases | Skill `context-engineering` |
| Parallel agents / Firstmate-on-Cursor | Skill `captain-crew` |
| Pre-ship soft gate (Cursor) | Skill `no-mistakes` |
| Production planning (opt-in PRD/spec/tickets) | Skills `production-planning`, `prd`, `spec`, `slice-tickets`, `prime`, `validation-tdd` (`/production-planning`) |
| Deletes / wipes / force-push | Skill `destructive-actions` |
| Reproducible hub / regenerate checklist | `references/reproducibility.md` |
| GitHub account, clone/commit/push habits | `references/github-dhelman999.md` |
| Public README / description conventions | `references/github-public-polish.md` |

## Memory vs skills (why it matters)

- **AGENTS.md** — tiny always-on prefs (loaded every session). Keep it short to save tokens.
- **Skills** — progressive disclosure: description always visible; body only when triggered.
- After a repeatable agent mistake: update **project** `AGENTS.md` or extract a skill with `skill-creator`.

## Path conventions (agents must follow)

1. Dev tools → `C:\Programs\<tool>` when installer allows.
2. Repos → `C:\Projects\<name>`.
3. Hub edits → `C:\Projects\dev-hub` (not the deprecated `~\agent-hub` folder).
4. Personal / PII skills → `C:\Projects\dev-hub-personal` only (optional; may be absent).
5. Exceptions → `docs\PATHS.md` in the hub.

## Privacy

Never commit passwords, tokens, claim IDs, financials, medical data, or home/vehicle PII into public `dev-hub`. See `docs\PERSONAL-HUB.md`.

## Reproducibility (hard rule)

Any change to the machine/agent harness must be hub-backed so `bootstrap` / `rebuild` can regenerate it. Checklist: `references/reproducibility.md`.

## Quick facts

- Apply: `C:\Projects\dev-hub\machine\rebuild.ps1 -Target Dev|Agent|All` (see `docs\GETTING-STARTED.md`)
- Personal PII skills: optional `C:\Projects\dev-hub-personal` → per-skill junctions into `agent\skills` (`docs\PERSONAL-HUB.md`)
- Skills junctions: `~\.cursor\skills`, `~\.claude\skills`, `~\.agents\skills` → `dev-hub\agent\skills`
- Memory: `dev-hub\agent\AGENTS.md` hard-linked as `~\AGENTS.md` and `~\.claude\CLAUDE.md`
- Cursor rules: `dotfiles\cursor\rules\*.mdc` → `~\.cursor\rules\` on Agent apply
- Voice: OpenWhispr soft-checked (manual install if missing); checklist in `agent\OPENWHISPR-SETUP.md`
- Terminal: Cmder via `Install-Cmder.ps1` + configs in `dotfiles\cmder`; `Update-Clink.ps1` on that path (not on `-SkipPackages`); Hack Nerd Font + classic context menu on Dev apply
- Do **not** `npx skills add … --all` or install unevaluated “magic” skill packs

## External links

- Video (from scratch): https://www.youtube.com/watch?v=5N-okeDdIuI
- Workflow writeup: https://blog.bytebytego.com/p/an-ex-meta-l8s-agentic-engineering
- Skills CLI: https://github.com/vercel-labs/skills
- AXI: https://axi.md/
