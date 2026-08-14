---
name: slice-tickets
description: >-
  Slice an accepted PRD plus spec into sprint-sized tickets with ACs, verification
  commands, and a dependency graph. Explicit invoke only: /tickets,
  /slice-tickets, /production-planning after spec, "slice this epic". Do not
  invent tickets for solo implement/fix work. disable-model-invocation keeps
  this human-gated.
disable-model-invocation: true
---

# Slice tickets

Turn an accepted PRD + spec into **sprint-sized** durable tickets (human or captain-crew). Not Cole-sized 500–1500-line AI dumps.

If this chat was not started with `/tickets`, `/production-planning`, or an explicit slice ask, **stop**.

## Prerequisites

Read `docs/planning/<slug>/prd.md` and `spec.md`. Both should be **accepted** (or they said slice anyway). If missing, go back to `prd` / `spec`.

Ask 1-2 questions only if needed: first-sprint cut line, serial vs parallel. Do not re-litigate the PRD. **GATE** if you ask.

## Output

Write `<repo>/docs/planning/<slug>/tickets/T<nn>-<short-name>.md` from `references/template.md`.

Write `docs/planning/<slug>/tickets/README.md` using `references/index.md` (table + dependency graph + waves).

Sizing:

- One testable concern; vertical slice of behavior when possible
- Small enough for one engineer or one agent pass without context rot
- Every ticket: acceptance criteria + verification commands
- Likely files, not a full patch

Do **not** open GitHub issues unless asked. Markdown in-repo is the default.

## Handoff

Tickets feed `captain-crew` when they want parallel work. Independent tickets (no shared files, no output dependency) can run in parallel; dependents wait until the dependency is **implemented**, not merely sliced.

Do not spawn crew unless they asked to implement next.

## After writing

Index path, ticket count, waves. Next opt-in: `/prime` then `/validation-tdd` per ticket, then implement. Do **not** implement in this pass.
