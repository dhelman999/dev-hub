# Prompt-cache hygiene

Providers cache **exact prefixes**. One early changing byte can invalidate the whole prefix discount.

## Do

- Keep `AGENTS.md` tiny and stable for weeks at a time.
- Put volatile guidance in the **user message** or a skill loaded only when needed.
- Prefer editing project files over rewriting global rules mid-chat.
- Keep MCP / tool enablement stable during a long agent session when possible.

## Don’t

- Prepend “Session started at {timestamp}” to system-style instructions every turn.
- Toggle large tool sets on/off repeatedly in one session.
- Paste megabytes of logs into the always-on memory file.
- Switch models every turn and expect cache benefits.

## Hub-specific

- Global memory: `C:\Projects\dev-hub\agent\AGENTS.md` (hardlinked to `~\AGENTS.md`).
- Procedures belong in `C:\Projects\dev-hub\agent\skills\`, not AGENTS.md.
- Cursor always-on rule: `dotfiles\cursor\rules\agent-workflow.mdc` — keep short; heavy playbooks stay in skills.
