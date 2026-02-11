---
title: RLM Architecture
description: How to apply Retrieval-Augmented Language Model principles to prevent context rot at organizational scale.
---

# RLM Architecture for Project Documentation

**How to apply Retrieval-Augmented Language Model principles to prevent context rot at organizational scale.**

---

## Abstract

Research into RLMs (Retrieval-Augmented Language Models) reveals why context rot is fundamental: models degrade when context exceeds soft limits, even if it fits the stated window. The RLM solution separates programmatic context (code, structured data) from tokenized context (active in attention window).

alexANTria extends this two-pool architecture with a critical third pool: **intentional context**—strategic decisions, product rationale, and business constraints that cannot be inferred from code or documentation alone.

This document explains how to implement RLM principles for project-scale knowledge management.

**Keywords:** RLM, context rot, three-pool architecture, programmatic context, tokenized context, intentional context, knowledge spectrum, documentation hierarchy

---

## The RLM Foundation

### Context Rot Is Structural

From [The Potential of RLMs](https://www.dbreunig.com/2026/02/09/the-potential-of-rlms.html):

> "Context rot occurs when context exceeds soft limits, even if it fits the stated window. Models continue generating output while accuracy degrades—a silent quality problem."

**The insight:** Bigger context windows don't solve this. Better architecture does.

### The Two-Pool RLM Architecture

RLMs separate context into two pools:

1. **Programmatic Pool**
   - Code, structured data, REPL state
   - Available for retrieval
   - Not actively in attention window

2. **Tokenized Pool**
   - Active in model's attention
   - Limited by soft context limits
   - Models intelligently filter what moves from programmatic → tokenized

This prevents attention degradation by keeping total tokenized context manageable.

---

## The Third Pool: Intentional Context

At project scale, codebases have a **third type of context** that RLMs don't address:

### Intentional Pool (Human Knowledge)

**What:** Strategic decisions, product rationale, business constraints, the "why" behind choices

**Where:** Strategy docs, ADRs (Architecture Decision Records), product briefs, design philosophy

**Problem:** Cannot be inferred from code or documentation alone

**Example:**
- **Code says:** "We use JWT tokens with 15-minute expiry"
- **Docs say:** "Always use httpOnly cookies for refresh tokens"
- **Intentional context says:** "We chose JWT over sessions because we're planning distributed architecture for enterprise customers"

The third statement requires human capture. No amount of code reading or doc analysis reveals it.

---

## The Knowledge Spectrum

Different types of knowledge require different capture methods:

```
Lower layers              →              Higher layers
Code-inferable            →              Human-required
"What exists"             →              "Why we decided"
Agents can discover       →              Humans must document
```

### Programmatic (Code-Inferable)

**What agents can discover by reading implementations:**
- Service boundaries (visible in directory structure)
- API contracts (visible in code)
- Data schemas (visible in migrations)
- Architecture patterns (discoverable by reading multiple files)

**When to document:** When the pattern isn't obvious from code alone, or when inferring context would take too long.

**alexANTria layers:** Service, Architecture

### Tokenized (Must Be Written)

**What must be explicitly documented:**
- How to apply patterns consistently
- Why we chose this pattern over alternatives
- Cross-cutting concerns (logging, error handling, auth flows)
- Conventions and standards

**When to document:** When the "how" matters for consistency, or when rationale prevents future mistakes.

**alexANTria layers:** Patterns (cross-cutting conventions)

### Intentional (Human-Required)

**What only humans can capture:**
- Who are our users? (product context)
- What problem are we solving? (business rules)
- Why did we make this strategic choice? (strategic alignment)
- What constraints must never be violated? (principles)

**When to document:** When strategic context affects implementation decisions, or when "why" prevents future pivots from breaking assumptions.

**alexANTria layers:** Product (product/business), Strategy (strategic alignment)

---

## Implementing RLM Principles at Project Scale

### 1. Separate the Three Pools

**Programmatic Pool:**
- Your codebase (git history, implementations, tests)
- Engineers and agents maintain through normal development

**Tokenized Pool:**
- ANT-* documentation files
- `.claude/rules/` (path-based auto-loading)
- `CLAUDE.md` (hierarchy map)
- Worker ant maintains lower layers, humans maintain patterns

**Intentional Pool:**
- Strategy layer (strategic alignment, principles)
- Product layer (product context, business rules)
- Humans only—agents cannot infer this

### 2. Map Documentation to the Knowledge Spectrum

Not all documentation is equal. Different layers need different maintenance strategies:

| Layer | Pool | What It Documents | Who Maintains | Automation |
|-------|------|------------------|---------------|------------|
| **Service** | Programmatic | Service-level implementations | Agents | Safe (code-adjacent) |
| **Architecture** | Programmatic | Architecture, service connections | Agents + humans | Safe (inferable from code) |
| **Patterns** | Tokenized | Cross-cutting conventions, rationale | Humans | Assisted (agents suggest) |
| **Product** | Intentional | Product context, business rules | Humans | Never (requires judgment) |
| **Strategy** | Intentional | Strategic constraints, principles | Humans | Never (requires judgment) |

### 3. Control the Automation Boundary

RLM architecture shows why some context can be automated and some cannot:

- **Programmatic context** (code reality) → Agents can maintain docs about what exists
- **Tokenized context** (patterns) → Agents can suggest, humans approve
- **Intentional context** (strategy) → Only humans can capture

alexANTria implements this via `starting_level` in config:

```json
{
  "scope": {
    "starting_level": "service"  // Only auto-update Service layer
  }
}
```

**Prevents:** Agents from documenting strategy they cannot infer
**Enables:** Agents to maintain code-adjacent documentation
**Result:** Context stays accurate without human bottleneck for inferable content

### 4. Design for Bidirectional Flow

Knowledge flows both directions:

**Upward (Service → Strategy):**
Implementation patterns bubble up through architecture, surface as cross-cutting insights, shape product views, inform strategic decisions.

**Downward (Strategy → Service):**
Strategic constraints guide product priorities, which shape architectural patterns, which direct implementation choices.

**RLM connection:** Programmatic pool informs tokenized context, which shapes what humans capture in intentional pool. Conversely, intentional context constrains what patterns are acceptable (tokenized), which guides implementations (programmatic).

---

## Preventing Context Rot at Scale

### The Problem: Attention Degradation

From RLM research: **Soft context limits cause degradation before hard limits.**

At project scale:
- 5 services × 3 patterns each = 15 patterns to track
- 10 engineers × 3 mental models = 30 competing models
- 30 agents × independent learning = 30× redundant re-explanations

**Result:** Context rot through attention overload.

### The Solution: Hierarchical Context

RLM principle: **Filter what moves from programmatic to tokenized space.**

At project scale: **Filter what moves from code to docs to strategy.**

```
Code (everything)
  ↓ filter: what's not obvious?
Docs (patterns, rationale)
  ↓ filter: what's not inferable?
Strategy (human decisions, constraints)
```

**alexANTria implements this filtering through:**
1. Smart triggers (only update docs when patterns change)
2. Layer boundaries (only escalate when higher layers affected)
3. Guardian validation (catch when wrong layer is updated)

### Evidence: Gas Town at 30 Agents

Steve Yegge's [Gas Town](https://steve-yegge.medium.com/welcome-to-gas-town-4f25ee16dd04) proved agent orchestration works at extreme scale (20-30 concurrent agents). But even Steve hit context problems:

- **Plan dementia:** Agents forgot outer context after compaction
- **Death by re-explanations:** Steve became the context oracle
- **"You can't leave":** Tribal knowledge stuck in his head

**The issue:** Beads solved work memory (what to do), Gas Town solved orchestration (who does it), but **intentional context** (why and how) remained unstructured.

alexANTria solves the third problem: **persistent, hierarchical, three-pool context.**

---

## Practical Implementation

### Starting Point: Identify Your Three Pools

**Audit your current documentation:**

1. **What can agents infer from code?**
   - API endpoints, data schemas, file structure
   - → These are candidates for programmatic pool

2. **What requires documentation?**
   - Patterns, conventions, the "how we do things"
   - → These belong in tokenized pool

3. **What only exists in people's heads?**
   - "Why we chose X over Y", product strategy, constraints
   - → These must be captured in intentional pool

### Implementation Path

**Stage 1: Separate Programmatic from Tokenized**
- Create `CLAUDE.md` (the map)
- Add `.claude/rules/` for path-based loading
- Document patterns that aren't obvious from code

**Stage 2: Add Intentional Layer**
- Create `ANT-STRATEGY.md` (strategic constraints)
- Create `ANT-PRODUCT.md` (product/business context)
- Capture the "why" behind major decisions

**Stage 3: Control Automation**
- Set `starting_level` to control what agents maintain
- Use worker ant for programmatic layer updates
- Keep humans in the loop for intentional context

**Stage 4: Scale**
- Add Patterns layer when conventions emerge across services
- Add Architecture layer when architecture needs rollup
- Maintain bidirectional flow (signals up, constraints down)

---

## Comparison to Other Approaches

### vs. Traditional Documentation

**Traditional:** Flat structure, everything in READMEs or wikis

**Problem:** No hierarchy means no precedence. Philosophy conflicts with implementation with no resolution mechanism.

**RLM approach:** Layered hierarchy where higher layers constrain lower ones. Conflicts resolve structurally.

### vs. Code Comments

**Traditional:** Important context lives in code comments

**Problem:** Comments are code-adjacent only. No place for strategic context or cross-cutting patterns.

**RLM approach:** Three pools separate code reality (programmatic) from patterns (tokenized) from strategy (intentional).

### vs. Wiki/Confluence

**Traditional:** Centralized knowledge base, manually maintained

**Problem:** Rots immediately. Agents can't auto-load it. No connection to code changes.

**RLM approach:** Documentation lives in git, auto-loads based on file paths, agents help maintain programmatic layer.

---

## Measuring Success

### Context Rot Indicators

**Bad signs:**
- Agents ask the same questions repeatedly
- Documentation contradicts code
- "Tribal knowledge" that only exists in Slack/heads
- Agents make choices that violate unstated constraints

**Good signs:**
- Agents work within constraints without prompting
- New team members onboard by reading docs
- Strategic decisions propagate to implementation automatically
- Documentation stays in sync with code

### RLM Architecture Health

**Programmatic pool:**
- ✓ Code is the source of truth
- ✓ Docs supplement when code isn't self-evident
- ✓ Agents can maintain code-adjacent docs

**Tokenized pool:**
- ✓ Patterns documented once, referenced everywhere
- ✓ Cross-cutting concerns have clear ownership
- ✓ "How we work" is explicit, not tribal

**Intentional pool:**
- ✓ Strategic constraints are written down
- ✓ Product context accessible to all agents
- ✓ "Why" behind decisions is preserved

---

## Related Work

### Research
- [The Potential of RLMs](https://www.dbreunig.com/2026/02/09/the-potential-of-rlms.html) - Foundation research on context rot and two-pool architecture

### Systems
- [Gas Town](https://steve-yegge.medium.com/welcome-to-gas-town-4f25ee16dd04) - Agent orchestration at 30-agent scale
- [Beads](https://steve-yegge.medium.com/introducing-beads-a-coding-agent-memory-system-637d7d92514a) - Work memory system (task graphs, dependencies)

### Concepts
- Architecture Decision Records (ADRs) - Capturing the "why" behind technical choices
- Layered architecture - Separation of concerns at system scale
- Pheromone trails - Ant colony metaphor for persistent context

---

## Further Reading

**In this repo:**
- [ANT-FRAMEWORK.md](./ANT-FRAMEWORK.md) - The organizational coordination model
- [ANT-SCHEMA.md](./ANT-SCHEMA.md) - The 5-layer documentation pattern
- [blog/gastown-context-infrastructure.md](./blog/gastown-context-infrastructure.md) - Why orchestration needs context infrastructure

**External:**
- [The Potential of RLMs](https://www.dbreunig.com/2026/02/09/the-potential-of-rlms.html) - Original RLM research
- [Gas Town](https://steve-yegge.medium.com/welcome-to-gas-town-4f25ee16dd04) - Proof point at 30-agent scale

---

## Summary

**RLM architecture reveals:** Context rot is structural. Solution: separate programmatic (code) from tokenized (active attention).

**alexANTria extends:** Add third pool for intentional context (human knowledge that cannot be inferred).

**Result:** Documentation hierarchy that scales from solo dev to 30-agent swarms without context rot.

**Key insight:** Not all context is equal. Code-inferable → pattern-based → human-required forms a spectrum. Structure your docs accordingly.

---

*This document implements RLM principles in its own structure: programmatic (git), tokenized (this file), intentional (why we built alexANTria).*
