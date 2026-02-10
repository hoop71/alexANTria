---
title: "ANT-ARCHITECTURE - Architecture"
description: "System architecture and service connections (Architecture layer)"
---

# alexANTria - Architecture

**Layer:** Architecture (🚇)

## System Architecture

alexANTria is a context infrastructure system for AI agent orchestration, structured as a 5-layer anthill.

```
┌─────────────────────────────────────┐
│  👑 ANT-STRATEGY.md                 │  Strategic alignment
│     (Core principles, constraints)   │
├─────────────────────────────────────┤
│  🐜 ANT-PRODUCT.md                  │  Product/business context
│     (What we're building, why)      │
├─────────────────────────────────────┤
│  🏛️ ANT-PATTERNS.md                 │  Cross-cutting patterns
│     (Documentation patterns)         │
├─────────────────────────────────────┤
│  🚇 ANT-ARCHITECTURE.md (this file) │  Architecture/connections
│     (How components connect)         │
├─────────────────────────────────────┤
│  🌱 ANT-SURFACE.md                  │  Individual service docs
│     (Per-directory implementation)   │
└─────────────────────────────────────┘
```

## Service Boundaries

### User-Level (Commands & Config)
**Location:** `user-level/`

**Components:**
- `commands/` - Executable commands (ant-init, ant-commit, etc.)
- `commands/guardians/` - Guardian agent prompts
- `alexantria-config-schema.md` - Configuration schema
- `validation-log-schema.md` - Validation logging schema

**Responsibility:** Command definitions, configuration schemas, agent prompts

### Templates
**Location:** `templates/`

**Components:**
- Layer templates (ANT-STRATEGY, ANT-PRODUCT, ANT-PATTERNS, ANT-ARCHITECTURE, ANT-SURFACE)
- Rule templates (frontend.md, backend.md, etc.)
- CLAUDE.md template

**Responsibility:** Scaffolding for new projects

### State Management
**Location:** `.alexantria/`

**Components:**
- `config.json` - Project configuration
- `manifest.json` - Change tracking, validation log, suggested reviews

**Responsibility:** Runtime state, validation tracking, change history

### Context Loading
**Location:** `.claude/`

**Components:**
- `CLAUDE.md` - Always-loaded hierarchy map
- `rules/*.md` - Path-based context auto-loading

**Responsibility:** Agent context delivery

## Data Flow

### 1. Init Flow
```
User runs /ant-init
  ↓
Scout discovers existing docs
  ↓
Map to 5-layer hierarchy
  ↓
Ask user: starting_level, adoption_mode, scope
  ↓
Generate CLAUDE.md, .claude/rules/, .alexantria/
  ↓
Create ANT-* files based on starting_level
  ↓
Install pre-commit hook
  ↓
Present team adoption checklist
```

### 2. Commit Flow (Agent)
```
Agent runs /ant-commit
  ↓
Check staging area (git diff --cached)
  ↓
Spawn worker ant sub-agent (blocking)
  ↓
Worker ant:
  - Read config (starting_level, managed_paths)
  - Analyze staged changes
  - Run bash validation checks
  - Detect affected layers
  - Spawn relevant guardians (if enabled)
  - Update ANT-* docs at or below starting_level
  - Detect higher-layer impacts
  - Update manifest (changes + validation_log)
  - Stage everything
  ↓
Create commit (code + docs + manifest)
  ↓
Show commit results
```

### 3. Validation Flow
```
Worker ant detects layer affected
  ↓
Check validation.enabled in config
  ↓
If enabled:
  Run bash checks (naming, structure, JSON)
    ↓
  If layer significantly affected:
    Spawn guardian agent (Haiku)
      ↓
    Guardian reads prompt + changes
      ↓
    Guardian validates patterns
      ↓
    Guardian reports: PASS | FAIL | REQUIRES_APPROVAL
    ↓
  Log to validation_log (violations + cost)
  ↓
Report results to worker ant
  ↓
Worker ant stages manifest with log
```

## Technology Stack

### Core Platform
- **Claude Code CLI** - Execution environment
- **Sonnet 4.5** - Main agent model
- **Haiku** - Guardian validation agents

### File Formats
- **Markdown** - All documentation (ANT-*.md, commands/*.md)
- **JSON** - Configuration and state (config.json, manifest.json)
- **Frontmatter YAML** - Rule file metadata

### Tools Used
- **Git** - Version control, change detection
- **Bash** - Quick validation checks (free)
- **Task tool** - Sub-agent spawning

## Integration Points

### With Claude Code
- Commands installed to `~/.claude/commands/`
- Rules auto-load based on file paths
- CLAUDE.md always loaded

### With Git
- Pre-commit hook detects agent vs human commits
- Worker ant runs before commits
- Manifest tracks all changes

### With Projects
- `.alexantria/config.json` - Per-project configuration
- `managed_paths` scope control
- `starting_level` automation boundary

## Automation Boundary

The `starting_level` config field controls what worker ant auto-maintains:

```
starting_level: "service"
  ✓ Auto: ANT-SURFACE.md
  ✗ Suggest: ANT-ARCHITECTURE, ANT-PATTERNS, ANT-PRODUCT, ANT-STRATEGY

starting_level: "architecture"
  ✓ Auto: ANT-SURFACE.md, ANT-ARCHITECTURE.md
  ✗ Suggest: ANT-PATTERNS, ANT-PRODUCT, ANT-STRATEGY

starting_level: "patterns"
  ✓ Auto: ANT-SURFACE.md, ANT-ARCHITECTURE.md, ANT-PATTERNS.md
  ✗ Suggest: ANT-PRODUCT, ANT-STRATEGY
```

**Always manual:**
- ANT-PRODUCT.md (product decisions)
- ANT-STRATEGY.md (strategic principles)

## Cost Model

### Worker Ant
- **Model:** Sonnet 4.5
- **Frequency:** Every commit
- **Cost:** ~$0.01-0.03 per commit
- **Paid by:** Developer

### Guardian Agents
- **Model:** Haiku
- **Frequency:** Only when layers affected
- **Cost:** ~$0.003 per guardian
- **Typical:** 0-2 guardians per commit
- **Paid by:** Developer (opt-in)

### Total Estimated Cost
- Small team (10 commits/day): ~$3-5/month
- Medium team (50 commits/day): ~$15-25/month
- Large team (200 commits/day): ~$60-100/month

## Recent Changes (Last 5-10 Commits)

- Added smart guardian triggers (only spawn affected layers)
- Added validation logging with cost tracking
- Created `/ant-validation-report` command
- Split `/ant-validate` (installation only)
- Created `/ant-check-consistency` (full validation)

## Higher-Layer Impacts (Detected by Worker Ant)

None currently - this file is new as part of migration to consistent naming.
