---
name: stack-context
description: >-
  Establish language/framework context before the first real edit in an
  unfamiliar stack: detect the stack, pin the verify loop (format, lint,
  typecheck, test, build), then distill a short project-local rules file from
  repo evidence and official guides — with community rule packs
  (cursor.directory, awesome-cursorrules, skills.sh) as prunable draft only.
  Use whenever starting a live-coding assignment, take-home, or fresh repo in a
  language or framework this harness has no authority for, or when the user asks
  for "best practices for X", names cursor.directory, or wants rules set up for a
  new language — even if they only say "we're doing this one in Python" or "new
  repo, get oriented." Prefer this over pasting a rule pack wholesale; for Java
  formatting, skill `java-coding-style` stays the authority.
---

# Stack context (new language / unfamiliar stack)

Before the first non-trivial edit in a stack this harness has no authority for, spend **one short pass** establishing the contract: what the stack is, how it is verified, which conventions are decidable. Then code.

Capped on purpose — one lookup pass, not a research project. If nothing authoritative turns up, write `Assumption (unverified): …` and continue (skill `grounding`).

## Run / skip

**Run when:** fresh agent in an unfamiliar repo; live-coding or take-home in a language you do not use daily; a new framework inside a familiar language (Quarkus when your reflexes are Spring MVC); the user asks for best practices for a language or points at cursor.directory.

**Skip when:** Java work already covered by `java-coding-style` with known build commands; a one-line fix; you already did this pass in this chat (do not re-run per file).

## Authority order (resolve conflicts top-down)

1. **Repo evidence** — existing code, formatter/linter config, CI workflow, `README` / `AGENTS.md`. In someone else's repo, house style beats personal preference.
2. **Official guide / framework docs** for the pinned version.
3. **Local style skill** (`java-coding-style`) — authority for Java in this hub's own repos and drills; a community pack never overrides it.
4. **Community rule packs** — draft material, prune before use (`references/rule-pack-sources.md`).
5. **Nothing found** — assumption line, keep moving.

## 1. Detect the stack

Manifest, language version, framework, test framework, and whether this is greenfield or existing code. Detection table: `references/verify-loop.md`.

## 2. Pin the verify loop (the part that matters most)

Get the **exact commands** for format, lint/typecheck, test, and build, then run them once on the untouched repo so you know they were green before you touched anything.

Machine-enforced beats prose: a checked-in `spotless`/`eslint`/`ruff` config outranks any paragraph instructing the model to write clean code. Record the commands — `no-mistakes` uses them as its build/test step, `validation-tdd` as its criteria.

## 3. Distill, do not paste

Write a **short** project-local file: repo `AGENTS.md`, or `.cursor/rules/<stack>.mdc` if it should only apply in Cursor. Target ~40 lines: Stack, Verify commands, Conventions, Do-not, Assumptions.

Record **where shared helpers and utilities live** in this repo, and which utility libraries are already dependencies. That is what makes "reuse before invent" (global memory; skill `java-coding-style`) enforceable in an unfamiliar tree.

Keep a rule only if it is **decidable** (a reviewer could point at a violation), **non-default**, and **true for this repo**. Cut restatements of language defaults, unfalsifiable advice ("write clean, well-documented code", "adhere to SOLID"), framework choices this repo did not make, and anything the formatter already enforces.

Never paste a 1k+ token pack into always-on rules — that cost is paid every turn (skill `context-engineering`).

## 4. Say it out loud (when demonstrating the harness)

Two or three sentences before implementing: the stack and version you detected, the commands you will gate on, the conventions you pinned and where each came from. Then implement and let the gate run.

The point is that the agent's rules are **derived and checkable**, not vibes.

## Do not

- Let this become a research phase — one pass, then code
- Add a rule you cannot verify or would not enforce in review
- Trust a pack's framework opinion over the repo's `pom.xml` / `package.json`
- Skip step 2 because the tests "probably pass"
- Reformat files unrelated to your change to satisfy a newly found guide

## References

| Need | Read |
|------|------|
| Detect + verify commands per stack | `references/verify-loop.md` |
| Where to find packs, how to prune (Java packs as a pruning demo, not rules to install) | `references/rule-pack-sources.md` |
