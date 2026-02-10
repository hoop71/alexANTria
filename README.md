# alexANTria

**RLM architecture for project-scale context.** Prevent context rot with three-pool documentation: what agents can infer (code), what must be written (patterns), what only humans know (strategy).

![alexANTria](image.png)

---

## The Problem: Context Rot

Every coding session starts from scratch:
- You re-explain your architecture every time
- Context bloats prompts (5,000+ tokens)
- Documentation rots (agents don't maintain it)
- Multiple agents contradict each other

**Context rot is structural:** Models degrade when context exceeds soft limits, even within the window. This compounds with teams, multiple sessions, or agent swarms.

---

## The Solution: Three-Pool Architecture

RLM research reveals three types of context. alexANTria separates them:

1. **Programmatic** (code) — What agents can infer by reading implementations
2. **Tokenized** (docs) — Patterns and conventions that must be written
3. **Intentional** (strategy) — Human knowledge: why decisions were made

Your docs become layered, auto-loading memory:
- **Survives sessions** — Context persists across restarts and compactions
- **Layers with precedence** — Strategy constrains implementation
- **Evolves with code** — Agents maintain lower layers, humans maintain upper
- **Scales** — Solo dev → teams → orchestrated swarms (Gas Town)

See: [The Potential of RLMs](https://www.dbreunig.com/2026/02/09/the-potential-of-rlms.html)

---

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/hoop71/alexANTria/main/install.sh | bash
```

Restart Claude Code, then:

```bash
cd your-project/
/ant-init
```

**Teams:** Each dev installs commands individually. Project structure lives in git. Fork if you need custom commands.

---

## What You Get

```
your-project/
├── CLAUDE.md              # The map (hierarchy of docs)
├── .claude/rules/         # Auto-loads by file path
│   ├── frontend.md        # Loads for src/components/**
│   └── backend.md         # Loads for src/server/**
└── .alexantria/          # Worker ant tracking
    └── manifest.json
```

When agents edit `src/components/Button.tsx`, they auto-load `frontend.md` which points to your design philosophy. They work within your constraints automatically.

**Drop-in philosophy:** alexANTria only auto-updates files it owns (`ANT-*` pattern, `.alexantria/`). Your docs (README.md, docs/, etc.) are never touched unless you explicitly opt-in. Safe to test, easy to remove.

### Graduation Path

ANT-* files are designed to graduate to native files when you're ready:

```
ANT-STRATEGY.md      → STRATEGY.md        (Strategic alignment)
ANT-PRODUCT.md       → PRODUCT.md         (Product context)
ANT-PATTERNS.md      → PATTERNS.md        (Cross-cutting patterns)
ANT-ARCHITECTURE.md  → ARCHITECTURE.md    (System architecture)
ANT-README.md        → README.md          (Service documentation)
```

**Adoption flow:**
1. **Pilot** — ANT-* files coexist with your existing docs
2. **Active** — Validate ANT-* files are well-maintained
3. **Graduate** — Convert ANT-* → native files with `/ant-graduate`
4. **Full** — System maintains your native files directly

This lets you test alexANTria risk-free, then adopt fully when ready.

---

## Commands

- `/ant-init` — Crawl existing docs, scaffold structure
- `/ant-update` — Process commits, update surface docs
- `/ant-validate` — Check colony health

**Behavior:** Read → Act → Repair

---

## Progressive Discovery

Start here, go deeper as needed:

- **[RLM-ARCHITECTURE.md](./RLM-ARCHITECTURE.md)** — **How RLM architecture prevents context rot** (deep dive)
- **[CLAUDE.md](./CLAUDE.md)** — The anthill map (layers, what to read when)
- **[ANT-FRAMEWORK.md](./ANT-FRAMEWORK.md)** — Organizational model (strategy/product/patterns/architecture/service)
- **[ANT-SCHEMA.md](./ANT-SCHEMA.md)** — Documentation pattern (nesting dolls)
- **[blog/gastown-context-infrastructure.md](./blog/gastown-context-infrastructure.md)** — Why orchestration needs context infrastructure

---

## Core Principles

1. **Context is load-bearing** — If context is wrong, behavior will be wrong
2. **Read, act, repair** — Every action assumes context; changing reality changes context
3. **Small actions scale** — Consistency emerges from accumulation, not authority
4. **No central brain** — Alignment from shared constraints, not top-down control
5. **History matters** — Past decisions explain why things look the way they do

---

## Customization

Fork when you need:
- Custom command behavior
- Team-specific templates
- Your own `/ant-*` commands

Otherwise, install from upstream and customize per project.

See `user-level/` and `templates/` directories.

---

## Platform

Currently implemented on Claude Code. Pattern works with any agent that reads markdown (Cursor, Copilot, Windsurf, Aider). Only the hook mechanism differs.

Not just for coding agents. Same structure helps orgs share knowledge at scale.

---

## License

MIT

---

*v0.1.0 — Living document. [Help us figure it out](https://github.com/hoop71/alexANTria/discussions).*
