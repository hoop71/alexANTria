# Colony Commands

Slash commands for alexANTria. These get installed to `~/.claude/commands/` and are available in any Claude Code session.

## Available Commands

| Command | Purpose |
|---------|---------|
| `/ant-init` | Scout and establish colony structure in a project |
| `/ant-validate` | Verify alexANTria installation health (files exist) |
| `/ant-check-consistency` | Validate pattern and rule consistency (guardian agents) |
| `/ant-commit` | Automated commit with worker ant (agent commits) |
| `/ant-migrate` | Migrate README.md to ANT-SURFACE.md |
| `/ant-update-doc` | Explicitly update a specific ANT-* doc |
| `/ant-review-suggestions` | Review and apply higher-layer doc suggestions |

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

1. **Crawl** - Find existing documentation and code structure
2. **Classify** - Map docs to the 5-layer hierarchy
3. **Configure** - Ask about starting_level, adoption mode, scope
4. **Generate** - Create CLAUDE.md, .claude/rules/, .alexantria/, ANT-* files
5. **Hook** - Install smart pre-commit hook
6. **Checklist** - Present team adoption checklist

## commit

Agent-only command. Wraps the entire commit workflow:

1. **Stage** - Check and stage modified files
2. **Spawn worker ant** - Blocking Task tool call
3. **Worker ant** - Updates ANT-* docs, detects impacts, stages changes
4. **Commit** - Create commit with code + docs + manifest
5. **Verify** - Show commit results

## ant-migrate

Migrate existing README.md to ANT-SURFACE.md:

1. **Validate** - Check if README.md exists
2. **Analyze** - Identify what content belongs in ANT-SURFACE.md
3. **Generate** - Create ANT-SURFACE.md from template
4. **Show diff** - Present changes to user
5. **Execute** - Write ANT-SURFACE.md, remove README.md, update manifest
6. **Stage** - Stage all changes for commit

## ant-update-doc

Manually update a specific ANT-* doc:

1. **Read config** - Check starting_level and scope
2. **Read manifest** - Find suggested_reviews for this doc
3. **Analyze** - Check recent changes affecting this doc
4. **Generate updates** - Update relevant sections
5. **Show diff** - Present changes to user
6. **Apply** - Write updates, mark suggestions as applied
7. **Stage** - Stage doc and manifest

## ant-review-suggestions

Review all pending higher-layer suggestions:

1. **Read manifest** - Find all pending suggested_reviews
2. **Group** - By doc and layer
3. **Present** - Show summary with options (apply all/review individually/dismiss all)
4. **Process** - Run /ant-update-doc for each doc or mark as dismissed
5. **Report** - Show results and suggest commit

## ant-check-consistency

On-demand validation via guardian agents:

1. **Read config** - Check if validation enabled
2. **Gather context** - Scan recent changes and relevant files
3. **Spawn guardians** - Run all 5 guardian agents in parallel (Haiku)
4. **Collect reports** - Parse results from each guardian
5. **Aggregate** - Generate comprehensive report
6. **Update manifest** - Record consistency check

## Guardian System

alexANTria uses specialized Haiku agents to validate consistency at each layer:

- **🌱 Surface Guardian** - Naming conventions (ant-*, ANT-*.md), file structure
- **🚇 Tunnels Guardian** - Config schema, command structure, architecture coherence
- **🏛️ Chambers Guardian** - Pattern consistency, duplication detection, cross-cutting conventions
- **🐜 Nest Guardian** - Adoption stages, workflows, product alignment
- **👑 Queen Guardian** - Core principles, strategic constraints, ANT-* only enforcement

Guardians are:
- **Opt-in** (validation.enabled = false by default)
- **Specialized** (each knows one layer deeply)
- **Autonomous** (run independently, report violations)
- **Cheap** (Haiku model, $0.002-0.005 per guardian)
- **Fast** (run in parallel, complete in seconds)

They run at two checkpoints:
1. **pre_commit** - Worker ant consults affected guardians
2. **on_demand** - /ant-check-consistency runs all guardians

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
