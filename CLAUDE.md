# alexANTria – Context

This is a meta-repo: a documentation framework that documents itself.

## The Anthill

This project uses the 5-layer anthill structure. Higher layers constrain lower layers.

### 👑 Queen: Strategic Alignment
- **[ANT-FRAMEWORK.md](./ANT-FRAMEWORK.md)** — Intelligence through coordination, not command
- **[README.md#philosophy](./README.md)** — Core principles (context is load-bearing, read-act-repair, etc.)

### 🐜 Nest: Product/Business Context
- **[README.md](./README.md)** — What alexANTria does, the problem it solves
- **[blog/gastown-context-infrastructure.md](./blog/gastown-context-infrastructure.md)** — Why orchestration needs context infrastructure

### 🏛️ Chambers: Cross-Cutting Patterns
- **[ANT-SCHEMA.md](./ANT-SCHEMA.md)** — The nesting doll documentation pattern
- **[templates/README.md](./templates/README.md)** — How templates and placeholders work

### 🚇 Tunnels: Architecture/Service Connections
- **[user-level/README.md](./user-level/README.md)** — User-level config overview
- **[user-level/commands/README.md](./user-level/commands/README.md)** — How to write commands
- **[user-level/CLAUDE.md](./user-level/CLAUDE.md)** — User-level agent instructions

### 🌱 Surface: Individual Service Docs
- **[user-level/commands/ant-init.md](./user-level/commands/ant-init.md)** — Colony initialization command
- **[user-level/commands/ant-update.md](./user-level/commands/ant-update.md)** — Worker ant update command
- **[user-level/commands/ant-validate.md](./user-level/commands/ant-validate.md)** — Colony health check command

## When to Read

| Working on... | Read first |
|--------------|------------|
| Strategic vision, core principles | Queen layer (ANT-FRAMEWORK.md, README.md) |
| Product positioning, use cases | Nest layer (README.md, blog/) |
| Documentation patterns, templates | Chambers layer (ANT-SCHEMA.md, templates/) |
| Command architecture, user config | Tunnels layer (user-level/README.md, commands/README.md) |
| Specific command implementation | Surface layer (ant-init.md, ant-update.md, ant-validate.md) |

## After Completing Work

Ask yourself:
- Did I change the **strategic vision or core principles**? → Update Queen layer (ANT-FRAMEWORK.md)
- Did I change **product positioning or use cases**? → Update Nest layer (README.md, blog/)
- Did I change the **schema pattern or template system**? → Update Chambers layer (ANT-SCHEMA.md, templates/)
- Did I add a **new command or change user-level config**? → Update Tunnels layer (user-level/)
- Did I change **specific command implementation**? → Update Surface layer (command .md files)

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
