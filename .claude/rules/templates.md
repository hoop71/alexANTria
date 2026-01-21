---
paths:
  - "templates/**"
---

# Template Context

Before modifying templates, read:
- [ANT-SCHEMA.md](../../ANT-SCHEMA.md) — The nesting doll documentation pattern
- [templates/README.md](../../templates/README.md) — How templates and placeholders work

## Quick Reference

- **Templates are starting points** — Users customize before install, not after generation
- **Placeholders** — Use `[project-name]`, `[domain]`, `[path/to/doc]` format for substitution
- **5-layer anthill** — Templates reflect Queen → Nest → Chambers → Tunnels → Surface structure
- **Bidirectional flow** — Templates support both upward signals and downward constraints
- **Bring Your Own** — Templates are designed for user customization, not rigid enforcement

## Template Types

| Template | Purpose | Layer |
|----------|---------|-------|
| CLAUDE.md.template | Doc hierarchy + when to read | Entry point |
| rules/*.template | Path-specific context loading | Auto-loaded |
| ANT-EXTERNAL.md.template | External context marker | Meta |

## When to Update Templates

- New layer added to anthill → Update CLAUDE.md.template
- New domain pattern emerges → Add rules/*.template
- Command behavior changes → Update command references in templates
