# Challenge 1: Context Conflicts at Agent Speed

**From the blog post:** [Guardrails for GasTown - Challenge 1](https://github.com/hoop71/alexANTria/blob/main/BLOG-gastown-context-infrastructure.md#challenge-1-context-conflicts-at-agent-speed)

## The Problem

When 20 agents update context in parallel, merge conflicts happen in `ANT-*.md` files. Who arbitrates truth when two agents assert contradictory principles?

**Example scenario:**
- Polecat 5 updates `ANT-FRAMEWORK.md`: "Use JWT for auth"
- Polecat 12 (parallel) updates it: "Use sessions for auth (JWT doesn't work with our SSO)"
- Both changes land in different branches
- Refinery has to merge them—but these are contradictory beliefs, not just code

## Current Exploration (v0.1.0)

- Manifest-based discovery (orchestrators query which layers apply)
- Human arbitration for Layer 1 philosophy
- Automated merge for Layer 2-4 with conflict detection

## Open Questions

1. What's the conflict rate in practice at 10 agents? 30 agents?
2. Can we detect philosophical drift automatically?
3. Should Layer 1 changes require explicit approval?
4. What about cross-repo conflicts (federated colonies)?
5. How do we version context changes vs code changes?

## Share Your Experience

- Are you running multiple agents that update shared docs?
- What conflict patterns have you seen?
- What resolution mechanisms work for you?
- Have you tried automated drift detection?

Please share your learnings—help us figure this out together.

---

**Status:** 🔶 Exploring (as of 2026-01-20)
