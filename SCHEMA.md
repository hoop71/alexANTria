# Alexandria Schema

The standard pattern for documentation hierarchy. Use this as a reference when customizing your setup.

## The Nesting Doll Principle

Documentation forms layers. Each layer builds on the previous, and outer layers constrain inner ones:

```
┌─────────────────────────────────────────────────────────────┐
│  🌐 Meta: Strategic Intelligence                            │
│  Vision gaps, platform health, executive analysis           │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  🦠 Organism: Audience-Specific Views               │    │
│  │  Product, Engineering, Marketing perspectives       │    │
│  │  ┌─────────────────────────────────────────────┐    │    │
│  │  │  🔬 Compound: Cross-Cutting Insights        │    │    │
│  │  │  Patterns across services, AI synthesis     │    │    │
│  │  │  ┌─────────────────────────────────────┐    │    │    │
│  │  │  │  🧪 Molecular: Aggregated Docs       │    │    │    │
│  │  │  │  Architecture rollups, API flows     │    │    │    │
│  │  │  │  ┌─────────────────────────────┐    │    │    │    │
│  │  │  │  │  ⚛️ Atomic: Raw Service Docs │    │    │    │    │
│  │  │  │  │  READMEs, code comments      │    │    │    │    │
│  │  │  │  └─────────────────────────────┘    │    │    │    │
│  │  │  └─────────────────────────────────────┘    │    │    │
│  │  └─────────────────────────────────────────────┘    │    │
│  └─────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

**Conflict resolution:** Outer layers override inner layers.

## Starting Simple

Most projects start with 4 layers (the basic starter pattern):

| Layer | Purpose | Example Files |
|-------|---------|---------------|
| Philosophy | Non-negotiable constraints | `PRINCIPLES.md`, `ux-philosophy.md` |
| Product | What we're building | `product-brief.md`, `PRD.md` |
| Architecture | How we build | `ARCHITECTURE.md`, `PATTERNS.md` |
| Implementation | The actual code | `CHANGELOG.md`, code comments |

As your system grows, you can expand to the full 5-layer model:

| Level | What It Contains | When to Add |
|-------|------------------|-------------|
| ⚛️ Atomic | Raw docs from individual services/repos | Start here |
| 🧪 Molecular | Static rollups (architecture, API flows) | When you have 3+ services |
| 🔬 Compound | AI-synthesized cross-service insights | When patterns emerge |
| 🦠 Organism | Audience-specific views (eng, product, marketing) | When stakeholders diverge |
| 🌐 Meta | Executive/strategic analysis | When vision-to-execution gaps matter |

The `/init-docs` command sets up the basic 4-layer structure. You can evolve from there.

## Standard Document Types

### Layer 1: Philosophy / Constraints

Files that define non-negotiable principles.

| Common Names | Purpose |
|-------------|---------|
| `PHILOSOPHY.md` | Core beliefs about how software should work |
| `CONSTRAINTS.md` | Hard limits (security, performance, accessibility) |
| `ux-philosophy.md` | Design principles that never bend |
| `PRINCIPLES.md` | Engineering values |

**Characteristics:**
- Rarely changes
- Short, opinionated
- Says "always" and "never"

### Layer 2: Product / Business Rules

Files that define what you're building.

| Common Names | Purpose |
|-------------|---------|
| `product-brief.md` | What the product does, for whom |
| `PRD.md` | Product requirements |
| `SCOPE.md` | What's in/out of scope |
| `business-rules.md` | Domain logic that must be followed |
| `REQUIREMENTS.md` | Functional requirements |

**Characteristics:**
- Changes when product direction changes
- Defines features and behaviors
- Says "the system should" and "users can"

### Layer 3: Architecture / Patterns

Files that define how you build.

| Common Names | Purpose |
|-------------|---------|
| `ARCHITECTURE.md` | System design, component relationships |
| `PATTERNS.md` | Code patterns to follow |
| `CONVENTIONS.md` | Naming, structure, style |
| `API.md` | API design and contracts |
| `CONTRIBUTING.md` | How to contribute (often includes patterns) |

**Characteristics:**
- Changes when tech stack or approach changes
- Defines structure and conventions
- Says "we use" and "components should"

### Layer 4: Implementation

The actual code, plus:

| Common Names | Purpose |
|-------------|---------|
| `CHANGELOG.md` | Record of changes |
| `decisions/` or `ADRs/` | Architecture decision records |
| `TODO.md` | Current work items |
| Code comments | Local context |

**Characteristics:**
- Changes frequently
- Records what happened
- Says "this does" and "changed because"

## Path-Specific Rules

Rules in `.claude/rules/` auto-load based on file paths. Standard domains:

| Rule File | Typical Paths | Purpose |
|-----------|---------------|---------|
| `frontend.md` | `src/components/**`, `app/**/*.tsx` | UI constraints |
| `backend.md` | `src/server/**`, `api/**`, `lib/**` | Server patterns |
| `data.md` | `src/db/**`, `prisma/**`, `migrations/**` | Data layer rules |
| `tests.md` | `**/*.test.*`, `__tests__/**` | Testing conventions |
| `agents.md` | `src/agents/**`, `prompts/**` | AI/LLM behavior |
| `infra.md` | `terraform/**`, `.github/**`, `docker/**` | Infrastructure |

## Mapping Your Docs

When running `/init-docs`, the crawler looks for your existing docs and maps them to layers:

```
Your docs              →  Layer
─────────────────────────────────
README.md              →  (often spans multiple layers)
ARCHITECTURE.md        →  Layer 3
docs/product-brief.md  →  Layer 2
docs/ux-guide.md       →  Layer 1
CONTRIBUTING.md        →  Layer 3
CHANGELOG.md           →  Layer 4
```

If you don't have docs for a layer, that's fine. The system adapts to what exists.

## Bring Your Own

To customize:

1. **Edit `templates/`** — Change the scaffolded output
2. **Edit `user-level/CLAUDE.md`** — Change the universal philosophy
3. **Add new rule templates** — Create `templates/rules/your-domain.md.template`

The schema is a pattern, not a prison. Adapt it to your workflow.
