---
name: prime
description: >-
  Load relevant codebase context for a named production ticket or spec before
  implementing. Explicit invoke only: /prime, "prime this ticket", "prime the
  codebase for T03". Do not run at the start of ordinary chats or generic
  implement/fix requests. disable-model-invocation keeps this human-gated.
disable-model-invocation: true
---

# Prime (load context for a ticket)

Human-invoked inner-loop start. Ground the next implementation in the **actual repo**, not a generic plan.

If this chat was not started with `/prime` or an explicit prime-this-ticket ask, **stop**. Do not prime every conversation.

## Input

Need a ticket id or path (`docs/planning/<slug>/tickets/T<nn>-*.md`) or a spec path. If missing, ask once.

## What to do

1. Read the ticket (and PRD/spec sections it points at).
2. Search/read only the files and tests likely involved. Follow skill `context-engineering`: narrow retrieval, not a repo dump.
3. Summarize in chat (and optionally `docs/planning/<slug>/prime-T<nn>.md`):
   - Current behavior and where it lives
   - Extension points / traps
   - Tests that already cover the area
   - Suggested first edit
4. Stay read-mostly. **Do not implement** unless the user already said to implement after priming.

## After priming

Offer the next opt-in step: `/validation-tdd` (tests-first plan or failing tests), then implement. Ship still uses `no-mistakes`.
