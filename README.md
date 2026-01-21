# alexANTria

**Living memory for your codebase.** Documentation that coding agents actually read, use, and maintain.

![alexANTria](image.png)

---

## The Problem

Every coding session starts from scratch:
- You re-explain your architecture every time
- Context bloats prompts (5,000+ tokens)
- Documentation rots
- Multiple agents contradict each other

This gets exponentially worse with teams, multiple sessions, or agent swarms.

---

## The Solution

Persistent context infrastructure. Your docs become layered, auto-loading memory:

- **Survives sessions** — Context persists across restarts and compactions
- **Layers with precedence** — Philosophy overrides implementation
- **Evolves with code** — Agents read it, use it, help maintain it
- **Scales** — Solo dev → teams → orchestrated swarms

Like ant colony pheromone trails: paths that persist, fade, and get reinforced.

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

---

## Commands

- `/ant-init` — Crawl existing docs, scaffold structure
- `/ant-update` — Process commits, update surface docs
- `/ant-validate` — Check colony health

**Behavior:** Read → Act → Repair

---

## Progressive Discovery

Start here, go deeper as needed:

- **[CLAUDE.md](./CLAUDE.md)** — The anthill map (layers, what to read when)
- **[ANT-FRAMEWORK.md](./ANT-FRAMEWORK.md)** — Organizational model (queen/nest/chambers/tunnels/surface)
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
