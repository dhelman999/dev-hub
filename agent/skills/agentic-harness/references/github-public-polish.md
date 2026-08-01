# Public GitHub presentation (dhelman999)

Conventions for public-facing repo polish (not code style).

## Naming

| Kind | Convention | Examples |
|------|------------|----------|
| New GitHub repos | `kebab-case`, descriptive | `java-interview-drills` |
| Existing branded names | Keep as-is (portfolio identity) | `McWendyQueen`, `Kewl-Tetris`, `DMUD`, `Pong` |
| Java packages | reverse-DNS | `com.mcwendyqueen...`, `leetcode.lru` |
| README title | Match product/repo name | `# McWendyQueen` |

Do **not** mass-rename old game repos unless the user asks — links and history break.

## Every public repo should have

1. Professional `README.md` (about, stack/features, how to run, layout, author)
2. Accurate GitHub **description** (one sentence, no typos)
3. Relevant **topics** tags when useful
4. Leave upstream READMEs alone on **forks** (e.g. `cisco-mibs`)

## Descriptions (current)

| Repo | Description |
|------|-------------|
| java-interview-drills | Java interview reference solutions (LRU, sliding-window rate limiting, and related drills)… |
| McWendyQueen | Spring Boot fast-food domain demo: menus, recipes, orders, and Kafka events |
| Pong | Space-themed Pong clone built in Unity |
| Kewl-Tetris | Unity Tetris clone with themed UI, level-up effects, and classic controls |
| DMUD | C# text MUD (8th Circle) — networking, parsing, combat; Unity client path |
| cisco-mibs | Fork — keep upstream Cisco description |
| dev-hub | Reproducible Windows dev + agentic hub: Cmder/dotfiles, shared AI skills, Dev/Agent rebuild targets |
| dev-hub-personal | Private personal AI skills companion for dev-hub (PII; not public) |
