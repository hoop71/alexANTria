# Commands - Programmatic Documentation

**Pool:** Programmatic (RLM)

**Location:** `user-level/commands/`

## Overview

This directory contains alexANTria commands. Each command is a markdown file with frontmatter and agent instructions.

## Active Commands

### Core Commands

- **ant-init.md** - Initialize alexANTria in a project
  - Discovers existing docs and code structure
  - Creates: CLAUDE.md, .claude/rules/, .alexantria/
  - Scaffolds RLM three-pool structure:
    - ANT-PROGRAMMATIC.md (file index)
    - ANT-TOKENIZED.md (patterns/conventions)
    - ANT-INTENTIONAL.md (strategy/decisions)

- **ant-validate.md** - Check documentation health and drift
  - Verifies: Files exist, references valid, structure correct
  - Detects: Missing files, undocumented files, broken links
  - Reports: Health status with actionable recommendations

- **ant-suggest.md** - Analyze changes and propose doc updates
  - Detects changes since last commit
  - Analyzes impact on documentation
  - Proposes specific updates to ANT-* files
  - Shows diffs for review

- **ant-capture.md** - Capture intent during commits
  - Replaces plain git commit workflow
  - Analyzes changes and captures intent
  - Updates ANT-INTENTIONAL.md decision log
  - Creates commit with context preserved

## File Structure

```
user-level/commands/
├── ant-init.md
├── ant-validate.md
├── ant-suggest.md
├── ant-capture.md
├── README.md
└── ANT-SURFACE.md (this file)
```

## Usage Patterns

### Creating New Commands

1. Create `user-level/commands/ant-<name>.md`
2. Follow command structure pattern (frontmatter + instructions)
3. Add to README.md Available Commands table
4. Test with agent
5. Run `./install.sh` to deploy

### Modifying Commands

1. Read command file
2. Edit following existing structure
3. Test changes
4. Run `./install.sh` to redeploy
5. Commit

## Dependencies

Commands depend on:
- Claude Code CLI (execution environment)
- Git (version control, change detection)
- Bash (for health checks)

## Configuration

Commands read configuration from:
- `.alexantria/config.json` - Project settings
- `.alexantria/manifest.json` - State and change log

## RLM Three-Pool Architecture

Commands maintain three documentation pools:

1. **Programmatic** - File index (what exists, where to find it)
2. **Tokenized** - Patterns and conventions (what can't be inferred from code)
3. **Intentional** - Strategy and decisions (why, principles, context)

Higher levels constrain lower levels.
