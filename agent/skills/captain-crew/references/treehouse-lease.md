# Treehouse leases (Phase 3)

[treehouse](https://github.com/kunchenguid/treehouse) pools git worktrees so parallel crew can edit without colliding on the same checkout.

## Install (hub)

- Soft-checked / soft-installed by `machine/Ensure-Treehouse.ps1` on Agent rebuild
- Binary: `%LOCALAPPDATA%\treehouse\treehouse.exe` (official Windows layout; PATHS exception vs `C:\Programs`)
- Manual: `irm https://kunchenguid.github.io/treehouse/install.ps1 | iex`

## When to lease (default: **do not**)

Treehouse is for **conflicting writers**, not a default for every crewmate. Prefer the main checkout unless isolation is necessary — extra leases cost commands, tokens, and pool state.

| Situation | Lease? |
|-----------|--------|
| Solo agent | **No** — main repo |
| Read-only explore / search / review crew | **No** — main repo |
| Parallel crew with **non-overlapping** file ownership (clear paths, no shared files) | **No** — main repo; name the owned paths in each Task prompt |
| Two+ writers that **may touch the same files**, or ownership is unclear | **Yes** — one lease **per writer** |
| One writer + many readers | **No** for readers; writer stays on main unless another writer exists |
| Captain unsure | **No** — serialize writers or tighten file ownership first; lease only if they still must edit in parallel and overlap is likely |

**Guarantee (playbook, not a binary lock):** captain-crew and this doc say **lease is opt-in**. Agents must not lease “just in case.” If a crewmate was dispatched without a leased path, it edits the main repo only.


## Agent commands (from the **main repo** cwd)

```powershell
# Lease (stdout = JSON when --json; banners on stderr)
treehouse get --lease --json --lease-holder "crew-<short-task>"

# Status
treehouse status
treehouse status --json

# Release when the crewmate is done (or after merge) — use the ABSOLUTE path
treehouse return C:\Users\<you>\.treehouse\<pool>\N\<repo>
```

**Windows / Cmder:** `treehouse status` may print `~\.treehouse\...`. That tilde is **not** expanded. Passing it to `return` becomes a bogus relative path under the repo (e.g. `C:\Projects\foo\~\.treehouse\...`) and fails with “not managed by treehouse.” Always use the absolute `path` from `--json`, or expand yourself:

```powershell
treehouse return "$env:USERPROFILE\.treehouse\java-interview-drills-c51b71\1\java-interview-drills"
```

PowerShell tip: capture JSON cleanly:

```powershell
$lease = & treehouse get --lease --json --lease-holder "crew-fix-auth" 2>$null | ConvertFrom-Json
$path = $lease.path
# … dispatch crew with working_directory / repo path = $path …
& treehouse return $path 2>$null
```

## Captain-crew integration

1. Decompose into non-overlapping tasks when possible.
2. If writers may conflict → before dispatch, `get --lease` per writer; put the **leased path** in the Task prompt as the only cwd to edit.
3. Label `--lease-holder` with a short crew id so `status` is readable.
4. After crew finishes (or captain merges), `return` each path. Do not leave leases hanging across days without reason.
5. Brief the captain with leased paths if they need to open a worktree manually.

## Do not

- Run interactive `treehouse` / `get` (subshell) from agents — use `--lease` / `--print-path`
- `destroy --yes` unless the user asked (destructive-actions)
- Promise Firstmate-style tmux panes — Cursor Agents Window + worktrees only
