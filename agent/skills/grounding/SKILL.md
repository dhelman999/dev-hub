---
name: grounding
description: >-
  Risk-based grounding (RAG): look up repo files, hub skills, or official docs
  before answering when being wrong is high-risk or would lock a design; if
  docs cannot be found, state the assumption and continue. Use whenever the
  agent might answer from training data about APIs, CLIs, product UI, Cursor
  behavior, architecture, security, money, legal, or "how does X actually work"
  — even if the user does not say RAG, retrieve, hallucinate, verify, look up,
  documentation, or grounding. Skip lookup only when confidence is high and
  consequences are low. Prefer this over inventing behavior from memory.
---

# Grounding (risk-based RAG)

Not a hard gate. Do not stop the task. Do not ask permission to look something up.

If **confidence is high** (training data or a guess looks solid) **and** being wrong is **low consequence**, answer and move on. Do not search the web for every identifier.

If **risk is high**, **or** being wrong would **lock a design**, retrieve first. How narrowly to retrieve is skill `context-engineering` (4 docs, not 40). This skill is **when**.

## When to retrieve

Retrieve (repo, hub, official docs, or a runtime check) when any of these are true:

- Product / UI / CLI / API behavior that changes across versions (Cursor surfaces, flags, OAuth, vendor APIs)
- A design call that is expensive to reverse (auth model, data store, public API shape)
- Security, money, legal, medical, PII, or destructive git/fs operations
- “Does X exist / how does X actually work?” where a wrong yes/no would mislead
- The claim is not already sitting in files you just read this turn

Skip retrieve when:

- You just read the source of truth (the function, ticket, or skill body is in context)
- Mechanical edits inside code you already opened
- Low-stakes wording, naming, or restating the user’s last message

When unsure whether it is high-risk, retrieve. A short lookup is cheaper than a wrong architecture.

## Where to look (stop at the first solid hit)

1. This repo — Grep/Glob/Read, then run the command or test if that is the proof
2. Hub skills / `AGENTS.md` / project docs already in the tree
3. Official vendor docs (WebFetch a known URL, or WebSearch then fetch the doc page — not a random blog)
4. Runtime: `--help`, a probe, or the actual UI artifact

Do not cite a source you did not open. Training data is not a citation.

## If you cannot verify

Continue the work. Put this status in the user-visible reply (and keep it if you later write a ticket or PR):

```text
Assumption (unverified)
Could not find verifiable documentation so we are making an assumption:
<xyz>
```

Replace `<xyz>` with the concrete bet (one or two sentences). Then proceed on that bet.

Do not silently guess after a failed lookup. The trail is the point.

## What not to do

- Do not prepend “I verified…” on routine replies. Silence means it was low-risk or already grounded.
- Do not dump search snippets. One path or URL is enough if you used it.
- Do not turn this into a 10s poll or extra crew. One lookup pass, then assume or answer.
- Do not override `destructive-actions` or `no-mistakes`. Grounding does not authorize deletes or skips of the ship gate.

## Examples

| Situation | Action |
|-----------|--------|
| “What does this function I have open return?” | Answer from the file. No RAG. |
| “How does the Agents Window show nested crew?” | Look up Cursor docs / hub `captain-crew` notes. If still unclear, `Assumption (unverified)` + continue. |
| “Should v1 use cron or a Sheet formula?” | Design lock — read the spec/PRD, do not invent from memory. |
| Rename a local test helper | No RAG. |

## Related

- Narrow retrieval / cost: skill `context-engineering`
- Hub layout: skill `agentic-harness`
- Ship checks: skill `no-mistakes`
- Deletes: skill `destructive-actions`
