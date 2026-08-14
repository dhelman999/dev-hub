---
name: validation-tdd
description: >-
  Write a tests-first validation plan (and failing tests when implementing) for
  a production ticket. Explicit invoke only: /validation-tdd, "validation first",
  "TDD this ticket", "write the failing tests first". Complements no-mistakes
  (this is before code; that is at ship). Do not use on solo drills or ordinary
  implement/fix requests. disable-model-invocation keeps this human-gated.
disable-model-invocation: true
---

# Validation-first / TDD (production lane)

Human-invoked inner-loop step. Define **how we will know it works** before writing production code.

If this chat was not started with `/validation-tdd` or an explicit TDD/validation-first ask, **stop**. Solo work does not need this ritual; `no-mistakes` still runs at ship.

## Input

A ticket path or the current production-planning slug. Read the ticket’s existing Validation section; deepen it rather than replacing empty hand-waving with more hand-waving.

## Output

Write or update:

- `docs/planning/<slug>/tickets/T<nn>-*.md` Validation + AC, and/or
- `docs/planning/<slug>/validation-T<nn>.md` when the plan is longer than a ticket section

Use `references/template.md`. Every check needs a **command** or a concrete manual step. “Write tests” is not a check.

## Legacy extraction / migration tickets

When the ticket moves existing behavior (extract a service, replace a data path, swap an implementation), the validation plan must **pin current behavior first**:

1. Write **characterization tests** against the legacy path — capture what it actually does today, including quirks, not what the docs claim.
2. Run them green on unchanged code. That is the baseline.
3. Do the extraction, then run the same tests against the new path to prove equivalence.
4. Only then add new-behavior tests for anything the ticket intentionally changes, and say in the ticket which differences are deliberate.

No characterization baseline means no way to tell a migration bug from a pre-existing quirk. Treat a missing baseline on a migration ticket as a gap in the plan.

## If also implementing in this chat

1. Write **failing** tests that encode the acceptance criteria.
2. Run them and show the failure.
3. Then implement until those tests pass.
4. At push/PR, still follow skill `no-mistakes` (this skill does not replace the ship gate).

If the user only asked for the plan, stop after writing the validation doc. Do not start production code.
