# alexANTria Schema

The standard pattern for documentation hierarchy. Use this as a reference when customizing your setup.

## The Nesting Doll Principle

Documentation forms layers. Each layer builds on the previous, and outer layers constrain inner ones.

Like pheromone trails in an ant colony, each layer is a signal that guides behavior:

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

**Conflict resolution:** Outer layers override inner layers. No central brain decides—the constraint hierarchy does.

## Starting Simple

Most projects start with 4 layers (the basic starter pattern):

| Layer | Purpose | Example Files |
|-------|---------|---------------|
| Philosophy | Non-negotiable constraints | `PRINCIPLES.md`, `ux-philosophy.md` |
| Product | What we're building | `product-brief.md`, `PRD.md` |
| Architecture | How we build | `ARCHITECTURE.md`, `PATTERNS.md` |
| Implementation | The actual code | `CHANGELOG.md`, code comments |

As your system grows, you can expand to the full 5-layer model:

| Level | What It Contains | Who Consumes It | When to Add |
|-------|------------------|-----------------|-------------|
| ⚛️ Atomic | Raw docs from individual services/repos | Individual contributors, Agents | Start here |
| 🧪 Molecular | Static rollups (architecture, API flows) | Engineers, Senior developers | When you have 3+ services |
| 🔬 Compound | Cross-service insights | Architects, Staff engineers, Tech leads | When patterns emerge |
| 🦠 Organism | Audience-specific views (eng, product, marketing) | Department leads, Product managers | When stakeholders diverge |
| 🌐 Meta | Executive/strategic analysis | Leadership, Executives | When vision-to-execution gaps matter |

The `/init-docs` command sets up the basic 4-layer structure. You can evolve from there.

## Bidirectional Flow

Knowledge flows both directions through your documentation layers. This is how the colony stays aligned.

**Upward (Code → Insights):** Implementation patterns bubble up to inform architectural decisions, which surface system health metrics, which shape strategic understanding.

**Downward (Vision → Priorities):** Strategic decisions constrain department goals, which guide architectural choices, which direct implementation.

```
        ↑ Signals                    ↓ Constraints

Code patterns reveal debt    →    Strategic pivots reshape
Workarounds signal problems  →    architecture requirements
Velocity metrics emerge      →    Implementation choices follow
```

When both flows work, organizations stay aligned. When either breaks, silos form. Structure your docs to maintain both flows.

## The Repair Principle

Every action that changes reality must repair the map.

This is the core behavior loop:
1. **Read** the relevant context
2. **Act** within the constraints
3. **Repair** any docs affected by the change

Small repairs accumulate into coherent documentation. No single change needs to be perfect. Consistency emerges from accumulation, not authority.

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
- Records what happened (history matters)
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

## Growing the Colony

alexANTria starts as a coding agent scaffold but can grow into an organizational knowledge framework.

### The Path from Starter to Full Organization

**Stage 1: Single Project**
- Atomic docs (READMEs, code comments)
- Basic 4-layer hierarchy (Philosophy → Product → Architecture → Implementation)
- Coding agents as the primary consumer

**Stage 2: Multiple Services**
- Add Molecular layer (architecture rollups, API documentation)
- Engineers and agents both benefit
- Cross-service patterns start to emerge

**Stage 3: Pattern Recognition**
- Add Compound layer (cross-cutting analysis)
- Architects can see system-wide concerns
- Technical debt becomes visible across boundaries

**Stage 4: Stakeholder Divergence**
- Add Organism layer (audience-specific views)
- Product, Engineering, and other leads get tailored perspectives
- Same underlying knowledge, different presentations

**Stage 5: Strategic Alignment**
- Add Meta layer (executive analysis)
- Leadership sees vision-to-execution alignment
- Organizational coherence becomes measurable

### You Don't Need All Five Layers

Most projects never need the full model. The value is knowing the structure exists so you can:

1. **Start simple** — Use the 4-layer starter pattern
2. **Recognize when to expand** — Add layers when their audience emerges
3. **Maintain coherence** — Outer layers constrain inner ones at any scale

See [FRAMEWORK.md](./FRAMEWORK.md) for the full organizational knowledge framework.
