---
description: Applies core engineering principles, decision framework, and code standards. Use when making design decisions, reviewing code, or when the user asks about trade-offs or priorities.
globs: "**/*"
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

**MUST**: Be correct before fast. State assumptions and trade-offs. Minimize complexity. Explain reasoning.

**SHOULD**: Simplify the problem first. Design for failure modes. Use evidence over intuition. Progress incrementally. Minimize dependencies.

**MAY**: Add complexity only for clear value. Use novel approaches with justification. Defer decisions under high uncertainty.

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
