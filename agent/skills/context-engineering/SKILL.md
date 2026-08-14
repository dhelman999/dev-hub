---
name: context-engineering
description: >-
  Cost-aware agent context: phase-stable model routing, prompt-cache hygiene,
  retrieval discipline (4 docs not 40), usage/quota mindset, and when batch/
  overnight lanes apply. Use whenever the user mentions AI cost, token burn,
  context window, prompt caching, model routing, cheaper models, Composer vs
  Opus, quota, usage dashboard, context engineering, or wasteful retrieval —
  even if they only say "this chat is getting expensive" or "use a smaller
  model." Prefer this over inventing ad-hoc cost tips. Workplace-portable.
---

# Context engineering

Treat **context size, model hops, and retrieval breadth** as first-class costs — not afterthoughts.

This skill is harness-agnostic enough for a future workplace; Cursor-specific notes are marked **(Cursor)**.

## Cost drivers (what actually burns money)

1. **Repeated large prefixes** — system memory, rules, tool schemas resent every turn (caching helps only if the prefix stays byte-stable).
2. **Oversized retrieval** — dumping 40 files when 4 matter.
3. **Mid-task model switching** — often **destroys prompt cache**; a hot expensive model can beat a cold cheap one.
4. **Tool / MCP churn mid-session** — mutating available tools reshapes the prompt and breaks cache affinity.
5. **Long chat history** — unfocused threads accumulate junk context.

## Phase-stable model routing

Route **once per phase**, not per tool call.

Read the table as **Do** vs **Don’t** (the Don’t column is anti-patterns — never treat those cells as advice to follow).

| Phase | Do (prefer) | Don’t (anti-pattern) |
|-------|-------------|----------------------|
| Clarify / architecture / hard debug | Stay on a **stronger** model for plan depth | Switch models every reply (“jumping”) — burns cache and coherence |
| Implement / boilerplate / mechanical edits | Use a **fast capable** model (e.g. Composer; turn **fast off** if quality slips) | Default these edits to Opus / frontier — overkill and expensive |
| Explore / map codebase | Cheap/fast subagents **(Cursor)** | Parent model reading the whole tree alone |
| Ship gate (`no-mistakes`) | Cost-aware default in that skill | Escalate to frontier unless stuck |

**(Cursor)** Plan mode already scouts with explore subagents — let that happen; keep the **parent** model stable for the plan itself.

If the user names a model, obey. If they ask to “route cheaper,” change at a **phase boundary** (after plan approved, before implement), and say so in one line.

Details: `references/phase-routing.md`.

## Prompt-cache hygiene

You cannot flip provider caching on from here, but you **can** preserve hit rate:

- Keep global `AGENTS.md` **short**; put procedures in skills (progressive disclosure).
- Do **not** rewrite always-on rules or tool lists mid-session for convenience.
- Prefer stable skill bodies over pasting the same essay into every reply.
- Avoid stuffing timestamps, random IDs, or “today’s date” into the *prefix* of repeated instructions.

Do / don’t: `references/cache-hygiene.md`.

## Context discipline (retrieval)

Default posture: **narrow then widen**.

1. Search (Grep/Glob) with a tight pattern.
2. Read only the hits that matter (with line limits).
3. Use explore subagents for breadth; summarize back — do not paste raw trees into the parent thread.
4. Cap “related files” — if you need more than ~4–6 substantive files, justify why.

Anti-patterns: whole-repo `@` dumps, reading every matcher “just in case,” expanding archives into chat.

**When** to retrieve at all is skill **`grounding`** (risk-based RAG, assumption trail if docs are missing). This section is **how narrow** once you have decided to look.

## Usage visibility (not fake $/task)

**(Cursor Pro+)** Exact cost-per-solved-task is usually unavailable. Prefer:

- Quota / usage windows (future: `quota-axi` — Phase 2)
- Qualitative labels: phase, model, rough scope (files touched)

Do **not** invent dollar figures. Workplace API workloads can log real tokens later.

## Batch / overnight lanes

Interactive chat is a bad batch API. Defer non-interactive bulk work to overnight/SDK patterns (`gnhf`-class — still Phase 4 in this hub). For now: do not spin huge unattended loops inside a single Cursor chat without the user asking.

## Workplace portability

Same principles apply with Claude Code, Codex, or internal agents:

- Small always-on memory
- Skills over mega-prompts
- Phase-stable models
- Narrow retrieval
- Measure usage when the platform allows

Hub layout specifics stay in skill `agentic-harness`.
