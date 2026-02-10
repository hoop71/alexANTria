# alexANTria – Context

This is a meta-repo: a documentation framework that documents itself.

## Meta Documentation (Defines the Pattern)

These docs explain HOW the 5-layer pattern works:

- **[RLM-ARCHITECTURE.md](./RLM-ARCHITECTURE.md)** — RLM foundation (three-pool architecture, context rot prevention)
- **[ANT-FRAMEWORK.md](./ANT-FRAMEWORK.md)** — Coordination model (intelligence through coordination)
- **[ANT-SCHEMA.md](./ANT-SCHEMA.md)** — 5-layer nesting doll pattern
- **[README.md](./README.md)** — User-facing overview

## Implementation (alexANTria Documenting Itself)

These docs USE the 5-layer pattern to document alexANTria itself. Higher layers constrain lower layers.

### 👑 Queen: Strategic Alignment
- **[.alexantria/ANT-QUEEN.md](./.alexantria/ANT-QUEEN.md)** — alexANTria's core principles and constraints
  - ANT-* only principle
  - Read-act-repair pattern
  - No central brain
  - Automation boundary
  - Cost constraints

### 🐜 Nest: Product/Business Context
- **[.alexantria/ANT-NEST.md](./.alexantria/ANT-NEST.md)** — alexANTria's product context
  - What we solve (context drift, Gastown, adoption friction)
  - Key features (adoption ramp, guardians, clean removal)
  - Use cases (greenfield, brownfield, large teams)
  - User workflows
  - Success metrics

### 🏛️ Chambers: Cross-Cutting Patterns
- **[.alexantria/ANT-CHAMBERS.md](./.alexantria/ANT-CHAMBERS.md)** — alexANTria's internal patterns
  - Naming conventions (ant-*, ANT-*, .alexantria/)
  - Command structure pattern
  - Guardian pattern
  - Validation pattern
  - Error handling pattern

### 🚇 Tunnels: Architecture/Service Connections
- **[.alexantria/ANT-TUNNELS.md](./.alexantria/ANT-TUNNELS.md)** — alexANTria's architecture
  - System architecture
  - Service boundaries
  - Data flows (init, commit, validation)
  - Technology stack
  - Automation boundary

### 🌱 Surface: Individual Service Docs
- **[user-level/commands/ANT-SURFACE.md](./user-level/commands/ANT-SURFACE.md)** — Commands documentation
- **[templates/ANT-SURFACE.md](./templates/ANT-SURFACE.md)** — Templates documentation

## When to Read

| Working on... | Read first |
|--------------|------------|
| Understanding RLM foundation | Meta docs (RLM-ARCHITECTURE.md) |
| Understanding the pattern | Meta docs (ANT-FRAMEWORK.md, ANT-SCHEMA.md) |
| Strategic decisions for alexANTria | Queen layer (.alexantria/ANT-QUEEN.md) |
| Product features, use cases | Nest layer (.alexantria/ANT-NEST.md) |
| Internal patterns, conventions | Chambers layer (.alexantria/ANT-CHAMBERS.md) |
| Architecture, data flows | Tunnels layer (.alexantria/ANT-TUNNELS.md) |
| Specific commands or templates | Surface layer (ANT-SURFACE.md in directories) |

## Before Committing Code

**Use `/ant-commit` for automated workflow:**

When you're ready to commit code changes:

```
Run: /ant-commit "your commit message"
```

This command:
1. Checks staging area (stages files if needed)
2. Spawns worker ant sub-agent (blocking)
3. Worker ant:
   - Runs bash validation checks (naming, structure, JSON)
   - Spawns guardians for affected layers (if validation enabled)
   - Updates ANT-* docs at or below starting_level
   - Detects higher-layer impacts
   - Updates manifest (changes + validation_log)
   - Stages everything
4. Creates single commit (code + docs + manifest)
5. Shows commit results

**Why:** This ensures docs and manifest stay in sync automatically. Everything rides in one commit. Worker ant completes before committing (blocking).

## After Completing Work

Ask yourself:
- Did I change the **RLM foundation or three-pool architecture**? → Update meta docs (RLM-ARCHITECTURE.md)
- Did I change the **coordination model or 5-layer pattern**? → Update meta docs (ANT-FRAMEWORK.md, ANT-SCHEMA.md)
- Did I change **core principles or constraints**? → Update Queen layer (.alexantria/ANT-QUEEN.md)
- Did I change **product features or use cases**? → Update Nest layer (.alexantria/ANT-NEST.md)
- Did I change **internal patterns or conventions**? → Update Chambers layer (.alexantria/ANT-CHAMBERS.md)
- Did I change **architecture or data flows**? → Update Tunnels layer (.alexantria/ANT-TUNNELS.md)
- Did I change **specific commands or templates**? → Update Surface layer (ANT-SURFACE.md in directories)

## Naming Convention

All alexANTria artifacts follow the `ANT-*` or `ant-*` pattern:
- Conceptual docs: `ANT-*.md`
- Commands: `ant-*`
- State: `.alexantria/`

Exception: `README.md` (GitHub convention)

## Platform Implementation

alexANTria is a universal framework. This project uses Claude Code as the implementation platform.

**Current implementation:**
- Rules: `.claude/rules/*.md` (path-based guidance)
- Commands: `user-level/commands/ant-*.md` (executable commands)
- Memory: `CLAUDE.md` (always-loaded hierarchy)
