# Commands - Service Documentation

**Layer:** Surface (🌱)

**Location:** `user-level/commands/`

## Overview

This directory contains all executable alexANTria commands. Each command is a markdown file with frontmatter and agent instructions.

## Components

### Core Commands

- **ant-init.md** - Initialize alexANTria in a project
  - Crawls existing docs, proposes hierarchy, generates structure
  - Asks: starting_level, adoption_mode, scope
  - Creates: CLAUDE.md, .claude/rules/, .alexantria/, ANT-* files

- **ant-commit.md** - Automated commit with worker ant
  - Agent-only command
  - Spawns worker ant (blocking)
  - Single commit: code + docs + manifest

- **ant-validate.md** - Check installation health
  - Verifies: Files exist, structure correct, JSON valid
  - Not pattern validation (use ant-check-consistency for that)

- **ant-upgrade.md** - Upgrade alexANTria framework
  - Updates commands, guardians, templates, worker ant
  - Handles config migration and preserves customizations
  - Creates backup before upgrading

- **ant-graduate.md** - Promote adoption stage
  - Transitions from experimental → trial → full
  - Removes adoption scaffolding
  - Renames ANT-* files to graduation-ready names
  - Updates all references across project
  - One-way operation

- **ant-check-consistency.md** - Run all guardians
  - On-demand full validation
  - Spawns all 5 guardians in parallel
  - Comprehensive report
  - Cost: ~$0.02

- **ant-validation-report.md** - Show validation metrics
  - Analyzes validation_log from manifest
  - Shows: violations caught, cost incurred, ROI
  - Trends: improving/stable/degrading
  - Recommendations based on data

### Migration Commands

- **ant-migrate.md** - Migrate README.md to ANT-SURFACE.md
  - Reads existing README
  - Analyzes content (LLM-assisted)
  - Generates ANT-SURFACE.md
  - Shows diff, asks approval
  - Stages migration

### Documentation Commands

- **ant-refresh-doc.md** - Refresh a specific ANT-* doc
  - Manual outlet for doc updates
  - Reads suggested_reviews from manifest
  - Updates specified doc based on recent changes
  - Stages changes

- **ant-review-suggestions.md** - Review higher-layer doc suggestions
  - Batch interface for pending suggestions
  - Options: Apply all / Review individually / Dismiss
  - Runs ant-refresh-doc for each
  - Stages updates

### Worker Ant

- **worker-ant-prompt.md** - Worker ant sub-agent instructions
  - Not a user-invocable command
  - Prompt for spawning worker ant sub-agent
  - Defines: constraints, automation boundary, validation logic
  - Used by: ant-commit, pre-commit hook

### Guardians

**Location:** `guardians/`

- **surface-guardian.md** - Validates naming, file structure
- **architecture-guardian.md** - Validates config schema, architecture
- **patterns-guardian.md** - Validates pattern consistency
- **product-guardian.md** - Validates adoption stages, workflows
- **strategy-guardian.md** - Validates core principles, constraints

## File Structure

```
user-level/commands/
├── ant-init.md
├── ant-commit.md
├── ant-graduate.md
├── ant-migrate.md
├── ant-validate.md
├── ant-check-consistency.md
├── ant-validation-report.md
├── ant-refresh-doc.md
├── ant-review-suggestions.md
├── worker-ant-prompt.md
├── guardians/
│   ├── surface-guardian.md
│   ├── architecture-guardian.md
│   ├── patterns-guardian.md
│   ├── product-guardian.md
│   └── strategy-guardian.md
├── README.md (legacy - describes command system)
└── ANT-SURFACE.md (this file)
```

## Usage Patterns

### Creating New Commands

1. Create `user-level/commands/ant-<name>.md`
2. Follow command structure pattern (see ANT-PATTERNS.md)
3. Add to README.md Available Commands table
4. Test with agent
5. Commit

**Enforcement:** Surface Guardian validates naming + README updated

### Modifying Commands

1. Read command file
2. Edit following existing structure
3. Test changes
4. Commit

**Note:** Worker ant doesn't auto-update command files (they're implementation, not generated docs)

## Dependencies

Commands depend on:
- Claude Code CLI (execution environment)
- Git (version control, change detection)
- Bash (for validation checks)
- Task tool (for spawning sub-agents)

## Configuration

Commands read configuration from:
- `.alexantria/config.json` - Project settings
- `.alexantria/manifest.json` - State and logs

## Recent Changes (Last 5-10 Commits)

- Renamed all guardians to graduation-ready names (service-guardian, architecture-guardian, etc.)
- Added ant-graduate.md command (adoption stage promotion)
- Updated worker-ant-prompt.md with new layer naming (Surface, Architecture, Patterns, Product, Strategy)
- Updated all guardian prompts with RLM language and new layer names
- Added manifest-schema.md (comprehensive manifest documentation)

## Higher-Layer Impacts (Detected by Worker Ant)

None currently detected.
