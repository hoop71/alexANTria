# Challenge 5: Cold Start / Bootstrap

**From the blog post:** [Guardrails for Gas Town - Challenge 5](https://github.com/hoop71/alexANTria/blob/main/BLOG-gastown-context-infrastructure.md#challenge-5-cold-start--bootstrap)

## The Problem

New project, empty alexANTria. How do you prime it without creating garbage context?

**The bootstrap paradox:**
- You need good context to have agents work well
- But you need agents to work to create context
- Chicken and egg problem

**What can go wrong:**
- Agent creates Layer 1 philosophy that doesn't reflect your actual intent
- Agent infers wrong constraints from existing code
- Agent creates verbose, unhelpful context (too generic)
- Agent creates overly specific context (doesn't generalize)

## Current Exploration (v0.1.0)

- `/ant-init` scaffolds structure based on discovered docs
- Convention-based layering (agents understand it without config)
- Humans write Layer 1, agents draft Layer 2-4 from code

**The approach:**
1. Run `/ant-init` in your project
2. Agent crawls existing docs, discovers structure
3. Agent proposes mapping (what docs go in which layer)
4. Human reviews and approves
5. Agent generates `CLAUDE.md` and `.claude/rules/`
6. Human writes/edits Layer 1 philosophy
7. Agents help draft Layer 2-4 based on code

## Open Questions

1. Can agents bootstrap Layer 1 from interviews with humans?
2. What's minimum viable context for a new project?
3. Should we provide "starter philosophies" for common use cases (web app, CLI tool, library)?
4. How do you validate initial context is useful (not just verbose)?
5. What if the existing code doesn't reflect best practices (legacy codebase)?
6. How do you handle greenfield (no existing docs or code)?
7. Should cold start be iterative (start minimal, grow over time)?

## Share Your Experience

- How do you bootstrap documentation for new projects?
- Have you tried agent-assisted doc generation?
- What makes context "good" vs "verbose but useless"?
- How do you onboard new team members (humans or agents)?

Please share your learnings—help us figure this out together.

---

**Status:** 🔴 Unknown (as of 2026-01-20)
