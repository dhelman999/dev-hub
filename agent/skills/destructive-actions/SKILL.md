---
name: destructive-actions
description: >-
  Tiered permission gate for deletes, wipes, force-push, hard reset, history
  rewrite, and gh repo delete. Tier A minor (proceed if work was requested),
  Tier B soft ask, Tier C hard stop requiring "yes authorize permanent deletion".
  Use whenever about to permanently delete, mass-wipe, destroy a repo, force-push
  main, or rewrite git history — even if the user said ship it or no-mistakes is
  green. Orthogonal to no-mistakes (ship quality); no-mistakes must early-scan and
  follow this skill when destruction is planned.
---

# Destructive actions (permission tiers)

Does **not** replace skill `no-mistakes` (build/test/review/ship posture). This skill only answers: **may we destroy or rewrite history?**

When in doubt: A vs B → **B**; B vs C → **C**.

## Confirm phrase (Tier C only)

User must type exactly (case-insensitive, trim OK):

`yes authorize permanent deletion`

Ordinary “yes” / “ship it” / “do it” / no-mistakes **PASS** never satisfies Tier C.
Skipping `no-mistakes` also never satisfies Tier C.

## Tiers

| Tier | When | Permission |
|------|------|------------|
| **A — Minor** | Single file / small scoped delete, undo local uncommitted change, replace file as part of requested edit, remove obvious generated junk | If user already asked for that work or ship → **proceed**. If side-effect they likely did not foresee → treat as **B**. |
| **B — Confirm** | Ambiguous or missing permission; agent-chosen cleanup; delete a directory / many paths; local history rewrite not clearly requested; force-with-lease to a **non-default** branch when they only said “push” | **Stop**, list targets, ask once. Normal yes is enough. |
| **C — Major** | Delete a git repo (local or `gh repo delete`); mass wipe (many projects, a whole hub, user profile); force push / history rewrite to **main/master/develop**; destructive prod DB wipe; irreversible cloud destroy | **Hard stop**. Require the exact authorize phrase. Re-state targets before executing. |

Examples: `references/examples.md`.

## With no-mistakes

- Ship quality still goes through `no-mistakes`.
- `no-mistakes` runs an **early destructive plan scan** before long build/test/review. Tier B/C must be cleared **up front**, not after a long gate.
- Gate green never authorizes Tier C.
- When executing a delete/wipe/force/history step during ship or auto-fix, follow this skill.

## Agent checklist

1. Classify the op (A / B / C).
2. Tier A + clear user ask → execute.
3. Tier B → ask once; wait.
4. Tier C → wait for `yes authorize permanent deletion` only.
5. Never bury surprise Tier C at the end of a long green ship — prefer early scan; if a later auto-fix invents Tier B/C, **stop immediately**.
