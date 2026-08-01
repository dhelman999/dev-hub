---
name: agent-workflow
description: >-
  Default Agent-mode execution for David Helman: edit files and run tools
  immediately with no conversational permission prompts. Use on every implement,
  build, create, add, tailor, fix, refactor, update, scaffold, or review/edit
  request — even if the user does not name this skill. Prefer this over any
  "Want me to…?" / "Should I…?" pause. Only ask before truly irreversible
  actions (permanent deletion, DB schema changes with lasting impact, etc.).
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

## Commits and PRs

- **Never** add `Co-authored-by: Cursor <cursoragent@cursor.com>` (or any Cursor/agent co-author trailer). See skill `java-coding-style` → Helman engineering conventions.
- When creating a **complex** PR, include comprehensive sections (description, expected behavior, summary of changes, plus other reviewer context). Small PRs can stay brief. Details in `java-coding-style`.

## Cursor Auto-review cards

If the UI blocks a tool and shows Smart Mode / Auto-review, that is a product security gate. Retry with approval so the user can Approve in the card. Do **not** also ask in chat "want me to proceed?"

## Only ask in chat when truly irreversible

Ask first **only** for actions with profound, hard-to-undo effects, for example:

- Permanent deletion of important data or mass wipe of files the user did not ask to remove
- Database schema migrations / destructive DB changes with lasting production impact
- Force push, hard reset, or similar history-destroying git ops the user did not explicitly request

Routine file edits, refactors, new files, installs the user requested, and normal repo work are **not** in this category — just do them.

That includes editing **skills**, **AGENTS.md**, **Cursor rules**, and other `C:\Projects\dev-hub` config when the request implies updating conventions or workflow. Those are ordinary file edits - not "ask first," and not special-cased beyond Auto-review product cards.

## Execution style

- Investigate and run commands yourself
- Keep diffs focused on the request
- End with a concise summary — not optional follow-ons already implied by the ask

## Project pointers

| Topic | Action |
|-------|--------|
| Writing/editing Java | Skill `java-coding-style` |
| Compiling `java-interview-drills` (`C:\Projects\java-interview-drills`) | `references/testcode-compile.md` — never bare `javac` from `src/` |
| Validate before push/PR | Skill `no-mistakes` (soft gate; default-on unless user says skip no-mistakes) |
