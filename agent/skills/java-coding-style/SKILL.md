---
name: java-coding-style
description: >-
  Spring Framework Code Style for David Helman (official wiki rules) with Helman
  tweaks: 4-space indent, blank line before if after dense code, blank after
  locals. Use whenever writing, editing, reformatting, or reviewing Java —
  especially java-interview-drills (C:\Projects\java-interview-drills), interview drills, Spring apps, or reference
  solutions — even if the user only says "fix this Java," "match my style,"
  "Spring style," or "like the LRU sentinel." Prefer this over Google 2-space
  style when Helman Java is in scope.
---

# Java Coding Style — Spring Framework (+ Helman tweaks)

**Authority:** [Spring Framework Code Style](https://github.com/spring-projects/spring-framework/wiki/Code-Style) (local mirror: `C:\Projects\dev-hub\agent\skills\java-coding-style\references\Code-Style.md`).

This skill follows that guide. **Helman tweaks** (below) override Spring only where listed.

**Canonical example:** `C:\Projects\java-interview-drills\src\leetcode\lru\LruCacheSentinelSolution.java`  
**GitHub repo:** https://github.com/dhelman999/java-interview-drills  
**Spring sample:** `C:\Projects\dev-hub\agent\skills\java-coding-style\references\spring-StringUtils.java`

Full digest: `references/conventions.md`.

## Helman tweaks (only deviations)

| Spring wiki | Helman |
|-------------|--------|
| Tabs for indent | **4 spaces** |
| (general blank-line rules) | Also: blank line **after local declarations**; blank line **before `if` after dense code** |
| Apache license on every file | Required for Spring/OSS contributions; **optional** for personal interview drills |
| `@since`, JSpecify, `Assert.*` | Apply for Spring libraries/apps; **lighten** for pure algorithm drills unless useful |

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
| java-interview-drills / leetcode drills | Formatting, braces, naming, `this.` fields, no `var`, wrap ~90 |
| Spring apps / shared libraries | Also: import order, member order, Assert/null-safety, Javadoc, Utils class rules, tests (`*Tests`, AssertJ, Mockito) |

## What not to do

- Do not reformat unrelated files or rewrite logic for style alone
- Do not use Google 2-space indent or `} else {`
- Do not invent blank lines inside tiny one-liner helpers the reference would not use

## Compile java-interview-drills

Use skill `agent-workflow` → `references/testcode-compile.md` — never bare `javac` into `src/`.
