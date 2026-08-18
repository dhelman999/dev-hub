# Soft gate checklist

## UX: run-then-report

1. Announce skill + mode (+ bypass hint) — see `SKILL.md`.
2. **Early destructive plan scan** (skill `destructive-actions`) — before long build/test/review.
3. Run mechanical steps back-to-back; apply **auto-fix** without pausing (**max 5** fix/re-check cycles — see `finding-classes.md`).
4. Pause **only** on **ask-you** findings, Tier B/C destructive permission waits, or when the auto-fix cap is hit. Confirmed **secrets** or **PII** before §5 → skip the dedicated review subagent (do not launch it).
5. Emit an **outcome summary**, then apply **ship posture** (`push` / `pr` / `hold`) only if green (or user bypassed). **hold** means stop with no push/PR.

Do **not** wait for approve after each step unless the user said “gate step by step” for this run — **except** Tier B/C from `destructive-actions` (must clear up front).

## Steps

### 1. Intent

State in 2–4 sentences what the user set out to accomplish (goal + tradeoffs),
not a file list. Use this when classifying ask-you vs deliberate choices.

### 1a. Ground (non-blocking)

Load skill **`grounding`** only if the intent rests on a claim that could be wrong: an API/CLI signature, product behavior, framework version, or a design decision this ship locks in.

Look it up, or write `Assumption (unverified): …` and continue. This is **never** a stop, and it is not a research phase — it runs here, before expensive checks, so a wrong premise is caught before tests and a review subagent are spent on it.

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

### 2b. Early safety skip (secrets / PII)

Before launching §5, glance at the working-tree / PR diff for **secrets**
(passwords, API tokens, private keys) and **PII** (see `finding-classes.md`).
If either is **confirmed**:

1. **Stop.** Quote the finding. Do not push/PR.
2. **Do not launch** the dedicated review subagent (§5). Independent
   confirmation is not worth the tokens once ship is already blocked.
3. Emit the outcome summary as **BLOCKED** with
   `Diff review: skipped-early-safety`.
4. Wait for approve / fix guidance / skip.

Do **not** skip §5 for other ask-you (intent, public API contract, “is this
the intended behavior?”). Those still need the unbiased reviewer.

On confirmed secrets/PII, §5 is the mandatory skip. Build/test/style may be
omitted (`n/a`) or finished if already cheap / in flight; do not start new
expensive work.

If secrets/PII are first found **by** the §5 subagent, treat as ask-you as
usual (that spend already happened).

### 3. Build and test

Discover how **this repo** proves the change. Do not keep a project-name
command table in this skill.

1. Prefer the project's own docs (`README`, `AGENTS.md`, `CONTRIBUTING`, `scripts/`).
2. Else run the standard command for the stack that is actually present:
   `mvnw`/`mvn test`, `npm test`/`pnpm test`/`yarn test`, `go test ./...`,
   `dotnet test`, `cargo test`, `pytest`, and similar.
3. If no test/build command is discoverable, say so in the outcome summary
   (`build/test: n/a — no project recipe`) rather than inventing one.

Failing tests from this change → **auto-fix** → re-run. Cannot fix → **ask-you** or block ship.

### 4. Style

- Follow the repo's formatter and style skill/docs if present.
- Mechanical style violations → **auto-fix**.
- The style skill's conventions include **reuse before invent** — catch obvious duplicates of an existing helper, utility, or pattern here and swap in the existing one (**auto-fix**). The §5 reviewer scans deeper (`finding-classes.md` → Reinvented code).
  - A reuse swap **changes behavior**, unlike formatting: **re-run build/test** after it (counts as a fix cycle). Never leave a swap as the last edit before ship with stale green tests.
- Parent agent may apply style; do not rely on this for deep review.

### 5. Diff review (dedicated subagent)

**Skip this step** when §2b already confirmed secrets or PII
(`skipped-early-safety`). Do not launch a reviewer “for completeness.”

**Do not** have this chat’s implementation context be the sole reviewer. The same
agent that wrote the code is biased and context-diluted.

Launch a **Task** subagent for review:

| Setting | Value |
|---------|--------|
| `subagent_type` | `generalPurpose` (or `explore`) |
| review-only | No `readonly` parameter exists — say it in the prompt: **read and report, do not edit files**. Parent applies fixes |
| `model` | **Default:** newest Grok on this session’s Task `model` list (prefer a `fast` slug of that same version if both exist). Else newest Composer. **Escalation only:** newest Claude Opus thinking tier on that list when the diff is large, cross-cutting, or security-sensitive, or the user asks for a deep review. **Never** copy a versioned slug from this file or from a prior chat |
| `run_in_background` | `false` unless the user wants async |

**How to pick** (do this every gate; do not reuse last week’s slug):

1. Read the Task tool’s `model` enum **in this session**. Only those strings are legal.
2. Collect Grok slugs (`cursor-grok-*` or similar). If any exist, pick the **highest version number** (4.6 beats 4.5). If that version has both `fast` and `high`, prefer `fast` for a routine gate. **Do not** pick an older Grok because it has `fast` or `high` in the name.
3. If no Grok, pick the newest Composer slug the same way.
4. Escalate to the newest Opus thinking slug only when the bar above is met.
5. If a chosen slug is rejected, take the next newest in that family. Never fall back to a remembered slug that is not on this session’s list (`cursor-grok-4.5-high` is wrong once 4.6 is listed).

Prefer Grok or Composer for normal no-mistakes runs (cost/quota). Do not default to Claude Sonnet/Opus or OpenAI models for the review subagent unless the user asks or the escalation bar above is met.

**Prompt the subagent with:**

- Repo path + branch
- User **intent** (from step 1)
- How to get the diff (`git diff` / `git diff base...HEAD` / PR range)
- Finding classes from `finding-classes.md` (auto-fix / ask-you / no-op) — explicitly scan for **secrets** and **PII / personal identifying information** (ask-you; see finding-classes)
- **Reinvented-code scan** (required): for every new helper, utility, abstraction, algorithm, or pattern in the diff, check whether the repo or an existing dependency already provides it, and whether it matches how neighboring code solves the same problem (`finding-classes.md` → Reinvented code)
- **False-green test scan** (required): for every new/changed test, judge whether it would still pass if the production change were reverted or the expected value inverted. Report weak assertions, mock-asserting-mock, tautologies, swallowed failures, over-mocked units, skipped/empty tests (`finding-classes.md` → False-green tests)
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
| **pr** | “create the PR”, “open a PR” | Commit if needed → push → `gh pr create`. **Paste the outcome summary block into the PR body** so the gate record outlives the chat. Blocked gate → no push/PR. |
| **hold** | “ready for review”, “gate”, “don’t push yet”; bare `/no-mistakes` / “run the gate” | No push, no PR. Summarize and wait. |

When a ship or auto-fix step **executes** a delete/wipe/force/history rewrite, follow skill `destructive-actions` (permission should already be cleared by the early scan when predictable).

## Outcome summary (required)

Always end a no-mistakes run with a compact block so the captain can see that the
gate ran and what it did. Fill every field (use `0` / `n/a` / `none` when empty).

**Ordering:** compose the block **before** shipping (posture `pr` needs it for the
PR body), then fill `Ship:` with the actual result. The PR-body copy cannot contain
its own URL — write `Ship: PR (this one)` there and keep the URL in the chat copy.

**Durability:** chat is not a record. On ship posture **pr**, paste this block into
the **PR body** (not the commit message). On **push** or **hold**, leave it in
chat only. **Never** append the block to a commit message — it is noisy and the
model slug goes stale.

```
no-mistakes: PASS | FIXED | BLOCKED | BYPASSED
Mode: validate-only | task-first
Ship posture: push | pr | hold
Auto-fix cycles: <used>/<max 5>
Issues auto-fixed: <count>  (tests / style / review mechanical — brief list OK)
Ask-you raised: <count>  (none | N — listed below)
Destructive plan: none | Tier A (N) | waiting Tier B/C | cleared
Diff review: subagent:<model> | parent-fallback | skipped-early-safety
Intent: <one line>
Checks:
  - build/test: pass | fail (detail)
  - style: pass | fixed | n/a
  - diff review: pass | N auto-fix | N ask-you | skipped-early-safety
Ask-you: <none | short list>
Ship: pushed <ref> | PR <url> | held for your review | not shipped (reason)
```

### Field notes

| Field | Meaning |
|-------|---------|
| **PASS** | Green with no auto-fixes needed |
| **FIXED** | Green after one or more auto-fixes (still ship-eligible) |
| **BLOCKED** | Red, ask-you pending, or hit the **5-cycle** auto-fix cap |
| **BYPASSED** | User skipped the gate |
| **Auto-fix cycles** | How many fix→re-check loops ran, out of **5**. Example: `2/5`. Cap hit → `5/5` and usually **BLOCKED** |
| **Issues auto-fixed** | Count of distinct mechanical findings actually fixed this run (not cycles). Optional one-line examples: `3 (2 style, 1 test)` |
| **Ask-you raised** | Count of findings that paused for the user |
| **Diff review** | `subagent:<model>` when §5 ran; `parent-fallback` if Task was unavailable; `skipped-early-safety` when §2b confirmed secrets/PII and §5 was not launched |

Keep the block short — scannable in chat, not a second review essay.
