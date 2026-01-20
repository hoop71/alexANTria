# alexANTria – Context

This is a meta-repo: a documentation framework that documents itself.

## Document Hierarchy

<!-- Outer layers override inner layers when they conflict -->

### Layer 1: Philosophy/Constraints
- **[ANT-FRAMEWORK.md](./ANT-FRAMEWORK.md)** — Intelligence through coordination, not command
- **[README.md#philosophy](./README.md)** — Core principles (context is load-bearing, read-act-repair, etc.)

### Layer 2: Product/Business
- **[README.md](./README.md)** — What alexANTria does, quick start, installation

### Layer 3: Architecture/Patterns
- **[ANT-SCHEMA.md](./ANT-SCHEMA.md)** — The nesting doll documentation pattern
- **[templates/README.md](./templates/README.md)** — How templates and placeholders work

### Layer 4: Implementation
- **[user-level/README.md](./user-level/README.md)** — User-level config overview
- **[user-level/commands/README.md](./user-level/commands/README.md)** — How to write commands
- **[user-level/commands/ant-init.md](./user-level/commands/ant-init.md)** — Colony initialization command
- **[user-level/commands/ant-update.md](./user-level/commands/ant-update.md)** — Worker ant update command
- **[user-level/CLAUDE.md](./user-level/CLAUDE.md)** — User-level agent instructions

## When to Read

| Working on... | Read first |
|--------------|------------|
| Philosophy or principles | ANT-FRAMEWORK.md |
| Documentation patterns | ANT-SCHEMA.md |
| Command behavior | user-level/commands/README.md, then the specific command |
| Template customization | templates/README.md |
| User-level config | user-level/README.md |
| Agent instructions | user-level/CLAUDE.md |

## After Completing Work

Ask yourself:
- Did I change the **colony philosophy**? → Update ANT-FRAMEWORK.md
- Did I change the **schema pattern**? → Update ANT-SCHEMA.md
- Did I add a **new command**? → Follow `ant-*` naming, update user-level/commands/README.md
- Did I change **how templates work**? → Update templates/README.md
- Did I change **user-level config**? → Update user-level/README.md

## Naming Convention

All alexANTria artifacts follow the `ANT-*` or `ant-*` pattern:
- Conceptual docs: `ANT-*.md`
- Commands: `ant-*`
- State: `.alexantria/`

Exception: `README.md` (GitHub convention)
