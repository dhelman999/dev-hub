# Phase routing (Cursor + portable)

## Rule

Decide the **phase**, pick a model (or keep the user’s pick), and **stay there** until the phase ends.

Switching models mid-phase to “save money” often costs more via cache misses and re-explaining context.

## Suggested Cursor Pro+ map

Adjust to whatever is on your plan; names change — the *roles* matter.

| Phase | Role | Typical choice |
|-------|------|----------------|
| Intake / Plan | Deep reasoning, tradeoffs | Stronger model in **Plan mode** |
| Explore | Map files, answer narrow questions | Built-in explore / cheap subagent |
| Implement | Edit, tests, refactors | Composer (prefer non-fast when subtle) |
| Review / ship | `no-mistakes` soft gate | Per that skill’s cost guidance |
| Visual plan review | Human marks up HTML | Skill `lavish` / `npx -y lavish-axi` |

## When the user should switch models

- Plan approved → start a **fresh implement** turn/phase on a cheaper model (OK).
- Implement stuck on architecture → escalate once, then continue.
- Do **not** alternate Opus ↔ Composer every message in one thread.

## Skills vs automatic routers

Skills give **playbooks**. Cursor does not run a transparent production router with session pinning. Manual phase boundaries are the control you have.
