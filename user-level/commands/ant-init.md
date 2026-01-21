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

### Detect External Context Feeds

```bash
# Find ANT-EXTERNAL.md markers
find . -name "ANT-EXTERNAL.md" -type f 2>/dev/null | grep -v node_modules | grep -v .git
```

Any directories containing `ANT-EXTERNAL.md` are external context feeds and should be excluded from layer mapping.

### Classify Found Docs

Read each discovered doc file briefly to understand its purpose. Map to the 5-layer anthill:

**👑 Queen - Strategic Alignment** (look for):
- Files with "strategy", "vision", "mission", "philosophy" in name
- Content with "always", "never", "must", "non-negotiable"
- Core principles, security constraints, company values
- Examples: `PHILOSOPHY.md`, `PRINCIPLES.md`, main `CLAUDE.md`

**🐜 Nest - Product/Business Context** (look for):
- Files with "product", "prd", "requirements", "scope", "brief" in name
- Content with "users can", "the system should", "features"
- Business rules, domain logic docs
- Examples: `product-brief.md`, `REQUIREMENTS.md`, `business-rules.md`

**🏛️ Chambers - Cross-Cutting Patterns** (look for):
- Design systems, shared component libraries
- Cross-service patterns, integration guides
- Org-wide conventions that span multiple services
- Examples: Design system docs, shared API patterns

**🚇 Tunnels - Architecture/Service Connections** (look for):
- Files with "architecture", "patterns", "conventions", "contributing", "api" in name
- Content with "we use", "structure", "components"
- Tech stack docs, coding standards, service boundaries
- Examples: `ARCHITECTURE.md`, `CONTRIBUTING.md`, `API.md`

**🌱 Surface - Individual Service Docs** (look for):
- README files, package-specific documentation
- Per-app/per-package CLAUDE.md files
- Service-level implementation details
- Examples: `apps/*/README.md`, `packages/*/CLAUDE.md`

**Note:** Skip any directories marked with `ANT-EXTERNAL.md` - these are external context feeds, not local docs to manage.

## Phase 2: Propose

Present findings to the user:

```
## Found Documentation

I found these docs and mapped them to the 5-layer anthill:

### 👑 Queen: Strategic Alignment
- [x] CLAUDE.md "Core Principles" — Non-negotiables
- [ ] (none found)

### 🐜 Nest: Product/Business Context
- [x] docs/product-brief.md — Product requirements
- [ ] (none found)

### 🏛️ Chambers: Cross-Cutting Patterns
- [x] packages/design-system/ — Shared UI components
- [ ] (none found)

### 🚇 Tunnels: Architecture/Service Connections
- [x] ARCHITECTURE.md — System design
- [x] CONTRIBUTING.md — Code conventions

### 🌱 Surface: Individual Service Docs
- [x] apps/*/README.md — Per-app documentation
- [x] packages/*/CLAUDE.md — Per-package context

### External Context Feeds (ANT-EXTERNAL)
- [x] docs/alexandria/ — Platform-wide intelligence (read-only)

### Code Structure Detected
- src/components/ → frontend rules
- src/server/ → backend rules
- packages/ → monorepo structure

Does this look right? Should I adjust any mappings?
```

Use `AskUserQuestion` to confirm or let them adjust.

## Phase 3: Generate

Create the context files based on confirmed mappings.

### Create CLAUDE.md

Generate a project-level CLAUDE.md with:

```markdown
# [Project Name] – Context

## The Anthill

This project uses the 5-layer anthill structure. Higher layers constrain lower layers.

### 👑 Queen: Strategic Alignment
- **[doc-name.md](./path)** — Non-negotiable principles

### 🐜 Nest: Product/Business Context
- **[doc-name.md](./path)** — What we're building

### 🏛️ Chambers: Cross-Cutting Patterns
- **[doc-name.md](./path)** — Patterns that span services

### 🚇 Tunnels: Architecture/Service Connections
- **[doc-name.md](./path)** — How services connect

### 🌱 Surface: Individual Service Docs
- **[doc-name.md](./path)** — Per-service implementation

## External Context Feeds

These directories contain read-only context from external sources:

- **[path/to/external/](./)** (ANT-EXTERNAL)
  - Source: [Generator name]
  - Update: [Frequency]
  - Purpose: [What it provides]

## When to Read

| Working on... | Read first |
|--------------|------------|
| Strategic decisions | Queen layer |
| New features | Nest + Chambers |
| Cross-service patterns | Chambers + Tunnels |
| Service implementation | Tunnels + Surface |
| Bug fixes | Surface + Tunnels |

## After Completing Work

Ask yourself:
- Did I establish a **new pattern**? → Suggest updating Chambers/Tunnels
- Did I change **product behavior**? → Suggest updating Nest layer
- Did I violate a **constraint**? → Discuss with user before proceeding
- Did implementation diverge from architecture? → Update Surface or Tunnels
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

### Install Git Hook (Optional)

Ask the user if they want to install a placeholder post-commit hook:

```
Would you like to install a placeholder post-commit hook?

This installs a disabled hook file for future use. Currently, /ant-update
works by processing the most recent commit (HEAD) when you run it manually.

You can enable automatic tracking later by editing .git/hooks/post-commit.
```

If yes, install the placeholder hook:

```bash
# Create hooks directory if needed
mkdir -p .git/hooks

# Install placeholder hook
cat > .git/hooks/post-commit << 'HOOK'
#!/bin/bash
# alexANTria post-commit hook
# Placeholder - hook disabled in favor of manual /ant-update runs
#
# This hook is installed but does nothing. Run /ant-update manually
# after commits when you want to update surface docs.

exit 0
HOOK

# Make it executable
chmod +x .git/hooks/post-commit
```

If no, skip the hook installation. The user can always run `/ant-update` manually to process HEAD.

## Phase 4: Summary

Show what was created:

```
🐜 Colony Established

Created:
  CLAUDE.md                    — 5-layer anthill hierarchy
  .claude/rules/
    ├── frontend.md            — For src/components/**
    ├── backend.md             — For src/server/**
    └── [domain].md            — For detected code domains
  .alexantria/
    ├── manifest.json          — Worker ant tracking
    └── pending.log            — Pending commits queue (created by hook)
  .git/hooks/
    └── post-commit            — Auto-tracks commits (if installed)

The anthill structure:
  👑 Queen: [Strategic docs]
  🐜 Nest: [Product docs]
  🏛️ Chambers: [Cross-cutting patterns]
  🚇 Tunnels: [Architecture docs]
  🌱 Surface: [Per-service docs]

External context feeds (read-only):
  [path/to/external/] (ANT-EXTERNAL) - [Description]

Next steps:
  1. Review CLAUDE.md and adjust layer mappings if needed
  2. Check .claude/rules/ quick references
  3. After commits, run /ant-update to process pending and keep docs fresh
  4. External feeds are consumed but not managed - changes tracked via manifest
```

## Notes

- **Don't create docs that don't exist** — only reference what's there
- **Keep rules files short** — they point to docs, not duplicate them
- **Respect existing setup** — if CLAUDE.md exists, offer to enhance not replace
- **When uncertain, ask** — use AskUserQuestion rather than guessing
