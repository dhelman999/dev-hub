# Global agent memory (David Helman)

Keep this file short. Everything here is loaded into every session across projects.
Put procedural / conditional knowledge in skills under `C:\Projects\dev-hub\agent\skills\`, not here.

## Communication

- Prefer plain ASCII dashes (`-`) over em dashes in prose you write for me (PR descriptions, commit messages, docs).
- Be direct and concise. Do not pad responses.
- Never add `Co-authored-by: Cursor <cursoragent@cursor.com>` (or any agent co-author trailer) to commits. See skill `java-coding-style`.

## How to work with me

- Prefer outcomes and the why over micro-instructions. Act like a capable engineer given a goal, not a typist given keystrokes.
- In Agent mode: **never ask permission to edit files** — just do the work. For deletes/wipes/history rewrite, follow skill `destructive-actions` (Tier C needs `yes authorize permanent deletion`).
- When I correct a mistake, update the relevant project `AGENTS.md` or extract a skill so it does not repeat.
- Do not take back control by doing work manually that an agent should retry with better guidance.

## Path conventions

- Dev tools → `C:\Programs\<tool>` when the installer allows a custom path.
- Git clones / project repos → `C:\Projects\<name>` (never Desktop/Documents/home root).
- Public hub (machine + shared AI) → `C:\Projects\dev-hub`. Apply with `.\machine\rebuild.ps1 -Target Dev|Agent|All`.
- Optional private personal skills → `C:\Projects\dev-hub-personal` (may be absent). Never commit PII into `dev-hub`.
- Installer exceptions (Program Files / Local\Programs) → document in `dev-hub\docs\PATHS.md`.

## Reproducibility (hard rule)

Anything that changes the **dev environment**, **agent harness**, or **agentic engineering** workflow must be checked for hub inclusion: land it under `C:\Projects\dev-hub` (skills, `dotfiles\`, `machine\*.ps1`, `packages.yaml`, docs) so `bootstrap` / `rebuild` can regenerate another machine. Do not leave one-off machine-only tweaks undocumented. Details: skill `agentic-harness`. If there is a good reason to not do this rule, say an extremely specific tool/program that isn't really necessary (such as OpenWhispr), make sure to document/state that this was excluded.

## Privacy (hard rule)

Never commit passwords, tokens, claim IDs, financial figures, medical data, home address, or other PII into `dev-hub` or any public repo. Personal skills belong in `dev-hub-personal` only.

## Technical decisions

- **Reuse before invent (any language):** search the repo and its current dependencies for an existing helper, utility, abstraction, algorithm, or pattern before writing a new one; extend it and match the surrounding style instead of forking a near-duplicate. Procedure: skill `java-coding-style` → "Reuse before invent".
- Do not overweight human-era development cost when choosing designs. Agents can implement ambitious options quickly; bias toward quality, clarity, and maintainability.
- For bugfixes: reproduce end-to-end in a setting close to the user experience before patching. Prefer E2E checks over unit tests alone when guarding product behavior.

## Project pointers

- Default Agent-mode execution style: skill `agent-workflow`.
- Production planning (opt-in PRD/spec/tickets/TDD): `/production-planning` or `/prd` `/spec` `/tickets` `/prime` `/validation-tdd`. GATE interview; offer the next skill; do not write the chain from assumptions. Default is solo Plan → implement → no-mistakes; do not volunteer the chain.
- Cost / context / model phases: skill `context-engineering`.
- High-risk or design-locking claims: skill `grounding` (look up or state the assumption; not a hard gate).
- Parallel agents (Cursor captain/crew): skill `captain-crew`.
- Skill catalog reminder: `/skills` or `/list` (skill `skills`).
- Java formatting / compile conventions: skill `java-coding-style`.
- Unfamiliar language / framework (live coding, take-home, new repo): skill `stack-context` (`/stack-context`).
- Hub layout and tooling: skill `agentic-harness` (canonical: `C:\Projects\dev-hub`).
- Deletes / wipes / force-push: skill `destructive-actions`.
- Personal GitHub: **dhelman999** (`gh` already authenticated). Clone/commit/push only when asked; see `agentic-harness` → `references/github-dhelman999.md`.
- **Do not put project-specific rules here** (paths, compile recipes, repo quirks, one-off workflows). Keep this file global and short. Put those in the **local project's** `AGENTS.md` / docs, or in a **skill** that loads when that context is needed.
