# Rule packs: where to look, how to prune

Community packs are **unversioned community prose with no evals**. Same posture as third-party skills (`agentic-harness` → `references/skills-policy.md`): useful as a checklist that jogs your memory about a framework, never an authority, never pasted in whole.

## Sources, best first

1. **Repo itself** — existing code, formatter/linter config, CI, `README`, `AGENTS.md`
2. **Official style guide / docs** for the pinned version:
   - Java: [Spring Framework Code Style](https://github.com/spring-projects/spring-framework/wiki/Code-Style) (mirrored in skill `java-coding-style`), [Google Java Style](https://google.github.io/styleguide/javaguide.html)
   - Python: PEP 8, PEP 484, ruff rule docs
   - Go: Effective Go, [Google Go Style Guide](https://google.github.io/styleguide/go/)
   - TypeScript: `typescript-eslint` recommended sets, framework docs (React, Next, Nest)
   - Rust: Rust API Guidelines, clippy lint docs
3. **Cursor rule packs** — `https://cursor.directory/plugins/<language>` and `https://cursor.directory/rules` ("Add to Cursor" writes a rule file). Verified Aug 2026: the Java page carries exactly two packs, *Java Quarkus* and *Java Spring*.
4. **Other pack collections** — [awesome-cursorrules](https://github.com/PatrickJS/awesome-cursorrules), `npx skills find <language>` / https://skills.sh (never `--all`)
5. **Nothing usable** — `Assumption (unverified): …` and continue

## Three-minute pruning pass

1. Pull the pack into scratch (chat or a temp file), not into `.cursor/rules`.
2. Delete every line that is a language default, unfalsifiable, or already formatter-enforced.
3. Delete every line whose framework the repo does not actually use.
4. Check the remainder against the local style skill; the local skill wins on any overlap.
5. Keep what survives — usually 5 to 15 lines — in the project-local file, and note the source.

## Worked example: the cursor.directory Java packs

For **your** Java work these packs add little, because `java-coding-style` already covers formatting from a real authority. What survives is framework reminders.

**Worth keeping (decidable, non-obvious, Spring-flavored):**

- Constructor injection over field injection
- `@ConfigurationProperties` for typed config; Spring profiles for per-environment config
- `@ControllerAdvice` + `@ExceptionHandler` for error mapping
- Test split: MockMvc for the web layer, `@DataJpaTest` for repositories, `@SpringBootTest` for integration
- Flyway or Liquibase for schema migrations
- Springdoc OpenAPI for docs; Actuator for health/metrics; BCrypt for password encoding

**Drop as noise:**

- PascalCase classes, camelCase methods, ALL_CAPS constants — language defaults the IDE already enforces
- "Write clean, efficient, well-documented code", "adhere to SOLID", "use Spring Boot best practices" — nothing a reviewer can point at
- "Implement proper database indexing and query optimization" — not actionable without a schema and a slow query

**Check against the repo before believing:**

- The Quarkus pack assumes Quarkus, Panache, Mutiny, GraalVM native — dead weight in a Spring repo, and the reverse is equally true
- "Java 17 or later features" — read `<java.version>` / the Gradle toolchain first; records and sealed classes are wrong answers on Java 11
- WebFlux / `@Async` / reactive advice — only if the repo is already reactive

**Where `java-coding-style` overrides:** the packs are silent on 4-space indent, line break before `else` / `catch` / `finally`, `this.` on instance fields (but not on injected collaborators), no `var` in main code, and ~50-line functions. Those are locked locally, so the pack cannot be treated as the style source.

**Conclusion:** do not install these two packs as always-on Cursor rules. Java is already covered; for an unfamiliar stack, run the pruning pass above and write the survivors into the project's own rules file.
