# Templates

These are starting points for the files `/ant-init` generates. **Edit them before running install.sh** to match your workflow.

## How Templates Work

When `/ant-init` runs in a project, it uses these templates as scaffolds. Placeholders like `{{UX_DOC}}` get replaced with actual values based on what docs exist in the target project.

## Template Types

### Rules Templates
Path-based behavioral guidance. Auto-loads when editing matching files.

- `rules/frontend.md.template` → `.claude/rules/frontend.md`
- `rules/backend.md.template` → `.claude/rules/backend.md`
- `rules/ai.md.template` → `.claude/rules/ai.md`

**Purpose:** Passive context that loads automatically based on file paths. Not executable commands.

### Skills Templates
Currently none - skills are copied from alexANTria, not generated per-project.

**Purpose:** Executable commands like `/ant-init` and `/ant-update` are maintained in `user-level/commands/` and copied during installation.

### Memory Template
- `CLAUDE.md.template` → `CLAUDE.md` (always-loaded hierarchy)

**Purpose:** Project-level context that loads in every session.

## Customizing Templates

### CLAUDE.md.template

The main context file generated for each project. Customize:
- The "When to Read" table mappings
- The "After Completing Work" checklist
- Add sections specific to your workflow

### rules/*.template

Path-specific rules that auto-load when editing matching files. Customize:
- `paths:` frontmatter to match your directory structure
- "Read first" links to your common doc types
- "Quick Reference" sections with your patterns

## Adding Your Own Templates

Create new `.template` files for domains you work with often:

**`rules/data.md.template`** — For database/data layer work
```markdown
---
paths:
  - "src/db/**/*"
  - "prisma/**/*"
  - "migrations/**/*"
---

# Data Layer Context

Before modifying data layer, read:
- [{{DATA_DOC}}](../../{{DATA_PATH}})

## Quick Reference
- Migrations must be reversible
- Use transactions for multi-table updates
```

**`rules/tests.md.template`** — For test files
```markdown
---
paths:
  - "**/*.test.*"
  - "**/*.spec.*"
  - "__tests__/**/*"
---

# Testing Context

## Quick Reference
- Unit tests: mock external dependencies
- Integration tests: use test database
- Name tests: "should [expected behavior] when [condition]"
```

**`rules/infra.md.template`** — For infrastructure/DevOps
```markdown
---
paths:
  - "terraform/**/*"
  - ".github/**/*"
  - "docker/**/*"
  - "k8s/**/*"
---

# Infrastructure Context

Before modifying infra, read:
- [{{INFRA_DOC}}](../../{{INFRA_PATH}})

## Quick Reference
- All changes require PR review
- Test in staging before prod
```

## Template Placeholders

Common placeholders used in templates:

| Placeholder | Replaced With |
|------------|---------------|
| `{{PROJECT_NAME}}` | Name of the target project |
| `{{UX_DOC}}` | Detected UX/design philosophy doc |
| `{{UX_PATH}}` | Path to UX doc |
| `{{ARCHITECTURE_DOC}}` | Detected architecture doc |
| `{{ARCHITECTURE_PATH}}` | Path to architecture doc |
| `{{PRODUCT_DOC}}` | Detected product/PRD doc |
| `{{PRODUCT_PATH}}` | Path to product doc |

If a placeholder's doc isn't found, `/ant-init` will either omit that section or ask you what to reference instead.

## Sharing Templates

If you build templates for a specific stack (Rails, Next.js, FastAPI, etc.), consider sharing them. Create a `templates/stacks/` directory with stack-specific rule sets:

```
templates/
├── stacks/
│   ├── nextjs/
│   │   ├── frontend.md.template
│   │   └── api-routes.md.template
│   ├── rails/
│   │   ├── controllers.md.template
│   │   ├── models.md.template
│   │   └── views.md.template
│   └── fastapi/
│       └── routes.md.template
└── rules/
    └── ... (generic templates)
```
