# Optional personal hub

Public `dev-hub` must not contain PII, passwords, claim IDs, financials, medical data, or home/vehicle specifics.

Personal skills live in a **private** companion repo:

- Local: `C:\Projects\dev-hub-personal`
- Remote: https://github.com/dhelman999/dev-hub-personal (private)

## Behavior

`.\machine\rebuild.ps1 -Target Agent` (or `All`):

1. Always links public skills under `dev-hub\agent\skills`.
2. If `C:\Projects\dev-hub-personal\skills` exists, creates a **per-skill junction** from `dev-hub\agent\skills\<name>` → `dev-hub-personal\skills\<name>`.
3. If the personal hub is missing, step 2 is skipped with a message. Public apply still succeeds.

## Clone (optional)

```powershell
git clone https://github.com/dhelman999/dev-hub-personal.git C:\Projects\dev-hub-personal
cd C:\Projects\dev-hub
.\machine\rebuild.ps1 -Target Agent -SkipPackages
```

## Agent policy

Never commit personal overlays into `dev-hub`. Put new personal skills only under `dev-hub-personal`.
