# Finding classes (auto-fix vs ask-you)

Mirror Kun’s gate split for the Cursor soft gate.

| Class | Meaning | Agent behavior |
|-------|---------|----------------|
| **auto-fix** | Mechanical, low-risk, does not change product intent | Fix, re-run the relevant check, continue — no pause |
| **no-op** | Informational; already fine | Mention in outcome summary only |
| **ask-you** | Challenges intent, product behavior, or safety | **Stop**; quote `id`/file/description plainly; wait for approve, fix guidance, or skip |

## auto-fix examples

- Failing unit/integration tests caused by the change (and fixable in scope)
- Java style: braces/`else` layout, Spring injected-collaborator `this.`, related-constant blank lines, import order, trailing whitespace
- Unused imports, obvious compile errors from the edit
- Test mocks missing a new constructor dependency the agent introduced

## ask-you examples

- Changing public API contracts or HTTP status semantics beyond the request
- Deleting features, endpoints, or data paths the user did not ask to remove
- Security: secrets in diff, auth bypass, weakening validation
- “Is this the intended behavior?” / large refactors beyond the ask
- Risky git: force push, hard reset, dumping unrelated WIP onto default branch

## Rules

- Never treat an **ask-you** finding as auto-fix.
- Never use **auto-fix** to expand scope or reinterpret the user’s goal.
- Under explicit user bypass (`skip no-mistakes`), skip the checklist entirely — do not reclassify findings to sneak past.
