# /usage

Refresh Cursor quota meters in a Canvas beside chat.

1. Follow skill **`usage-canvas`** (hub: `agent/skills/usage-canvas`).
2. Run `npx -y quota-axi --provider cursor --json`.
3. Write/update `cursor-usage.canvas.tsx` in this workspace’s canvases folder (stacked meters).
4. Tell the user the canvas is open as an editor tab; close the tab to hide, `/usage` again to refresh.
