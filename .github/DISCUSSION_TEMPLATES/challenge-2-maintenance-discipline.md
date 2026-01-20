# Challenge 2: Agent Maintenance Discipline

**From the blog post:** [Guardrails for Gas Town - Challenge 2](https://github.com/hoop71/alexANTria/blob/main/BLOG-gastown-context-infrastructure.md#challenge-2-agent-maintenance-discipline)

## The Problem

Agents skip trail maintenance when under context pressure. From Steve Yegge's Gas Town article: agents disavow work and cut corners when nearing compaction limits.

**What happens:**
- Agent implements a feature
- Discovers a new pattern during implementation
- Should update `ANT-FRAMEWORK.md` with the pattern
- But agent is at 90% context limit
- Skips the doc update, marks task complete

**Result:** Next agent doesn't know about the pattern, implements it differently.

## Current Exploration (v0.1.0)

- Pattern promotion at merge-to-main (when work lands, trigger context update)
- Post-merge checks create context-update tasks
- **Known limitation:** At swarm velocity (20+ agents), patterns emerge faster than they merge

## Open Questions

1. What's the minimum enforcement mechanism that works?
2. How do we measure "context adherence rate"?
3. Should trail maintenance be a separate agent role (like Gas Town's Witness)?
4. What happens when an agent updates context incorrectly?
5. How do we handle "proposed patterns" vs "approved patterns"?
6. Can we detect when context is stale automatically?

## Share Your Experience

- How do you enforce doc maintenance with agents?
- What prompting strategies work?
- Have you tried merge gates or CI checks?
- What's your experience with agents updating docs incorrectly?

Please share your learnings—help us figure this out together.

---

**Status:** 🔶 Exploring (as of 2026-01-20)
