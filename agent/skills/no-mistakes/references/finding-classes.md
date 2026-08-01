# Finding classes (auto-fix vs ask-you)

Mirror Kun’s gate split for the Cursor soft gate.

| Class | Meaning | Agent behavior |
|-------|---------|----------------|
| **auto-fix** | Mechanical, low-risk, does not change product intent | Fix, re-run the relevant check, continue — no pause. **Cap: 5** auto-fix cycles per gate run (see below) |
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

## Auto-fix iteration cap

- **Max 5** auto-fix cycles per no-mistakes gate run (a cycle = apply fix(es) + re-run the relevant check: build/test, style, or a follow-up review pass).
- If still not green after 5 cycles → **stop**, report `no-mistakes: BLOCKED` with what remains, and **ask-you** (do not keep burning tokens).
- Distinct auto-fix items in the *same* pass can be batched into one cycle; do not count each tiny edit as its own cycle when they ship together before one re-check.
- ask-you findings do not consume the auto-fix budget — they pause immediately.

## Rules

- Never treat an **ask-you** finding as auto-fix.
- Never use **auto-fix** to expand scope or reinterpret the user’s goal.
- Under explicit user bypass (`skip no-mistakes`), skip the checklist entirely — do not reclassify findings to sneak past.
