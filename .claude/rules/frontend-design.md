---
description: Create distinctive, production-grade frontend interfaces with high design quality. Use this skill when the user asks to build web components, pages, artifacts, posters, or applications. Generates creative, polished code that avoids generic AI aesthetics.
globs: "**/*.{html,css,scss,tsx,jsx,vue,svelte}"
---

# Frontend Design (Impeccable)

This skill guides creation of distinctive, production-grade frontend interfaces that avoid generic "AI slop" aesthetics.

## Design Direction

Commit to a BOLD aesthetic direction:
- **Purpose**: What problem does this interface solve?
- **Tone**: Pick an extreme: brutally minimal, maximalist, retro-futuristic, organic, luxury, playful, editorial, brutalist, art deco, soft/pastel, industrial
- **Differentiation**: What makes this UNFORGETTABLE?

## Typography
- Choose distinctive fonts. **DON'T**: Inter, Roboto, Arial, Open Sans, system defaults
- Better alternatives: Instrument Sans, Plus Jakarta Sans, Outfit, Onest, Figtree, Fraunces
- Use modular type scale with fluid sizing (clamp)
- Vary font weights and sizes for clear hierarchy

## Color & Theme
- Use OKLCH for perceptually uniform palettes
- Tint neutrals toward brand hue (even 0.01 chroma creates cohesion)
- **DON'T**: gray text on colored backgrounds, pure black (#000), cyan-on-dark AI palette, gradient text

## Layout & Space
- Create visual rhythm through varied spacing
- **DON'T**: wrap everything in cards, nest cards inside cards, identical card grids, center everything

## Motion
- Use exponential easing (ease-out-quart/quint/expo)
- Only animate transform and opacity
- **DON'T**: bounce or elastic easing, animate layout properties

## Visual Details
- **DON'T**: glassmorphism everywhere, rounded rectangles with generic shadows, sparklines as decoration

## The AI Slop Test
If someone would say "AI made this" immediately — that's the problem. A distinctive interface should make someone ask "how was this made?"

## Reference Files
Consult `skills/frontend-design/reference/` for deep dives:
- typography.md, color-and-contrast.md, spatial-design.md
- motion-design.md, interaction-design.md, responsive-design.md, ux-writing.md

*License: Apache 2.0. Based on Anthropic's frontend-design skill. See skills/frontend-design/NOTICE.md*
