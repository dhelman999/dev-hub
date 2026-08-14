---
name: production-planning
description: >-
  Opt-in production-planning: GATE PRD interview, then offer spec, then offer
  tickets. Explicit invoke only: /production-planning, "production planning",
  "sprint plan", "team planning". Default stays the solo lane. Do not start
  this chain because a task looks large. disable-model-invocation keeps this
  human-gated.
disable-model-invocation: true
---

# Production planning (opt-in outer loop)

Formal lane for team/sprint/epic work. Not the default. If they did not invoke it, **do not run it**.

Staged conversation. **Offer** the next skill after each accept. Do **not** auto-pipeline PRD → spec → tickets in one turn or because the previous file exists.

## Sequence

Repo: current project, or `C:\Projects\<name>` for a new product. Artifacts: `docs/planning/<slug>/`.

1. **PRD** — follow skill **`prd`** (GATE phases). Write `prd.md` only at Phase 6. Wait for accept.
2. **Offer spec** — after they accept the PRD, tell them `/spec` is next. Start skill `spec` only if they say continue / run spec.
3. **Offer tickets** — after they accept the spec, tell them `/tickets` is next. Start `slice-tickets` only if they say so.
4. Index `docs/planning/<slug>/README.md` when real artifacts exist (not during Phase 1).

Stop after tickets unless they explicitly asked to implement.

## Do not

- Write PRD + spec + tickets in the kickoff turn
- Skip GATE to "keep the mock moving"
- Invent problem, success, non-goals, or stack
- Implement in this pass
- Open Jira/GitHub issues unless asked
- Prime the whole repo (`/prime` is per ticket)
- Use this on interview drills or hub one-offs

## After tickets exist

Paths, ticket count, dependency waves. Next opt-in: `/prime` and `/validation-tdd` on a ticket, then implement. Ship with `no-mistakes`. Optional: skill `lavish` on the spec.

Diagram: `C:\Projects\dev-hub\docs\diagrams\production-two-loop.excalidraw` (REVIEW zoom: `no-mistakes-soft-gate.excalidraw`).
