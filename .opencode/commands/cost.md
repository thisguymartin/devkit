---
description: Check OpenCode token usage and spending
agent: build
model: opencode/minimax-m2.5-free
---

Run `/opt/homebrew/bin/opencodebar status` and report the current usage:
- Quota-based providers: percentage and remaining
- Pay-as-you-go providers: dollars spent

Example output:
```
Provider              Type             Usage       Key Metrics
─────────────────────────────────────────────────────────────────────────────────
Antigravity           Quota-based      0%          100/100 remaining
ChatGPT               Quota-based      6%          94/100 remaining
GitHub Copilot        Quota-based      3%          290/300 remaining
OpenCode Zen          Pay-as-you-go    -           $6.14 spent
```
