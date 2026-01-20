# Challenge 3: Economic Break-Even Point

**From the blog post:** [Guardrails for Gas Town - Challenge 3](https://github.com/hoop71/alexANTria/blob/main/BLOG-gastown-context-infrastructure.md#challenge-3-economic-break-even-point)

## The Problem

At what agent count does context infrastructure overhead pay off vs just repeating context in prompts?

**The trade-off:**

**Prompt replication cost:**
- 20 agents × 5,000 tokens per prompt × $X per token
- Static cost per run
- Grows linearly with agent count

**Context infrastructure cost:**
- Initial setup (human time to create ANT-*.md files)
- Maintenance burden (human reviews of agent context updates)
- Merge conflict resolution (human arbitration)
- Staleness debugging ("why did agent do X? Oh, context was wrong")
- False confidence cost (agents following outdated context confidently)

## Current Thinking (v0.1.0)

- Qualitatively valuable at 5-30 agents based on early usage
- Below 5 agents: setup/maintenance overhead may exceed benefit
- Above 30 agents: additional governance mechanisms needed
- **No hard ROI data yet—this is early**

## Open Questions

1. What's the daily maintenance time per agent?
2. At what scale does context conflict overhead exceed prompt replication cost?
3. Are there early indicators of when a team needs this?
4. How do we measure value (time saved, errors prevented)?
5. What's the cost of a "false confidence" mistake (agent follows wrong context)?
6. Does the break-even point change with model quality (Opus vs Sonnet vs Haiku)?

## Share Your Experience

- How many agents are you running?
- How much time do you spend maintaining context vs re-explaining in prompts?
- Have you tracked ROI on documentation infrastructure?
- What metrics would help you decide if this is worth it?

Please share your learnings—help us figure this out together.

---

**Status:** 🔴 Unknown (as of 2026-01-20)
