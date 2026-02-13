---
title: "Three Pools or Nothing: Why Context Infrastructure Has a Minimum Viable Shape"
description: "Context infrastructure isn't optional complexity you add later. The three-pool architecture — Programmatic, Tokenized, Intentional — is the minimum viable shape. Here's why, and how to adopt it."
---

# Three Pools or Nothing: Why Context Infrastructure Has a Minimum Viable Shape

**Or: The Part Your Agent Can Never Figure Out on Its Own**

---

**Version:** 0.1.0 (February 11, 2026)
**Status:** Practical guide — based on what we've learned building alexANTria
**Last Updated:** 2026-02-11
**Discussions:** [GitHub Issues](https://github.com/hoop71/alexANTria/issues) | [Changelog](#changelog)

---

## The Minimum Viable Shape (30 seconds)

Every team using AI agents eventually invents context infrastructure. They write a `CLAUDE.md`. They add a `.cursor/rules` folder. They create a "project context" doc that tells the agent how things work.

**This is the right instinct.** But most stop too early.

They capture what exists (code structure) and how things work (patterns). They skip the third thing: **why.**

That's the gap. Not optional complexity — a structural hole. Your agent can read your code. Your agent can follow your patterns. **Your agent cannot know why you made the choices you made.**

Three pools. Not two. Not five. Three.

```
Programmatic  →  What exists (your code, agents discover this)
Tokenized     →  How we work (your docs, agents need this written down)
Intentional   →  Why we decided (your strategy, only humans can capture this)
```

If you skip the third pool, you get agents that follow patterns without understanding purpose. They'll implement features that contradict your product direction. They'll optimize for the wrong users. They'll make architectural choices that foreclose strategic options you haven't communicated.

**You don't need all five layers. You do need all three pools.**

*Stop here if you just need the headline. Keep reading for what this means in practice.*

---

## Why Two Pools Aren't Enough (2 minutes)

### The Pattern Everyone Discovers

Here's the typical adoption arc for AI-assisted development:

**Week 1:** "This agent is amazing, it just reads my code and figures things out."

**Week 3:** "Wait, it keeps using the wrong auth pattern. Let me write that down." *(Creates CLAUDE.md)*

**Week 6:** "Okay, it follows the patterns now. But it built a dashboard for admins when our users are developers. And it picked a database schema that makes our planned multi-tenant feature impossible."

**Week 6 is when you need the third pool.** The agent had full access to your code (programmatic) and your documented patterns (tokenized). It just didn't know your product strategy.

### What Each Pool Actually Does

**Programmatic pool** — Your codebase. Git history. Tests. Directory structure.

Agents are good at this. They read code, infer structure, discover patterns. You don't need to document that your API uses REST — the agent can see that. You don't need to list your database tables — the agent can read the schema.

**The trap:** Assuming agents can infer everything from code.

**Tokenized pool** — Your documented patterns, conventions, and the "how."

This is what moves from code into the agent's active attention. Cross-cutting concerns. Naming conventions. Error handling strategy. Authentication flow. The things that *aren't* obvious from reading any single file but matter for consistency.

**The trap:** Assuming patterns are self-documenting. They're not — that's why every team eventually writes a `CLAUDE.md`.

**Intentional pool** — Your strategy, product direction, and the "why."

This is what **only humans can capture**:
- Who are our users? (Not "everyone" — specifically.)
- What problem are we solving? (Not the technical one — the human one.)
- Why did we choose this architecture? (Not because it's popular — because of specific tradeoffs.)
- What constraints must never be violated? (Not code constraints — business constraints.)

**The trap:** Assuming this will emerge from code and patterns. It won't. Code tells you *what* was built. Patterns tell you *how* to build. Neither tells you *why* — and "why" is what prevents agents from building the wrong thing correctly.

### The Knowledge Spectrum

This isn't arbitrary. It maps to a spectrum:

```
Code-inferable                    →                    Human-required
"What exists"                     →                    "Why we decided"
Agents discover this              →                    Humans must capture this
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Programmatic          Tokenized              Intentional
  (your code)          (your docs)           (your strategy)
```

Lower on the spectrum: agents handle it. Higher: humans must.

The boundary isn't fixed — it shifts as your codebase matures and patterns crystallize. But the intentional pool never becomes inferrable. Your business strategy doesn't exist in your code. Your product vision doesn't emerge from your file structure. Your "why" requires a human to write it down.

*Stop here if you understand the shape. Keep reading for how to adopt it.*

---

## How to Adopt This (5 minutes)

### Start With Why (The Intentional Pool)

Most people start at the bottom — documenting code structure, listing files, mapping APIs. That's backwards.

**Start with the pool that only you can fill.**

Your agents already handle the programmatic pool (reading code). Your `CLAUDE.md` already handles some of the tokenized pool (patterns). But nobody's capturing the intentional pool.

Write down:

1. **Who is this for?** Not "developers" — which developers? What's their context? What are they trying to accomplish?

2. **What problem does this solve?** Not the technical problem. The human problem that caused someone to need this software.

3. **What tradeoffs did we make, and why?** "We chose PostgreSQL over MongoDB because we're planning multi-tenant isolation and relational integrity matters more than schema flexibility for our use case."

4. **What must never change?** "We will never require users to create accounts before trying the product." This is a business constraint, not a code constraint — and it affects every feature an agent builds.

That's your intentional pool. It doesn't need to be long. Four paragraphs might be enough. But without it, your agent is building blind.

### Then Add How (The Tokenized Pool)

Once you've captured why, document how:

- Authentication flow (JWT vs sessions, and the refresh strategy)
- Error handling conventions (how errors surface to users)
- Naming patterns (that aren't obvious from one file)
- Cross-cutting concerns (logging, monitoring, feature flags)

The key question: **"Would an agent reading a single file get this wrong?"** If yes, document it.

This pool changes as your codebase evolves. Patterns emerge, crystallize, and sometimes get replaced. That's fine — document the current state.

### Let Code Speak for Itself (The Programmatic Pool)

Here's the liberating part: **you probably don't need to document much here.**

Your code is your programmatic pool. Your directory structure, your API endpoints, your database schema — agents read these directly. Document only what's not self-evident:

- Non-obvious service boundaries
- Legacy patterns that look wrong but exist for a reason
- Dependencies that aren't in package files

Most teams over-document this pool and under-document the intentional pool. Flip it.

### The Adoption Path

You don't need to do all three pools on day one. But understand where you're headed:

**Day 1: Capture intent.**
Write four paragraphs of "why." Who is this for? What problem? What tradeoffs? What's sacred?

**Week 1: Add patterns.**
As you notice agents making wrong choices, document the pattern they're missing. Each wrong choice reveals a gap in your tokenized pool.

**Ongoing: Let code be code.**
Resist the urge to document what agents can already see. Your energy goes to the pools they can't fill themselves.

### What This Looks Like in Practice

A solo developer working across multiple sessions:

```
Session 1: Agent reads code (programmatic ✓)
           Agent reads CLAUDE.md patterns (tokenized ✓)
           Agent reads product strategy (intentional ✓)
           → Builds feature that fits your product vision

Session 2: New context window, but same three pools
           → Picks up exactly where session 1's understanding was
           → No re-explaining architecture or strategy
```

A team with multiple agents:

```
Agent A (frontend): Reads UI patterns + product vision
                    → Builds interface for the right user persona

Agent B (backend):  Reads API patterns + product constraints
                    → Designs schema that supports planned features

Agent C (tests):    Reads testing conventions + quality principles
                    → Tests what matters, not just what's easy
```

Without the intentional pool, Agent A builds for "generic users," Agent B designs for today's requirements only, and Agent C tests for code coverage rather than product correctness.

---

## Why Human Feedback Is the Irreducible Core

### Agents Can't Infer Strategy

This is the fundamental claim: **no amount of code reading, pattern matching, or context window expansion will give an agent your product strategy.**

Consider:

- **Code says:** "We use JWT tokens with 15-minute expiry and httpOnly refresh cookies."
- **Patterns say:** "Always use the auth middleware. Never expose tokens to client-side JavaScript."
- **Strategy says:** "We chose JWT over sessions because we're planning distributed architecture for enterprise customers who need SSO federation."

The third statement changes how an agent approaches every auth-related task. Without it, the agent might suggest switching to sessions for simplicity. With it, the agent understands that apparent complexity serves a strategic purpose.

**You cannot get there from code.**

### The Interview Problem

Here's what happens when you skip the intentional pool:

An agent encounters a design decision. It has two options:
1. **Infer from code** (might get it right, might not)
2. **Ask the developer** (always gets it right, never scales)

Option 1 leads to silent mistakes. Option 2 makes you the bottleneck — the "context oracle" that every agent needs to consult. Both break at scale.

The intentional pool is option 3: **write it down once, every agent reads it forever.**

This is why human feedback isn't just important — it's the irreducible core of the entire system. Without it, you're choosing between agents that guess and agents that constantly ask. With it, agents have what they need to make correct decisions autonomously.

### Living Documents, Not Artifacts

The intentional pool isn't a document you write once and forget. Strategy evolves. Product direction shifts. Tradeoffs get re-evaluated.

But here's the key: **it changes at human speed, not agent speed.** Your code changes every commit. Your patterns change every few weeks. Your strategy changes every few months.

This means the intentional pool is the most stable part of your context infrastructure — and the highest leverage. A few paragraphs of strategy that stay accurate for months give every agent, every session, every team member the context they need.

When strategy does change, update the intentional pool first. Everything else flows from it. Constraints propagate downward: strategy shapes patterns, patterns shape code.

---

## Common Objections

### "We don't have a strategy yet"

You do. It's just implicit. If you're building software, you've made choices about who it's for, what it does, and how it works. The intentional pool doesn't require a formal strategy document — it requires writing down the decisions you've already made.

Start with: "We're building X for Y because Z." That's your intentional pool.

### "Our patterns aren't established yet"

Then your tokenized pool is thin. That's fine. It'll grow as patterns emerge. The intentional pool matters more early on — it prevents agents from establishing the *wrong* patterns.

### "This is too much documentation"

Three pools doesn't mean three large documents. It means three *types* of context:
- Your code already exists (programmatic — free)
- A CLAUDE.md with patterns (tokenized — you probably have this)
- A few paragraphs of "why" (intentional — this is what's missing)

The total new work is often four paragraphs. The return is every agent understanding your intent.

### "Can't AI just figure it out from enough context?"

No. This is the fundamental insight from [RLM research](https://www.dbreunig.com/2026/02/09/the-potential-of-rlms.html): more context doesn't solve context rot. Bigger windows degrade silently. The solution isn't more tokens — it's better architecture.

Three pools with the right content in each beats one massive context dump every time.

---

## Getting Started

### With alexANTria

```
/ant-init
```

Scaffolds the three-pool structure. You fill in the intentional pool. Agents help maintain the rest.

### Without alexANTria

The three-pool architecture works regardless of tooling:

1. **Programmatic:** Your codebase (already exists)
2. **Tokenized:** A `CLAUDE.md` or equivalent (patterns, conventions)
3. **Intentional:** A `STRATEGY.md` or equivalent (who, what, why, constraints)

The pattern matters more than the tool.

### The Test

After setting up three pools, try this:

> Give an agent a non-trivial task. Don't explain anything verbally. See if it makes the right strategic choices — not just the right technical choices.

If it picks the right auth approach, designs for the right users, and respects your constraints without you intervening — your three pools are working.

If it builds technically correct but strategically wrong — your intentional pool needs work.

---

## Changelog

### Version 0.1.0 (2026-02-11)
**Initial practical guide**

**What we're sharing:**
- Three-pool architecture as the minimum viable shape for context infrastructure
- Human feedback (intentional pool) as the irreducible core
- Practical adoption path starting with "why"

---

_This post follows the pattern it advocates: programmatic (code examples), tokenized (adoption patterns), intentional (why three pools and not two)._

---

## Further Reading

- **[Guardrails for Gas Town](/blog/gastown-context-infrastructure)** — Why multi-agent orchestration needs context infrastructure
- **[RLM Architecture](https://www.dbreunig.com/2026/02/09/the-potential-of-rlms.html)** — The research foundation for three-pool architecture
- **[alexANTria](https://github.com/hoop71/alexANTria)** — Implementation of three-pool context infrastructure
- **[Gas Town](https://steve-yegge.medium.com/welcome-to-gas-town-4f25ee16dd04)** — Proof point at 30-agent scale (Steve Yegge)
