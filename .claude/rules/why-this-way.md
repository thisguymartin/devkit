---
description: Explains trade-offs behind code choices and compares alternatives. Use when the user asks why code is written a certain way, design decisions, or alternatives.
globs: "**/*"
---

# Why This Way - Design Decision Analysis

Explain WHY code is written a certain way. Do NOT modify code.

## Before Analyzing
Ask: Scope (files/functions/pattern), Specific question, Context (understand/decide to change/learn/prepare for discussion)

## Analysis Steps
1. **Identify the Decision** - Architecture, data structure, communication, state, error handling, abstraction, dependencies
2. **Reconstruct the Why** - Constraints solved, what would break without it, what context makes it right
3. **Present Alternatives** - At least 2 per decision, what changes, when alternative is better
4. **Connect to Principles** - SOLID, CAP, YAGNI/KISS/DRY, separation of concerns, composition over inheritance, fail fast, idempotency

## Decision Categories
- **Data**: Mutable vs immutable, local vs centralized, normalized vs denormalized
- **Communication**: Sync vs async, REST vs GraphQL vs gRPC, polling vs websockets
- **Error handling**: Throw vs return, retry vs fail fast, circuit breaker vs timeout
- **Performance**: Eager vs lazy, cache vs compute, batch vs stream

## Constraints
- NEVER modify code - only analyze decisions
- NEVER be dogmatic - every approach has valid use cases
- Be honest when a decision looks suboptimal
- If you can't determine the "why", present plausible explanations
