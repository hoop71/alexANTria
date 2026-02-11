---
description: Initialize colony in project
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

## Phase 1: Crawl (Silent Discovery)

**IMPORTANT:** Consolidate all discovery into ONE bash command. The user should NOT see multiple individual commands.

```bash
{
  echo "=== DOCUMENTATION ==="
  find . -maxdepth 3 -name "*.md" -type f 2>/dev/null | grep -v node_modules | grep -v .git | head -50

  echo "=== DIRECTORIES ==="
  ls -d */ 2>/dev/null | head -20

  echo "=== CODE STRUCTURE ==="
  ls src/ app/ lib/ packages/ 2>/dev/null || echo "none"

  echo "=== EXISTING SETUP ==="
  ls .claude/ CLAUDE.md .alexantria/ 2>/dev/null || echo "none"

  echo "=== EXTERNAL FEEDS ==="
  find . -name "ANT-EXTERNAL.md" -type f 2>/dev/null | grep -v node_modules | grep -v .git || echo "none"
}
```

**After this command, process the data internally.** Do not show additional bash commands or file reads to the user.

### Classify Found Docs

Read each discovered doc file briefly to understand its purpose. Map to the RLM 3-pool architecture:

**Pool 3: Intentional (Human Knowledge)**

**Strategy Layer** (look for):
- Files with "strategy", "vision", "mission", "philosophy" in name
- Content with "always", "never", "must", "non-negotiable"
- Core principles, security constraints, company values
- Examples: `PHILOSOPHY.md`, `PRINCIPLES.md`, main `CLAUDE.md`

**Product Layer** (look for):
- Files with "product", "prd", "requirements", "scope", "brief" in name
- Content with "users can", "the system should", "features"
- Business rules, domain logic docs
- Examples: `product-brief.md`, `REQUIREMENTS.md`, `business-rules.md`

**Pool 2: Tokenized (Active in Attention)**

**Patterns Layer** (look for):
- Design systems, shared component libraries
- Cross-service patterns, integration guides
- Org-wide conventions that span multiple services
- Examples: Design system docs, shared API patterns

**Pool 1: Programmatic (Code-Inferable)**

**Architecture Layer** (look for):
- Files with "architecture", "conventions", "contributing", "api" in name
- Content with "we use", "structure", "components"
- Tech stack docs, coding standards, service boundaries
- Examples: `ARCHITECTURE.md`, `CONTRIBUTING.md`, `API.md`

**Service Layer** (look for):
- README files, package-specific documentation
- Per-app/per-package CLAUDE.md files
- Service-level implementation details
- Examples: `apps/*/README.md`, `packages/*/CLAUDE.md`

**Note:** Skip any directories marked with `ANT-EXTERNAL.md` - these are external context feeds, not local docs to manage.

## Phase 2: Propose & Configure

Present findings to the user:

```
## Found Documentation

I found these docs and mapped them to the RLM architecture:

### Pool 3: Intentional (Human Knowledge)

**Strategy Layer**
- [x] CLAUDE.md "Core Principles" — Non-negotiables
- [ ] (none found)

**Product Layer**
- [x] docs/product-brief.md — Product requirements
- [ ] (none found)

### Pool 2: Tokenized (Active in Attention)

**Patterns Layer**
- [x] packages/design-system/ — Shared UI components
- [ ] (none found)

### Pool 1: Programmatic (Code-Inferable)

**Architecture Layer**
- [x] ARCHITECTURE.md — System design
- [x] CONTRIBUTING.md — Code conventions

**Service Layer**
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
1. Service only (Recommended for pilot)
   Description: Creates ANT-SURFACE.md in directories. Everything else gets suggestions only. Lowest risk, test the system.

2. Architecture level (architecture + service)
   Description: Creates ANT-SURFACE.md + ANT-ARCHITECTURE.md. Auto-maintains both programmatic layers. Medium risk, suitable after pilot succeeds.

3. Patterns level (patterns + architecture + service)
   Description: Creates ANT-SURFACE.md + ANT-ARCHITECTURE.md + ANT-PATTERNS.md. Auto-maintains all through tokenized layer. Higher risk, for full adoption.
```

Based on selection, set `starting_level: "docs".

**Note:** ANT-PRODUCT.md and ANT-STRATEGY.md always require manual updates (strategic/product layers).

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

### Ask: Collaboration Mode

```
Use AskUserQuestion:

Question: "How will you use alexANTria?"
Header: "Collaboration Mode"
Options:
1. Local-only (Recommended for individual testing)
   Description: Gitignore all alexANTria files except config.json. Test privately before sharing with team. Run /ant-publish when ready.

2. Team-shared (Recommended for established projects)
   Description: Track alexANTria files in git. Team sees all ANT-* docs from day 1. Standard adoption path.
```

Based on selection:
- **Local-only:** Set `collaboration.mode = "local_only"`, `gitignored_at = <current ISO timestamp>`, `published_at = null`. Create .gitignore section.
- **Team-shared:** Set `collaboration.mode = "team_shared"`, `gitignored_at = null`, `published_at = null`. No .gitignore changes.

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

### Create .gitignore Section (If Local-Only Mode)

If user selected collaboration mode = "local_only":

**First, check if .gitignore is itself gitignored:**
```bash
git check-ignore .gitignore
```

If exit code 0 (is ignored):
- Show: "⚠️  .gitignore is gitignored. This will cause issues with local-only mode."
- Show: "Remove .gitignore from .gitignore first, then retry /ant-init."
- Pause: Exit command without making changes

**If .gitignore is not ignored, proceed:**

```bash
# Append alexANTria section to .gitignore (or create if doesn't exist)
cat >> .gitignore <<'EOF'

# alexANTria (local-only mode)
.alexantria/
!.alexantria/config.json
CLAUDE.md
.claude/
**/ANT-SURFACE.md
ANT-ARCHITECTURE.md
ANT-PATTERNS.md
ANT-PRODUCT.md
ANT-STRATEGY.md

EOF

# Stage .gitignore
git add .gitignore

echo "✓ Created .gitignore section for local-only mode"
```

**Note:** config.json is NOT gitignored (documents your configuration, makes publishing smoother).

If collaboration mode = "team_shared", skip this step entirely.

### Create CLAUDE.md

Generate a project-level CLAUDE.md with:

```markdown
# [Project Name] – Context

## RLM Architecture

This project uses the RLM 3-pool architecture. Higher pools constrain lower pools.

**RLM:** Programmatic (code) → Tokenized (attention) → Intentional (intent)

### Pool 3: Intentional (Human Knowledge)

**Strategy Layer**
- **[doc-name.md](./path)** — Non-negotiable principles

**Product Layer**
- **[doc-name.md](./path)** — What we're building

### Pool 2: Tokenized (Active in Attention)

**Patterns Layer**
- **[doc-name.md](./path)** — Cross-cutting conventions

### Pool 1: Programmatic (Code-Inferable)

**Architecture Layer**
- **[doc-name.md](./path)** — System structure

**Service Layer**
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
| Strategic decisions | Strategy (Intentional) |
| New features | Product + Patterns |
| Cross-service patterns | Patterns (Tokenized) |
| Service implementation | Architecture + Service (Programmatic) |
| Bug fixes | Service + Architecture |

## After Completing Work

Ask yourself:
- Did I establish a **new pattern**? → Suggest updating Patterns (Tokenized)
- Did I change **product behavior**? → Suggest updating Product (Intentional)
- Did I violate a **constraint**? → Discuss with user before proceeding
- Did implementation diverge from architecture? → Update Service or Architecture (Programmatic)
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

**If starting_level = "service":**
```bash
# Create ANT-SURFACE.md in each directory under managed_paths
# Use template from templates/ANT-SURFACE.md.template
```

**If starting_level = "architecture":**
```bash
# Create ANT-SURFACE.md in each directory
# Create ANT-ARCHITECTURE.md at repo root
# Use templates from templates/
```

**If starting_level = "patterns":**
```bash
# Create ANT-SURFACE.md in each directory
# Create ANT-ARCHITECTURE.md at root
# Create ANT-PATTERNS.md at root
# Use templates from templates/
```

**Always create (not auto-maintained, but part of structure):**
- ANT-PRODUCT.md (optional, for product/business context)
- ANT-STRATEGY.md (optional, for strategic alignment)

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
    "starting_level": "[service|architecture|patterns]"
  },
  "auto_update": {
    "ant_files": true
  },
  "commit_tracking": {
    "enabled": true
  },
  "adoption_stage": "[pilot|active|full]",
  "collaboration": {
    "mode": "[local_only|team_shared]",
    "gitignored_at": "[ISO timestamp if local_only, null if team_shared]",
    "published_at": null
  }
}
```

**Adoption stage mapping:**
- Single directory + surface → "pilot"
- Multiple directories + surface/tunnels → "active"
- Entire repo + tunnels/chambers → "full"

**Collaboration field:**
- If local_only selected: `"mode": "local_only"`, `"gitignored_at": "<current ISO timestamp>"`, `"published_at": null`
- If team_shared selected: `"mode": "team_shared"`, `"gitignored_at": null`, `"published_at": null`

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
  Starting Level: [service | architecture | patterns]
  Managed Paths: [scope from config]
  Adoption Stage: [pilot | active | full]
  Collaboration Mode: [local-only | team-shared]

Created:
  CLAUDE.md                    — RLM 3-pool hierarchy
  .claude/rules/
    ├── frontend.md            — For src/components/**
    ├── backend.md             — For src/server/**
    └── [domain].md            — For detected code domains
  .alexantria/
    ├── config.json            — Worker ant configuration
    └── manifest.json          — Change tracking and suggestions
  [ANT-SURFACE.md files]       — In managed directories
  [ANT-ARCHITECTURE.md]             — If starting_level >= architecture
  [ANT-PATTERNS.md]            — If starting_level >= patterns
  .git/hooks/
    └── pre-commit             — Smart hook (detects agent commits)

The RLM architecture:
  Pool 3 (Intentional): Strategy + Product [manual updates only]
  Pool 2 (Tokenized): Patterns [suggestions only]
  Pool 1 (Programmatic): Architecture + Service [auto-maintained based on starting_level]

Automation Boundary:
  Below starting_level: Fully automated
  Above starting_level: Suggestions only (use /ant-review-suggestions)

External context feeds (read-only):
  [path/to/external/] (ANT-EXTERNAL) - [Description]
```

### Post-Init Messaging

**If collaboration mode = local-only, show:**

```
📍 Local-Only Mode Active

Your alexANTria files are private (gitignored).

What this means:
  ✓ You can experiment freely without team seeing changes
  ✓ Worker ant still maintains docs locally
  ✓ All features work normally (validation, guardians, etc.)

  ✗ Team members won't see your ANT-* docs
  ✗ Your docs won't be in version control (except config.json)

When ready to share with team: /ant-publish

Files gitignored:
  .alexantria/ (except config.json)
  CLAUDE.md
  .claude/
  ANT-*.md

File tracked:
  .alexantria/config.json (documents your configuration)
```

**If collaboration mode = team-shared, skip this message.**

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
