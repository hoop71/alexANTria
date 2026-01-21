# alexANTria - Strategic Alignment

**Layer:** Queen (👑)

## Core Principles

These are the non-negotiable principles that guide all decisions in alexANTria:

### 1. ANT-* Only Principle

**Constraint:** Worker ant ONLY auto-updates files with `ANT-*` naming pattern or files in `.alexantria/`.

**Why:** This makes alexANTria safe, testable, and removable:
- Clear ownership (we only touch files we own)
- Easy to find (glob for ANT-*)
- Easy to remove (delete ANT-* files, system is gone)
- No surprises (never modifies user's existing docs)

**Never violate:** Worker ant must never auto-update README.md or other user docs.

### 2. Read-Act-Repair Pattern

**Constraint:** Agents must read context before acting, then repair if wrong.

**Why:** Prevents agents from guessing or assuming. Forces grounding in actual state.

**Application:**
- Read config before updating docs
- Read manifest before spawning guardians
- Read existing patterns before creating new files
- Check git status before committing

### 3. No Central Brain

**Constraint:** No single coordinator agent that directs all work.

**Why:** Coordination emerges from simple rules, not central control (ant colony model).

**Application:**
- Worker ant is spawned per-commit (stateless)
- Guardians run independently (don't coordinate)
- Commands are autonomous (no master command)

### 4. Minimal, Load-Bearing Docs

**Constraint:** Only document what agents need to make correct decisions.

**Why:** Lower token cost, easier maintenance, more likely to stay in sync.

**Examples:**
- ❌ "Authentication is important for security..."
- ✅ "Use JWT tokens (refresh + access). Refresh in httpOnly cookies."

### 5. Automation Boundary

**Constraint:** Only auto-update docs at or below `starting_level`.

**Why:** Higher layers (strategic, product) require human judgment.

**Never violate:**
- ANT-NEST.md always requires manual updates
- ANT-QUEEN.md always requires manual updates
- Even if starting_level = "chambers", never auto-update nest/queen

### 6. Opt-In Complexity

**Constraint:** Advanced features (guardians, validation) must be opt-in and easily disabled.

**Why:** Avoid forcing complexity on users who don't need it.

**Application:**
- `validation.enabled = false` by default
- Worker ant works without guardians
- System functions with minimal config

### 7. Platform Convention Exceptions

**Constraint:** Specific files follow platform conventions and are maintained manually.

**Exceptions:**
- **CLAUDE.md** - Claude Code expects this at repo root (hierarchy map, always-loaded context)
- **README.md** - GitHub convention for user-facing overview and discovery

**Why:** These files serve critical platform-specific purposes that outweigh pure consistency.

**Enforcement:**
- Worker ant NEVER auto-updates these files
- Changes require manual editing with user approval
- Documented exception to ANT-* only principle
- Guardian validation acknowledges these as special cases

## Architectural Constraints

### No Coexistence

**Constraint:** README.md and ANT-SURFACE.md cannot coexist long-term in same directory.

**Why:** Sync between them is impossible to maintain.

**Application:**
- Hybrid-to-ANT mode is temporary (evaluation phase)
- Must choose: Keep README OR migrate to ANT-SURFACE
- Use `/ant-migrate` to convert

### Starting Level Controls Automation

**Constraint:** `starting_level` field determines automation boundary.

**Options:**
- `surface`: Only ANT-SURFACE.md auto-maintained
- `tunnels`: ANT-SURFACE + ANT-TUNNELS auto-maintained
- `chambers`: ANT-SURFACE + ANT-TUNNELS + ANT-CHAMBERS auto-maintained

**Never:** `starting_level: "queen"` - strategic docs always manual

### Clean Removal Path

**Constraint:** alexANTria must be removable with zero trace.

**Implementation:**
```bash
git rm -r ANT-*.md .alexantria/ .claude/
git rm .git/hooks/pre-commit
git commit -m "Remove alexANTria"
```

**Why:** If system doesn't work for a team, they can cleanly remove it.

## Security Constraints

### Git Safety

**Never:**
- Skip hooks (--no-verify)
- Force push to main/master
- Amend commits (unless user explicitly requests)
- Commit secrets (.env, credentials)

**Always:**
- Create NEW commits
- Stage for user review before committing
- Run pre-commit hooks

### Validation Safety

**Constraints:**
- Guardians report violations but never block commits
- Violations logged, user decides what to do
- `REQUIRES_APPROVAL` status stops automation, asks user
- Failed validation still stages changes (user can proceed)

**Why:** Never trap user in unrecoverable state.

## Cost Constraints

### Not Gastown

**Constraint:** System must not become complex orchestration that needs infrastructure.

**Limits:**
- Maximum 5 guardians (one per layer, no more)
- Guardians are stateless (no memory, no coordination)
- Bash checks run first (free, catch 80%)
- Guardians only spawn when needed (not all 5 every time)

**Target:** <$10/month for typical team (50 commits/day)

### Measurable Value

**Constraint:** Validation must prove its worth through metrics.

**Target:** Value-to-cost ratio > 500 points per dollar

**Action:** If ratio falls below 100, disable guardians entirely.

## Performance Requirements

### Worker Ant Speed

**Constraint:** Worker ant must complete in <30 seconds.

**Why:** Developers won't wait longer for commits.

**Application:**
- Minimal doc updates (surgical edits only)
- Parallel guardian spawning
- Quick bash checks first

### Context Size

**Constraint:** CLAUDE.md + rules should be <10K tokens.

**Why:** Loaded on every session, must be lightweight.

**Application:**
- Point to docs, don't duplicate them
- Terse instructions
- No fluff

## Team Values

### No AI Attribution in Commits

**Constraint:** Never include "Co-Authored-By: Claude" or "Generated by AI" in commit messages.

**Why:** Commits should be indistinguishable from human commits.

**Application:**
- Plain commit messages describing changes
- No meta-commentary about agent involvement

### Explicit Over Implicit

**Constraint:** When uncertain, ask user rather than guessing.

**Why:** Better to clarify than implement wrong thing.

**Application:**
- Use AskUserQuestion for ambiguous requirements
- Don't assume what user wants
- Make adoption path explicit (ask about starting_level)

## Violation Handling

**If core principle violated:**
1. Guardian detects it (Queen Guardian specifically)
2. Status: `REQUIRES_APPROVAL`
3. Worker ant stops, asks user
4. User must explicitly approve or fix

**Example:** If code tries to auto-update README.md, Queen Guardian catches it, stops the process.

---

**Meta-Note:** This file itself is an example of the 5-layer pattern being used to document alexANTria. See ANT-FRAMEWORK.md for the meta-level description of the coordination model.
