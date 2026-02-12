# alexANTria – Context

Meta-repo: framework documents itself using RLM three-pool architecture.

## Meta Docs (The Pattern)

- **[RLM-ARCHITECTURE.md](./RLM-ARCHITECTURE.md)** — Three-pool architecture
- **[ANT-FRAMEWORK.md](./ANT-FRAMEWORK.md)** — Coordination model
- **[ANT-SCHEMA.md](./ANT-SCHEMA.md)** — Documentation pattern
- **[README.md](./README.md)** — User overview

## Implementation Docs (Using the Pattern)

**RLM:** Programmatic → Tokenized → Intentional

Higher levels constrain lower levels.

### Programmatic

[.alexantria/ANT-PROGRAMMATIC.md](./.alexantria/ANT-PROGRAMMATIC.md)

What exists and where to find it. File index. Agents read on demand.

### Tokenized

[.alexantria/ANT-TOKENIZED.md](./.alexantria/ANT-TOKENIZED.md)

Patterns, conventions, system structure. Loaded selectively into attention.

### Intentional

[.alexantria/ANT-INTENTIONAL.md](./.alexantria/ANT-INTENTIONAL.md)

Why decisions were made, who this is for, core principles. Human knowledge.

## Quick Reference

| Working on... | Read | Pool |
|--------------|------|-------|
| RLM foundation | RLM-ARCHITECTURE.md | — |
| Pattern itself | ANT-FRAMEWORK.md, ANT-SCHEMA.md | — |
| Understanding project | ANT-PROGRAMMATIC.md | Programmatic |
| Following patterns | ANT-TOKENIZED.md | Tokenized |
| Making decisions | ANT-INTENTIONAL.md | Intentional |

## Commands

**Core commands:**
- `/ant-init` — Scaffold structure in new projects
- `/ant-validate` — Check documentation health and drift
- `/ant-suggest` — Analyze changes and propose doc updates
- `/ant-capture` — Capture intent during commits (replaces plain git commit)

## After Changes

Update docs if you changed:
- **RLM/pattern itself** → Meta docs (RLM-ARCHITECTURE.md, ANT-FRAMEWORK.md, ANT-SCHEMA.md)
- **Files/structure** → ANT-PROGRAMMATIC.md
- **Patterns/conventions** → ANT-TOKENIZED.md
- **Decisions/principles** → ANT-INTENTIONAL.md

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
