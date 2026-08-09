# Cursor parallel primitives

## Primary UI: Multitask mode and `/multitask`

**Multitask** in the Plan / Agent / Multitask mode picker (and typing `/multitask` in the Agents Window) is Cursor’s **explicit parallel dispatch**: async subagents instead of a serial queue.

- Each subagent gets its **own context window** (no shared chat history unless the parent copies it into the dispatch).
- Subagents can run **in parallel**; the parent stays interactive.
- Results come back to the **parent** (first-mate) chat as summaries; the parent reconciles for you.
- Large asks may be **split** into several subagent chunks automatically.

Docs/changelog: [multi-agent help](https://cursor.com/help/ai-features/multi-agent), [changelog multitask](https://cursor.com/changelog/04-24-26), [subagents](https://cursor.com/docs/subagents).

Prefer `/multitask …` over flaky “Start multitasking” UI buttons when those misbehave.

## Optional: Plan card “Build in Parallel”

**Build in Parallel is not a mode** next to Plan / Agent / Multitask.

When it exists, it is a **button on an already-generated plan card** (alternative to a sequential build / “Build Locally”). It appears only after Plan produces a multi-step plan, and availability varies by Cursor version and Agents Window vs editor.

If the captain does not see that button: use **Multitask** mode, `/multitask`, or ask the first mate to implement independent steps in parallel via Task/subagents. Do not treat a missing button as a broken setup.

## Captain mode vs Multitask (do I have to switch?)

| Goal | What to do |
|------|------------|
| Captain/crew playbook | Stay in **Agent** (or Plan). Say “crew / parallel / brief me.” No mode switch required. |
| Product-level fan-out | Switch picker to **Multitask**, or type `/multitask …`. |
| Plan then parallel | Plan → approve → **Build in Parallel** *if shown*; else Multitask / `/multitask`. |

Captain/crew is a **skill**, not a Cursor mode toggle.

## Will I see new tabs? (visibility)

**Usually not like Firstmate/tmux.** Default crew work is **nested under the parent chat**, not a wall of equal top-level chats you must babysit.

| Mechanism | What you typically see |
|-----------|-------------------------|
| Parent Task / explore / shell subagents | Activity under the **same** first-mate chat (foreground blocks; background returns later). Intermediate noise stays in the subagent. |
| Multitask / `/multitask` fleet | Parallel subagents tied to that parent session; Agents Window can surface them as **related entries** you can inspect — still orchestrated by one liaison chat. |
| Manual new Agent chats / cloud agents | **Separate** sidebar sessions you open yourself — more Firstmate-like visually, more babysitting. |
| Worktrees / cloud VMs | Extra isolation (files/VM); still managed from Agents Window, not Cmder panes. |

**Captain-crew design goal:** you talk to **one** chat; the mate dispatches crew and gives a short briefing. You *can* open a crew entry to peek, but you should not *have* to.

This is **not** Kun Firstmate (each crewmate in its own tmux/herdr window by default).

## First-mate session vs solo — how it starts

There is **no separate Cursor mode toggle** named “captain.” The skill is a **behavior playbook**.

| How you start | What happens |
|---------------|--------------|
| Normal Agent chat, single coherent ask | **Solo** — one agent does the work (may still use tiny explore subagents internally). |
| You say “captain/crew,” “in parallel,” “don’t make me track agents” | Agent should follow **`captain-crew`**: decompose, dispatch, brief (still OK in Agent mode). |
| You pick **Multitask** or type `/multitask` | Product fans work to async subagents; mate still briefs. |
| Plan card **Build in Parallel** (if shown) | Same parallel engine via the plan UI. |
| Ambiguous medium task | Prefer **solo** when unsure. |

**Practical tip:** Open one Agents Window chat as your standing “first mate.” Explicitly say *crew/parallel* when you want the liaison pattern. Use Multitask when you want Cursor’s built-in fan-out.

## Tools the captain should know

| Primitive | Role |
|-----------|------|
| **Agent / Plan modes** | Normal solo or plan-then-build; captain playbook works here without Multitask |
| **Multitask mode** | Primary product UI for parallel async subagents (mode picker) |
| **`/multitask`** | Same parallel engine via slash command (Agents Window) |
| **Build in Parallel** | Optional plan-card button only; may be absent — not required |
| **Task tool / subagents** | Parent spawns explore/shell/general workers; results return to parent |
| **Agents Window** | Sidebar to manage parent + any surfaced parallel/cloud agents |
| **Worktrees** (Cursor / later treehouse) | File isolation when two writers would collide |

## Dispatch tips

- One crewmate = one clear outcome + path scope.
- Prefer **read-only explore** crewmates before many writers.
- Avoid two writers on the same file without isolation.
- When treehouse is installed (Phase 3), lease a worktree per writer.
- **Default non-blocking:** background/async crew unless the captain says wait/block or a step depends on another crew result (see `SKILL.md` → Blocking default).

## Reporting

Summarize diffs and decisions. Link PR URLs or file paths. Do not require the captain to open every crew transcript.
