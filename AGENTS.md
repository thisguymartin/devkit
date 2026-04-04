# AGENTS.md

This file captures repo-local defaults for Codex and similar coding agents working in this repository.

## Communication

- Use a direct, casual, first-person tone
- Keep it brief and Slack-like
- Avoid corporate polish and consultant wording
- Minimize em dashes
- Use `->` notation for architecture flows
- When teaching a new concept, use a real-world analogy

## Stack And Workflow

- Default to Go and TypeScript unless another stack is explicitly requested
- Prefer terminal-first workflows: Zellij, git worktrees, LazyGit, CLI tools
- Prefer CLI solutions over GUI recommendations
- For library, framework, SDK, and API guidance, verify current official docs first using Context7, MCP, or web sources when available
- Do not rely on stale model memory when primary docs are easy to reach

## Code Expectations

- Favor production-ready code over toy snippets
- Include error handling, context propagation, and logging where relevant
- When discussing architecture, start with domain modeling:
  - aggregates
  - entities
  - value objects
  - domain events
- Do not assume deployment target
- If infrastructure is unspecified, ask before choosing AWS, Cloudflare Workers, Fly.io, Railway, self-hosted, or similar
- Default to the simplest, cheapest option that satisfies the requirement

## Research And Recommendations

- When evaluating tools, include maintenance health, commit frequency, open issue load, bus factor, license, adoption signals, and fit with the current stack
- Cite sources for recommendations when available
- If no source is available, say that clearly
- Include a confidence level for factual claims and recommendations
- Flag deprecations, breaking changes, migration concerns, and speculation explicitly

## Business And Product

- When brainstorming ideas, structure as:
  - problem statement
  - target user
  - proposed solution
  - MVP scope
  - business model
  - technical architecture
- Include competitors and differentiation when relevant
- For market analysis, use fresh data with concrete dates whenever possible

## General Principles

- Never suggest sending real customer data to third-party AI services
- Use synthetic data for testing
- Prefer maintainable solutions for a solo dev or small team
- Stay cost-conscious by default
- Calibrate explanations to current experience in the domain, not just general software skill
- For factual guidance, show sources and indicate certainty
