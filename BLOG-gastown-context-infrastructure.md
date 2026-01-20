# Guardrails for Gas Town: Why Orchestration Needs Context Infrastructure

**Or: How to Run 30 Agents Without Burning Down Production**

---

**Version:** 0.1.0 (January 20, 2026)
**Status:** Early exploration - sharing what we've learned so far
**Last Updated:** 2026-01-20
**Discussions:** [GitHub Issues](https://github.com/hoop71/alexANTria/issues) | [Changelog](#changelog)

---

**What this is:**

A living document exploring how context infrastructure complements agent orchestration. We're sharing early findings from running 1-10 agents and extrapolating to larger swarms. This document will evolve as we learn more.

**What this isn't:**

A complete solution or production-ready system. We're at the "line in the sand" phase—documenting our current thinking so we (and you) can refine it.

**Help us evolve this:** We've identified several [open challenges](#known-challenges) where we need input. [Open an issue](https://github.com/hoop71/alexANTria/issues/new) if you're hitting similar problems or have ideas.

---

## The Chaos Paradox

Steve Yegge's [Gas Town](https://steve-yegge.medium.com/welcome-to-gas-town-4f25ee16dd04) is incredible. It's also terrifying.

In his New Year's Day 2026 post, Steve describes orchestrating 20-30 Claude Code instances simultaneously—what he calls "Stage 8" development. It's agent swarms, merge queue refineries, ephemeral workers called polecats, and throughput that would make most engineering teams weep with envy.

It's also chaos by design:

> "Work in Gas Town can be chaotic and sloppy... Some bugs get fixed 2 or 3 times, and someone has to pick the winner. Other fixes get lost. Designs go missing and need to be redone. **It doesn't matter, because you are churning forward relentlessly** on huge, huge piles of work."

This is the future of development: swarms of superintelligent agents coordinated by orchestration layers, moving at "creation and correction at the speed of thought."

**But here's the thing nobody's talking about:**

Even Steve—who literally invented this workflow and has been vibe coding for months—ran headfirst into every single context management problem that distributed agent systems create.

Plan dementia. 605 inscrutable markdown files. "Death by a thousand re-explanations." Becoming the bottleneck context oracle for 30 agents.

**The paradox:** Gas Town proved you can orchestrate chaos and still ship. But it also proved that **orchestration without context infrastructure just moves the bottleneck from work coordination to knowledge coordination.**

This post is about why context infrastructure matters—not instead of orchestration, but *beneath* it.

---

## The Context Problems Gas Town Exposed

Before Gas Town, Steve tried building his orchestrator on markdown plans. Agents would create plans, nest them, track them... and gradually lose their minds.

### Problem 1: Plan Dementia (605 Markdown Files)

From his [Beads article](https://steve-yegge.medium.com/introducing-beads-a-coding-agent-memory-system-637d7d92514a):

> "By the start of phase 3 (out of 6), the AI has mostly forgotten where it came from... When the agent arrives at phase 3 (out of 5) of phase 3 (out of 6), it has gone full-blown bugshit amnesiac, and it announces triumphantly: 'Congratulations, the system is DONE! 🎉'"

> "By the time I finally found a solution... I discovered I had **six hundred and five markdown plan files** in varying stages of decay in my plans/ folder."

**What went wrong:**

Agents don't have persistent memory across session compactions. Every 10 minutes, they restart. They read whatever plan file they find, declare "Oh wow, this is a big project," create 5 more nested plans, and gradually forget the outer context.

This is agent amnesia about work structure. And Steve solved it brilliantly with Beads—a git-backed issue tracker that gives agents persistent work memory.

**But here's what Beads *doesn't* solve:**

Beads tracks *what* work exists. It doesn't track *how* you do the work, or *why* you're structured this way, or *what architectural constraints* matter.

That's context memory. And without it, you're still the oracle.

### Problem 2: Death by a Thousand Re-explanations

From the Gas Town article:

> "Every new session starts from zero context. You repeat the same architectural explanations weekly. 'Why did we structure it this way?' gets asked over and over."

**The bottleneck:** Even with perfect orchestration (Gas Town) and perfect work tracking (Beads), Steve became the context oracle for 20-30 agents.

Think about what this means:

- Polecat 3 asks: "How do we handle auth in this codebase?"
- Polecat 7 asks: "What's our testing strategy?"
- Polecat 12 asks: "Why is the database structured this way?"
- The Refinery asks: "Which of these two conflicting implementations should I pick?"

They're all asking *you* because the context lives in your head. Beads tells them *what* to work on. But you have to tell them *how*.

**At 30 agents, this doesn't scale.**

### Problem 3: You Can't Leave

The most damning quote from the article:

> "You become the bottleneck: the single source of truth living in your head. Context becomes tribal knowledge—when you leave, it leaves with you."

Gas Town can swarm 30 agents. It can run all night processing convoys. But if Steve takes a vacation, or gets hit by a bus, or just wants someone else to drive for a while...

**The system doesn't know how to work without him.**

That's not a tooling problem. That's a knowledge problem.

---

## The Three-Layer Stack

Gas Town revealed what a mature agent system actually needs. It's not just orchestration. It's a stack:

| Layer | System | What It Does | What It Remembers |
|-------|--------|--------------|-------------------|
| **Execution** | Claude Code, Amp, etc. | Runs commands, writes code | Current session only (ephemeral) |
| **Work Memory** | Beads | Tracks tasks, dependencies, status | "What needs doing? What's blocked?" |
| **Orchestration** | Gas Town | Coordinates swarms, merge queues | "Who's working on what? How do we coordinate?" |
| **Context Memory** | **alexANTria** | **Curates institutional knowledge** | **"How do we work? Why? What are our constraints?"** |

**The key insight:** Work memory ≠ context memory.

- **Beads** answers: "What's the next task in the dependency graph?"
- **alexANTria** answers: "How should we approach it? What constraints matter? Why did we decide to do it this way?"

Both are external memory for agents. Both are necessary. But they solve fundamentally different problems.

**Think of it this way:**

When you onboard a new human engineer, you give them:
1. **A task** (Jira ticket, GitHub issue) ← Beads equivalent
2. **The architecture docs** (how we work, our conventions, why we made past decisions) ← alexANTria equivalent

Gas Town is the manager assigning work. Beads is the ticket system. alexANTria is the institutional knowledge that makes new engineers productive without asking you a thousand questions.

You need all of them.

---

## Two Kinds of Chaos

Here's what Gas Town taught us: **Not all chaos is created equal.**

### Acceptable Chaos (Gas Town's Feature, Not Bug)

From Steve's article:

> "Some bugs get fixed 2 or 3 times, and someone has to pick the winner. Other fixes get lost. Designs go missing and need to be redone. **It doesn't matter.**"

This chaos is fine:
- **Redundant work** — Two polecats fix the same bug (inefficient, but harmless)
- **Lost designs** — A design doc disappears and gets redone (annoying, but forward progress)
- **Fish fall out of the barrel** — Some work is lost (more will come)

**Why it works:**

High velocity + self-correction means you can tolerate waste. If you're moving 10x faster than traditional development, losing 20% of work to chaos still leaves you 8x faster.

### Catastrophic Chaos (What Kills You)

But there's another kind of chaos that Gas Town can't tolerate:

- Agent commits `.env` files with production secrets
- Agent force-pushes to `main` and destroys 2 weeks of history
- Agent drops the production database table
- Agent implements auth with sessions (Polecat 1), JWT (Polecat 5), and API keys (Polecat 12)

**Why this kills you:**

Speed becomes destruction. The cleanup takes longer than the original work. Contradictory implementations mean the Refinery has to pick winners, which means rework, which defeats the velocity advantage.

**The line between them is context infrastructure.**

Acceptable chaos happens *above* the guardrails. Catastrophic chaos happens when there are no guardrails.

---

## Part 4: What Context Infrastructure Gets You (Even in Chaos)

### 1. Faster (Sustained Velocity)

**Without context:**
- Polecat 1 implements auth with sessions
- Polecat 5 implements auth with JWT
- Refinery has to pick a winner, rework one
- Happens again next week

**With context:**
- `ANT-FRAMEWORK.md`: "We use JWT for auth, not sessions. See ADR-007."
- All 20 polecats implement it correctly the first time
- No winner-picking, no refactoring

**Net:** Chaos is fast until it creates contradictions.

### 2. Cheaper (Context Efficiency)

**Without context:**
- 20 polecats × 5,000 tokens of architectural context per prompt
- = 100,000 tokens of redundant context per convoy
- Every session, every polecat, same bloat

**With context:**
- 20 polecats × pointer to shared living memory
- Agents read `CLAUDE.md`, load relevant rules
- Context is infrastructure, not payload

**Net:** You're already burning cash on Gas Town. Why burn more on redundant prompts?

### 3. Guardrails (Layer 1 Philosophy)

**Gas Town assumes YOU are the safety system.**

From the article:
> "They'll rip your face off if you aren't already an experienced chimp-wrangler."

But when you're swarming 20 agents, you can't babysit them all.

**Layer 1 constraints reduce the likelihood of catastrophic chaos:**
- "Never force-push to main/master"
- "Never skip hooks (--no-verify)"
- "Never commit secrets (.env, credentials.json)"
- "Read-act-repair loop is sacred"

These aren't "conventions." They're **safety constraints that scale when you can't.** They won't eliminate all mistakes—agents can still ignore or misinterpret them—but they raise the bar significantly. See [Challenge 2](#challenge-2-agent-maintenance-discipline) for how we're working on enforcement.

### 4. Smarter (Collective Learning)

**Gas Town model:**
- Polecats are ephemeral (sessions die, work persists in Beads)
- Each session starts fresh from prompting + Beads
- No polecat makes future polecats smarter

**alexANTria model:**
- Polecats can maintain trails as they work (with prompting and enforcement)
- Polecat 5 discovers: "The login API changed, new endpoint is /v2/auth"
- Updates `ANT-EXTERNAL.md` with the new endpoint
- Polecats 6-20 inherit the improved context

**Net:** The swarm can learn collectively, not just individually. This requires discipline—agents under pressure will skip trail maintenance. See [Challenge 2](#challenge-2-agent-maintenance-discipline) for how we're addressing this.

### 5. Multi-Stakeholder (Beyond Dev Workflow)

**From Steve's own pain:**
> "Execs don't know what was built, when. Product isn't able to influence. The vision goes beyond code but code is the first step."

**Gas Town/Beads focus on dev workflow:**
- Convoys, MRs, merge queues
- Devs and agents understand it
- Execs/product are blind to the "why"

**alexANTria's 5-layer anthill structure allows multi-stakeholder visibility:**
- Layer 1: Philosophy (readable by execs)
- Layer 2: Product/Business (product managers can contribute)
- Layer 3: Architecture (tech leads)
- Layer 4: Implementation (developers)
- Layer 5: Code (agents)

**The structure doesn't guarantee cross-functional engagement**—most orgs won't have execs reading `ANT-FRAMEWORK.md`. But it doesn't prevent it either. For teams that do cross-functional context work, the layered structure provides a natural home for different stakeholder perspectives.

---

## Part 5: The Integration (How They Work Together)

**When a polecat in Gas Town claims a convoy:**

1. **Reads Beads:** "What's my task?"
   - `bd-a7f3`: "Implement login form"
   - Dependencies: blocked by `bd-x99` (auth service ready)
   - Status: ready

2. **Reads alexANTria:** "How do we do this?"
   - Loads `.claude/rules/frontend.md` (path-specific context)
   - Reads `ANT-FRAMEWORK.md`: "Use JWT, follow accessibility guidelines"
   - Reads `ANT-SCHEMA.md`: "Login is Layer 4 implementation, constrained by Layer 2 product spec"

3. **Executes** using both memories:
   - Implements login form with JWT
   - Follows accessibility guidelines from Layer 2
   - Doesn't contradict other polecats

4. **Repairs trails:**
   - Updates `frontend/README.md` if login form pattern is new
   - Signals to Witness: work complete, trails maintained

**Without alexANTria:**
- Polecat knows WHAT to do (Beads)
- Doesn't know HOW you do it (tribal knowledge)
- You become the context oracle for 20 polecats simultaneously

**With alexANTria:**
- Polecat has both work memory and context memory
- Scales to swarms without scaling your explanations

---

## Part 6: The Ramp (Adoption Spectrum)

One reason alexANTria matters: **not everyone will run Gas Town.**

Gas Town is Stage 8:
- Expensive (multiple Claude accounts)
- Chaotic (vibe coding at scale)
- High-risk ("chimp wranglers only")
- Complex (tmux, Beads, wisps, patrols, Refinery)

Most developers are at Stage 4-6:
- 1-5 concurrent Claude sessions
- Hand-managing agents
- Not ready for orchestration

**But they still feel context pain:**
- "I just explained this yesterday..."
- "Let me copy that 5,000-token context into this new session..."
- "My teammate's agent did it differently than mine..."

**alexANTria provides the on-ramp:**

| Stage | Setup | What alexANTria Provides |
|-------|-------|--------------------------|
| **Stage 4-5** | 1-2 Claude sessions, hand-managed | Persistent context across sessions, no repetition |
| **Stage 6-7** | 3-10 concurrent agents | Shared context across agents, reduced prompt bloat |
| **Stage 8** | Gas Town orchestration, 20-30 agents | Context infrastructure beneath orchestration, guardrails at scale |

**You don't need Gas Town to need alexANTria.**

But when you're ready for Gas Town, alexANTria slots right in as the knowledge layer.

---

## Part 7: What If Beads Added Context?

**The risk:** "Why not just use Beads for context too?"

You could:
- File "knowledge issues" in Beads (`bd-arch-101`: "We use JWT")
- Use pinned beads (like Role Beads) that never close
- Query them: `bd list --label=knowledge`

**Why this doesn't work:**

### Different data models, different purposes

**Beads' model:**
- Work graph: tasks → subtasks → dependencies
- Lifecycle: created → in_progress → done → closed
- Query: "What work is ready?"

**alexANTria's model:**
- Knowledge hierarchy: layers with override semantics
- Lifecycle: created → evolved → maintained (never "closed")
- Query: "What are our principles? How do we do X?"

**The conflict:**
- Beads asks: "Is it done?"
- alexANTria asks: "Is it true/current?"

### The override/layering semantics

alexANTria's power is **epistemological precedence:**

```
Layer 1 (Philosophy)   → OVERRIDES ↓
Layer 2 (Product)      → OVERRIDES ↓
Layer 3 (Architecture) → OVERRIDES ↓
Layer 4 (Implementation)
```

Beads has dependencies (blocking, parent/child), but not **"this belief constrains that decision."**

You'd have to rebuild alexANTria inside Beads, serving two masters:
- Work orchestration (Gas Town's needs)
- Knowledge management (context needs)

### Human readability

**Beads format (JSONL):**
```json
{"id":"bd-a1b2c","title":"Use JWT","status":"pinned"}
```
- Machine-first, agent/dev focused

**alexANTria format (Markdown):**
```markdown
# Authentication Philosophy

We use JWT because sessions don't scale horizontally.
See ADR-007 for the decision record.
```
- Human-first, accessible to execs/product/teams

**Our stance: Clean separation is better engineering than conflating concerns.**

Could Beads add knowledge issues? Yes, technically. It would be awkward (mixing "is it done?" with "is it true?"), but possible. We think separating work tracking from knowledge management makes both systems easier to evolve independently. But we're open to being wrong—this is early thinking.

---

## Part 8: The Future (Complementary Evolution)

**Gas Town + Beads will evolve:**
- Better orchestration (remote workers, federation)
- Richer workflows (formulas, Mol Mall)
- Improved GUPP and nudging

**alexANTria will evolve:**
- Multi-repo federation ("your colony can collaborate with neighboring colonies")
- Better maintenance loops (trails that auto-fade if not reinforced)
- Cross-stakeholder visibility (Layer 2 for product, Layer 1 for execs)

**They solve different problems, evolve on different axes:**
- Gas Town: How do we coordinate 100 agents across multiple repos?
- alexANTria: How do we maintain institutional memory across teams and time?

**The vision:**

```
              Gas Town (orchestration)
                       ↑
                  coordinates
                       ↑
      ┌────────────────┴────────────────┐
      │                                  │
   Beads (work)                 alexANTria (context)
      │                                  │
   "What to do"                    "How to do it"
      │                                  │
      └────────────────┬────────────────┘
                       ↓
                  Claude Code
                  (execution)
```

**Each layer makes the others more powerful.**

---

## Known Challenges

We're actively working on these problems. Each challenge has an open discussion—please share your experiences.

### Challenge 1: Context Conflicts at Agent Speed
[💬 Join the discussion](https://github.com/hoop71/alexANTria/discussions/1)

**The problem:** When 20 agents update context in parallel, merge conflicts happen in `ANT-*.md` files. Who arbitrates truth when two agents assert contradictory principles?

**Current exploration:**
- Manifest-based discovery (orchestrators query which layers apply)
- Human arbitration for Layer 1 philosophy
- Automated merge for Layer 2-4 with conflict detection

**Status:** 🔶 Exploring (as of 2026-01-20)

**Open questions:**
- What's the conflict rate in practice at 10 agents? 30 agents?
- Can we detect philosophical drift automatically?
- Should Layer 1 changes require explicit approval?

---

### Challenge 2: Agent Maintenance Discipline
[💬 Join the discussion](https://github.com/hoop71/alexANTria/discussions/2)

**The problem:** Agents skip trail maintenance when under context pressure. From Steve's own article: agents disavow work and cut corners when nearing compaction limits.

**Current exploration:**
- Pattern promotion at merge-to-main (when work lands, trigger context update)
- Post-merge checks create context-update tasks
- **Known limitation:** At swarm velocity (20+ agents), patterns emerge faster than they merge

**Status:** 🔶 Exploring (as of 2026-01-20)

**Open questions:**
- What's the minimum enforcement mechanism that works?
- How do we measure "context adherence rate"?
- Should trail maintenance be a separate agent role (like Gas Town's Witness)?
- What happens when an agent updates context incorrectly?

---

### Challenge 3: Economic Break-Even Point
[💬 Join the discussion](https://github.com/hoop71/alexANTria/discussions/3)

**The problem:** At what agent count does context infrastructure overhead pay off vs just repeating context in prompts?

**Current thinking:**
- Qualitatively valuable at 5-30 agents based on early usage
- Below 5 agents: setup/maintenance overhead may exceed benefit
- Above 30 agents: additional governance mechanisms needed
- No hard ROI data yet—this is early

**Status:** 🔴 Unknown (as of 2026-01-20)

**Open questions:**
- What's the daily maintenance time per agent?
- At what scale does context conflict overhead exceed prompt replication cost?
- Are there early indicators of when a team needs this?
- How do we measure value (time saved, errors prevented)?

---

### Challenge 4: Governance Model
[💬 Join the discussion](https://github.com/hoop71/alexANTria/discussions/4)

**The problem:** Who owns Layer 1 truth? How are conflicts resolved? How do you prevent Layer 1 from becoming a political document?

**Current thinking:**
- **Solo dev:** You own it, agents propose changes
- **Small team:** Architect owns Layer 1, team owns Layer 2-4
- **Large org:** Federated model (teams own their colonies, shared Layer 1)
- Conflicts require human arbitration (no automated resolution for philosophy)

**Status:** 🔶 Exploring (as of 2026-01-20)

**Open questions:**
- How do you prevent political capture of Layer 1 in orgs?
- What's the approval process for philosophy changes?
- Do we need "context CODEOWNERS"?
- How does this work across repos/teams?

---

### Challenge 5: Cold Start / Bootstrap
[💬 Join the discussion](https://github.com/hoop71/alexANTria/discussions/5)

**The problem:** New project, empty alexANTria. How do you prime it without creating garbage context?

**Current exploration:**
- `/ant-init` scaffolds structure based on discovered docs
- Convention-based layering (agents understand it without config)
- Humans write Layer 1, agents draft Layer 2-4 from code

**Status:** 🔴 Unknown (as of 2026-01-20)

**Open questions:**
- Can agents bootstrap Layer 1 from interviews with humans?
- What's minimum viable context for a new project?
- Should we provide "starter philosophies" for common use cases?
- How do you validate initial context is useful?

---

**Status Legend:**
- 🟢 **Validated:** Tested at scale, high confidence
- 🔶 **Exploring:** Early findings, evolving understanding
- 🔴 **Unknown:** Open question, need more data

**Help us figure this out:** These aren't blockers—they're research directions. If you're experimenting with context infrastructure, please share what you're learning in the discussions.

---

## Closing: Guardrails That Scale

Steve Yegge proved you can run 30 agents in chaos and still ship.

But even Steve ran into every context problem:
- Plan dementia
- Re-explanations
- Tribal knowledge
- Bottleneck as context oracle

**alexANTria doesn't slow Gas Town down. It makes Gas Town sustainable.**

Context infrastructure isn't about writing artisanal code.
It's about not letting chaos become catastrophic.

**Guardrails that scale from 1 agent to 100.**

Whether you're hand-managing Claude Code today, or orchestrating swarms with Gas Town tomorrow, you need somewhere persistent for institutional memory to live.

Agents leave trails.
Trails fade.
Trails get reinforced.

That's how colonies scale intelligence.

---

## Changelog

### Version 0.1.0 (2026-01-20)
**Initial position paper**

**What we're sharing:**
- Framed context infrastructure as complementary to orchestration (Gas Town/Beads)
- Introduced "acceptable vs catastrophic chaos" distinction
- Identified work memory ≠ context memory as core insight
- Documented 5 known challenges we're actively exploring
- Technical hints: manifest-based discovery, merge-to-main pattern promotion

**What we learned since last version:** N/A (initial version)

**What changed in our thinking:** N/A (initial version)

**Status of challenges:**
- 🔶 Exploring: Challenges 1, 2, 4
- 🔴 Unknown: Challenges 3, 5

---

_This changelog tracks how our understanding evolves. Each version documents what we learned and what changed in our thinking. The blog post itself is living memory—it follows the read-act-repair loop we advocate._

---

## Call to Action

**Try alexANTria:**
- [GitHub repo](https://github.com/hoop71/alexANTria)
- Works with Claude Code, Cursor, Windsurf, any markdown-reading agent
- 5-minute setup: `/ant-init` scaffolds your project

**Explore the stack:**
- [Gas Town](https://steve-yegge.medium.com/welcome-to-gas-town-4f25ee16dd04) - Agent orchestration at scale (Steve Yegge)
- [Beads](https://steve-yegge.medium.com/introducing-beads-a-coding-agent-memory-system-637d7d92514a) - Work memory for coding agents (Steve Yegge)
- [alexANTria](https://github.com/hoop71/alexANTria) - Context memory for your codebase

**Join the conversation:**
- What context problems are you hitting at your stage of agent adoption?
- How are you currently managing institutional memory?
- Are you ready for Stage 8, or building the foundation first?

---

**The future is coordinated chaos. Make sure it has guardrails.**

*Agents leave trails. Trails fade. Trails get reinforced.*

*That's how colonies scale intelligence.*
