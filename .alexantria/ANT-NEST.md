# alexANTria - Product Context

**Layer:** Nest (🐜)

## Product Overview

alexANTria is a context infrastructure system for AI agent orchestration. It solves the "Gastown problem": complex orchestration needs infrastructure, which needs orchestration, which needs infrastructure...

**Not:** A documentation generator
**Is:** Infrastructure that makes context load-bearing and self-maintaining

## The Problem We Solve

### Context Drift

**Problem:** As codebases evolve, documentation gets stale. Agents make bad decisions based on outdated context.

**Traditional solution:** Manual documentation updates (rarely happens)

**alexANTria solution:** Worker ant automatically maintains docs at commit time. Context stays fresh.

### Gastown (Orchestration Regress)

**Problem:** Complex agent systems need coordination infrastructure, which itself needs agents to maintain, which needs...

**Traditional solution:** Central coordinator agent (becomes single point of failure)

**alexANTria solution:** Simple autonomous workers with clear boundaries. No central brain.

### Adoption Friction

**Problem:** Teams can't adopt "all-or-nothing" documentation systems. Need gradual path.

**Traditional solution:** Pilot in one area, but no clear expansion path.

**alexANTria solution:** Explicit adoption ramp: pilot → active → full, with scope control.

## Key Features

### 1. Adoption Ramp

**Pilot Stage:**
- Single directory (e.g., `src/auth/**`)
- Surface level only (ANT-SURFACE.md)
- Test for 5-10 commits
- Low risk, prove value

**Active Stage:**
- Multiple directories (e.g., `src/**`, `lib/**`)
- Optionally add tunnels level (architecture)
- Migrate README → ANT-SURFACE via `/ant-migrate`
- Expanding confidence

**Full Stage:**
- Entire repo (`**`)
- Optionally add chambers level (patterns)
- Full automation across codebase
- Complete adoption

### 2. Automation Boundary

Worker ant only auto-maintains docs at or below `starting_level`:

- **Surface:** Directory-level docs (ANT-SURFACE.md)
- **Tunnels:** Architecture docs (ANT-TUNNELS.md)
- **Chambers:** Pattern docs (ANT-CHAMBERS.md)
- **Nest/Queen:** Always manual (product/strategic)

User controls boundary via config. Everything above = suggestions only.

### 3. Guardian Validation (Opt-In)

Specialized Haiku agents validate consistency:

- **🌱 Surface:** Naming conventions, file structure
- **🚇 Tunnels:** Config schema, architecture coherence
- **🏛️ Chambers:** Pattern consistency, duplication
- **🐜 Nest:** Adoption stages, workflow logic
- **👑 Queen:** Core principles, strategic constraints

**Smart triggers:** Only spawn guardians for affected layers (not all 5 every time).

**Cost:** ~$3-10/month for active team, measurable ROI via `/ant-validation-report`.

### 4. Clean Removal Path

If alexANTria doesn't work for your team:

```bash
git rm -r ANT-*.md .alexantria/ .claude/
git rm .git/hooks/pre-commit
git commit -m "Remove alexANTria"
```

Zero trace left. No lock-in.

## Use Cases

### Use Case 1: New Greenfield Project

**Scenario:** Starting fresh, want docs from day 1.

**Path:**
1. Run `/ant-init`
2. Choose "ANT-only" mode
3. Choose starting_level: "surface"
4. ANT-SURFACE.md created in all directories
5. Worker ant maintains them automatically

**Result:** Docs stay fresh from day 1, zero manual work.

### Use Case 2: Existing Brownfield Project (Cautious)

**Scenario:** Mature codebase, lots of READMEs, want to test alexANTria.

**Path:**
1. Run `/ant-init`
2. Choose "Hybrid-to-ANT" mode (keep READMEs)
3. Choose scope: single directory (e.g., `src/auth/**`)
4. Choose starting_level: "surface"
5. Test for 10 commits
6. Review quality via `/ant-validation-report`
7. If good: expand scope or migrate READMEs
8. If bad: clean removal

**Result:** Low-risk pilot, can expand or remove cleanly.

### Use Case 3: Large Team with Consistency Issues

**Scenario:** 50+ developers, patterns diverging, docs stale.

**Path:**
1. Run `/ant-init` with full scope
2. Enable guardians (`validation.enabled: true`)
3. Set starting_level: "tunnels" (surface + architecture)
4. Guardians catch naming violations, pattern drift
5. `/ant-validation-report` shows ROI
6. Gradually expand to chambers level

**Result:** Enforced consistency, measurable value, automatic maintenance.

### Use Case 4: Agency/Consultant (Multiple Projects)

**Scenario:** Managing many client codebases, need consistent structure.

**Path:**
1. Install alexANTria in all projects
2. Use same CLAUDE.md structure across clients
3. Share templates and guardian configs
4. Client-specific context in ANT-NEST.md
5. Standard patterns in ANT-CHAMBERS.md

**Result:** Consistent onboarding, portable knowledge, agents work same way across projects.

## User Workflows

### Workflow 1: Agent Commit

```
Agent makes code changes
  ↓
Agent runs /ant-commit "message"
  ↓
Worker ant spawns (blocking)
  ↓
Worker ant updates docs, runs validation
  ↓
Single commit created (code + docs + manifest)
  ↓
Agent shows commit results
```

**Time:** ~5-10 seconds
**Cost:** ~$0.01-0.03 per commit

### Workflow 2: Human Commit

```
Human makes code changes
  ↓
Human commits: git commit -m "message"
  ↓
Pre-commit hook detects (no manifest staged)
  ↓
Hook tries to spawn worker ant OR warns
  ↓
Commit includes updated docs (if worker ant succeeded)
```

**Fallback:** If hook can't spawn, warns user to run `/ant-commit` via agent later.

### Workflow 3: Migration

```
User runs /ant-migrate src/auth
  ↓
Reads src/auth/README.md
  ↓
Analyzes content (LLM-assisted)
  ↓
Generates src/auth/ANT-SURFACE.md
  ↓
Shows diff, asks approval
  ↓
If approved: stages migration, suggests commit
```

**Result:** Clean migration from README → ANT-SURFACE, user reviews before committing.

### Workflow 4: Validation Review

```
User runs /ant-review-suggestions
  ↓
Shows pending suggestions (higher-layer impacts)
  ↓
User chooses: Apply all / Review individually / Dismiss
  ↓
If apply: runs /ant-refresh-doc for each suggested doc
  ↓
Stages updates, suggests commit
```

**When:** After major changes, before releases, monthly maintenance.

## Business Rules

### Rule 1: Scope Must Be Configured

Worker ant only touches files in `managed_paths`. No wildcards without user approval.

**Validation:** ANT-init asks explicitly, config committed to git (team agreement).

### Rule 2: Naming Conventions Are Enforced

- Commands: `ant-*.md`
- Layer docs: `ANT-SURFACE.md`, `ANT-TUNNELS.md`, etc.
- Config: `.alexantria/*.json`

**Enforcement:** Bash checks (free) + Surface Guardian (if enabled).

### Rule 3: Validation Is Opt-In

Guardians disabled by default (`validation.enabled: false`).

**Why:** Teams can adopt core features (worker ant) without validation cost.

### Rule 4: Higher Layers Need Approval

ANT-NEST.md and ANT-QUEEN.md never auto-maintained, even if starting_level = "chambers".

**Why:** Strategic and product decisions require human judgment.

### Rule 5: Adoption Stage Matches Configuration

- **Pilot:** Single directory + surface level
- **Active:** Multiple directories + surface/tunnels level
- **Full:** Entire repo + tunnels/chambers level

**Validation:** Nest Guardian checks logical consistency (pilot shouldn't have scope: `["**"]`).

## Domain Model

```
Project
  ├─ config (starting_level, managed_paths, adoption_stage)
  ├─ manifest (changes[], validation_log[], suggested_reviews[])
  ├─ ANT-* files (layer docs)
  │   ├─ ANT-QUEEN.md (strategic - always manual)
  │   ├─ ANT-NEST.md (product - always manual)
  │   ├─ ANT-CHAMBERS.md (patterns - auto if starting_level >= chambers)
  │   ├─ ANT-TUNNELS.md (architecture - auto if starting_level >= tunnels)
  │   └─ ANT-SURFACE.md (surface - always auto)
  ├─ Commands (ant-init, ant-commit, ant-migrate, etc.)
  └─ Guardians (5 specialized Haiku agents)

Worker Ant (per-commit)
  ├─ reads config
  ├─ analyzes changes
  ├─ runs bash validation
  ├─ spawns guardians (if needed)
  ├─ updates docs at or below starting_level
  ├─ detects higher-layer impacts
  └─ logs to manifest
```

## Success Metrics

**Short-term (first 10 commits):**
- Worker ant completes without errors
- Docs are actually updated (not stale)
- No false positives from guardians
- Cost < $0.50

**Medium-term (first month):**
- Value-to-cost ratio > 500 (if guardians enabled)
- Violations decreasing over time (system learning)
- Team adopts without friction
- Cost < $10

**Long-term (3+ months):**
- Docs consistently accurate
- Onboarding time reduced (new devs find context easily)
- Pattern drift prevented (guardians catch early)
- Clean expansion path (pilot → active → full)

---

**Meta-Note:** This file itself is an example of the 5-layer pattern documenting alexANTria's product context. See README.md for user-facing overview.
