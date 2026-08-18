# Detect the stack, pin the verify loop

## Where the real commands live (check these before guessing)

1. `package.json` `scripts`, `Makefile`, `justfile`, `Taskfile.yml`
2. CI: `.github/workflows/*.yml` — the pipeline is the definition of "green"
3. `README` / `CONTRIBUTING` / repo `AGENTS.md`
4. `.pre-commit-config.yaml`, `.editorconfig`, formatter/linter configs
5. Only then the language defaults below

If CI runs a command you cannot run locally (containers, cloud creds), record it as *CI-only* and gate on the closest local subset.

## Detection

| Marker | Stack | Look next at |
|--------|-------|--------------|
| `pom.xml` | Java/Maven | `<java.version>`, parent (`spring-boot-starter-parent`, `quarkus-bom`), `spotless`/`checkstyle` plugins |
| `build.gradle`, `build.gradle.kts` | Java/Kotlin/Gradle | `./gradlew tasks`, toolchain block, `spotless` |
| `package.json` | Node | `tsconfig.json`, framework deps, `eslint`/`prettier`/`biome` config, package manager lockfile |
| `pyproject.toml`, `requirements.txt` | Python | `[tool.ruff]`, `[tool.black]`, `[tool.mypy]`, `uv.lock` / `poetry.lock` |
| `go.mod` | Go | Go directive version, `.golangci.yml` |
| `Cargo.toml` | Rust | edition, `clippy.toml`, `rustfmt.toml` |
| `*.csproj`, `*.sln` | .NET | `TargetFramework`, `.editorconfig` analyzer rules |

Lockfile picks the package manager: `package-lock.json` → npm, `pnpm-lock.yaml` → pnpm, `yarn.lock` → yarn, `uv.lock` → uv, `poetry.lock` → poetry.

## Default verify commands (fallback when the repo is silent)

| Stack | Format | Lint / types | Test | Build |
|-------|--------|--------------|------|-------|
| Java + Maven | `mvn spotless:apply` (if plugin) | `mvn -q checkstyle:check` (if plugin) | `mvn -q test` | `mvn -q verify` |
| Java + Gradle | `./gradlew spotlessApply` (if plugin) | `./gradlew check` | `./gradlew test` | `./gradlew build` |
| Node / TypeScript | `npx prettier --check .` | `npx eslint .`, `npx tsc --noEmit` | `npm test` | `npm run build` |
| Python | `ruff format .` or `black .` | `ruff check .`, `mypy .` | `pytest -q` | `python -m build` (packages only) |
| Go | `gofmt -l .` | `go vet ./...`, `golangci-lint run` | `go test ./...` | `go build ./...` |
| Rust | `cargo fmt --check` | `cargo clippy -- -D warnings` | `cargo test` | `cargo build` |
| .NET | `dotnet format --verify-no-changes` | analyzers via build | `dotnet test` | `dotnet build` |

Run installs the repo's way (`npm ci`, `uv sync`, `mvn -q -DskipTests package`) before claiming a command fails.

## Baseline first

Run the verify loop **once before editing**. If it is already red, record that ("N pre-existing failures in X") so a later red is attributable. Do not fix unrelated pre-existing failures unless asked.

## Greenfield (no repo yet)

Choose the boring standard toolchain for the language, state the choice in one line, and create the config up front so the gate has something to enforce:

- Java: Maven + JUnit 5 (+ AssertJ), Spring Boot only if the task is a web service
- TypeScript: strict `tsconfig`, vitest or jest, eslint + prettier
- Python: `pyproject.toml`, ruff (lint + format), pytest
- Go: stdlib + `go test`, `golangci-lint` if the task is more than one file

## Hand-off

Record the final commands where the next step can find them (repo `AGENTS.md`, or the chat summary for a throwaway exercise). `no-mistakes` runs them as its build/test step; `validation-tdd` turns them into pass criteria.
