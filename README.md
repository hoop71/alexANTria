# alexANTria

**Structured documentation hierarchy for coding agents.** A three-pool model that separates what agents infer (code), what must be written (patterns), and what only humans know (strategy).

![alexANTria](image.png)

---

## The Problem

Every session starts from scratch. You re-explain architecture, context bloats, docs go stale, agents contradict each other.

**Context rot is structural** — documentation drifts from code, strategic decisions live in Slack threads, patterns exist only in senior developers' heads.

[RLMs](https://www.dbreunig.com/2026/02/09/the-potential-of-rlms.html) introduce two context pools: **programmatic** (code environment) and **tokenized** (docs). But they don't maintain themselves:

- **Tokenized** (docs): Go out of sync with code
- **Intentional** (strategy): Rarely captured at all — why decisions were made, who this is for, core principles. Evaporates over time.

---

## The Solution

**alexANTria extends RLMs with a third intentional pool** and provides **automatic maintenance:**

1. **Programmatic** — What exists and where to find it (file index)
2. **Tokenized** — Patterns and conventions that must be documented
3. **Intentional** — Why decisions were made, principles, context

**How it works:**

- **Automatic:** Git pre-commit hook runs `/ant-capture` before every commit
- **Proactive:** `/ant-validate` checks health when you open projects
- **Assisted:** `/ant-suggest` proposes updates after major changes
- **Contextual:** Auto-loads relevant docs based on file paths you're editing

**Goal:** Documentation that maintains itself, survives sessions, and scales with your team.

---

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/hoop71/alexANTria/main/install.sh | bash
# Restart Claude Code
cd your-project/ && /ant-init
# Done - commits now maintain docs automatically
```

**Automatic by default:** `/ant-init` installs git pre-commit hook that runs `/ant-capture` before every commit.

**Teams:** Each dev installs commands locally. Project structure (CLAUDE.md, ANT-* files, git hook) lives in git.

---

## What You Get

```
your-project/
├── CLAUDE.md                   # Hierarchy map
├── .claude/rules/              # Path-based context loading
│   ├── framework.md            # Meta rules for alexANTria itself
│   └── commands.md             # Command behavior
├── .alexantria/                # Three pools (RLM)
│   ├── ANT-PROGRAMMATIC.md     # What exists (file index)
│   ├── ANT-TOKENIZED.md        # Patterns and conventions
│   └── ANT-INTENTIONAL.md      # Why and principles
└── templates/                  # Templates for new projects
```

When agents edit files, `.claude/rules/*.md` auto-loads based on path patterns, guiding them to relevant documentation.

**Drop-in:** Only creates `CLAUDE.md`, `.claude/rules/`, and `.alexantria/`. Your existing docs untouched. Easy to test, easy to remove.

---

## Commands

- `/ant-init` — Scaffold structure + install git hook (one-time setup)
- `/ant-capture` — Capture intent during commits (runs automatically via git hook)
- `/ant-validate` — Check documentation health (runs on project open)
- `/ant-suggest` — Analyze changes and propose doc updates (manual)

**Pattern:** Setup once → Automatic maintenance → Manual refinement when needed

---

## Documentation

- **[RLM-ARCHITECTURE.md](./RLM-ARCHITECTURE.md)** — Three-pool architecture explained
- **[ANT-FRAMEWORK.md](./ANT-FRAMEWORK.md)** — How the pools coordinate
- **[ANT-SCHEMA.md](./ANT-SCHEMA.md)** — Documentation pattern
- **[CLAUDE.md](./CLAUDE.md)** — This project's hierarchy map

---

## Principles

1. **Three pools, three strategies** — Programmatic (indexed), Tokenized (validated), Intentional (captured)
2. **Read, act, repair** — Actions assume context; reality changes context; tools help repair drift
3. **Documentation as infrastructure** — Not separate from code, not just comments
4. **Layered hierarchy** — Intentional constrains Tokenized, Tokenized constrains Programmatic
5. **Agent-assisted, human-approved** — Tools help maintain, humans decide what matters

---

## Customization

Fork for custom commands or team-specific templates. Add new `/ant-*` commands in `user-level/commands/`.

---

## Platform

Claude Code implementation. Pattern works with any markdown-reading agent (Cursor, Copilot, Windsurf, Aider). Also for org knowledge management.

---

## License

MIT

---

*v0.1.0 — Living document. [Help us figure it out](https://github.com/hoop71/alexANTria/discussions).*
