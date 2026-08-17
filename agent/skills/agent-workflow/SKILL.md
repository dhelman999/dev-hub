---
name: agent-workflow
description: >-
  Default Agent-mode execution: edit files and run tools immediately with no
  conversational permission prompts. Use on every implement, build, create,
  add, tailor, fix, refactor, update, scaffold, or review/edit request — even
  if the user does not name this skill. Prefer this over any "Want me to…?" /
  "Should I…?" pause. For deletes/wipes/history rewrite, follow skill
  destructive-actions (tiers A/B/C; Tier C needs yes authorize permanent
  deletion).
---

# Agent Workflow Preferences

When the user is in **Agent mode** and has asked you to do something, **proceed immediately**. Edit files, create files, and run commands. **Never ask permission to edit files.**

If the user says “stop asking to edit,” that means **stop prompting / pausing** — still edit and finish the work. It does **not** mean abandon the edits. Auto-review / Smart Mode cards are product gates: retry with approval so the user can Approve once; do not interpret that as a chat refusal.

## Never ask (conversational)

Do not pause with:

- "Want me to create / edit / update…?"
- "Should I add…?"
- "I can do X if you'd like…"
- Waiting for a chat yes before applying in-scope work

If the request implies the work, do it. Include obvious follow-ons (tests, boilerplate, small related fixes) in the same pass. Summarize when done.

Also: do **not** ask whether to commit/push unless the user already asked for that — and if they did ask, just do it (subject to their git rules). Prefer a sensible default over asking which architecture to use.

Before push/PR after agent work, apply skill **`no-mistakes`** (soft gate) unless the user said **skip no-mistakes** / **bypass gate**.

## Solo vs production planning

**Default is the solo lane:** Plan or Agent → implement → **no-mistakes**. Do **not** volunteer a PRD / spec / ticket chain because the work looks large. One-person features stay on that loop.

The production-planning skills (`prd`, `spec`, `slice-tickets`, `prime`, `validation-tdd`, orchestrator `production-planning`) are **explicit-invoke only** (`disable-model-invocation`). Run them only for `/production-planning`, `/prd`, `/spec`, `/tickets`, `/prime`, `/validation-tdd`, or clear phrases: “production planning,” “sprint plan,” “write a PRD,” “slice this epic,” “team planning.”

When those skills **are** invoked: follow **`prd` GATE phases** (stop the turn after each question cluster). Do not write PRD/spec/tickets from agent assumptions. After they accept a stage, **offer** the next skill; do not auto-pipeline. “Prefer a sensible default” applies to solo implementation, not to product intent or architecture calls.

## Commits and PRs

- **Never** add `Co-authored-by: Cursor <cursoragent@cursor.com>` (or any Cursor/agent co-author trailer). See skill `java-coding-style`.
- When creating a **complex** PR, include comprehensive sections (description, expected behavior, summary of changes, plus other reviewer context). Small PRs can stay brief. Details in `java-coding-style`.

## Cursor Auto-review cards

If the UI blocks a tool and shows Smart Mode / Auto-review, that is a product security gate. Retry with approval so the user can Approve in the card. Do **not** also ask in chat "want me to proceed?"

## Destructive / irreversible actions

Follow skill **`destructive-actions`** (tiers A/B/C). Do not invent a separate ad-hoc policy.

- **Tier A (minor):** obvious small deletes as part of requested work → proceed
- **Tier B:** ambiguous / side-effect destruction → ask once in chat
- **Tier C (major):** repo delete, mass wipe, force-push default branch, etc. → hard stop until the user types `yes authorize permanent deletion`

Routine file edits, refactors, new files, installs the user requested, and normal repo work are **not** destructive-gated — just do them.

That includes editing **skills**, **AGENTS.md**, **Cursor rules**, and other harness/config files when the request implies updating conventions or workflow. Those are ordinary file edits - not "ask first," and not special-cased beyond Auto-review product cards.

## Reproducible harness

Whenever a change affects the **dev environment**, **agent harness**, or **agentic engineering** setup: land it in the version-controlled hub (skills, dotfiles, machine scripts, docs) so another machine can regenerate. Do not leave machine-only one-offs. See skill **`agentic-harness`**.

## Execution style

- Investigate and run commands yourself
- Keep diffs focused on the request
- End with a concise summary — not optional follow-ons already implied by the ask

## Project pointers

| Topic | Action |
|-------|--------|
| Writing/editing Java | Skill `java-coding-style` |
| Build/test for the current repo | Project docs (`README`, `AGENTS.md`, `scripts/`) — never invent a compile that dumps artifacts into `src/` |
| Validate before push/PR | Skill `no-mistakes` (soft gate; default-on unless user says skip no-mistakes) |
| Deletes / wipes / force-push / history rewrite | Skill `destructive-actions` (tiers A/B/C; Tier C phrase required) |
| Hub / regenerate / environment changes | Skill `agentic-harness` (reproducibility checklist) |
| High-risk / design-locking claims from memory | Skill `grounding` (RAG or assumption trail; not a hard gate) |
| Production planning (PRD/spec/tickets, opt-in) | `/production-planning` or skills `prd`, `spec`, `slice-tickets`, `prime`, `validation-tdd` |
