# Soft gate checklist

## UX: run-then-report

1. Announce skill + mode (+ bypass hint) — see `SKILL.md`.
2. **Early destructive plan scan** (skill `destructive-actions`) — before long build/test/review.
3. Run mechanical steps back-to-back; apply **auto-fix** without pausing (**max 5** fix/re-check cycles — see `finding-classes.md`).
4. Pause **only** on **ask-you** findings, Tier B/C destructive permission waits, or when the auto-fix cap is hit.
5. Emit an **outcome summary**, then apply **ship posture** (`push` / `pr` / `hold`) only if green (or user bypassed). **hold** means stop with no push/PR.

Do **not** wait for approve after each step unless the user said “gate step by step” for this run — **except** Tier B/C from `destructive-actions` (must clear up front).

## Steps

### 1. Intent

State in 2–4 sentences what the user set out to accomplish (goal + tradeoffs),
not a file list. Use this when classifying ask-you vs deliberate choices.

### 1b. Early destructive plan scan (required)

Load skill **`destructive-actions`**. Before build/test/review:

1. List deletes, wipes, force-pushes, or history rewrites **already known** for this ship (user ask, diff, ship steps).
2. Classify each Tier A / B / C.
3. **Any Tier B or C** → **stop immediately**, list targets, get approval (normal yes for B; exact `yes authorize permanent deletion` for C). Do **not** start long checks until cleared.
4. **None or Tier A only** → continue the gate with no pause.
5. If a later auto-fix invents a new Tier B/C destroy → stop then; prefer fixes that avoid surprise major destruction.

`skip no-mistakes` does **not** bypass Tier C. Gate green never authorizes Tier C.

### 2. Scope / branch

- Prefer a **feature branch** for ship/PR work.
- **ask-you** if about to force large WIP onto `main`/`master`/`develop` in an unusual way, push secrets, or push **PII / personal identifying information**.
- History rewrite / force-push / mass delete → skill `destructive-actions` (early scan + execute-time).

### 3. Build and test (by project)

| Project | Command |
|---------|---------|
| McWendyQueen | `.\mvnw.cmd test` from repo root |
| java-interview-drills | JDK **21** `javac -d out\classes` all `src/**/*.java`, then run drill mains (`LruCache*Test`, `SlidingWindowRateLimiterTest`, `Main`) — never bare `javac` dumping into `src/` |
| Other | If present: `mvnw`/`mvn test`, `npm test`/`pnpm test`, `go test ./...`, project `scripts\` helpers |

Failing tests from this change → **auto-fix** → re-run. Cannot fix → **ask-you** or block ship.

### 4. Style

- Java → skill `java-coding-style` (Spring `this.` rules, related constants, braces).
- Mechanical style violations → **auto-fix**.
- Parent agent may apply style; do not rely on this for deep review.

### 5. Diff review (dedicated subagent)

**Do not** have this chat’s implementation context be the sole reviewer. The same
agent that wrote the code is biased and context-diluted.

Launch a **Task** subagent for review:

| Setting | Value |
|---------|--------|
| `subagent_type` | `generalPurpose` |
| `readonly` | `true` |
| `model` | **Default:** `cursor-grok-4.5-high-fast`. **Alternate:** `composer-2.5-fast` (either is fine on Pro / first-party pool). **Escalation only:** `claude-opus-4-8-thinking-high` when the diff is large, cross-cutting, security-sensitive, or the user asks for a deep/complicated review — do **not** use Opus for routine gates |
| `run_in_background` | `false` unless the user wants async |

Prefer Grok or Composer for normal no-mistakes runs (cost/quota). Do not default to Claude Sonnet/Opus or OpenAI models for the review subagent unless the user asks or the escalation bar above is met.

**Prompt the subagent with:**

- Repo path + branch
- User **intent** (from step 1)
- How to get the diff (`git diff` / `git diff base...HEAD` / PR range)
- Finding classes from `finding-classes.md` (auto-fix / ask-you / no-op) — explicitly scan for **secrets** and **PII / personal identifying information** (ask-you; see finding-classes)
- Required return format: a list of findings `{class, severity, file, line?, description}` plus a one-line overall verdict

**Parent agent then:**

1. Applies **auto-fix** findings itself (or a follow-up non-readonly pass), within the **5-cycle** cap
2. Escalates **ask-you** findings to the user
3. Re-runs build/test if auto-fixes landed
4. If still red after 5 auto-fix cycles → block ship and ask-you with remaining failures

If Task/subagents are unavailable, fall back to parent review but **say so** in the outcome summary (`diff review: parent-fallback`).

### 6. Ship

Gate first (max **5** auto-fix cycles). Only if green (or bypassed), resolve **ship posture** from `SKILL.md`:

| Posture | Triggers | Action |
|---------|----------|--------|
| **push** | “push”, “ship it” | Commit if needed → push. No PR unless also requested. Blocked gate → no push. |
| **pr** | “create the PR”, “open a PR” | Commit if needed → push → `gh pr create`. Blocked gate → no push/PR. |
| **hold** | “ready for review”, “gate”, “don’t push yet”; bare `/no-mistakes` / “run the gate” | No push, no PR. Summarize and wait. |

When a ship or auto-fix step **executes** a delete/wipe/force/history rewrite, follow skill `destructive-actions` (permission should already be cleared by the early scan when predictable).

## Outcome summary (required)

End with a compact block, for example:

```
no-mistakes: PASS | FIXED | BLOCKED | BYPASSED
Mode: validate-only | task-first
Ship posture: push | pr | hold
Destructive plan: none | Tier A (N) | waiting Tier B/C | cleared
Intent: <one line>
Checks:
  - build/test: pass | fail (detail)
  - style: pass | fixed | n/a
  - diff review: pass | N auto-fix | N ask-you (subagent:<model> | parent-fallback)
Ask-you: <none | list>
Ship: pushed <ref> | PR <url> | held for your review | not shipped (reason)
```
