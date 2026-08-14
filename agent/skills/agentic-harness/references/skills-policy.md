# Skills install policy

## Commands

```powershell
npx skills find <query>
npx skills add <owner/repo> --list
npx skills add <owner/repo> --skill <name> -g -a cursor -a claude-code --copy -y
npx skills list -g
```

Discover: https://skills.sh

## Policy (why)

- Skills run with full agent permissions — treat third-party skills as code execution
- Do **not** `npx skills add … --all`
- Do **not** install viral “make agents better” packs without published evals
- Curated install already present: `skill-creator` (`anthropics/skills`)

## Skills in the public hub

Canonical directory: `C:\Projects\dev-hub\agent\skills`

- `agent-workflow`
- `java-coding-style`
- `agentic-harness`
- `context-engineering` (cost / cache / retrieval / phase routing)
- `grounding` (risk-based RAG / assumption trail; not a hard gate)
- `captain-crew` (Cursor-native parallel captain/crew)
- `lavish` (HTML annotate review via lavish-axi; upstream kunchenguid)
- `usage-canvas` (Cursor quota meters via quota-axi + `/usage`)
- `skills` (human `/skills` or `/list` — one-line catalog)
- `no-mistakes` (Cursor soft gate; Go binary still deferred)
- `destructive-actions` (delete/wipe/force-push permission tiers)
- `skill-creator` (upstream; do not rewrite casually)
- `production-planning` (opt-in orchestrator: PRD → spec → tickets; `/production-planning`)
- `prd`, `spec`, `slice-tickets`, `prime`, `validation-tdd` (standalone; explicit invoke / slash only)

## Personal skills (private companion)

Canonical directory: `C:\Projects\dev-hub-personal\skills` (optional)

- `sc-unemployment-help`
- `honda-accord-2008-maintenance`

Linked into the public skills folder by `link.ps1` only when the personal hub is present. Never commit these into `dev-hub`.
