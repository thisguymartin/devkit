# Cost-Aware Model Routing

## The Rule

Expensive model for thinking. Cheap model for doing. Free model for grunt work. Copilot for everything small.

## Model Tiers

| Tier | Models | Cost (per 1M tokens) | Use For |
|------|--------|---------------------|---------|
| **FREE** | MiniMax M2.5 Free, Qwen3.6 Plus Free, Big Pickle | $0 | Tests, docs, boilerplate, comments, changelogs |
| **Budget** | Gemini 3 Flash, GLM 5, GPT 5.4 Nano | $0.20-$3 | Docs, project management, quick utilities |
| **Standard** | GPT 5.4, GPT 5.3 Codex, Kimi K2.5, GPT 5.4 Mini | $0.60-$15 | Implementation, autonomous coding, frontend |
| **Premium** | Gemini 3.1 Pro | $2/$12 | Architecture, planning, code review, security audit |

## Routing Guidelines

- **Planning/Architecture:** Use the planning tier (Gemini 3.1 Pro). 1M context holds entire repos.
- **Implementation:** Use the builder tier (GPT 5.4). Fast iteration, idiomatic code.
- **Autonomous loops:** Use Codex (GPT 5.3 Codex). Trained for test-fix cycles.
- **Code Review:** Use a DIFFERENT model than the one that wrote the code. Blind spots compound.
- **Tests/Docs/Boilerplate:** Use FREE models first. Never waste paid tokens on grunt work.
- **Quick questions:** Use Copilot Chat (300 free premium requests). Don't burn Zen credits.
- **Inline completions:** Use Copilot (unlimited, always on in Neovim).

## Cross-Model Review Rule

**NEVER review code with the same model that wrote it.** This is critical:
- GPT 5.4 wrote it → Review with Gemini 3.1 Pro
- Gemini planned it → Review with GPT 5.4
- Builder and Reviewer agents must always use different models

## Budget Guardrails

- **Total budget:** $100/mo ($10 Copilot Pro + $90 OpenCode Zen)
- **Copilot Pro ($10):** Inline completions, quick chat (300 reqs), PR review, CLI agents
- **OpenCode Zen (~$90):** Architecture, implementation, review, autonomous coding
- Set Zen monthly limit to $90 (hard cap)
- Disable auto-reload or cap at $10
- Use free models for ALL bulk work — saves paid budget for reasoning

## Decision Checklist

Before choosing a model, ask:
1. Can a free model handle this? → Use MiniMax M2.5 Free
2. Is this a quick question? → Use Copilot Chat
3. Is this grunt work (tests, docs, comments)? → Use free/budget tier
4. Is this implementation with clear spec? → Use GPT 5.3 Codex
5. Is this implementation with ambiguity? → Use GPT 5.4
6. Is this planning or review? → Use Gemini 3.1 Pro
7. Is this frontend/UI? → Use Kimi K2.5
