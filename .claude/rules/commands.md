---
paths:
  - "user-level/commands/**/*.md"
---

# Command Context

Before modifying command behavior, read:
- [ANT-FRAMEWORK.md](../../ANT-FRAMEWORK.md) — Intelligence through coordination, not command
- [user-level/commands/README.md](../../user-level/commands/README.md) — How to write commands

## Quick Reference

- **Read, Act, Repair** — Every command follows this pattern: agents read context, act locally, repair docs
- **No central brain** — Commands are autonomous workers, not orchestrated by a master
- **Small actions scale** — Commands make focused changes, consistency emerges from accumulation
- **History matters** — Commands preserve and respect past decisions (manifest.json, pending.log)
- **Naming convention** — All commands follow `ant-*` pattern (ant-init, ant-update)
- **Worker ants are cheap** — Spawn agents to process commits in batches, not on every commit

## Command Philosophy

Commands are worker ants, not generals:
- They discover and propose, not dictate
- They enhance existing structure, don't replace it
- They ask when uncertain via AskUserQuestion
- They track their work via .alexantria/ state
