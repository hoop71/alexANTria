---
title: "Guardrails for Gas Town: Why Orchestration Needs Context Infrastructure"
description: "Why multi-agent orchestration needs context infrastructure. Work memory (Beads) tracks what to do. Context memory (alexANTria) tracks how and why — using RLM three-pool architecture."
---

# Guardrails for Gas Town: Why Orchestration Needs Context Infrastructure

**Or: How to Run 30 Agents Without Burning Down Production**

---

**Version:** 0.2.0 (February 11, 2026)
**Status:** Active development - three-pool architecture validated
**Last Updated:** 2026-02-11
**Discussions:** [GitHub Issues](https://github.com/hoop71/alexANTria/issues) | [Changelog](#changelog)

---

## 👑 The Core Insight (30 seconds)

Steve Yegge's [Gas Town](https://steve-yegge.medium.com/welcome-to-gas-town-4f25ee16dd04) proved you can orchestrate 20-30 agents in chaos and still ship. **But even Steve ran headfirst into every context problem:** Plan dementia. "Death by a thousand re-explanations." Becoming the bottleneck context oracle.

**The insight:** **Work memory ≠ context memory.**

- **[Beads](https://steve-yegge.medium.com/introducing-beads-a-coding-agent-memory-system-637d7d92514a)** tracks *what* to do (tasks, dependencies, status)
- **alexANTria** tracks *how* to do it (conventions, constraints, why)

**Gas Town is the proof point at extreme scale (30 agents).** But the same context problems hit you at **1 agent, 5 agents, or 30 agents**:
- "Let me explain our architecture again..."
- "Wait, which auth approach did we pick?"
- "Why is the database structured this way?"

**You don't need Gas Town to need context infrastructure.** You need it the moment you:
- Work across multiple sessions (context doesn't persist)
- Collaborate with teammates (each agent learns independently)
- Scale beyond 3-5 concurrent agents (re-explanations compound)

**Context infrastructure isn't about writing artisanal code. It's about not repeating yourself.**

*Stop here if you just need the headline. Keep reading for why this matters.*

---

## 🐜 The Problems Gas Town Exposed (2 minutes)

### The Three Context Crises

**1. Plan Dementia (605 Markdown Files)**

Agents don't have persistent memory. Every compaction, they restart, read whatever plan file they find, create 5 nested plans, forget the outer context. By phase 3, they declare "DONE! 🎉" when they've barely started.

Steve solved this with Beads—git-backed issue tracking that gives agents persistent *work* memory. **But Beads tracks WHAT work exists, not HOW you do it.**

**2. Death by a Thousand Re-explanations**

Even with perfect orchestration (Gas Town) and work tracking (Beads), Steve became the context oracle:
- Polecat 3: "How do we handle auth?"
- Polecat 7: "What's our testing strategy?"
- Polecat 12: "Why is the database structured this way?"
- The Refinery: "Which conflicting implementation should I pick?"

**At 30 agents, this doesn't scale.**

**3. You Can't Leave**

> "You become the bottleneck: the single source of truth living in your head. Context becomes tribal knowledge—when you leave, it leaves with you."

Gas Town can run all night. But if Steve takes a vacation, the system doesn't know how to work without him. **That's not a tooling problem. That's a knowledge problem.**

### The Three-Layer Stack

| Layer | System | What It Remembers | Based On |
|-------|--------|-------------------|----------|
| **Orchestration** | Gas Town | "Who's working on what? How do we coordinate?" | Multi-agent coordination |
| **Work Memory** | Beads | "What needs doing? What's blocked?" | Task graphs |
| **Context Memory** | alexANTria | **"How do we work? Why? What are our constraints?"** | **RLM three-pool architecture** |

Think of human onboarding:
- **Task** (Jira ticket) ← Beads
- **Architecture docs** (how we work, our conventions, why) ← alexANTria
- **Manager** (assigns work, coordinates) ← Gas Town

You need all of them.

*Stop here if you get the problem. Keep reading for what context infrastructure gets you.*

---

## 🏛️ What You Get (5 minutes)

### Two Kinds of Chaos

**Acceptable Chaos (Gas Town's Feature)**
- Bugs fixed 2-3 times (inefficient, but forward progress)
- Lost designs (annoying, but gets redone)
- Redundant work (waste, but still 8x faster than traditional)

**Why it works:** High velocity + self-correction tolerates waste.

**Catastrophic Chaos (What Kills You)**
- Agent commits production secrets
- Agent force-pushes to main, destroys history
- Agent drops production database table
- Three agents implement three different auth systems

**Why it kills:** Cleanup takes longer than original work. Contradictory implementations defeat velocity advantage.

**The Third Kind: User Experience Drift**

Your 20 agents ship fast. Tests pass. Merge conflicts resolve. But users see:
- Inconsistent terminology ("projects" vs "workspaces")
- Navigation chaos (sidebar vs top-nav vs settings)
- Contradictory workflows (save-first vs publish-immediately)

**Code chaos self-corrects.** Bugs get fixed, redundancy gets refactored. **UX chaos accumulates.** Users adapt to broken patterns. New features build on inconsistent foundations. **At agent speed, you can destroy product-market fit in a week.**

**The Tokenized pool prevents catastrophic technical chaos.** (Never force-push, never commit secrets — patterns every agent follows.)
**The Intentional pool prevents user experience chaos.** (Who is this for? What problem does it solve? How should it feel? — strategy only humans can capture.)

### The RLM Foundation: Why Context Infrastructure Is Structural

Recent research into RLMs (Retrieval-Augmented Language Models) reveals why context rot is fundamental, not accidental.

**The Core Problem:** Context rot occurs when context exceeds soft limits, even if it fits the stated window. Models continue generating output while accuracy degrades—a silent quality problem.

**The RLM Solution:** Two-pool architecture separates:
1. **Programmatic context** (code, structured data in REPL)
2. **Tokenized context** (active in model's attention window)

Models intelligently filter what moves from programmatic to tokenized space, preventing attention degradation.

**At Project Scale:** alexANTria extends the two-pool model with a critical third pool:

| RLM Pool | What It Holds | alexANTria Implementation |
|----------|--------------|---------------------------|
| **Programmatic** | Code reality — what exists | Your codebase (agents discover this) |
| **Tokenized** | Patterns — how we work | ANT-* docs (agents need this written down) |
| **Intentional** | Strategy — why we decided | Human knowledge (only humans can capture this) |

The insight: codebases have a **third pool** that RLMs don't address—**intentional context**. Strategic decisions, product rationale, and business constraints can't be inferred from code or docs. Humans must capture them. (See [Three Pools or Nothing](/blog/three-pools-or-nothing) for a deep dive on why all three pools are the minimum viable shape.)

**The Knowledge Spectrum:**

```
Lower layers (Service/Architecture)  →  Higher layers (Product/Strategy)
Code-inferable                        →  Human-required
Agents can discover                   →  Humans must document
```

This explains why alexANTria has five layers: they map from code-adjacent reality (programmatic pool) to strategic intent (intentional pool). It's not organizational hierarchy—it's a knowledge capture spectrum.

**Why This Matters for Gas Town:**

At 30 agents, you have:
- **30 agents reading code** (Programmatic pool) ✓
- **30 agents reading docs** (Tokenized pool) ✓ with Beads
- **30 agents needing strategy** (Intentional pool) ✗ stuck in Steve's head

Beads solves work memory. Gas Town solves orchestration. **alexANTria solves the Intentional pool**—capturing why decisions were made so agents don't need Steve to explain architecture, constraints, and product direction every convoy.

**The Intentional pool is the irreducible core.** Agents can discover code. Agents can follow documented patterns. But agents cannot infer product strategy, business constraints, or the "why" behind architectural choices. That requires human feedback — and it's the part most teams skip.

See [The Potential of RLMs](https://www.dbreunig.com/2026/02/09/the-potential-of-rlms.html) for the research foundation.

### What Context Infrastructure Gets You

**1. Faster (Sustained Velocity)**

Without context: Polecat 1 uses sessions, Polecat 5 uses JWT. Refinery picks winner, rework happens.

With context: `ANT-FRAMEWORK.md` says "Use JWT (ADR-007)". All 20 polecats implement correctly first time.

**2. Cheaper (Token Efficiency)**

Without: 20 polecats × 5,000 tokens = 100,000 redundant tokens per convoy.

With: 20 polecats read `CLAUDE.md`. Context is infrastructure, not payload.

**3. Guardrails**

Layer 1 constraints scale when you can't babysit 20 agents:
- "Never force-push to main/master"
- "Never commit secrets"
- "Read-act-repair loop is sacred"

**4. Collective Learning**

Gas Town: Each polecat starts fresh. No collective memory.

alexANTria: Polecat 5 discovers "API changed to /v2/auth", updates context. Polecats 6-20 inherit knowledge.

**5. Multi-Stakeholder**

Steve's pain: "Execs don't know what was built. Product can't influence."

alexANTria's three-pool structure enables product steering:
- **Intentional pool:** Strategy and product direction (execs, product managers)
- **Tokenized pool:** Patterns and architecture (tech leads, developers)
- **Programmatic pool:** Code reality (developers, agents)

### How They Work Together

When a polecat claims a convoy in Gas Town:

1. **Reads Beads:** "What's my task?" → `bd-a7f3: Implement login form`
2. **Reads alexANTria:** "How do we do this?" → Loads `.claude/rules/frontend.md`, reads Intentional pool (product strategy), Tokenized pool (patterns)
3. **Executes** using both memories → Implements correctly first time
4. **Repairs trails** → Updates `frontend/README.md` if pattern is new

Without alexANTria, you're the context oracle for 20 polecats simultaneously.

### The Adoption Ramp

Gas Town is the extreme proof point, but you don't need 30 agents to benefit:

| Stage | Setup | What alexANTria Provides |
|-------|-------|-----------------------------|
| **1-2 agents** | Single Claude session, or frontend + backend | Persistent context across sessions, stops re-explaining architecture |
| **3-5 agents** | Parallel workflows (UI, API, tests, docs) | Shared context prevents contradictory implementations |
| **5-10 agents** | Multiple teammates, concurrent work | Team-wide institutional memory, onboarding acceleration |
| **10-30 agents** | Orchestration layer (Gas Town) | Context infrastructure scales beneath orchestration |

**You feel the pain earliest at 1-2 agents** (re-explanations after compaction). **You hit the wall at 5-10 agents** (contradictory decisions, becoming the oracle). **Gas Town proves it's critical at 30 agents.**

alexANTria provides the on-ramp from day one through to swarm scale.

*Stop here if you're convinced. Deep dives below are optional.*

---

## 🚇 Deep Dives (Optional Reading)

### The Adoption Ramp

Not everyone will run Gas Town. Most developers use 1-5 concurrent sessions, hand-managed. But they still feel context pain.

**alexANTria provides the on-ramp:**

| Setup | What alexANTria Provides |
|-------|--------------------------|
| 1-2 Claude sessions | Persistent context across sessions |
| 3-10 concurrent agents | Shared context, reduced prompt bloat |
| Gas Town orchestration | Context infrastructure beneath orchestration |

You don't need Gas Town to need alexANTria. But when you're ready for Gas Town, alexANTria slots right in.

### Why Not Beads for Context?

You could file "knowledge issues" in Beads (`bd-arch-101: "We use JWT"`). Why doesn't this work?

**Different data models:**
- Beads: Work graph with lifecycle (created → done → closed)
- alexANTria: Knowledge hierarchy with precedence (Layer 1 overrides Layer 2)

**Different queries:**
- Beads: "What work is ready?"
- alexANTria: "What are our principles? How do we do X?"

**Different formats:**
- Beads: JSONL (machine-first, agent-focused)
- alexANTria: Markdown (human-first, accessible to execs/product)

**Clean separation is better engineering than conflating concerns.** Beads could add knowledge issues, but mixing "is it done?" with "is it true?" serves two masters poorly.

### Integration with Gas Town

**When a polecat claims work:**

```
Gas Town (orchestration)
     ↓ coordinates
     ↓
┌────┴─────┬──────────┐
│          │          │
Beads   alexANTria   │
"What"   "How"       │
│          │          │
└────┬─────┴──────────┘
     ↓
Claude Code (execution)
```

Each layer makes the others more powerful.

---

## 🌱 Known Challenges (Reference Material)

We're actively working on these. Each has an open discussion—please share your experiences.

### Challenge 1: Context Conflicts at Agent Speed
[💬 Join discussion](https://github.com/hoop71/alexANTria/discussions/2)

**Problem:** 20 agents update context in parallel. Who arbitrates when two assert contradictory principles?

**Exploring:** Manifest-based discovery, human arbitration for Layer 1, automated merge for Layers 2-4.

**Status:** 🔶 Exploring

---

### Challenge 2: Agent Maintenance Discipline
[💬 Join discussion](https://github.com/hoop71/alexANTria/discussions/3)

**Problem:** Agents skip trail maintenance under context pressure. How do we enforce it?

**Exploring:** Pattern promotion at merge-to-main, post-merge context-update tasks.

**Limitation:** At swarm velocity (20+ agents), patterns emerge faster than merges.

**Status:** 🔶 Exploring

---

### Challenge 3: Economic Break-Even Point
[💬 Join discussion](https://github.com/hoop71/alexANTria/discussions/4)

**Problem:** At what agent count does context infrastructure overhead pay off vs prompt repetition?

**Current thinking:** Qualitatively valuable at 5-30 agents. Below 5: overhead may exceed benefit. Above 30: additional governance needed.

**Status:** 🔴 Unknown

---

### Challenge 4: Governance Model
[💬 Join discussion](https://github.com/hoop71/alexANTria/discussions/5)

**Problem:** Who owns Layer 1 truth? How are conflicts resolved?

**Current thinking:**
- Solo dev: You own it
- Small team: Architect owns Layer 1, team owns Layers 2-4
- Large org: Federated model

**Status:** 🔶 Exploring

---

### Challenge 5: Cold Start / Bootstrap
[💬 Join discussion](https://github.com/hoop71/alexANTria/discussions/6)

**Problem:** New project, empty alexANTria. How do you prime it without creating garbage?

**Current approach:** `/ant-init` scaffolds the three-pool structure. Start with the Intentional pool (humans write strategy — four paragraphs is enough). Agents help maintain Programmatic and Tokenized pools from there. Local-only mode lets you test privately before team adoption.

**Remaining question:** Can agents help draft the Intentional pool through interviews? What's minimum viable context for each pool?

**Status:** 🔶 Exploring

---

**Status Legend:**
- 🟢 Validated: Tested at scale, high confidence
- 🔶 Exploring: Early findings, evolving understanding
- 🔴 Unknown: Open question, need more data

---

## Changelog

### Version 0.2.0 (2026-02-11)
**Three-pool alignment and practical adoption**

**What changed:**
- Aligned all terminology with RLM three-pool architecture (Programmatic / Tokenized / Intentional)
- Emphasized the Intentional pool as the irreducible core — human feedback that agents cannot infer
- Updated Challenge 5 (Cold Start) from 🔴 Unknown to 🔶 Exploring — `/ant-init` scaffolds three-pool structure, local-only mode enables private testing
- Added cross-link to [Three Pools or Nothing](/blog/three-pools-or-nothing) for the practical adoption guide

**Status of challenges:**
- 🔶 Exploring: Challenges 1, 2, 4, 5
- 🔴 Unknown: Challenge 3

---

### Version 0.1.0 (2026-01-20)
**Initial position paper**

**What we shared:**
- Work memory ≠ context memory as core insight
- Three kinds of chaos: acceptable, catastrophic, user experience drift
- Intentional pool prevents UX chaos (agents building incoherent products)
- 5 known challenges, actively exploring

**Status of challenges:**
- 🔶 Exploring: Challenges 1, 2, 4
- 🔴 Unknown: Challenges 3, 5

---

_This changelog tracks how our understanding evolves. The blog post itself is living memory—it follows the read-act-repair loop we advocate._

---

## Call to Action

**Try alexANTria:**
- [GitHub repo](https://github.com/hoop71/alexANTria)
- Works with Claude Code, Cursor, Windsurf
- 5-minute setup: `/ant-init` scaffolds your project

**Read next:**
- [Three Pools or Nothing](/blog/three-pools-or-nothing) — Why three pools is the minimum viable shape, and how to adopt it

**Explore the stack:**
- [Gas Town](https://steve-yegge.medium.com/welcome-to-gas-town-4f25ee16dd04) - Orchestration (Steve Yegge)
- [Beads](https://steve-yegge.medium.com/introducing-beads-a-coding-agent-memory-system-637d7d92514a) - Work memory (Steve Yegge)
- [alexANTria](https://github.com/hoop71/alexANTria) - Context memory

**Join the conversation:**
- What context problems are you hitting?
- How are you managing institutional memory?
- Have you captured your Intentional pool yet?

---

**The future is coordinated chaos. Make sure it has guardrails.**

*Agents leave trails. Trails fade. Trails get reinforced.*

*That's how colonies scale intelligence.*
