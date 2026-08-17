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

## Hub / harness specifics

When this machine uses a version-controlled agent hub, keep global `AGENTS.md`
short and put procedures in skills. Cursor always-on rules should stay short;
heavy playbooks stay in skills. Layout details live in skill `agentic-harness`.
