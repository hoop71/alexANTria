# Alexandria

<img width="1024" height="1536" alt="image" src="https://github.com/user-attachments/assets/cdba2148-c8f4-4a7f-af4e-b79e42be12d7" />

**Shareable context automation for Claude Code.**

Alexandria helps you set up consistent, reusable documentation patterns that Claude Code understands. Instead of manually typing context every session, your project docs become living instructions that Claude reads on-demand and keeps in sync.

## Philosophy

### Read Before You Act

Every project has documentation that guides decisions. Alexandria teaches Claude to:

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

When you change something at a lower level that affects a higher level, Claude suggests updating the upstream doc.

### References, Not Imports

CLAUDE.md stays lean. Instead of copying entire docs into context:

- Use `[readable descriptions](./path.md)` — Claude reads them when relevant
- `.claude/rules/` auto-loads domain-specific guidance — only when editing matching paths
- Hierarchy is codified — Claude knows what to read and when to suggest updates

## Quick Start

### 1. Install (one-time)

```bash
git clone https://github.com/yourname/alexandria
cd alexandria
./install.sh
```

This creates `~/.claude/` with:
- Universal philosophy (applies to all projects)
- `/init-docs` command to scaffold new projects

### 2. Set Up a Project

```bash
cd /path/to/your/project
```

Then in Claude Code, run:
```
/init-docs
```

Claude will:
1. Ask what kind of project this is
2. Ask what documentation files exist
3. Create a `CLAUDE.md` with your doc hierarchy
4. Create `.claude/rules/` with path-specific rules

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

Your project's CLAUDE.md tells Claude what to read and when:

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

After Claude completes work, it checks:
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

## Optional: Session Start Hook

Add a reminder at the start of each Claude Code session in `~/.claude/settings.json`:

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

## License

MIT
