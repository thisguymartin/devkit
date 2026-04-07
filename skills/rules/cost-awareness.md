# Cost-Aware Model Routing

## The Rule

Expensive model for thinking. Cheap model for doing. Free model for grunt work. Copilot for everything small.

## Model Tiers

| Tier | Models | Cost (per 1M tokens) | Use For |
|------|--------|---------------------|---------|
| **FREE** | MiniMax M2.5 Free, Qwen3.6 Plus Free, Big Pickle | $0 | Tests, docs, boilerplate, comments, changelogs |
| **Budget** | MiniMax M2.5, GLM 5, GPT 5.4 Nano | $0.20-$3 | Docs, project management, quick utilities |
| **Builder** | GPT 5.3 Codex | $1.75/$14 | Default implementation for normal engineering work |
| **Specialist** | GPT 5.3 Codex | $1.75/$14 | Autonomous coding loops, spec-driven implementation |
| **Workhorse** | GPT 5.4 Mini | $0.75/$4.50 | QA, project management, structured support tasks |
| **Frontend** | Kimi K2.5 | $0.60/$3 | Visual-heavy UI work, screenshot-to-code, component implementation |
| **Premium Builder** | Gemini 3.1 Pro | $2/$12 | Higher-stakes implementation, orchestration, hard trade-offs |
| **Premium** | Gemini 3.1 Pro | $2/$12 | Architecture, planning, code review, security audit |

## Routing Guidelines

- **Planning/Architecture:** Use the planning tier (Gemini 3.1 Pro). 1M context holds entire repos.
- **Implementation:** Use the builder tier (GPT 5.3 Codex) by default for normal engineering work when you want the main paid OpenAI lane.
- **Premium implementation:** Use Gemini 3.1 Pro when the task is unusually risky, ambiguous, or failure-intolerant and you want a stronger implementation path.
- **Autonomous loops:** Use Codex (GPT 5.3 Codex). Trained for test-fix cycles.
- **Free code changes:** Big Pickle or MiniMax M2.5 Free are acceptable for low-risk code edits like config changes, boilerplate, small refactors, copy changes, and first-pass implementations. Do not use them as the default for security-sensitive work, architecture, or final review.
- **Code Review:** Use a DIFFERENT model than the one that wrote the code. Blind spots compound. Default pairing here is GPT 5.3 Codex -> GPT 5.4 Mini.
- **Tests/BDD/Structured Ops:** Prefer GPT 5.4 Mini when you need reliable structure and tool use without paying builder-tier prices.
- **Quick questions:** Use Copilot Chat (300 free premium requests). Don't burn Zen credits.
- **Inline completions:** Use Copilot (unlimited, always on in Neovim).

## Cross-Model Review Rule

**NEVER review code with the same model that wrote it.** This is critical:
- GPT 5.3 Codex wrote it → Review with GPT 5.4 Mini
- If Gemini 3.1 Pro wrote it, avoid same-model self-review
- Gemini planned it → Review with GPT 5.4 Mini
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
1. Can a free model handle this and the work is disposable/low-risk? → Use Big Pickle or MiniMax M2.5 Free
2. Is this a quick question? → Use Copilot Chat
3. Is this docs-only or lightweight support work? → Use budget tier
4. Is this QA, issue generation, review, or other structured support work? → Use GPT 5.4 Mini
5. Is this implementation with clear spec? → Use GPT 5.3 Codex
6. Is this implementation with ambiguity but still normal day-to-day engineering? → Use GPT 5.3 Codex
7. Is this higher-stakes implementation or orchestration? → Use Gemini 3.1 Pro
8. Is this planning or review? → Use Gemini 3.1 Pro
9. Is this frontend/UI? → Use GPT 5 first for general UI work; use Kimi K2.5 for screenshot-driven or visually heavy work

## Free Model Guardrails

- **Use Big Pickle first** for disposable work, low-risk code changes, rough drafts, and context compression.
- **Use MiniMax M2.5 Free** when you want a free option for lightweight implementation or summaries, not as the default paid coding lane.
- **Escalate immediately** to GPT 5.3 Codex, GPT 5.4 Mini, or Gemini 3.1 Pro if the task touches authentication, money, concurrency, production incidents, or multi-file refactors that need stronger reasoning or validation.
- **Do not put secrets, regulated data, or sensitive internal context** into free experimental models unless you are comfortable with the provider's current privacy terms.
