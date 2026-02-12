# Colony Commands

Slash commands for alexANTria. These get installed to `~/.claude/commands/` and are available in any Claude Code session.

## Available Commands

| Command | Purpose |
|---------|---------|
| `/ant-init` | Initialize alexANTria structure in a project |
| `/ant-validate` | Check documentation health and drift |
| `/ant-suggest` | Analyze changes and propose doc updates |
| `/ant-capture` | Capture intent during commits |

## Command Structure

Each command is a markdown file with:

```markdown
---
description: Short description shown in command list
allowed-tools: Read, Write, Edit, Bash, etc.
---

# Command Title

Instructions for the agent...
```

### Frontmatter

- **description** - Shows up when listing commands
- **allowed-tools** - Which tools the command can use

### Body

The body is instructions for the agent. Write it like you're telling another developer what to do:

- Be specific about the steps
- Include example bash commands
- Describe decision points
- Define what success looks like

## Core Commands

### ant-init

Initialize alexANTria documentation structure in your project.

**What it does:**
- Creates CLAUDE.md (hierarchy map)
- Creates .alexantria/ directory with RLM three-pool docs:
  - ANT-PROGRAMMATIC.md (file index)
  - ANT-TOKENIZED.md (patterns/conventions)
  - ANT-INTENTIONAL.md (strategy/decisions)
- Creates .claude/rules/ for path-based context loading
- Scaffolds basic structure

**Simple, not magical.** Just creates files. You edit them to fit your project.

### ant-validate

Check documentation health and drift.

**What it checks:**
- Files referenced in ANT-PROGRAMMATIC.md actually exist
- Patterns claimed in ANT-TOKENIZED.md are used in code
- New files exist that aren't documented
- Core structure is intact

**Fully automated health check.** Catches obvious drift between docs and code.

### ant-suggest

Analyze changes and propose documentation updates.

**What it does:**
- Detects changes since last commit
- Analyzes which ANT-* docs might need updates
- Proposes specific changes
- Shows diffs for review

**Agent-assisted, human-approved.** Helps maintain docs without being intrusive.

### ant-capture

Capture intent during commits (replaces plain git commit).

**What it does:**
- Stages changes
- Analyzes what changed and why
- Captures intent and context
- Creates commit with documentation updates
- Updates ANT-INTENTIONAL.md decision log if appropriate

**Preserves the "why" automatically.** Intent captured at commit time, not reconstructed later.

## Writing New Commands

Follow the `ant-*` naming convention. Create a new file:

```bash
user-level/commands/ant-yourcommand.md
```

Structure:
```markdown
---
description: What this command does
allowed-tools: List, Of, Tools
---

# 🐜 Ant YourCommand: Short Title

Philosophy and context...

## Phase 1: First Step
...

## Phase 2: Second Step
...

## Notes
- Edge cases
- What not to do
```

Run `./install.sh` to deploy your new command.

## RLM Three-Pool Architecture

Commands maintain three documentation pools:

1. **Programmatic** (ANT-PROGRAMMATIC.md) - File index, what exists, where to find it
2. **Tokenized** (ANT-TOKENIZED.md) - Patterns, conventions, what can't be inferred from code
3. **Intentional** (ANT-INTENTIONAL.md) - Why decisions were made, principles, strategy

Higher levels constrain lower levels. Commands help keep all three synchronized with code.
