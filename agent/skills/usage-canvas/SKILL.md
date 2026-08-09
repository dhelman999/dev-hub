---
name: usage-canvas
description: >-
  Show Cursor quota/usage in a Cursor Canvas beside chat via quota-axi. Use when
  the user runs /usage, asks for usage, quota, remaining included/auto/API, or
  wants the usage dashboard refreshed.
---

# Usage canvas (Phase 2)

Open or refresh a **Cursor Canvas** with live Cursor quota windows from `quota-axi`.

## Locked UX (do not reopen)

| Decision | Choice |
|----------|--------|
| Content | **Stacked meters** (three `UsageBar`s in a column) — easier glance in a full editor tab |
| Placement | Canvas opens as an **editor tab** beside Agents — not inside chat chrome |
| Above/below chat | **Out of scope** (Cursor cannot dock canvas into Agents chat) |
| Hide / bring back | Close the canvas tab; re-run this skill or `/usage` |
| Auto-open on IDE launch | **No** — session/skill open only |
| Dollars | **No** — percent used / remaining only |
| Extra providers | Cursor-first; Claude/Codex later if asked |

## Workflow

1. Ensure CLI path: `npx -y quota-axi --provider cursor --json`
   - Needs **Node** + **sqlite3** on PATH (Cursor auth reads `state.vscdb`). Soft-checked by `machine/Ensure-QuotaAxi.ps1`.
2. Parse JSON: for provider `cursor`, read each window’s `id`, `label`, `percentUsed`, `percentRemaining`, `resetsAt`.
3. Write/update canvas at the **workspace** canvases dir (IDE-managed):
   - `C:\Users\<user>\.cursor\projects\<workspace-id>\canvases\cursor-usage.canvas.tsx`
   - Prefer that stable name for the live dashboard (not the placement-smoke files).
4. Use layout from `references/canvas-layout.md` (stacked `UsageBar`s; theme tokens only).
5. Tone bars by **percentUsed**: green &lt; 50, yellow &lt; 80, orange otherwise.
6. Caption: source `quota-axi --provider cursor`, `generatedAt`, and reset date if present.
7. If `sqlite3_unavailable` or empty windows: still write a canvas with a Callout explaining the failure and how to install `SQLite.SQLite` / re-run Ensure — do not invent percentages.
8. Briefly tell the user the canvas is ready (editor tab); they can close it anytime.

## Commands

- Prefer: `npx -y quota-axi --provider cursor --json`
- Auth probe only: `npx -y quota-axi auth --provider cursor`
- Help: `npx -y quota-axi --help`

## Do not

- Promise docking above/below the Agents chat input
- Fake dollar costs or invent quota numbers
- Replace Cursor Settings → Usage; this is a glanceable agent-side canvas only
- Mid-task model thrashing based on quota alone (see skill `context-engineering`)
