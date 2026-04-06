---
name: cost-status
description: Shows OpenCode token usage and cost tracking from opencode-bar. Use when the user wants to check AI provider usage, remaining quotas, or spending.
---

# Cost Status

Check OpenCode spending and quota usage via opencode-bar.

**Command:** `opencodebar status`

**Shell alias:** `cost` (already added to ~/.zshrc)

Shows:
- Quota-based providers: usage percentage and remaining
- Pay-as-you-go providers: dollars spent (e.g., "~$6.14 spent on OpenCode Zen")

The command reads from `~/.opencode/auth.json` automatically — no configuration needed.
