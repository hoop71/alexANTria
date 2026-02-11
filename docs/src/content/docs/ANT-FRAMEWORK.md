---
title: ANT Framework
description: Organizational Knowledge Framework. RLM architecture at organizational scale with three-pool context separation.
---

# ANT-FRAMEWORK: Organizational Knowledge Framework

**RLM architecture at organizational scale.** Three-pool context separation (programmatic/tokenized/intentional) prevents context rot.

The anthill pattern isn't just for code. It's an organizational pattern.

## The Core Insight

When we built alexANTria for coding agents, we discovered something broader: the same hierarchical structure that helps agents understand code also helps organizations understand themselves.

A coding agent reading your codebase is just one **context engine**. Product managers reading strategy docs, engineers reading architecture specs, executives reviewing health metrics—these are all context engines consuming knowledge at different layers.

The question isn't "how do we document code?" It's "how do we structure organizational knowledge so the right consumers get the right context?"

## The Colony Model

alexANTria is based on a simple observation: **intelligence emerges from coordination, not command**.

An ant colony has no central brain. No master ant directs traffic. Yet the colony builds complex structures, finds optimal paths, and adapts to change. How?

- Each ant acts locally with simple rules
- Each ant reads and writes to shared state (pheromones)
- The map is continuously maintained by many small repairs
- Alignment comes from shared constraints, not top-down control

Organizations work the same way. The documentation hierarchy is your pheromone trail.

## Three Sources of Truth

alexANTria is built on research into how language models handle context at scale. The RLM (Retrieval-Augmented Language Model) architecture reveals why context rot happens and how to prevent it.

### The Three Pools

Every AI-assisted codebase has three pools of knowledge:

1. **Programmatic Pool** (Code)
   - What: The actual implementation
   - Where: Your codebase, git history, test suites
   - Inferable: Agents can read code to understand what exists
   - Example: "We have a JWT auth system with refresh tokens"

2. **Tokenized Pool** (Documentation)
   - What: How we implement patterns and conventions
   - Where: ANT-* files, CLAUDE.md, .claude/rules/
   - Explicit: Must be written down, not inferable from code alone
   - Example: "Always use httpOnly cookies for refresh tokens"

3. **Intentional Pool** (Human Knowledge)
   - What: Why we made strategic decisions
   - Where: Strategy/Product layers, ADRs, strategic memos
   - Human-only: Cannot be inferred, must be captured from humans
   - Example: "We chose JWT over sessions because we're going distributed"

### The Knowledge Spectrum

Different layers require different capture methods:

```
Lower layers (Service/Architecture)  →  Higher layers (Product/Strategy)
Code-inferable                        →  Human-required
"What exists"                         →  "Why we decided"
Agents can discover                   →  Humans must document
```

**Service/Architecture**: Code-inferable. Agents can discover these by reading implementations.

**Patterns**: Mixed. Patterns visible in code, rationale requires documentation.

**Product/Strategy**: Human-required. Strategy, constraints, and "why" decisions were made.

### Why This Matters

RLM research: **context rot is fundamental**—models degrade when context exceeds soft limits. Solution: separate what agents can infer (code) from what must be written (docs) from what requires human capture (strategy).

**The five layers aren't bureaucracy—they're a knowledge spectrum from code-inferable to human-required.** Start with what you need. Build higher when the audience emerges.

See [The Potential of RLMs](https://www.dbreunig.com/2026/02/09/the-potential-of-rlms.html) for the research foundation.

## The Five-Layer Anthill

Every anthill starts as a small mound. Stack layers as the colony grows:

```
                    ╱╲
                   ╱  ╲
                  ╱ 👑 ╲
                 ╱STRAT ╲            ← Strategic alignment
                ╱────────╲              Leadership, Executives
               ╱ PRODUCT  ╲          ← Org-wide views
              ╱────────────╲            Department leads
             ╱   PATTERNS   ╲        ← Cross-cutting patterns
            ╱────────────────╲          Architects, Tech leads
           ╱   ARCHITECTURE   ╲      ← Service connections
          ╱────────────────────╲        Engineers, Senior devs
         ╱       SERVICE        ╲    ← Individual docs
        ╱────────────────────────╲      Contributors, Agents
═══════════════════════════════════════
              🌱 ground 🌱
```

### Layer Details

| Layer | Audience | Key Questions Answered |
|-------|----------|----------------------|
| 👑 **Strategy** | Leadership | "Are we building the right thing? What's our strategic position?" |
| 🐜 **Product** | Department Leads | "How does my area connect to others? What's the cross-functional picture?" |
| 🏛️ **Patterns** | Architects | "What patterns span systems? Where are the integration points?" |
| 🚇 **Architecture** | Engineers | "How do these services work together? What's the architecture?" |
| 🌱 **Service** | Contributors / Agents | "How does this specific service work? What's the implementation?" |

## Bidirectional Flow

Knowledge flows both directions through the anthill.

### Upward: Service → Strategy

```
Implementation details  →  Architectural patterns  →  System health  →  Strategic position
(Service)                  (Architecture/Patterns)    (Product)         (Strategy)
```

What happens at the service level bubbles up. A proliferation of workarounds at the service level signals architectural debt in the patterns, which manifests as velocity problems at the product level, which becomes a strategic concern.

### Downward: Strategy → Service

```
Strategic priorities  →  Department goals  →  Architectural decisions  →  Implementation choices
(Strategy)               (Product)            (Patterns/Architecture)      (Service)
```

Vision constrains execution. A strategic pivot at the strategy level reshapes department priorities at the product level, which redefines acceptable architectures in the patterns, which guides implementation at the service level.

### The Feedback Loop

Healthy organizations maintain both flows:

- **Bottom-up signals** surface problems before they become crises
- **Top-down constraints** prevent local optimizations that hurt global outcomes
- **Bidirectional alignment** ensures everyone works toward the same goals with shared understanding

When either flow breaks down, organizations fragment. Engineers build the wrong thing. Leaders make decisions without ground truth. alexANTria's structure maintains both flows.

## Context Engines

Different consumers access different layers of the anthill. Each is a "context engine" that processes knowledge for a specific purpose.

| Context Engine | Primary Layers | What It Does |
|----------------|----------------|--------------|
| Coding Agent | Service, Architecture | Implements features within architectural constraints |
| Engineer | Service, Architecture, Patterns | Designs solutions that fit system patterns |
| Architect | Patterns, Architecture | Evolves system design based on emerging patterns |
| Product Lead | Product, Patterns | Makes roadmap decisions with technical context |
| Engineering Lead | Product, Patterns | Allocates resources based on system health |
| Executive | Strategy, Product | Sets strategy based on organizational reality |

Each engine needs **different context at different granularity**. The service layer would overwhelm a CEO. The strategy layer won't help an engineer fix a bug. The anthill structure lets each consumer access the appropriate level.

## Why Coding Agents Are Just the Start

Coding agents read code and docs (programmatic + tokenized pools) but can't access the intentional pool without human capture. Service/Architecture sufficient for agents, Product/Strategy require humans.

alexANTria began as a way to give coding agents better context. But coding agents are just one context engine—arguably the simplest one.

The same patterns that help an agent understand your codebase can help:

- **Product teams** understand technical constraints
- **Engineering leads** understand cross-team dependencies
- **Architects** understand emergent patterns
- **Executives** understand platform health

The scaffolding you set up for coding agents becomes the foundation for org-wide knowledge. Start with surface documentation for your agents. As your system grows, the anthill naturally extends upward.

## Growing from Starter to Organization

```
Start here                          Build to this
─────────────                       ─────────────

    ╱╲                                   ╱╲
   ╱  ╲                                 ╱👑╲  ← Strategy
  ╱    ╲                               ╱────╲
 ╱ 🌱  ╲                             ╱PRODUCT╲  ← Department views
╱SERVICE╲                           ╱────────╲
──────────                         ╱ PATTERNS ╲  ← Cross-cutting
                                  ╱────────────╲
     ↓                           ╱ ARCHITECTURE ╲  ← Architecture
                                ╱────────────────╲
    ╱╲                         ╱     SERVICE      ╲  ← Service docs
   ╱  ╲                       ╱────────────────────╲
  ╱🚇 ╲                      ══════════════════════════
 ╱ARCH╲
╱──────╲
╱SERVICE╲
──────────
```

The path:

1. **Service** — Start with service-level docs that help coding agents
2. **Architecture** — Add architecture docs when services connect
3. **Patterns** — Add cross-cutting analysis when patterns emerge across services
4. **Product** — Add audience-specific views when stakeholders need different perspectives
5. **Strategy** — Add strategic analysis when vision-to-execution alignment matters

You don't need all five layers on day one. The anthill scales with your organization's complexity.

## The Constraint Principle

Higher layers constrain lower layers. This is fundamental.

A strategic decision at the strategy level ("we're pivoting to enterprise") constrains product-level priorities ("product focuses on security features"), which constrains patterns-level architecture ("we need audit logging everywhere"), which constrains architecture-level design ("here's the logging pattern"), which constrains service-level implementation ("this service implements the pattern").

When conflicts arise between layers, higher layers win. This isn't bureaucracy—it's coherence. An organization where implementation decisions override strategic direction is an organization at war with itself.

## The Repair Principle

Every action that changes reality must repair the map.

In a healthy colony:
- Code changes trigger doc reviews
- Architecture decisions update the architecture layer
- Cross-cutting patterns get documented in patterns
- Department priorities reflect at the product level
- Strategic shifts cascade down from the strategy level through all layers

If a system acts without updating shared memory, it is drifting.

## What alexANTria Rejects

- **One-shot intelligence** — context must persist across sessions
- **Hidden state** — if it matters, it's documented
- **Orphaned documentation** — docs that no one reads or maintains
- **"Magic" behavior** — every action traceable to context
- **Central brains** — no master prompt, no god agent

Alignment comes from shared constraints, not top-down control.

## Summary

alexANTria provides a template for organizational knowledge, not just code documentation:

- **Five layers** (Service → Architecture → Patterns → Product → Strategy) map to organizational audiences
- **Bidirectional flow** maintains alignment between vision and execution
- **Context engines** consume knowledge at appropriate granularity
- **Higher constrains lower** ensures coherent decision-making
- **Read, act, repair** keeps the map accurate

Start with coding agents. The same anthill scales to your entire organization.

---

**The Goal:** Make intelligence maintainable. Not smarter in isolation. Smarter over time. Through coordination, not command.

---

See [ANT-SCHEMA.md](./ANT-SCHEMA.md) for the technical implementation of this pattern.
