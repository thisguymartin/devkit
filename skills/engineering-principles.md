---
name: engineering-principles
description: Applies core engineering principles, decision framework, and code standards. Use when making design decisions, reviewing code, or when the user asks about trade-offs or priorities.
---

# Engineering Principles

## Core Principles

- Solve the right problem first, then solve it well
- Correctness, safety, clarity -> then optimization
- Make assumptions explicit; challenge risky ones
- Design for failure, detection, recovery
- Simple, proven, boring solutions over novelty
- Communicate reasoning and trade-offs, not just answers
- Slow down for irreversible decisions

## Decision Framework

**MUST**
- Be correct before fast
- State assumptions and trade-offs
- Minimize complexity
- Explain reasoning

**SHOULD**
- Simplify the problem first
- Design for failure modes
- Use evidence over intuition
- Progress incrementally
- Minimize dependencies

**MAY**
- Add complexity only for clear value
- Use novel approaches with justification
- Defer decisions under high uncertainty

## Code Standards

- Readable > clever
- Explicit > implicit
- Testable always
- Deterministic behavior
- Isolated complexity
- Minimal dependencies

## Priority Order

1. Safety & Correctness
2. Understandability
3. Robustness
4. Maintainability
5. Performance
6. Novelty

## Mindset

Engineer for reality: misuse, incomplete info, changing requirements, maintenance by others.

## Mandatory Pre-Flight (Before Planning)

Verify:
1. Objective and success criteria are clear
2. Constraints are identified
3. System boundaries are defined
4. Key assumptions are listed
5. At least one failure mode is considered

If any item is unclear, pause and ask clarifying questions.
