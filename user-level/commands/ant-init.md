---
description: Crawl project docs and scaffold context files
allowed-tools: Read, Write, Glob, Grep, Bash, AskUserQuestion
---

# 🐜 Ant Init: Establish the Colony

Automatically detect existing documentation and scaffold context files for coding agents.

## Philosophy

You are the first ant entering new territory. Your job is to:
- Scout what documentation already exists
- Map it to the colony's hierarchy
- Lay down the initial pheromone trails (CLAUDE.md, rules)

## Phase 1: Crawl

First, discover what documentation already exists.

### Find Documentation Files

```bash
# Find markdown files in common locations
find . -maxdepth 3 -name "*.md" -type f 2>/dev/null | grep -v node_modules | grep -v .git | head -50
```

```bash
# Check for docs directories
ls -la docs/ doc/ documentation/ 2>/dev/null || true
```

```bash
# Check for existing setup
ls -la .claude/ CLAUDE.md 2>/dev/null || true
```

### Identify Code Structure

```bash
# Find main code directories
ls -d */ 2>/dev/null | head -20
```

```bash
# Look for common patterns
ls src/ app/ lib/ packages/ 2>/dev/null || true
```

### Classify Found Docs

Read each discovered doc file briefly to understand its purpose. Map to the nesting doll layers:

**Layer 1 - Philosophy/Constraints** (look for):
- Files with "philosophy", "principles", "constraints", "values" in name
- Content with "always", "never", "must", "non-negotiable"
- Design systems, UX guidelines

**Layer 2 - Product/Business** (look for):
- Files with "product", "prd", "requirements", "scope", "brief" in name
- Content with "users can", "the system should", "features"
- Business rules, domain logic docs

**Layer 3 - Architecture/Patterns** (look for):
- Files with "architecture", "patterns", "conventions", "contributing", "api" in name
- Content with "we use", "structure", "components"
- Tech stack docs, coding standards

**Layer 4 - Implementation** (look for):
- CHANGELOG, ADRs, decision records
- TODO files, roadmaps
- Code comments (don't need to catalog these)

## Phase 2: Propose

Present findings to the user:

```
## Found Documentation

I found these docs and mapped them to the hierarchy:

### Layer 1: Philosophy/Constraints
- [x] docs/ux-philosophy.md — "Design principles"

### Layer 2: Product/Business
- [x] docs/product-brief.md — "Product requirements"
- [ ] (none found)

### Layer 3: Architecture/Patterns
- [x] ARCHITECTURE.md — "System design"
- [x] CONTRIBUTING.md — "Code conventions"

### Layer 4: Implementation
- [x] CHANGELOG.md — "Version history"

### Code Structure Detected
- src/components/ → frontend rules
- src/server/ → backend rules
- src/agents/ → agent rules

Does this look right? Should I adjust any mappings?
```

Use `AskUserQuestion` to confirm or let them adjust.

## Phase 3: Generate

Create the context files based on confirmed mappings.

### Create CLAUDE.md

Generate a project-level CLAUDE.md with:

```markdown
# [Project Name] – Context

## Document Hierarchy

<!-- Outer layers override inner layers when they conflict -->

### Layer 1: Philosophy/Constraints
- **[doc-name.md](./path)** — What it governs

### Layer 2: Product/Business
- **[doc-name.md](./path)** — What it governs

### Layer 3: Architecture/Patterns
- **[doc-name.md](./path)** — What it governs

### Layer 4: Implementation
- **[CHANGELOG.md](./CHANGELOG.md)** — Version history

## When to Read

| Working on... | Read first |
|--------------|------------|
| UI changes | Layer 1 philosophy + Layer 3 patterns |
| New features | Layer 2 product brief |
| Refactoring | Layer 3 architecture |
| Bug fixes | Layer 3 patterns |

## After Completing Work

Ask yourself:
- Did I establish a **new pattern**? → Suggest updating Layer 3 docs
- Did I change **product behavior**? → Suggest updating Layer 2 docs
- Did I violate a **constraint**? → Discuss with user before proceeding
```

### Create .claude/rules/

```bash
mkdir -p .claude/rules
```

Generate rule files for each detected code domain. Each rule should:
1. Have correct path globs in frontmatter
2. Reference the relevant docs from the hierarchy
3. Include a brief "Quick Reference" with key points from those docs

**Example: `.claude/rules/frontend.md`**

```markdown
---
paths:
  - "src/components/**"
  - "app/**/*.tsx"
---

# Frontend Context

Before modifying UI, read:
- [ux-philosophy.md](../../docs/ux-philosophy.md) — Design constraints

## Quick Reference
<!-- Pull 3-5 key points from the philosophy doc -->
- Key point 1
- Key point 2
```

Only create rules for code directories that actually exist.

### Create .alexantria/

```bash
mkdir -p .alexantria
```

Initialize the manifest for worker ants:

```json
{
  "version": "0.1",
  "repo": "[project-name]",
  "last_sync": null,
  "changes": []
}
```

## Phase 4: Summary

Show what was created:

```
🐜 Colony Established

Created:
  CLAUDE.md                    — Document hierarchy (4 docs mapped)
  .claude/rules/
    ├── frontend.md            — For src/components/**
    ├── backend.md             — For src/server/**
    └── agents.md              — For src/agents/**
  .alexantria/
    └── manifest.json          — Worker ant tracking

The hierarchy is:
  Layer 1: docs/ux-philosophy.md
  Layer 2: docs/product-brief.md
  Layer 3: ARCHITECTURE.md, CONTRIBUTING.md
  Layer 4: CHANGELOG.md

Next steps:
  1. Review CLAUDE.md and adjust if needed
  2. Check .claude/rules/ quick references
  3. After commits, run /ant-update to keep docs fresh
```

## Notes

- **Don't create docs that don't exist** — only reference what's there
- **Keep rules files short** — they point to docs, not duplicate them
- **Respect existing setup** — if CLAUDE.md exists, offer to enhance not replace
- **When uncertain, ask** — use AskUserQuestion rather than guessing
