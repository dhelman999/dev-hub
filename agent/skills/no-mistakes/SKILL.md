---
name: no-mistakes
description: >-
  Cursor-native soft gate before commit/push/PR: intent, build/test, style,
  diff review, then ship only when green. Ship postures: push, pr, or hold
  (gate then wait for human review). Default-on when shipping unless the user
  says skip no-mistakes / bypass gate. Use when the user asks to no-mistakes,
  validate before push, gate/ship safely, open a PR, push a branch, hold after
  the gate, or /no-mistakes — even if they only say "ship it", "push", "create the PR",
  "open a PR", "ready for review", "gate", or "don't push yet". Prefer this over
  pushing unvalidated agent work. Not the Kun Go binary yet.
---

# no-mistakes (soft gate)

Cursor-native pre-ship validation for David Helman. Inspired by
[kunchenguid/no-mistakes](https://github.com/kunchenguid/no-mistakes); the Go
git-proxy binary is **not** required (see `references/upstream-tool.md`).

**Default:** when about to commit (if shipping), push, or open a PR after agent
work, **run this gate** unless the user explicitly bypasses.

**Prefer this over Cursor "Agent review on commit"** (Quick/Deep auto-review).
David keeps that product setting **off** - quality control goes through this soft
gate, not light mid-task/commit auto-reviews. Do not suggest enabling it.

## Announce (required)

First user-visible line when the skill runs:

> Running **no-mistakes** soft gate (**validate-only** | **task-first**). Say **skip no-mistakes** / **bypass gate** to ship without the full checklist.

Proceed immediately after that line (not a permission prompt). End with an
outcome summary (see `references/soft-gate.md`).

## Bypass

Treat as bypass (ack in one line, then normal git rules — no checklist):

- `skip no-mistakes`, `skip no-mistake`, `bypass gate`, `skip soft gate`
- `just push` / `push without gate` / clear “no gate” intent

## Mode selection

| Invocation | Mode |
|------------|------|
| Bare `/no-mistakes`, “validate before push,” “run the soft gate,” “gate this,” ship/PR/push with work already done | **Validate-only** |
| `/no-mistakes <task>`, “do X then no-mistakes,” “implement X and ship/validate” | **Task-first** |
| Ambiguous | **Validate-only** — do not invent a task |

**Task-first:** do the work → commit on a feature branch if shipping → soft gate → ship only if green (or bypassed).

## Ship posture (after the gate is green)

The gate always runs first (auto-fix capped at **5** cycles). Ship action is chosen only from the user’s wording — do not infer size of the change:

| Posture | Say / trigger | After green |
|---------|---------------|-------------|
| **push** | **“push”** or **“ship it”** | Commit (if needed) → **push**. No PR unless they also said create the PR. If the gate is **blocked**, do not push. |
| **pr** | **“create the PR”** or **“open a PR”** | Commit (if needed) → push → **`gh pr create`** (rich body when complex per `java-coding-style`). If the gate is **blocked**, do not push or open a PR. |
| **hold** | **“ready for review”**, **“gate”**, **“don’t push yet”** (also: bare `/no-mistakes`, “run the gate”, “run the soft gate”, “validate before push” with no ship verb) | **Stop.** No push, no PR. Outcome summary + wait for an explicit follow-up (`push` / `ship it` / `create the PR` / further edits). |

- If push/PR and hold cues both appear, **hold** wins.
- After **hold**, a later **“push”** / **“ship it”** / **“create the PR”** re-runs the gate if the tree changed since the green run; if unchanged, may ship without a full re-gate.

## Finding classes

Load `references/finding-classes.md`.

- **auto-fix** — agent fixes and continues (tests, style, mechanical); **max 5** fix/re-check cycles per gate run, then block + ask-you.
- **ask-you** — stop, quote finding, wait for approve / fix guidance / skip.
- **no-op** — summary only.

## Soft gate steps

Load `references/soft-gate.md`. **Run-then-report** (not a per-step wizard).
Pause only for **ask-you** findings or when the **5-cycle** auto-fix cap is
hit. Interactive step-by-step only if the user asks for that run.

**Diff review** must use a **dedicated review subagent** (not this chat’s
implementation context) — see soft-gate §5. Default model:
`cursor-grok-4.5-high-fast` (or `composer-2.5-fast`); escalate to
`claude-opus-4-8-thinking-high` only for unusually hard reviews.

## When to load references

| Need | Read |
|------|------|
| Checklist, project test recipes, outcome format | `references/soft-gate.md` |
| auto-fix vs ask-you vs no-op | `references/finding-classes.md` |
| Kun binary install later | `references/upstream-tool.md` |
