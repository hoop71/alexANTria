# Guardrails for Gas Town: Why Orchestration Needs Context Infrastructure

**Or: How to Run 30 Agents Without Burning Down Production**

---

**Version:** 0.1.0 (January 20, 2026)
**Status:** Early exploration - sharing what we've learned so far
**Last Updated:** 2026-01-20
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

| Layer | System | What It Remembers |
|-------|--------|-------------------|
| **Orchestration** | Gas Town | "Who's working on what? How do we coordinate?" |
| **Work Memory** | Beads | "What needs doing? What's blocked?" |
| **Context Memory** | alexANTria | **"How do we work? Why? What are our constraints?"** |

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

**Layer 1 prevents catastrophic technical chaos.** (Never force-push, never commit secrets)
**Layer 2 prevents user experience chaos.** (Who is this for? What problem does it solve? How should it feel?)

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

alexANTria's 5-layer structure enables product steering:
- Layer 1: Philosophy (execs)
- Layer 2: Product/Business (product managers)
- Layer 3: Architecture (tech leads)
- Layers 4-5: Implementation (developers, agents)

### How They Work Together

When a polecat claims a convoy in Gas Town:

1. **Reads Beads:** "What's my task?" → `bd-a7f3: Implement login form`
2. **Reads alexANTria:** "How do we do this?" → Loads `.claude/rules/frontend.md`, reads Layer 1 philosophy, Layer 2 product spec
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

Not everyone will run Gas Town. Most developers are at Stage 4-6 (1-5 concurrent sessions, hand-managed). But they still feel context pain.

**alexANTria provides the on-ramp:**

| Stage | Setup | What alexANTria Provides |
|-------|-------|--------------------------|
| **Stage 4-5** | 1-2 Claude sessions | Persistent context across sessions |
| **Stage 6-7** | 3-10 concurrent agents | Shared context, reduced prompt bloat |
| **Stage 8** | Gas Town orchestration | Context infrastructure beneath orchestration |

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

**Exploring:** `/ant-init` scaffolds from discovered docs. Convention-based layering. Humans write Layer 1, agents draft Layers 2-4.

**Open question:** Can agents bootstrap Layer 1 from interviews? What's minimum viable context? How do you bootstrap Layer 2 for user-facing products (personas, UX principles)?

**Status:** 🔴 Unknown

---

**Status Legend:**
- 🟢 Validated: Tested at scale, high confidence
- 🔶 Exploring: Early findings, evolving understanding
- 🔴 Unknown: Open question, need more data

---

## Changelog

### Version 0.1.0 (2026-01-20)
**Initial position paper**

**What we're sharing:**
- Work memory ≠ context memory as core insight
- Three kinds of chaos: acceptable, catastrophic, user experience drift
- Layer 2 prevents UX chaos (agents building incoherent products)
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

**Explore the stack:**
- [Gas Town](https://steve-yegge.medium.com/welcome-to-gas-town-4f25ee16dd04) - Orchestration (Steve Yegge)
- [Beads](https://steve-yegge.medium.com/introducing-beads-a-coding-agent-memory-system-637d7d92514a) - Work memory (Steve Yegge)
- [alexANTria](https://github.com/hoop71/alexANTria) - Context memory

**Join the conversation:**
- What context problems are you hitting?
- How are you managing institutional memory?
- Ready for Stage 8, or building the foundation first?

---

**The future is coordinated chaos. Make sure it has guardrails.**

*Agents leave trails. Trails fade. Trails get reinforced.*

*That's how colonies scale intelligence.*
