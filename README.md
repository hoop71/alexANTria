# Alexandria

<img width="1024" height="1536" alt="image" src="https://github.com/user-attachments/assets/cdba2148-c8f4-4a7f-af4e-b79e42be12d7" />

**A starter template for coding agent context automation.**

Alexandria is a scaffold you clone and run once to set up documentation patterns that coding agents understand. Fork it, customize the templates to match your workflow, then install. From there, any project you work on gets the same documentation-first approach.

> **This is not a library or dependency.** Think [shadcn/ui](https://ui.shadcn.com/) for coding agent context — you own the code, customize freely, no upstream to track.

## The Goal: A Knowledge Library for Coding Agents

Alexandria helps you build a **living knowledge library** that coding agents (Claude Code, Cursor, etc.) can hook into. Instead of re-explaining your architecture every session, your docs become the source of truth that agents read automatically.

**What you're building toward:**

```
Your Project
├── CLAUDE.md                    # Entry point - tells agents what to read
├── docs/
│   ├── philosophy.md            # Layer 1: Non-negotiables
│   ├── product-brief.md         # Layer 2: What we're building
│   └── ...
├── ARCHITECTURE.md              # Layer 3: How we build
└── .claude/rules/               # Auto-loaded context by file path
    ├── frontend.md
    ├── backend.md
    └── ...
```

When your agent opens a file in `src/components/`, it automatically loads `frontend.md` which points to your design philosophy. The agent works within your constraints without you having to repeat them.

See [SCHEMA.md](./SCHEMA.md) for the full "Russian Nesting Doll" pattern.

## Philosophy

### Read Before You Act

Every project has documentation that guides decisions. Alexandria teaches your agent to:

1. **Identify the area** — UI? Backend? Agent behavior?
2. **Read relevant docs** — Check the hierarchy, load what matters
3. **Implement with context** — Decisions align with documented constraints
4. **Suggest updates** — When changes affect higher-level docs, ask about updating them

### Document Hierarchy

Most projects have layered documentation:

```
Philosophy/Constraints  ← Overrides everything below
    ↓
Product/Business Rules  ← Informs features
    ↓
Technical Patterns      ← Guides implementation
    ↓
Changelog/History       ← Records decisions
```

When you change something at a lower level that affects a higher level, the agent suggests updating the upstream doc.

### References, Not Imports

CLAUDE.md stays lean. Instead of copying entire docs into context:

- Use `[readable descriptions](./path.md)` — the agent reads them when relevant
- `.claude/rules/` auto-loads domain-specific guidance — only when editing matching paths
- Hierarchy is codified — the agent knows what to read and when to suggest updates

## Quick Start

### 1. Fork & Clone

```bash
# Fork this repo on GitHub first, then:
git clone https://github.com/YOUR_USERNAME/alexandria
cd alexandria
```

### 2. Customize (optional but recommended)

Before installing, review and edit:
- `user-level/CLAUDE.md` — Your universal philosophy for all projects
- `user-level/commands/init-docs.md` — How project scaffolding works
- `templates/` — Starting points for project-level docs

Delete what doesn't fit your workflow. Add what's missing.

### 3. Install

```bash
./install.sh
```

This copies your customized files to `~/.claude/`:
- Universal philosophy (applies to all your projects)
- `/init-docs` command to scaffold new projects

### 4. Set Up a Project

```bash
cd /path/to/your/project
```

Then run:
```
/init-docs
```

The agent will:
1. **Crawl** — Find existing markdown files and code directories
2. **Classify** — Map docs to the hierarchy (philosophy → product → architecture → implementation)
3. **Propose** — Show you the mapping and ask for confirmation
4. **Generate** — Create `CLAUDE.md` and `.claude/rules/` based on what exists

The command discovers what you have rather than asking you to describe it.

## What Gets Installed

### User-Level (`~/.claude/`)

```
~/.claude/
├── CLAUDE.md              # Universal "how to manage docs" philosophy
└── commands/
    └── init-docs.md       # Scaffolds project structure
```

### Project-Level (after `/init-docs`)

```
your-project/
├── CLAUDE.md              # Doc hierarchy + "when to read" table
└── .claude/
    └── rules/
        ├── frontend.md    # Auto-loads for src/components/**
        ├── backend.md     # Auto-loads for src/server/**
        └── ...
```

## How It Works

### Automatic Context Loading

Rules in `.claude/rules/` have path matchers:

```markdown
---
paths:
  - "src/components/**/*.tsx"
  - "src/routes/**/*.tsx"
---

# Frontend Context

Before modifying UI, read:
- [ux-philosophy.md](../../docs/ux-philosophy.md)
```

When you edit a file matching those paths, the rule auto-loads.

### Doc Hierarchy in CLAUDE.md

Your project's CLAUDE.md tells the agent what to read and when:

```markdown
## When to Read

| Working on... | Read first |
|--------------|------------|
| UI/UX decisions | [ux-philosophy.md](./docs/ux-philosophy.md) |
| Product scope | [product-brief.md](./docs/product-brief.md) |
| Implementation | [ARCHITECTURE.md](./ARCHITECTURE.md) |

## When to Suggest Updates

After completing work that affects:
- Design patterns → update ux-philosophy.md
- Product scope → update product-brief.md
- Technical patterns → update ARCHITECTURE.md
```

### Update Propagation

After completing work, the agent checks:
- "Did I change a **UX pattern**? → Should we update the constraints doc?"
- "Did I change **product scope**? → Should we update the product doc?"
- "Did I add **technical patterns**? → Should we update architecture?"

This keeps docs in sync without manual effort.

## Templates

The `templates/` directory contains starting points you can customize:

| Template | Purpose |
|----------|---------|
| `CLAUDE.md.template` | Doc hierarchy structure |
| `rules/frontend.md.template` | UI component rules |
| `rules/backend.md.template` | Server/API rules |
| `rules/ai.md.template` | AI/LLM agent rules |

## Growing Your Knowledge Library

Start simple with 4 layers. As your system evolves, you can expand to a full 5-layer model:

| Level | What It Contains | When to Add |
|-------|------------------|-------------|
| ⚛️ Atomic | Raw docs from individual services | Start here |
| 🧪 Molecular | Aggregated architecture, API flows | 3+ services |
| 🔬 Compound | AI-synthesized cross-service insights | Patterns emerge |
| 🦠 Organism | Audience-specific views (eng, product) | Stakeholders diverge |
| 🌐 Meta | Executive strategic analysis | Vision gaps matter |

See [SCHEMA.md](./SCHEMA.md) for the full pattern.

## Bring Your Own

Alexandria is designed for customization:

- **Templates** — Edit `templates/` before install to change what gets generated
- **Rules** — Add new `templates/rules/*.template` for your domains (data layer, infra, security)
- **Commands** — Modify `user-level/commands/init-docs.md` to change the scaffolding workflow
- **Philosophy** — Edit `user-level/CLAUDE.md` to change how the agent approaches all your projects

See [templates/README.md](./templates/README.md) for customization details.

## Optional: Session Start Hook

Add a reminder at the start of each session in `~/.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "echo 'Read relevant docs before making changes. See CLAUDE.md for the document hierarchy.'"
          }
        ]
      }
    ]
  }
}
```

## Other Coding Agents

The pattern works with any agent that reads markdown:

- **Cursor** — Use `.cursorrules` or project-level instructions
- **GitHub Copilot** — Use `.github/copilot-instructions.md`
- **Windsurf** — Use project rules
- **Aider** — Use conventions files

The knowledge library pattern (layered docs + path-specific rules) transfers. Only the hook mechanism differs.

## License

MIT
