# Global agent memory (David Helman)

Keep this file short. Everything here is loaded into every session across projects.
Put procedural / conditional knowledge in skills under `C:\Projects\dev-hub\agent\skills\`, not here.

## Communication

- Prefer plain ASCII dashes (`-`) over em dashes in prose you write for me (PR descriptions, commit messages, docs).
- Be direct and concise. Do not pad responses.

## How to work with me

- Prefer outcomes and the why over micro-instructions. Act like a capable engineer given a goal, not a typist given keystrokes.
- In Agent mode: **never ask permission to edit files** — just do the work. Ask only for truly irreversible actions (permanent deletion, destructive DB schema changes, force push / hard reset the user did not request).
- When I correct a mistake, update the relevant project `AGENTS.md` or extract a skill so it does not repeat.
- Do not take back control by doing work manually that an agent should retry with better guidance.

## Path conventions

- Dev tools → `C:\Programs\<tool>` when the installer allows a custom path.
- Git clones / project repos → `C:\Projects\<name>` (never Desktop/Documents/home root).
- Public hub (machine + shared AI) → `C:\Projects\dev-hub`. Apply with `.\machine\rebuild.ps1 -Target Dev|Agent|All`.
- Optional private personal skills → `C:\Projects\dev-hub-personal` (may be absent). Never commit PII into `dev-hub`.
- Installer exceptions (Program Files / Local\Programs) → document in `dev-hub\docs\PATHS.md`.

## Privacy (hard rule)

Never commit passwords, tokens, claim IDs, financial figures, medical data, home address, or other PII into `dev-hub` or any public repo. Personal skills belong in `dev-hub-personal` only.

## Technical decisions

- Do not overweight human-era development cost when choosing designs. Agents can implement ambitious options quickly; bias toward quality, clarity, and maintainability.
- For bugfixes: reproduce end-to-end in a setting close to the user experience before patching. Prefer E2E checks over unit tests alone when guarding product behavior.

## Project pointers

- Default Agent-mode execution style: skill `agent-workflow`.
- Java formatting: skill `java-coding-style` (Spring Framework Code Style + Helman tweaks: 4 spaces, blank before `if` after dense code).
- java-interview-drills (`C:\Projects\java-interview-drills`; GitHub: https://github.com/dhelman999/java-interview-drills): never bare `javac` from `src/`; use `scripts\compile-and-run.ps1` or `javac -d out\classes`.
- Hub layout and tooling: skill `agentic-harness` (canonical: `C:\Projects\dev-hub`).
- Personal GitHub: **dhelman999** (`gh` already authenticated). Clone/commit/push only when asked; see `agentic-harness` → `references/github-dhelman999.md`.
