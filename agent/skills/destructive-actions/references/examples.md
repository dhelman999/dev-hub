# Destructive-actions examples

## Tier A (minor — proceed if work was requested)

- Delete one obsolete file the user asked to remove
- `git restore` / discard a single uncommitted edit the user asked to undo
- Overwrite editor/user settings as part of an explicit apply/rebuild the user requested
- Delete stray `.class` files under `src/` while fixing a bad `javac`
- Harness wipe-test: remove a local tool install when the user clearly asked to delete it for regenerate testing

## Tier B (soft ask)

- Delete a whole directory of sources without a clear “delete this folder”
- Agent decides to “clean up” unrelated temp projects
- `git reset --soft HEAD~3` when user only said “fix the commit message”
- `git push --force-with-lease` to a feature branch when user only said “push”
- Ambiguous: “clean up the old stuff” with no path list

## Tier C (exact phrase required)

- `gh repo delete <owner>/<repo>`
- Recursively delete a whole projects/hub tree or wipe a user profile
- `git push --force` / `--force-with-lease` to `main` / `master` / `develop`
- `git filter-branch` / history rewrite already pushed to default branch
- Drop production database / wipe prod data

## Not Tier C

- Ordinary `git commit` + `git push` (no force) after `ship it`
- no-mistakes auto-fix editing files (not deleting repos)
- Recreating junctions / hardlinks (replace link, not mass-delete user data)
