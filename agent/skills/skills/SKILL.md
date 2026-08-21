---
name: skills
description: >-
  List every installed skill with a one-line summary. Use only when the
  user types /skills, /list, "list skills", "what skills do I have", or asks
  for a skill catalog reminder. disable-model-invocation keeps this human-only.
disable-model-invocation: true
---

# List skills (`/skills` / `/list`)

Human-invoked catalog. Do **not** auto-run this mid-task.

## What to do

1. Scan skill directories on this machine (each must contain `SKILL.md`).
   Typical Cursor/Claude locations: `~/.cursor/skills`, `~/.claude/skills`,
   `~/.agents/skills`, plus any hub skills folder the environment documents.
   If a hub path is configured, prefer that canonical tree.
   Do **not** scan `dev-hub-personal` as a fallback to re-add omitted skills.
2. For each folder, read YAML frontmatter:
   - `name` (fallback: folder name)
   - `description` — compress to **one short line** (first sentence or ~12 words; strip “Use when…” fluff)
   - Skip any skill with `hide-from-catalog: true` (interview / screen-share). Do not name skipped skills in the list, the count, or a “hidden” footnote.
3. Skip this skill itself in the list, or include it once as `skills — list installed skills (/skills)`
4. Sort by name
5. Reply with a compact list only — no essays:

```text
Skills (N)
- name — one-line summary
- ...
```

Mark personal/private junctions lightly if obvious (e.g. `honda-… (personal)`).

Optional footer one-liner: `Invoke: /skills or /list`

## Do not

- Dump full SKILL.md bodies
- Install or remove skills
- Suggest `npx skills add --all`
