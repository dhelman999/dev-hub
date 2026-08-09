# Canvas layout (locked)

Write `cursor-usage.canvas.tsx` with:

- Imports from `cursor/canvas` only
- `useHostTheme()` for muted text (`theme.text.secondary`) — no hardcoded hex
- Header: title + `Pill` (Fresh / Error)
- A vertical `Stack` of three `UsageBar`s (stacked, not a 3-column grid) for:
  - `included_usage`
  - `auto_usage`
  - `api_usage`
- `UsageBar` props: `total={100}`, `segments={[{ id, value: percentUsed, color }]}`
- Labels: pass `<Text style={{ fontSize: 16, fontWeight: 600 }}>` for both `topLeftLabel` and `topRightLabel` (not plain strings — default UsageBar labels are too small for a full editor tab)
- Prefer a modest `maxWidth` (~520) so bars stay readable in the editor tab
- Footer `Text`: generatedAt + resetsAt (ISO fine) + “Close tab to hide · /usage to refresh”
- On error: `Callout tone="danger"` with the CLI error string; omit fake meters

## Color helper

```text
percentUsed < 50  → green
percentUsed < 80  → yellow
else              → orange
```

## Placement reminder

Editor tab beside Agents. Split Up/Down is optional user IDE action, not skill-controlled.
Content is stacked because the canvas is a full tab you open occasionally — readability over density.
