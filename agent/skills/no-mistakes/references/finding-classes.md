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
- Security: secrets in diff (passwords, API tokens, private keys), auth bypass, weakening validation
- **Personal / identifying information (PII):** see below — never auto-fix by “just commit anyway”
- “Is this the intended behavior?” / large refactors beyond the ask
- Risky git / mass delete: classify with skill `destructive-actions` (early scan). Tier B → ask-you style pause; Tier C → require `yes authorize permanent deletion` (not ordinary yes). Force push to default branch, repo delete, mass wipe are Tier C.

## ask-you: personal / identifying information (PII)

Treat as **ask-you** (and block ship to public remotes) when the diff or commit would expose personal data, especially into `dev-hub` or any public repo. Examples:

- Home / mailing address, phone, personal email used as identity, full legal name in claimant/medical context
- Government IDs, claim IDs, case numbers, SSN/tax IDs, driver’s license / VIN when tied to the person
- Financial figures tied to a person (bank balances, benefit amounts, account numbers)
- Medical / unemployment / legal narrative that identifies David or household members
- Vehicle or property identifiers combined with personal context (e.g. maintenance notes with VIN + address)
- Private skill content that belongs in `dev-hub-personal` (or similar) leaking into a public hub

**Correct handling:** stop, quote the finding, do **not** push/PR. Prefer moving the content to `C:\Projects\dev-hub-personal` (or redacting) after user direction. Aligns with hub `AGENTS.md` Privacy hard rule.

This is separate from **secrets** (credentials/tokens): both are ask-you; PII is about identity/personal life, secrets are about auth/access.

## Auto-fix iteration cap

- **Max 5** auto-fix cycles per no-mistakes gate run (a cycle = apply fix(es) + re-run the relevant check: build/test, style, or a follow-up review pass).
- If still not green after 5 cycles → **stop**, report `no-mistakes: BLOCKED` with what remains, and **ask-you** (do not keep burning tokens).
- Distinct auto-fix items in the *same* pass can be batched into one cycle; do not count each tiny edit as its own cycle when they ship together before one re-check.
- ask-you findings do not consume the auto-fix budget — they pause immediately.
- Outcome summary must report **Auto-fix cycles: used/5** and **Issues auto-fixed: N** (see `soft-gate.md`).

## Rules

- Never treat an **ask-you** finding as auto-fix.
- Never use **auto-fix** to expand scope or reinterpret the user’s goal.
- Under explicit user bypass (`skip no-mistakes`), skip the checklist entirely — do not reclassify findings to sneak past.
