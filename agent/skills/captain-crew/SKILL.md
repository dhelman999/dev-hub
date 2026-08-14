---
name: captain-crew
description: >-
  Cursor-native captain/crew orchestration: one liaison chat plans and
  summarizes while parallel subagents (Multitask mode, /multitask, Task tool)
  do isolated work. Use when the user wants multiple agents, parallel work,
  Firstmate-like orchestration, a crew, captain mode, multitask, or not to
  babysit several chats — even if they only say "run these in parallel" or
  "don't make me track agents." Prefer this over inventing a tmux Firstmate
  fork. Full Kun Firstmate remains deferred on this Windows/Cursor machine.
---

# Captain / crew (Cursor-native)

You are the **first mate** in the user’s main chat. They are the **captain**.

Goal: one conversation they trust, while **crew** agents do parallel or long work and you report outcomes — not a wall of tabs they must babysit.

**Visibility:** crew are usually **subagents under this chat** (async via Multitask / `/multitask` / Task tool), not Firstmate-style tmux panes. The Agents Window spinner is the **parent chat thinking**, not a crew count. When crew is backgrounded the parent goes idle and that spinner **stops**. Count and work-in-flight live in the **launch ping**; outcomes live in the **finish briefing**. The captain may peek at Agents Window entries for extra detail; they should not need to. See `references/cursor-parallel.md`.

**Session start:** there is no separate Cursor “captain mode” toggle. This skill is a playbook. It applies when the user asks for parallel/crew/first-mate behavior, switches to **Multitask** mode, types `/multitask`, or the work clearly splits into independent streams; otherwise stay **solo**.

**Multitask is not required for captain mode.** Stay in Agent (or Plan) and say “crew / parallel / brief me” — you can still dispatch Task/subagents. **Multitask mode** (picker) or `/multitask` is the strongest *product* switch when the captain wants Cursor itself to fan work out.

This is the Windows/Cursor substitute for [firstmate](https://github.com/kunchenguid/firstmate). Do **not** install Firstmate’s tmux/Claude-Code distro unless the user explicitly leaves Cursor as the primary harness.

## When to use crew vs solo

| Situation | Mode |
|-----------|------|
| Single coherent change, shared context | Solo parent agent |
| Independent workstreams (unrelated fixes, scout + implement) | Crew / parallel (Agent + ask, or Multitask) |
| Long plan with independent steps | Plan first; then Multitask / `/multitask`, or plan-card **Build in Parallel** *if shown* |
| Conflicting edits on same files | **Only then** isolate with treehouse leases (`references/treehouse-lease.md`), or serialize. Default: **no** lease — see treehouse-lease “When to lease”. |

## Captain loop

1. **Intake** — clarify outcome; if large/ambiguous, switch to Plan mode.
2. **Decompose** — list crew tasks with non-overlapping ownership when possible.
3. **Dispatch** — spawn parallel subagents (Task tool; Multitask / `/multitask` when the product should fan out). Give each a crisp goal, repo path, and done definition. Prefer **background / async** so this chat stays free (see Blocking default below). **Treehouse:** default is the main checkout. Lease a worktree per writer **only** when two+ writers may collide on the same files (`references/treehouse-lease.md`). Do not lease explore/read-only crew or non-overlapping writers.
4. **Launch ping, then stop** — one short chat: how many crewmates, one line each on what they are doing. Then **stop** unless Blocking default applies (captain asked to wait, or the next step depends on crew). Do not poll, do not loop, do not keep talking until they finish or the captain asks.
5. **On-demand update** — if the captain asks mid-flight, peek once and report who is still running / who is done; then stop again.
6. **Finish briefing** — when crew completes (end-of-turn notification), report each crewmate: what they did, outcome. That is the summary. Extra detail only if asked, or they open the Agents Window.
7. **Escalate** — only real decisions (product tradeoffs, Tier B/C destruction, secrets/PII). Follow `destructive-actions` and `no-mistakes` as usual.

## Blocking default (non-blocking unless required)

**Default: do not block.** Launch crew in the background / async. Send the launch ping, then leave the chat quiet so the captain can do other work. Brief when crew results arrive or when they ask.

**Block / wait on crew only when:**

- The captain explicitly says wait, block, stop until done, “one combined report after all finish,” etc.
- The next step **implies** a dependency (e.g. “investigate Y, **then** implement Z from that findings,” “merge crew results then open the PR”).

Independent “do X, investigate Y, and Z” with no “then / after / once” → treat as parallel non-blocking crew.

## Briefing format (to the captain)

Two messages. Nothing in between unless they ask.

**Launch ping** (right after dispatch; then stop):

```text
Crew launched: N
- T06 schema — ensure Children/Transactions tabs exist
- T07 ledger — children + transaction adapters
```

**Finish briefing** (when they complete; this is the summary):

```text
Crew finished
- T06 schema — done: ensureSchema + client merged
- T07 ledger — done: children/transactions adapters merged
- Blocked: none (or: needs your call: …)
- Next: …
```

Mid-flight, if they ask: same shape with Running vs Done. No paste of full subagent transcripts unless asked. Do not poll on a timer to keep a spinner alive.

## Model / cost

Follow skill `context-engineering`: stable model for the captain phase; cheaper models for explore/implement crew when appropriate. Do not thrash models mid-phase.

## Tickets vs ad-hoc decompose

When the captain already has production-planning tickets (`/production-planning` or `/tickets`), use those as crew task boundaries. Do **not** invent a PRD or ticket files in the middle of ordinary solo work; captain-crew decompose-in-chat is enough there.

## What this is not

- Not Firstmate’s event-driven bash watcher or secondmates.
- Not Lavish (HTML annotate UI) — that is skill **`lavish`** (`npx -y lavish-axi`).
- Not a replacement for `no-mistakes` at ship time.
- Not “you must pick Multitask in the mode picker” — that is optional product parallel.
- Not an auto-PRD factory — durable tickets come from opt-in **`production-planning`**.

## Related

- Hub / Phase status: skill `agentic-harness` → `references/phase2-backlog.md`
- Parallel file isolation: **treehouse** — `references/treehouse-lease.md` (Phase 3 — live)
- Visual feedback: skill `lavish` (Phase 1 — live)
- Usage meters: skill `usage-canvas` / `/usage` (Phase 2 — live)
- Production planning tickets: skill `production-planning` / `/tickets` (opt-in; not the solo default)

More detail: `references/cursor-parallel.md`.
