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

**Visibility:** crew are usually **subagents under this chat** (async via Multitask / `/multitask` / Task tool), not Firstmate-style tmux panes. The captain may peek at Agents Window entries; they should not need to. See `references/cursor-parallel.md`.

**Session start:** there is no separate Cursor “captain mode” toggle. This skill is a playbook. It applies when the user asks for parallel/crew/first-mate behavior, switches to **Multitask** mode, types `/multitask`, or the work clearly splits into independent streams; otherwise stay **solo**.

**Multitask is not required for captain mode.** Stay in Agent (or Plan) and say “crew / parallel / brief me” — you can still dispatch Task/subagents. **Multitask mode** (picker) or `/multitask` is the strongest *product* switch when the captain wants Cursor itself to fan work out.

This is the Windows/Cursor substitute for [firstmate](https://github.com/kunchenguid/firstmate). Do **not** install Firstmate’s tmux/Claude-Code distro unless the user explicitly leaves Cursor as the primary harness.

## When to use crew vs solo

| Situation | Mode |
|-----------|------|
| Single coherent change, shared context | Solo parent agent |
| Independent workstreams (unrelated fixes, scout + implement) | Crew / parallel (Agent + ask, or Multitask) |
| Long plan with independent steps | Plan first; then Multitask / `/multitask`, or plan-card **Build in Parallel** *if shown* |
| Conflicting edits on same files | Serialize, or isolate with worktrees (treehouse — Phase 3) |

## Captain loop

1. **Intake** — clarify outcome; if large/ambiguous, switch to Plan mode.
2. **Decompose** — list crew tasks with non-overlapping ownership when possible.
3. **Dispatch** — spawn parallel subagents (Task tool; Multitask / `/multitask` when the product should fan out). Give each a crisp goal, repo path, and done definition. Prefer **background / async** so this chat stays free (see Blocking default below).
4. **Supervise** — wait or poll only as needed; do not spam the captain with noise.
5. **Reconcile** — merge findings into a short briefing: what shipped, what failed, what needs a decision.
6. **Escalate** — only real decisions (product tradeoffs, Tier B/C destruction, secrets/PII). Follow `destructive-actions` and `no-mistakes` as usual.

## Blocking default (non-blocking unless required)

**Default: do not block.** Launch crew in the background / async. Acknowledge launch quickly, keep answering the captain (summaries, email drafts, follow-ups), and brief when crew results arrive.

**Block / wait on crew only when:**

- The captain explicitly says wait, block, stop until done, “one combined report after all finish,” etc.
- The next step **implies** a dependency (e.g. “investigate Y, **then** implement Z from that findings,” “merge crew results then open the PR”).

Independent “do X, investigate Y, and Z” with no “then / after / once” → treat as parallel non-blocking crew.

## Briefing format (to the captain)

Keep it scannable:

```text
Crew status
- Done: …
- Blocked: … (needs your call: …)
- Next: …
```

No paste of full subagent transcripts unless asked.

## Model / cost

Follow skill `context-engineering`: stable model for the captain phase; cheaper models for explore/implement crew when appropriate. Do not thrash models mid-phase.

## What this is not

- Not Firstmate’s event-driven bash watcher or secondmates.
- Not Lavish (HTML annotate UI) — that is skill **`lavish`** (`npx -y lavish-axi`).
- Not a replacement for `no-mistakes` at ship time.
- Not “you must pick Multitask in the mode picker” — that is optional product parallel.

## Related

- Hub / Phase 2 status: skill `agentic-harness` → `references/phase2-backlog.md`
- Parallel isolation later: treehouse (Phase 3)
- Visual feedback: skill `lavish` (Phase 1 — live)

More detail: `references/cursor-parallel.md`.
