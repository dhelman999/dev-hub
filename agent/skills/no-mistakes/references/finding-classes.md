# Finding classes (auto-fix vs ask-you)

Mirror Kun’s gate split for the Cursor soft gate.

| Class | Meaning | Agent behavior |
|-------|---------|----------------|
| **auto-fix** | Mechanical, low-risk, does not change product intent | Fix, re-run the relevant check, continue — no pause. **Cap: 5** auto-fix cycles per gate run (see below) |
| **no-op** | Informational; already fine | Mention in outcome summary only |
| **ask-you** | Challenges intent, product behavior, or safety | **Stop**; quote `id`/file/description plainly; wait for approve, fix guidance, or skip |

## auto-fix examples

- Failing unit/integration tests caused by the change (and fixable in scope)
- Java style: braces, indent, import order, unused imports, trailing whitespace
  (follow the repo's style skill or formatter if present)
- Unused imports, obvious compile errors from the edit
- Test mocks missing a new constructor dependency the agent introduced
- **False-green tests** (see below) where tightening the assertion is mechanical
- **Reinvented code** (see below) where the new helper can simply be replaced by an existing one

## ask-you examples

- Changing public API contracts or HTTP status semantics beyond the request
- Deleting features, endpoints, or data paths the user did not ask to remove
- Security: secrets in diff (passwords, API tokens, private keys), auth bypass, weakening validation
- **Personal / identifying information (PII):** see below — never auto-fix by “just commit anyway”
- “Is this the intended behavior?” / large refactors beyond the ask
- Risky git / mass delete: classify with skill `destructive-actions` (early scan). Tier B → ask-you style pause; Tier C → require `yes authorize permanent deletion` (not ordinary yes). Force push to default branch, repo delete, mass wipe are Tier C.

## ask-you: personal / identifying information (PII)

Treat as **ask-you** (and block ship to public remotes) when the diff or commit would expose personal data. Examples:

- Home / mailing address, phone, personal email used as identity, full legal name in claimant/medical context
- Government IDs, claim IDs, case numbers, SSN/tax IDs, driver’s license / VIN when tied to a person
- Financial figures tied to a person (bank balances, benefit amounts, account numbers)
- Medical, legal, or benefits narrative that identifies a real person or household
- Vehicle or property identifiers combined with personal context
- Private notes or skills that belong in a personal/private repo leaking into a public one

**Correct handling:** stop, quote the finding, do **not** push/PR. If confirmed
**before** the dedicated review subagent (soft-gate §5), **skip §5** — do not
launch it for a second look. Redact or move the content to a private location
after user direction.

This is separate from **secrets** (credentials/tokens): both are ask-you; PII is about identity/personal life, secrets are about auth/access. The same
early skip applies to **confirmed secrets** (passwords, API tokens, private
keys). Other ask-you classes (intent, API contract) do **not** skip §5.

## False-green tests (always scanned)

Agent-written tests fail most often by **passing no matter what the code does**. Every diff review must scan new/changed tests for:

- No assertion, or asserting only that no exception was thrown
- Asserting on a mock/stub instead of the behavior under test (mock returns X, test asserts X)
- Tautologies: `assertEquals(actual, actual)`, comparing a value to itself, re-deriving expected from the same production call
- Try/catch that swallows the failure, or `assertTrue(true)` fallbacks
- Over-mocking the unit under test so the real code path never runs
- Asserting implementation details (call order, internals) instead of the contract, so the test passes while behavior regresses
- Skipped / disabled / empty tests added with the change
- Test that still passes when the production change is reverted or the value is inverted

**Handling:** tightening a weak assertion is **auto-fix**. Deleting coverage, or a test that only passes because the contract itself is wrong, is **ask-you**. Cheapest proof: invert the expected value (or revert the production line) and confirm the test actually fails.

## Reinvented code (always scanned)

Agents also fail by writing code that already exists. Every diff review must check new helpers, utilities, abstractions, algorithms, and patterns for:

- A repo helper that already does it (`*Utils`, `*Helper`, `*Support`, `*Factory`, `common/` `shared/` `core/`)
- A **current dependency** or stdlib call that already does it (hand-rolled null/blank checks, string joins, sorting, retry, date math, DTO mapping)
- A second pattern for something the repo already solves one way (new config style, new error-handling shape, a parallel test fixture)
- A copy-pasted block that should have been extracted or called
- A new dependency added for something already available

**Handling:** swapping the new code for the existing helper or stdlib call is **auto-fix**. Where the existing thing needs a small generalization to fit, extending it is **auto-fix** only if it does not change existing callers' behavior. Removing a whole parallel abstraction, changing shared helper semantics, or migrating existing callers is **ask-you** (scope). If the existing pattern looks deprecated, raise it as **ask-you** rather than allowing a third pattern to ship.

## Auto-fix iteration cap

- **Max 5** auto-fix cycles per no-mistakes gate run (a cycle = apply fix(es) + re-run the relevant check: build/test, style, or a follow-up review pass).
- If still not green after 5 cycles → **stop**, report `no-mistakes: BLOCKED` with what remains, and **ask-you** (do not keep burning tokens).
- Distinct auto-fix items in the *same* pass can be batched into one cycle; do not count each tiny edit as its own cycle when they ship together before one re-check.
- ask-you findings do not consume the auto-fix budget — they pause immediately.
- Outcome summary must report **Auto-fix cycles: used/5** and **Issues auto-fixed: N** (see `soft-gate.md`).

## Rules

- Never treat an **ask-you** finding as auto-fix.
- Never use **auto-fix** to expand scope or reinterpret the user’s goal.
- Confirmed secrets/PII before §5 → skip the review subagent; never launch it “for completeness.”
- Under explicit user bypass (`skip no-mistakes`), skip the checklist entirely — do not reclassify findings to sneak past.
