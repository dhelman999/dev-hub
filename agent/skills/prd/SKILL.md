---
name: prd
description: >-
  GATE-style PRD interview (what/why), then write a product PRD. Explicit invoke
  only: /prd, /production-planning, "write a PRD". Do not use for solo features
  or ordinary implement/fix/plan requests.
  disable-model-invocation keeps this human-gated.
disable-model-invocation: true
---

# PRD (what / why)

Discover **intent** with the user, then write a durable PRD. Not a spec and not an implementation.

If this chat was not started with `/prd`, `/production-planning`, or an explicit PRD ask, **stop** (solo lane).

## GATE

**GATE** means: post one cluster, then **end the turn**. Do not ask and answer in the same breath. Do not roll into the next phase. Do not write `prd.md` until Phase 6.

If they decline the interview ("just write it"): honour it, name what you would have to guess, and offer the two or three highest-leverage questions instead of all of them. Anything still unanswered ships as **TBD — needs validation**, never as an invented requirement or a fake `Assumption:`.

Solo-lane "prefer a default" does **not** apply. No stack, APIs, or file paths (that is skill `spec`). No secrets, claim IDs, financials, medical data, or home address. Placeholder names for people.

**Reframe test:** if only one solution could fit the problem statement, you wrote a spec. Leave room for more than one how.

## Phases

```
INITIATE → FOUNDATION → DEEP DIVE → HYPOTHESIS → MVP & DOORS → GENERATE
```

### Phase 1 — Initiate

Restate their idea in a few sentences. Confirm or correct. If blank: "What do you want to build?" **GATE.**

### Phase 2 — Foundation

Ask (one cluster):

1. **Who** has this problem (a role, not "users")?
2. **What** is the observable pain today?
3. How do they **cope today**, and why is that not enough?
4. **Why now?**

**GATE.** Dig if the why is vague.

### Phase 3 — Deep dive

Ask (one cluster): who operates vs who benefits; who it is **not** for; product-level constraints (privacy, platform, time). **GATE.**

### Phase 4 — Hypothesis

Co-write a falsifiable bet. The **wrong** condition is required:

```
We believe [change] will cause [these people] to [do Y], resulting in [outcome].
We'll know we're RIGHT if [signal] within [timeframe].
We'll know we're WRONG if [counter-signal].
```

**GATE.**

### Phase 5 — MVP and non-goals

Thinnest slice that can prove the hypothesis end to end. What is explicitly out of scope. Any one-way door that should be a spike later (flag it; do not design it). **GATE.**

### Phase 6 — Generate

Only after Phase 5 answers (or an explicit "draft it now"). Write `<repo>/docs/planning/<slug>/prd.md` from `references/template.md`. Use the user's words. Leftovers are **TBD — needs validation** or **Open:** checkboxes.

Then a short summary (thesis + hypothesis) and **wait for accept/correct**. Offer `/spec` — do not start it.

Skip phases only when the user already answered them in this chat. Never skip GATE by filling silence.
