# Spring Framework Code Style — digest (local tweaks)

Official source: https://github.com/spring-projects/spring-framework/wiki/Code-Style  
Local mirror: `references/Code-Style.md`  
CONTRIBUTING summary: `references/CONTRIBUTING.md`

---

## Local tweaks (read first)

These **override** the Spring wiki where they conflict:

1. **Indent with 4 spaces**, not tabs (Spring uses tabs).
2. **Blank line after a local variable declaration** before the next statement.
3. **Blank line before an `if` block** when dense / non-trivial code sits above it (assignments, calls, or a finished `if`/`else` block).
4. **License header / `@since` / JSpecify / `Assert`:** required when contributing Spring-style libraries or real Spring apps; optional for personal interview/leetcode files unless the user asks.

### Engineering conventions

1. Keep methods/functions **under ~50 lines** unless there is a strong reason; otherwise split into smaller helpers.
2. **Search for existing** helpers, patterns, static utility classes, and related workflows before inventing new code in the file under edit — prefer extending shared helpers.
3. **Complex PRs** need a thorough review body (description, expected behavior, change summary, other reviewer context). Small PRs can be brief.
4. **Never** add `Co-authored-by: Cursor <cursoragent@cursor.com>` (or other Cursor/agent co-author trailers) to commits.

Everything else below follows Spring.

---

## Source file basics

- Encoding: **UTF-8**
- Line endings: prefer **LF** (Unix); eliminate trailing whitespace
- Indent: **4 spaces** (local tweak) — Spring wiki says tabs

### File structure (exact order)

1. License (when required)
2. Package statement
3. Import statements
4. Exactly one top-level class

Exactly **one blank line** between those sections.

### Import order (Spring)

```
java.*
<blank>
javax.*
jakarta.*
<blank>
all other imports
<blank>
org.springframework.*
<blank>
static imports
```

- **No wildcard imports** (`import java.util.*` forbidden), including in tests
- **Static imports:** avoid in production code; use in tests (e.g. AssertJ). Allowed in production for constants/enum constants and third-party DSL factory methods

### Member order (Spring)

1. static fields  
2. normal fields  
3. constructors  
4. (private) methods called from constructors  
5. static factory methods  
6. JavaBean getters/setters  
7. interface method implementations  
8. private/protected helpers used by those implementations (prefer **immediately below** the caller, not all piled at the bottom)  
9. other methods  
10. `equals`, `hashCode`, `toString`

Organization should still feel natural.

Spring blank-line extras: **two blank lines** before `static {}` blocks, fields, constructors, and inner classes (inner classes that are tiny may skip the extra field/ctor blanks). **One blank line** after a multiline method signature before the body.

Local note: for small algorithm/drill classes, prefer readability over forcing double blanks everywhere.

---

## Formatting

### Braces (K&R / Egyptian)

- Space before `{`; newline after `{`
- Newline before `}`
- Newline after `}` when it ends a statement/method/class
- **Newline before `else`, `catch`, and `finally`**

```java
if (condition()) {
    something();
}
else {
    try {
        alternative();
    }
    catch (ProblemException ex) {
        recover();
    }
}
```

### Line wrapping (Spring)

- Aim for **~90** columns; **90–105** OK when wrapping hurts readability
- **105–120** discouraged; **never exceed 120**
- Javadoc: wrap nearer **~80**
- Put separators (`,`, `+`, `?`, `:`, `&&`, `||`) at the **end** of the current line

```java
if (thisLengthyMethodCall(param1, param2) && anotherCheck() &&
        yetAnotherCheck()) {

    // ...
}
```

### Local blank lines (in addition to Spring)

**After locals:**

```java
Node node = nodeByKey.get(key);

if (node == null) {
```

**Before `if` after dense code:**

```java
node.value = value;
moveToMostRecent(node);
touchMetadata(node);

if (nodeByKey.size() > capacity) {
    evictLeastRecent();
}
```

**Between logical steps / before explanatory comments** — keep as in the LRU reference.

**Exception:** `if` as the first statement in a method needs no leading blank after `{`.

**Related constants (no extra whitespace):**

```java
private static final int MAX_FAILURE_COUNT = 3;
private static final int MAX_RETRY_COUNT = 2;
private static final int BASE_RETRY_AMOUNT = 1;

private final OrderPolicyEligibilityClient delegate;
```

Keep related `static final` constants back-to-back. Only blank-line-separate constant groups that represent **different** concepts (e.g. a path string vs an unknown-id sentinel). Never qualify constants with `this.`.

---

## Naming

- Constants: `CONSTANT_CASE` only for real constants (`static final` values that are constant in spirit)
- Non-constants that happen to be `static final` (e.g. `ThreadLocal` holders): **not** CONSTANT_CASE
- Avoid single-letter names; prefer `Method method` over `Method m`
- Try to keep `extends` / `implements` on the same line as the class name when practical; most important type first

---

## Programming practices (Spring)

### `this` references

- **Always** qualify instance **fields** with `this.`
- **Never** qualify instance **method** calls with `this.`
- **Never** qualify `static final` constants with `this.`
- **Spring apps exception:** do **not** use `this.` when calling through injected collaborators (services, repositories, `KafkaTemplate`, config beans, etc.). Keep `this.field = field` in constructors. Prefer `this.` for the type's own mutable/domain state when it aids clarity.

### Local variable type inference

- **`var` not permitted** in production/main code
- `var` OK in tests if used consistently in the test (preferably the whole test class)

### `@Override`

Always annotate methods that override or implement a super-type method.

### Ternary

Wrap in parentheses; non-null / positive condition first:

```java
return (foo != null ? foo : "default");
```

### Null checks (Spring apps / libraries)

- Arguments: `Assert.notNull(event, "Event must not be null");` → `IllegalArgumentException`
- State: `Assert.state(event != null, "Event must not be null");` → `IllegalStateException`
- Message shape: capitalized identifier + `" must not be null"`

### Null safety (Spring libraries)

- JSpecify: package `@NullMarked` in `package-info.java`; use `@Nullable` on nullable API
- Prefer Spring `@Contract` where useful for NullAway
- When overriding, preserve null-safety annotations unless intentionally changing them

### Utility classes

Name with `Utils` suffix; class is `abstract` with a **private** constructor (prevents instantiation).

### Setters

Place near related properties; order by importance / field order, not “append at end of history.”

### File history

A file should look authored as one coherent style — do not leave a patchwork of formats.

### `@since` / license

For framework or shared library code: Apache header; `@since` on new types and new public/protected members. Skip for personal drills unless asked.

---

## Javadoc (Spring)

- First sentence **imperative** (“Parse …” not “Parses …”)
- No blank line between description and `@param` list
- Multi-paragraph descriptions: start paragraphs with `<p>`
- Wrapped `@param` lines: do not indent continuations
- Type-level tag order: `@author`, `@since`, `@param`, `@see`, `@deprecated`
- Member tag order: `@param`, `@return`, `@throws`, `@since`, `@see`, `@deprecated`
- Use `{@code}` for code/values like `null`
- Prefer FQCN inside `{@link}` when that avoids an otherwise-unused import

For leetcode drills: short class/method comments are enough; full Spring Javadoc when writing library APIs.

---

## Tests (Spring)

- JUnit Jupiter
- Test class names end with **`Tests`**
- Assertions: **AssertJ**
- Mocking: **Mockito**

---

## Quick checklist before finishing a Java edit

- [ ] 4-space indent, K&R braces, `else`/`catch`/`finally` on new lines
- [ ] Blank after locals; blank before `if` after dense code
- [ ] Related constants grouped with no blank lines between them; blank only between different concepts
- [ ] Own state fields use `this.` when useful; injected Spring collaborators and constants do not; methods never use `this.`
- [ ] No `var` in main code; `@Override` present
- [ ] Lines mostly ≤90–105; none >120
- [ ] Imports ordered if the file has nontrivial imports
- [ ] Did not reformat unrelated code
