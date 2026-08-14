# Validation: T<nn> <title>

- Slug: `<slug>`
- Ticket: `docs/planning/<slug>/tickets/T<nn>-*.md`

## Behavior under test

What a passing slice proves. Tie each item to an acceptance criterion.

## Unit

| Check | Command |
|-------|---------|
| | |

## Integration / E2E

| Check | Command |
|-------|---------|
| | none if N/A |

## Manual

- …

## Characterization baseline (migration / extraction tickets only)

| Legacy behavior pinned | Command | Green before the change? |
|------------------------|---------|--------------------------|
| | | |

Deliberate differences from legacy: …

## TDD order

1. Add or extend tests so current code **fails** the new AC.
2. Implement the slice.
3. Re-run the commands above.
4. Ship with `no-mistakes` (not a substitute for this list).

## False-green self-check

For each check above: would it still pass if the production change were reverted or the expected value inverted? If yes, the check is not a check. See `no-mistakes` → `references/finding-classes.md`.
