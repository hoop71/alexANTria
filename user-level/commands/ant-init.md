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

### Documentation Standards

**Write minimal, load-bearing docs:**
- Only document what's actually needed for agents to make correct decisions
- No preamble, no "helpful introductions", no fluff
- If you can't justify why a doc exists in one sentence, don't create it
- Lower token cost = easier to maintain = more likely to stay in sync

**Examples:**
- ❌ "This document describes our authentication strategy. Authentication is very important for security..." (fluff)
- ✅ "Use JWT tokens (refresh + access). Refresh tokens in httpOnly cookies, access in memory." (load-bearing)

**When generating CLAUDE.md and rules:**
- Be terse and specific
- Point to existing docs, don't duplicate them
- Use imperative language ("Read X before Y", not "It would be helpful to read...")
- Every sentence should change agent behavior

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

## Phase 2: Propose & Configure

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

### Ask: Where Should ANT Take Over?

```
Use AskUserQuestion:

Question: "Which layer should worker ant auto-maintain?"
Header: "Starting Level"
Options:
1. Surface level only (Recommended for pilot)
   Description: Creates ANT-SURFACE.md in directories. Everything else gets suggestions only. Lowest risk, test the system.

2. Tunnels level (architecture + surface)
   Description: Creates ANT-SURFACE.md + ANT-TUNNELS.md. Auto-maintains both. Medium risk, suitable after pilot succeeds.

3. Chambers level (patterns + architecture + surface)
   Description: Creates ANT-SURFACE.md + ANT-TUNNELS.md + ANT-CHAMBERS.md. Auto-maintains all three. Higher risk, for full adoption.
```

Based on selection, set `starting_level` to "surface", "tunnels", or "chambers".

**Note:** ANT-NEST.md and ANT-QUEEN.md always require manual updates (strategic/product layers).

### Ask: Adoption Mode

```
Use AskUserQuestion:

Question: "How should ANT handle existing README.md files?"
Header: "Adoption Mode"
Options:
1. ANT-only (Recommended for new repos)
   Description: Create ANT-SURFACE.md, no README.md. Full automation from day 1.

2. Hybrid-to-ANT (Recommended for existing repos)
   Description: Keep existing README.md, create ANT-SURFACE.md alongside. Worker ant updates ANT-SURFACE.md only. Use /ant-migrate later to convert README → ANT-SURFACE.
```

Based on selection:
- **ANT-only:** Create only ANT-* files, suggest migrating any existing README.md files
- **Hybrid-to-ANT:** Create ANT-* files alongside existing README.md files

### Ask: Scope

For existing repos, ask which directories to manage:

```
Use AskUserQuestion:

Question: "Which directories should worker ant manage?"
Header: "Scope"
Options:
1. Single directory (pilot stage)
   Description: Test in one directory (e.g., src/auth/). Minimal risk, prove it works.

2. Multiple directories (active stage)
   Description: Manage multiple directories (e.g., src/, lib/). Expanding adoption.

3. Entire repo (full stage)
   Description: Manage all directories (**). Full automation.
```

Based on selection, set `managed_paths` in config.json:
- **Single directory:** Ask which one (e.g., "src/auth/**")
- **Multiple directories:** Ask which ones (e.g., ["src/**", "lib/**"])
- **Entire repo:** Set to ["**"]

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

### Create ANT-* Files Based on Starting Level

Based on the selected `starting_level`, create the appropriate ANT-* files:

**If starting_level = "surface":**
```bash
# Create ANT-SURFACE.md in each directory under managed_paths
# Use template from templates/ANT-SURFACE.md.template
```

**If starting_level = "tunnels":**
```bash
# Create ANT-SURFACE.md in each directory
# Create ANT-TUNNELS.md at repo root
# Use templates from templates/
```

**If starting_level = "chambers":**
```bash
# Create ANT-SURFACE.md in each directory
# Create ANT-TUNNELS.md at root
# Create ANT-CHAMBERS.md at root
# Use templates from templates/
```

**Always create (not auto-maintained, but part of structure):**
- ANT-NEST.md (optional, for product/business context)
- ANT-QUEEN.md (optional, for strategic alignment)

These higher-layer files are never auto-maintained, only get suggestions.

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
  "changes": [],
  "suggested_reviews": []
}
```

Create config for worker ant behavior based on user selections:

```json
{
  "version": "0.1",
  "worker_ant": {
    "enabled": true,
    "mode": "auto"
  },
  "scope": {
    "managed_paths": ["[from user selection]"],
    "exclude_paths": [],
    "starting_level": "[surface|tunnels|chambers]"
  },
  "auto_update": {
    "ant_files": true
  },
  "commit_tracking": {
    "enabled": true
  },
  "adoption_stage": "[pilot|active|full]"
}
```

**Adoption stage mapping:**
- Single directory + surface → "pilot"
- Multiple directories + surface/tunnels → "active"
- Entire repo + tunnels/chambers → "full"

### Configure Worker Ant (Optional)

Ask the user how they want worker ant to behave:

```
🐜 Worker Ant Configuration

How should worker ant maintain docs when you commit?

1. Auto (recommended)
   - Agents spawn worker ant before commit (sub-agent pattern)
   - Humans get reminder if worker ant hasn't run
   - Pre-commit hook detects if agent already ran

2. Agent-only
   - Only agents spawn worker ant (sub-agent pattern)
   - Humans warned to commit via agent or run /ant-update after
   - Good for teams standardizing on agent commits

3. Manual
   - No automatic behavior
   - Always run /ant-update manually after committing
   - Good for testing or minimal adoption

Choose mode [1-3]:
```

Based on selection, set `config.json` mode to "auto", "agent-only", or "manual".

### Install Pre-Commit Hook

If worker ant enabled, install smart pre-commit hook:

```bash
# Create hooks directory if needed
mkdir -p .git/hooks

# Copy pre-commit hook template
cp ~/.claude/alexantria/templates/hooks/pre-commit .git/hooks/pre-commit

# Make it executable
chmod +x .git/hooks/pre-commit
```

**What the hook does:**
1. Checks if worker ant already ran (manifest staged with pending entry)
2. If yes: Skips (agent already did the work)
3. If no: Follows mode from config (warn, try to spawn, or skip)

This ensures partial adoption doesn't break the system - hook is smart about agent vs human commits.

## Phase 4: Summary & Team Adoption Checklist

Show what was created:

```
🐜 Colony Established

Configuration:
  Adoption Mode: [ANT-only | Hybrid-to-ANT]
  Starting Level: [surface | tunnels | chambers]
  Managed Paths: [scope from config]
  Adoption Stage: [pilot | active | full]

Created:
  CLAUDE.md                    — 5-layer anthill hierarchy
  .claude/rules/
    ├── frontend.md            — For src/components/**
    ├── backend.md             — For src/server/**
    └── [domain].md            — For detected code domains
  .alexantria/
    ├── config.json            — Worker ant configuration
    └── manifest.json          — Change tracking and suggestions
  [ANT-SURFACE.md files]       — In managed directories
  [ANT-TUNNELS.md]             — If starting_level >= tunnels
  [ANT-CHAMBERS.md]            — If starting_level >= chambers
  .git/hooks/
    └── pre-commit             — Smart hook (detects agent commits)

The anthill structure:
  👑 Queen: [Strategic docs] (manual updates only)
  🐜 Nest: [Product docs] (manual updates only)
  🏛️ Chambers: [Cross-cutting patterns] (auto if starting_level >= chambers, else suggestions)
  🚇 Tunnels: [Architecture docs] (auto if starting_level >= tunnels, else suggestions)
  🌱 Surface: [Per-service docs] (always auto-maintained)

Automation Boundary:
  Below starting_level: Fully automated
  Above starting_level: Suggestions only (use /ant-review-suggestions)

External context feeds (read-only):
  [path/to/external/] (ANT-EXTERNAL) - [Description]
```

### Team Adoption Checklist

Present this checklist to the user:

```
## Team Adoption Checklist

Before committing and sharing with your team:

✓ Configuration
  [ ] Config committed (.alexantria/config.json)
  [ ] Scope matches team's comfort level (pilot/active/full)
  [ ] Starting level appropriate (recommend: surface for pilot)
  [ ] Adoption mode chosen (ANT-only vs Hybrid-to-ANT)

✓ Pre-commit Hook
  [ ] Hook installed (.git/hooks/pre-commit)
  [ ] Hook is executable (chmod +x)
  [ ] Team understands hook behavior (smart detection)

✓ Documentation
  [ ] CLAUDE.md committed (hierarchy map)
  [ ] Rules committed (.claude/rules/)
  [ ] ANT-* files created in managed paths
  [ ] Team knows which docs are auto-maintained

✓ Team Alignment
  [ ] Team understands ANT-* files are auto-maintained below starting_level
  [ ] Team knows to use /ant-commit for agent commits
  [ ] Team knows to use /ant-review-suggestions for higher-layer updates
  [ ] Team comfortable with adoption stage (can rip out if needed)

✓ First Commit Test
  [ ] Make a code change in managed path
  [ ] Run /ant-commit "Test worker ant"
  [ ] Verify ANT-SURFACE.md updated
  [ ] Verify manifest updated
  [ ] Single commit contains code + docs + manifest

Ready to commit? Run:
  git add .
  /ant-commit "Initialize alexANTria colony"

After team onboarding:
  1. Share this checklist with team
  2. Have each member run /ant-validate to verify setup
  3. Monitor first 5-10 commits for quality
  4. Adjust scope/starting_level as needed
  5. Use /ant-migrate to convert README.md files when ready
```

Show this checklist and ask user if they're ready to commit the initialization.

## Notes

- **Don't create docs that don't exist** — only reference what's there
- **Keep rules files short** — they point to docs, not duplicate them
- **Respect existing setup** — if CLAUDE.md exists, offer to enhance not replace
- **When uncertain, ask** — use AskUserQuestion rather than guessing
