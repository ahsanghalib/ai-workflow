---
name: pi-extension-builder
description: Build or revise Pi TypeScript extensions using current documented APIs. Use when the task concerns pi extension builder.
---
# Pi extension building

- Read https://pi.dev/docs/latest/extensions before coding against the runtime.
- Use `import type { ExtensionAPI } from "@earendil-works/pi-coding-agent"`.
- Place globally trusted modules in `~/.pi/agent/extensions/` and project modules
  only in trusted `.pi/extensions/`.
- Distinguish event hooks, `registerCommand`, and `registerTool`.
- Check `ctx.hasUI` before dialogs/notifications in headless contexts.
- `pi.exec(binary, args, {cwd,timeout})` executes without a shell; arguments
  stay separate and must not contain secrets.
- `tool_call` interception is a guardrail, not an operating-system sandbox.
- Test failure paths, invalid input, unsupported modes, and `/reload` state.
- Do not auto-install new dependencies or publish extensions without approval.
