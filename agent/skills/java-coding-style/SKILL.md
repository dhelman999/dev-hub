---
name: java-coding-style
description: >-
  Spring Framework Code Style (official wiki rules) with local tweaks:
  4-space indent, blank line before if after dense code, blank after locals,
  ~50-line functions, reuse before invent (search the repo and existing
  dependencies instead of writing a duplicate helper/util/pattern), no Cursor
  Co-authored-by trailers, rich PR bodies for complex changes. Use whenever
  writing, editing, reformatting, or reviewing Java — Spring apps, interview
  drills, or reference solutions — even if the user only says "fix this Java,"
  "match my style," "Spring style," "coding style," "don't reinvent it," or asks
  about commit trailers / PR description depth. Prefer this over Google 2-space style when these
  conventions are in scope.
---

# Java Coding Style — Spring Framework (local tweaks)

**Authority:** [Spring Framework Code Style](https://github.com/spring-projects/spring-framework/wiki/Code-Style) (local mirror: `references/Code-Style.md`).

This skill follows that guide. **Local tweaks** (below) override Spring only where listed.

**Spring sample:** `references/spring-StringUtils.java`

Full digest: `references/conventions.md`.

## Local tweaks (only deviations)

| Spring wiki | This skill |
|-------------|------------|
| Tabs for indent | **4 spaces** |
| (general blank-line rules) | Also: blank line **after local declarations**; blank line **before `if` after dense code** |
| Apache license on every file | Required for Spring/OSS contributions; **optional** for personal interview drills |
| `@since`, JSpecify, `Assert.*` | Apply for Spring libraries/apps; **lighten** for pure algorithm drills unless useful |

## Engineering conventions (always)

These apply to code work and shipping (Java first; same intent for non-Java when this skill is in play):

1. **Function size:** Methods/functions should generally stay **under ~50 lines**. If longer, split into smaller focused helpers unless there is a clear reason not to (e.g. a single tight algorithm that is harder to follow when scattered).
2. **Reuse before invent:** Never add a helper, utility class, abstraction, algorithm, or pattern without first searching for one that already exists — in the repo or in its current dependencies. See below.
3. **PR descriptions:** For **complex** PRs, write a thorough body for reviewers: description, expected behavior, summary of changes, and any other context a reviewer needs. For small/obvious PRs, a short description/summary is enough.
4. **Never Cursor Co-authored-by:** Do **not** add `Co-authored-by: Cursor <cursoragent@cursor.com>` (or any Cursor/agent co-author trailer) to commits. Commit messages stay human-authored only. Also avoid enabling Cursor "attribute commits to agent" / Attribution features that inject that trailer.

## Reuse before invent (search first)

Two helpers that do the same job are the defect — not the formatting. Before adding a helper, utility class, abstraction, algorithm, config pattern, or test fixture:

1. **Search for the behavior, not the name you would have picked.** Grep the operation (`isBlank`, `retry`, `toDto`, `truncate`, `parseDuration`) and the likely homes: `*Utils`, `*Helper`, `*Support`, `*Factory`, `*Mapper`, and `common/` `shared/` `core/` `internal/` packages.
2. **Check what is already on the classpath.** Never hand-roll what a current dependency provides: `Objects`, `Optional`, `Collectors`, `Comparator`, Spring's `StringUtils` / `CollectionUtils` / `ObjectUtils` / `Assert`, plus Guava or Commons **if already a dependency**. Do not add a dependency to avoid five lines, and do not write fifty lines to avoid a dependency that is already there.
3. **Match the neighbors.** Read how the nearest existing service, controller, repository, or test solves the same shape of problem and follow that pattern, even if you would have designed it differently.
4. **Extend, do not fork.** If the existing helper is close but not quite right, generalize or fix it in place. Creating a second near-identical helper is worse than a slightly wider signature on the first.
5. **Justify anything new in one line** — what you searched for and why nothing fit (no existing equivalent, or reuse would force an unrelated module to depend on this code).

If the existing pattern is genuinely deprecated or wrong, **say so** and get direction. Do not quietly start a third pattern.

## Non-negotiables (every Java edit)

1. K&R braces; **line break before `else` / `catch` / `finally`** (never `} else {`)
2. **4 spaces** indent; no trailing whitespace; prefer LF
3. Blank after locals; blank before `if` after dense code; blank between logical steps
   - **Related constants:** consecutive `static final` constants that form one concept group (e.g. retry/failure limits) stay **adjacent with no blank lines**. Only insert a blank line between constant groups that are truly different concepts.
4. Reference instance **fields with `this.`**; do **not** prefix instance **method** calls with `this.`
   - **Spring exception:** do **not** qualify injected collaborators with `this.` (`orderService`, repositories, `KafkaTemplate`, `@ConfigurationProperties` beans, etc.). Keep `this.x = x` in constructors. Still use `this.` for the class's own mutable/domain state when helpful.
   - **Constants:** never qualify `static final` constants with `this.` (use `MAX_FAILURE_COUNT`, not `this.MAX_FAILURE_COUNT`)
5. No `var` in production/main code (OK in tests if consistent)
6. Always `@Override` when overriding/implementing
7. Prefer `private static` nested helpers; `CONSTANT_CASE` only for true constants

## Scope when applying “full” Spring practices

| Context | Apply |
|---------|--------|
| Algorithm / interview drills | Formatting, braces, naming, `this.` fields, no `var`, wrap ~90 |
| Spring apps / shared libraries | Also: import order, member order, Assert/null-safety, Javadoc, Utils class rules, tests (`*Tests`, AssertJ, Mockito) |

## What not to do

- Do not reformat unrelated files or rewrite logic for style alone
- Do not use Google 2-space indent or `} else {`
- Do not invent blank lines inside tiny one-liner helpers the reference would not use
- Do not add Cursor/agent `Co-authored-by` trailers to commits

## Compile

Use the current repo's README / `scripts/` / `AGENTS.md`. Never run bare `javac` that dumps `.class` files into `src/`.
