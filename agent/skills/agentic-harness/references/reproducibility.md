# Reproducibility checklist

Whenever something changes the **dev environment**, **agent harness**, or **agentic engineering** workflow, ask: *can a wipe + `bootstrap` / `rebuild` recreate this on another machine?*

If not, fix that in the same task (or the same PR series).

## Land in the hub

| Kind of change | Put it here |
|----------------|-------------|
| Skills / global memory | `agent\skills\`, `agent\AGENTS.md` |
| Cursor rules / slash commands / settings templates | `dotfiles\cursor\` |
| Cmder / PowerShell / IntelliJ notes | `dotfiles\` |
| Install / ensure / link / rebuild | `machine\*.ps1`, `machine\packages.yaml` |
| Paths / setup docs | `docs\` |
| PII / personal skills only | `C:\Projects\dev-hub-personal` (never public `dev-hub`) |

## Wire apply paths

- Agent layer: `rebuild.ps1 -Target Agent` → `link.ps1` (junctions, hardlinks, rules, commands, Cursor settings).
- Dev layer: `rebuild.ps1 -Target Dev` → packages, Cmder, fonts, profile, etc.
- New tools: `Ensure-*.ps1` and/or `packages.yaml` + PATHS / GETTING-STARTED / TOOL-MAP / phase2-backlog as needed.

## Anti-patterns

- Editing only `~\.cursor\...` or `C:\Programs\...` without a hub source of truth.
- “It works on this PC” with no script.
- Documenting a manual step that should have been automated on Dev/Agent apply (unless explicitly manual, e.g. OpenWhispr install, IntelliJ).

## Done check

Before closing harness work: hub files updated, apply script path exists, docs mention it, wipe-test would restore it.
