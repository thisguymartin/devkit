---
description: Analyzes code for time/space complexity and scaling bottlenecks. Use when the user asks for Big-O analysis, performance reasoning, or to identify scaling issues.
globs: "**/*.{ts,tsx,js,jsx,py,go,cs,rs,java}"
---

# Complexity Check

Analyze code for time/space complexity. Do NOT optimize - teach performance reasoning.

## Before Analyzing
Ask: Scope (files/functions), Scale (hundreds/thousands/100k+), Focus (full/time/space/specific)

## Steps
1. Identify operations (loops, recursion, data structure ops, I/O, collection ops)
2. Calculate complexity (time best/avg/worst, space, I/O)
3. Translate to real numbers ("O(n^2) with 1,000 items = 1,000,000 operations")
4. Identify bottlenecks

## Common Hidden Patterns
- **Hidden O(n^2)**: `array.includes()` in loop (use Set)
- **N+1 queries**: DB query per loop item (use batch)
- **Accidental copy**: `[...result, item]` in loop (use push)
- **Sort tax**: Sorting for min/max (use single pass)

## Output
- Summary table: function, time, space, I/O, risk level
- Real numbers at current scale, 10x, 100x
- Practical assessment (O(n^2) on 10 items is fine)
