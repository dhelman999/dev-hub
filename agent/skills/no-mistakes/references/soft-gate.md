# Soft gate checklist

## UX: run-then-report

1. Announce skill + mode (+ bypass hint) — see `SKILL.md`.
2. Run mechanical steps back-to-back; apply **auto-fix** without pausing.
3. Pause **only** on **ask-you** findings.
4. Emit an **outcome summary**, then ship only if green (or user bypassed).

Do **not** wait for approve after each step unless the user said “gate step by step” for this run.

## Steps

### 1. Intent

State in 2–4 sentences what the user set out to accomplish (goal + tradeoffs),
not a file list. Use this when classifying ask-you vs deliberate choices.

### 2. Scope / branch

- Prefer a **feature branch** for ship/PR work.
- **ask-you** if about to force large WIP onto `main`/`master`/`develop` in an unusual way, or push secrets / destructive history.

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
- Finding classes from `finding-classes.md` (auto-fix / ask-you / no-op)
- Required return format: a list of findings `{class, severity, file, line?, description}` plus a one-line overall verdict

**Parent agent then:**

1. Applies **auto-fix** findings itself (or a follow-up non-readonly pass)
2. Escalates **ask-you** findings to the user
3. Re-runs build/test if auto-fixes landed

If Task/subagents are unavailable, fall back to parent review but **say so** in the outcome summary (`diff review: parent-fallback`).

### 6. Ship

Only if gate is green (or bypassed):

- Commit only when the user asked (git rules)
- Push / `gh pr create` when that was requested

## Outcome summary (required)

End with a compact block, for example:

```
no-mistakes: PASS | FIXED | BLOCKED | BYPASSED
Mode: validate-only | task-first
Intent: <one line>
Checks:
  - build/test: pass | fail (detail)
  - style: pass | fixed | n/a
  - diff review: pass | N auto-fix | N ask-you (subagent:<model> | parent-fallback)
Ask-you: <none | list>
Ship: pushed/PR <url> | not shipped (reason)
```
