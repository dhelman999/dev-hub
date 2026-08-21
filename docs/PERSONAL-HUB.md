# Optional personal hub

Public `dev-hub` must not contain PII, passwords, claim IDs, financials, medical data, or home/vehicle specifics.

The **Dev** (machine) and **Agent** (playbook) harnesses both live in public `dev-hub`. This companion is only the private overlay: PII skills, personal/work/interview diagrams, and personal `AGENTS.md` bullets. It is not a second `rebuild.ps1`. Harness workflow boards (two-loop, no-mistakes) live in public [`docs/diagrams/`](diagrams/README.md).

Personal content lives in a **private** companion repo:

| | |
|--|--|
| Local | `C:\Projects\dev-hub-personal` |
| Remote | https://github.com/dhelman999/dev-hub-personal (private) |
| Skills | `skills\<skill-name>\` (same shape as public skills) |
| AGENTS overlay | `agent\AGENTS.overlay.md` |
| Generated memory | `generated\AGENTS.md` (gitignored; Cursor live file) |
| Dictation vocabulary | `agent\openwhispr-dictionary.txt` (employers, recruiters, pipeline names) |

## Behavior

`.\machine\rebuild.ps1 -Target Agent` (or `All`):

1. Always junctions `~\.cursor\skills` (and Claude / agents twins) → `dev-hub\agent\skills`.
2. If `C:\Projects\dev-hub-personal\skills` exists, creates a **per-skill junction**  
   `dev-hub\agent\skills\<name>` → `dev-hub-personal\skills\<name>` — except skills whose `SKILL.md` has `hide-from-catalog: true` (those stay private-hub-only so they do not appear in Cursor discovery or `/skills`; attach/`@` the file when needed). Existing junctions for hidden skills are removed on apply.
3. If `dev-hub-personal\agent\AGENTS.overlay.md` exists, `Merge-AgentsMd.ps1` appends overlay bullets into matching `##` sections of public `agent\AGENTS.md`, writes `dev-hub-personal\generated\AGENTS.md` (gitignored), and hardlinks `~\AGENTS.md` (and Claude twins) to **that** generated file. Cursor loads `~\AGENTS.md` only. The overlay is not live until this apply.
4. If `dev-hub-personal\agent\openwhispr-dictionary.txt` exists, `Apply-OpenWhisprDictionary.ps1` merges it with the portable public list into the local OpenWhispr DB. Employer, recruiter, and live-pipeline spellings belong only in the private list.
5. If the personal hub or overlay file is missing, the steps above are skipped as needed. `~\AGENTS.md` stays hardlinked to public `dev-hub\agent\AGENTS.md`. Public Agent apply still succeeds.

Do **not** splice private bullets into the git-tracked public `AGENTS.md`. That file is the portable template. A hardlink to it would make `git commit` in `dev-hub` publish PII.

## Clone (optional)

```powershell
git clone https://github.com/dhelman999/dev-hub-personal.git C:\Projects\dev-hub-personal
cd C:\Projects\dev-hub
.\machine\rebuild.ps1 -Target Agent -SkipPackages
```

## Day-to-day

| Task | Where |
|------|--------|
| Edit an existing personal skill | `C:\Projects\dev-hub-personal\skills\<name>\` (live via junction) |
| Add a **new** personal skill folder | Create under personal `skills\`, then re-run Agent apply above |
| Portable global memory | public `dev-hub\agent\AGENTS.md`, then Agent apply if an overlay is in use (regenerates the live file) |
| Private global memory (jobs, names, PII) | `dev-hub-personal\agent\AGENTS.overlay.md`, then Agent apply |
| Dictation names OpenWhispr mangles | `dev-hub-personal\agent\openwhispr-dictionary.txt`, then Agent apply |
| Commit / push personal changes | Only in `dev-hub-personal` (private remote). Never commit `generated/` |

Do not edit `~\AGENTS.md` by hand. When the overlay exists it is generated and the next apply overwrites it.

## Agent policy

- Never commit personal overlays into `dev-hub`.
- Never copy personal skill trees into public git history.
- Put new PII-bearing skills only under `dev-hub-personal`.
- Do not name `hide-from-catalog` skills in public hub files (`.gitignore`, skill lists, READMEs). Gitignore only **linked** personal folders.
