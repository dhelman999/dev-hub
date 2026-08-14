# Optional personal hub

Public `dev-hub` must not contain PII, passwords, claim IDs, financials, medical data, or home/vehicle specifics.

The **Dev** (machine) and **Agent** (playbook) harnesses both live in public `dev-hub`. This companion is only the private overlay: PII skills and diagrams, junctioned in on Agent apply. It is not a second `rebuild.ps1`.

Personal skills live in a **private** companion repo:

| | |
|--|--|
| Local | `C:\Projects\dev-hub-personal` |
| Remote | https://github.com/dhelman999/dev-hub-personal (private) |
| Layout | `skills\<skill-name>\` (same shape as public skills) |

## Behavior

`.\machine\rebuild.ps1 -Target Agent` (or `All`):

1. Always junctions `~\.cursor\skills` (and Claude / agents twins) → `dev-hub\agent\skills`.
2. If `C:\Projects\dev-hub-personal\skills` exists, creates a **per-skill junction**  
   `dev-hub\agent\skills\<name>` → `dev-hub-personal\skills\<name>`.
3. If the personal hub is missing, step 2 is skipped with a message. Public Agent apply still succeeds.

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
| Commit / push personal changes | Only in `dev-hub-personal` (private remote) |

## Agent policy

- Never commit personal overlays into `dev-hub`.
- Never copy personal skill trees into public git history.
- Put new PII-bearing skills only under `dev-hub-personal`.
