# Colony Commands

Slash commands for alexANTria. These get installed to `~/.claude/commands/` and are available in any Claude Code session.

## Available Commands

| Command | Purpose |
|---------|---------|
| `/ant-init` | Scout and establish colony structure in a project |
| `/ant-update` | Worker ant: process pending commits, update surface docs |
| `/ant-validate` | Verify alexANTria installation and configuration |

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

## ant-init

The scout ant. Enters a new project and establishes the colony:

1. **Crawl** - Find existing documentation
2. **Classify** - Map docs to the 4-layer hierarchy
3. **Propose** - Show the user and confirm
4. **Generate** - Create CLAUDE.md, .claude/rules/, .alexantria/
5. **Hook** - Optionally install git post-commit hook

## ant-update

The worker ant. Processes commits and keeps surface docs fresh:

1. **Check pending** - Read `.alexantria/pending.log`
2. **Assess** - For each commit, decide if docs need updating
3. **Update** - Make minimal changes to local READMEs
4. **Record** - Log to `.alexantria/manifest.json`
5. **Clear** - Remove processed entries from pending

## ant-validate

The scout ant health check. Verifies alexANTria installation:

1. **Check structure** - Verify CLAUDE.md, .claude/rules/, .alexantria/ exist
2. **Validate content** - Check CLAUDE.md has 5-layer hierarchy
3. **Check rules** - Verify frontmatter and path globs in rule files
4. **Validate manifest** - Check JSON structure and required fields
5. **Report health** - Generate pass/fail report with recommendations

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
