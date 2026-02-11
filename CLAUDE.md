# alexANTria – Context

Meta-repo: framework documents itself using RLM three-pool architecture.

## Meta Docs (The Pattern)

- **[RLM-ARCHITECTURE.md](./RLM-ARCHITECTURE.md)** — Three-pool architecture
- **[ANT-FRAMEWORK.md](./ANT-FRAMEWORK.md)** — Coordination model
- **[ANT-SCHEMA.md](./ANT-SCHEMA.md)** — Documentation pattern
- **[README.md](./README.md)** — User overview

## Implementation Docs (Using the Pattern)

**RLM:** Programmatic (code) → Tokenized (attention) → Intentional (intent)

Higher levels constrain lower levels.

### Level 1: Programmatic

**Surface** — [user-level/commands/ANT-SURFACE.md](./user-level/commands/ANT-SURFACE.md), [templates/ANT-SURFACE.md](./templates/ANT-SURFACE.md)

Code-adjacent. Agents discover by reading files.

### Level 2: Tokenized

**Docs** — [.alexantria/ANT-DOCS.md](./.alexantria/ANT-DOCS.md)

Active in attention. System structure, patterns, conventions. Selective RAG.

### Level 3: Intentional

**Strategy** — [.alexantria/ANT-STRATEGY.md](./.alexantria/ANT-STRATEGY.md)

Our intent. Why we do this, who for, core principles. Human-only.

## Quick Reference

| Working on... | Read | Level |
|--------------|------|-------|
| RLM foundation | RLM-ARCHITECTURE.md | — |
| Pattern itself | ANT-FRAMEWORK.md, ANT-SCHEMA.md | — |
| Commands/surface docs | ANT-SURFACE.md | Programmatic |
| System structure/patterns | ANT-DOCS.md | Tokenized |
| Strategy/why/who | ANT-STRATEGY.md | Intentional |

## Committing

**Use `/ant-commit "message"`** — Worker ant validates, updates docs, manifests, commits atomically.

## After Changes

Update docs if you changed:
- **RLM/pattern itself** → Meta docs (RLM-ARCHITECTURE.md, ANT-FRAMEWORK.md, ANT-SCHEMA.md)
- **Commands/surface** → Surface (ANT-SURFACE.md) [Programmatic]
- **System/patterns** → Docs (ANT-DOCS.md) [Tokenized]
- **Strategy/why/who** → Strategy (ANT-STRATEGY.md) [Intentional]

## Naming

- Docs: `ANT-*.md`
- Commands: `ant-*`
- State: `.alexantria/`
- Exception: `README.md`

## Platform

Claude Code implementation:
- Rules: `.claude/rules/*.md`
- Commands: `user-level/commands/ant-*.md`
- Memory: `CLAUDE.md`
