---
name: spec
description: >-
  Architecture working session: 2-3 approaches with trade-offs, recommend, wait
  for the user's call, then write a how-spec from an accepted PRD. Explicit
  invoke only: /spec, /production-planning after a PRD. Do not use for solo
  Plan-mode chats or ordinary implement/fix requests.
  disable-model-invocation keeps this human-gated.
disable-model-invocation: true
---

# Spec (architecture / how)

High-level **how** after an accepted PRD. You **propose; you do not dictate.** Not a task list (that is tickets + `/validation-tdd`).

If this chat was not started with `/spec`, `/production-planning`, or an explicit spec ask, **stop**.

## Prerequisites

Read `<repo>/docs/planning/<slug>/prd.md`. If the PRD is not accepted, resume skill `prd`. Do not invent product goals.

## Conversation first (GATE)

The conversation **is** the deliverable until calls are made.

```
investigate → 2-3 options with trade-offs → recommend + why → GATE (wait for their call) → go deeper if needed → write
```

1. **Investigate** — PRD plus, if brownfield, a narrow look at existing code. Ask whether reference docs exist; do not dump the repo (skill `context-engineering`).
2. **Options** — two or three genuinely different approaches (stack, shape, where it runs). Trade-offs. Familiarity beats a "better" stack they do not know. Skip what does not apply and say so.
3. **Recommend** — one direction and why, pulled back to the PRD goal. Reversible calls can be light; one-way doors get a **spike** (question, smallest test, decision rule) instead of a guess.
4. **GATE** — stop. Do not pick Node vs Java vs SQLite in silence. Do not write `spec.md` in the same turn as the options.
5. After they choose, go deeper only on what is still open (data shape, boundaries). Then write.

If they say **draft it now**: write the spec, mark unchosen calls as **TBD — needs validation**.

## Output (only after they choose)

Write `<repo>/docs/planning/<slug>/spec.md` from `references/template.md`. High-level: approaches considered, recommended approach, stack, data shape, boundaries, spikes. No file-by-file edits.

Optional visual review: skill `lavish`.

Summarize the chosen approach. **Offer** next moves; do not start them:

- `/tickets` (slice-tickets)
- Stay here and refine
- Spike a flagged risk

Do **not** implement.
