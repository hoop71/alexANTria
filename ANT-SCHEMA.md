# ANT-SCHEMA

The standard pattern for documentation hierarchy. Use this as a reference when customizing your setup.

## The Anthill Principle

Documentation forms layers. Each layer builds on the previous, and higher layers constrain lower ones.

Every anthill starts as a small mound. Stack layers as the colony grows:

```
                    ╱╲
                   ╱  ╲
                  ╱ 👑 ╲
                 ╱QUEEN ╲            ← Strategic alignment
                ╱────────╲
               ╱   NEST   ╲          ← Org-wide views
              ╱────────────╲
             ╱   CHAMBERS   ╲        ← Cross-cutting patterns
            ╱────────────────╲
           ╱     TUNNELS      ╲      ← Service connections
          ╱────────────────────╲
         ╱       SURFACE        ╲    ← Individual docs
        ╱────────────────────────╲
═══════════════════════════════════════
              🌱 ground 🌱
```

**Conflict resolution:** Higher layers override lower layers. No central brain decides—the constraint hierarchy does.

## The 5-Layer Structure

alexANTria uses the same layered context pattern as Claude Code, extended to organizational scale:

| Layer | What Lives Here | Who Consumes It | When to Build |
|-------|-----------------|-----------------|---------------|
| 🌱 **Surface** | Per-service docs, READMEs, code comments | Individual contributors, Agents | Start here |
| 🚇 **Tunnels** | Architecture patterns, API contracts, service boundaries | Engineers, Senior developers | When services connect |
| 🏛️ **Chambers** | Cross-cutting patterns, shared conventions, integration points | Architects, Staff engineers, Tech leads | When patterns emerge |
| 🐜 **Nest** | Audience-specific views (engineering, product, business context) | Department leads, Product managers, Cross-functional teams | When stakeholders diverge |
| 👑 **Queen** | Strategic alignment, vision-to-execution, organizational coherence | Leadership, Executives, C-suite | When vision gaps matter |

**Key difference from engineering-only patterns:** Surface → Tunnels → Chambers aligns with typical engineering documentation (like Claude Code's modular rules). **Nest and Queen extend to organizational scale**—product context, business rules, strategic alignment that affects the entire org, not just engineering.

The `/ant-init` command scaffolds all 5 layers based on what it finds in your project.

## Bidirectional Flow

Knowledge flows both directions through your anthill. This is how the colony stays aligned.

**Upward (Surface → Queen):** Implementation patterns bubble up through tunnels, surface in chambers as cross-cutting insights, shape nest-level views, and inform queen-level strategy.

**Downward (Queen → Surface):** Strategic decisions constrain nest priorities, which guide chamber-level patterns, which direct tunnel architecture, which shapes surface implementation.

```
        ↑ Signals                    ↓ Constraints

Surface patterns reveal debt  →    Queen pivots reshape
Tunnel bottlenecks emerge     →    Nest priorities
Chamber insights surface      →    Tunnel architecture follows
```

When both flows work, the colony stays aligned. When either breaks, silos form. Structure your docs to maintain both flows.

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

## External Context Feeds

Some documentation comes from external sources and should not be managed by the local anthill. Mark these with `ANT-EXTERNAL.md`:

### The ANT-EXTERNAL Marker

Place an `ANT-EXTERNAL.md` file in any directory that contains read-only external context:

```
docs/alexandria/
├── ANT-EXTERNAL.md          ← Marker file
├── SERVICE_CONTEXT.md
└── INTEGRATION_CONTRACTS.md
```

**Location-agnostic:** The marker works anywhere in your project tree.

```
project/
├── docs/platform-intelligence/
│   └── ANT-EXTERNAL.md
├── vendor/partner-docs/
│   └── ANT-EXTERNAL.md
└── .claude/external-feeds/
    └── ANT-EXTERNAL.md
```

### ANT-EXTERNAL.md Template

```markdown
# External Context Feed

This directory contains read-only context from an external source.

- **Source**: [Name of generator/source]
- **Update Frequency**: [How often it updates]
- **Ownership**: External (do not modify locally)
- **Purpose**: [What this context provides]

## ant-init Behavior

- **Reads**: Yes (for context awareness)
- **Manages**: No (excluded from anthill maintenance)
- **References**: Listed in CLAUDE.md as external context

## Feedback Loop

Changes to local documentation that reference this context are tracked
via `.alexantria/manifest.json` and can phone home to improve future
generations.
```

### How ant-init Handles External Context

1. **During crawl**: Detects `ANT-EXTERNAL.md` markers
2. **Excludes from layers**: Does not map external docs to anthill layers
3. **References in CLAUDE.md**: Lists external feeds for awareness
4. **Tracks usage**: Notes when local docs reference external context

**Example CLAUDE.md output:**

```markdown
## External Context Feeds

These directories contain read-only context from external sources:

- **docs/alexandria/** - Platform-wide intelligence
  - Source: Alexandria Hub
  - Update: Nightly automated generation
  - Purpose: Cross-service architectural context
```

### Why External Feeds Matter

External context feeds solve a critical problem: some knowledge is generated at a different scope or lifecycle than your local docs.

**Use cases:**
- **Platform-wide intelligence** (Alexandria) generated from multiple repos
- **Vendor documentation** that updates independently
- **Generated API specs** from other teams
- **Compliance documentation** managed by legal/security teams

The anthill **consumes** external context but doesn't try to **maintain** it. Changes flow through the manifest phone-home mechanism.

## Mapping Your Docs

When running `/ant-init`, the crawler looks for your existing docs and maps them to layers:

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

## Growing the Anthill

alexANTria starts as a coding agent scaffold but can grow into an organizational knowledge framework.

### The Path from Mound to Mountain

**Stage 1: Surface Only**
- Surface docs (READMEs, code comments)
- Basic 4-layer hierarchy (Philosophy → Product → Architecture → Implementation)
- Coding agents as the primary consumer

**Stage 2: Digging Tunnels**
- Add Tunnels layer (architecture rollups, API documentation)
- Engineers and agents both benefit
- Cross-service patterns start to emerge

**Stage 3: Building Chambers**
- Add Chambers layer (cross-cutting analysis)
- Architects can see system-wide concerns
- Technical debt becomes visible across boundaries

**Stage 4: Organizing the Nest**
- Add Nest layer (audience-specific views)
- Product, Engineering, and other leads get tailored perspectives
- Same underlying knowledge, different presentations

**Stage 5: Queen's View**
- Add Queen layer (executive analysis)
- Leadership sees vision-to-execution alignment
- Organizational coherence becomes measurable

### You Don't Need All Five Layers on Day One

The anthill grows with your organization:

**Start here (engineering focus):**
- **Surface** — Service docs, READMEs
- **Tunnels** — Architecture docs
- Works great for coding agents and engineering teams

**Add when you scale organizationally:**
- **Chambers** — When cross-cutting patterns emerge across teams
- **Nest** — When product/business/eng need different views of the same system
- **Queen** — When strategic alignment matters (vision-to-execution coherence)

The value is knowing the structure exists so you can:
1. **Start with engineering context** — Surface + Tunnels (aligns with Claude Code patterns)
2. **Build higher when needed** — Add layers when their audience emerges
3. **Maintain coherence** — Higher layers constrain lower ones at any scale

See [ANT-FRAMEWORK.md](./ANT-FRAMEWORK.md) for the full organizational knowledge framework.
