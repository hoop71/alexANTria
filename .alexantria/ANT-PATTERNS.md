# alexANTria - Cross-Cutting Patterns

**Layer:** Patterns (🏛️)

## Naming Conventions

### Commands

**Pattern:** `ant-<action>.md`

**Examples:**
- `ant-init.md` - Initialize colony
- `ant-commit.md` - Automated commit
- `ant-migrate.md` - Migrate README to ANT-SURFACE
- `ant-validate.md` - Check installation health
- `ant-check-consistency.md` - Run guardians

**Location:** `user-level/commands/`

**Enforcement:** Bash checks + Service Guardian

### Layer Documentation

**Pattern:** `ANT-<LAYER>.md` (all caps for layer name)

**Examples:**
- `ANT-STRATEGY.md` - Strategic alignment
- `ANT-PRODUCT.md` - Product context
- `ANT-PATTERNS.md` - Cross-cutting patterns
- `ANT-ARCHITECTURE.md` - Architecture
- `ANT-SURFACE.md` - Individual service docs

**Location:**
- Strategy/Product/Patterns/Architecture: `.alexantria/` directory
- Surface: Within service directories

### Configuration & State

**Pattern:** `.alexantria/<filename>.json`

**Files:**
- `config.json` - Project configuration
- `manifest.json` - Change tracking, validation log

**Format:** JSON (never YAML, always validated)

### Meta Documentation

**Pattern:** `ANT-<CONCEPT>.md` (uppercase, describes the pattern itself)

**Examples:**
- `ANT-FRAMEWORK.md` - Coordination model (meta)
- `ANT-SCHEMA.md` - 5-layer pattern (meta)

**Location:** Repo root

**Purpose:** Define the patterns, not use them

## Command Structure Pattern

All commands follow this structure:

```markdown
# /ant-<name> - Title

**Purpose:** One-line description

**Layer:** <Which layer this operates on>

## Overview

What this command does and why it exists.

## Problem

What problem does this solve?

## Workflow

```
User: "/ant-<name> [args]"

1. Step 1
   - Detail
2. Step 2
   - Detail
```

## Agent Instructions

```markdown
When the user says "/ant-<name> [args]":

1. **Do this:**
   ```bash
   # Example commands
   ```

2. **Then this:**
   ...
```

## Usage Examples

### Example 1: Basic usage
...

### Example 2: Advanced usage
...

## Success Criteria

After running `/ant-<name>`:
- ✓ Criterion 1
- ✓ Criterion 2

## Related Commands

- `/ant-other` - Related command

## Notes

- Edge cases
- Gotchas
```

**Enforcement:** Patterns Guardian checks all commands follow this structure.

## Guardian Pattern

All guardians follow this structure:

```markdown
# <Layer> Guardian Prompt

You are the <Layer> Guardian...

**Layer:** <Layer emoji + name>

**Responsibility:** What this guardian validates

## What You Validate

### 1. Category 1
- ✓ Pass criteria
- ✗ Fail criteria

### 2. Category 2
...

## Your Task

You will receive...

## Output Format

Report in this structure:

```
<emoji> <Layer> Guardian Report
━━━━━━━━━━━━━━━━━━━━━━━━

Status: [PASS | FAIL]

Violations:
...
```

## Examples

**FAIL Example:**
...

**PASS Example:**
...
```

**Location:** `user-level/commands/guardians/<layer>-guardian.md`

**Enforcement:** Patterns Guardian validates all guardians follow this pattern.

## Validation Pattern

### Bash Checks (Always First)

**Pattern:**
1. Run free bash checks first
2. Catch 80% of violations at zero cost
3. Only spawn guardians if needed

**Checks:**
- Naming conventions (regex matching)
- File structure (paths correct)
- JSON syntax (jq validation)

**Location:** Worker ant prompt, step 6

### Guardian Triggers (Smart)

**Pattern:**
1. Detect which layers are SIGNIFICANTLY affected
2. Only spawn guardians for those layers
3. Not all 5 on every commit

**Triggers:**
- **Surface:** NEW command file OR naming violations
- **Architecture:** Config/schema changed
- **Patterns:** 3+ files OR guardian prompts changed
- **Product:** Adoption stages OR workflows changed
- **Strategy:** Core principles OR ANT-* only logic changed

### Validation Logging

**Pattern:**
```json
{
  "validation_log": [
    {
      "timestamp": "ISO-8601",
      "commit": "hash or pending",
      "trigger": "pre_commit | on_demand",
      "bash_checks": { violations[], cost: 0.0 },
      "guardians_consulted": [ { layer, violations[], tokens_used, cost_usd } ],
      "total_violations": N,
      "total_cost_usd": X,
      "prevented_issues": bool,
      "notes": "what happened"
    }
  ]
}
```

**Location:** `.alexantria/manifest.json`

**Schema:** Documented in `user-level/validation-log-schema.md`

## Guardian Spectrum Pattern

Guardians validate different types of knowledge based on layer position in the knowledge spectrum.

### Lower Layers: Code-Adjacent Validation

**Service Guardian:**
- **Validates:** Naming conventions, file structure, paths
- **Method:** Bash checks (regex, file existence, JSON syntax)
- **Cost:** Free (bash) + ~$0.002 (semantic check)

**Architecture Guardian:**
- **Validates:** Config schema, architecture coherence, service boundaries
- **Method:** JSON validation + pattern matching
- **Cost:** ~$0.003

### Middle Layer: Pattern Consistency

**Patterns Guardian:**
- **Validates:** Cross-cutting pattern consistency, duplication detection
- **Method:** Semantic analysis across files
- **Cost:** ~$0.005

### Upper Layers: Strategic Alignment

**Product Guardian:**
- **Validates:** Product logic, workflow coherence, use case alignment
- **Method:** Logical consistency + human prompts
- **Cost:** ~$0.004

**Strategy Guardian:**
- **Validates:** Core principles, strategic constraints
- **Method:** Principle violation detection + REQUIRES_APPROVAL status
- **Cost:** ~$0.004

### Why Different Validation Methods

Based on three-pool architecture:

| Layer | Pool | Validation Type | Automatable? |
|-------|------|----------------|--------------|
| Surface/Architecture | Programmatic | Code-adjacent checks | Yes (bash + simple LLM) |
| Patterns | Tokenized | Pattern consistency | Mostly (LLM-assisted) |
| Product/Strategy | Intentional | Strategic alignment | Partially (requires human) |

Lower layers validate against code reality. Upper layers validate against human intent.

### Smart Triggers Revisited

Guardians only spawn when their layer is SIGNIFICANTLY affected:

- **Surface/Architecture:** NEW files, naming violations, structural changes
- **Patterns:** 3+ files changed, guardian prompts modified
- **Product/Strategy:** Core principles, strategic docs, adoption logic

This saves cost by not running strategic validation (intentional pool) on code-reality changes (programmatic pool).

## Error Handling Pattern

### Worker Ant Errors

**Pattern:**
1. Try to complete task
2. If fail: Log error to manifest
3. Report to user with clear message
4. Never leave system in inconsistent state

**Example:**
```
Worker ant failed to update ANT-SURFACE.md
Reason: File doesn't exist in managed directory
Action: Logged to manifest, staged other changes
User can proceed with commit or fix issue
```

### Guardian Failures

**Pattern:**
1. Guardian reports FAIL with violations
2. Worker ant logs to validation_log
3. Changes still staged (user decides)
4. Report shows what needs fixing

**Never:** Block commit entirely (user might disagree with guardian)

### Hook Failures

**Pattern:**
1. Pre-commit hook detects issue
2. Shows clear error message
3. Suggests fix
4. Exits with non-zero (prevents bad commit)

**Example:**
```
❌ alexANTria pre-commit check failed:
   Worker ant not available in this environment

   Options:
   1. Commit via agent: /ant-commit "message"
   2. Disable worker ant: validation.enabled = false
   3. Manual update: /ant-update after commit
```

## Template Usage Pattern

### Placeholder Substitution

**Pattern:** `{{PLACEHOLDER_NAME}}`

**Examples:**
- `{{PROJECT_NAME}}` → Actual project name
- `{{UX_DOC}}` → Path to UX doc (if found)
- `{{STARTING_LEVEL}}` → Chosen starting level

**Location:** `templates/*.template`

**Process:**
1. /ant-init reads template
2. Detects placeholders
3. Asks user or infers values
4. Substitutes and writes final file

### Template Structure

**Pattern:**
```markdown
# {{PROJECT_NAME}} - <Layer Name>

**Layer:** <Layer emoji + name>

## <Section 1>

<!-- Content or placeholder -->

## Recent Changes (Last 5-10 Commits)

<!-- Maintained by worker ant -->

## Higher-Layer Impacts (Detected by Worker Ant)

<!-- Suggested updates to higher layers -->
```

## Documentation Standards

### Minimal, Load-Bearing

**Pattern:**
- No preamble ("This document describes...")
- No fluff ("It's very important to...")
- Every sentence changes agent behavior
- Lower token cost = easier maintenance

**Examples:**
- ❌ "Authentication is a critical security concern and we take it very seriously..."
- ✅ "Use JWT tokens. Refresh in httpOnly cookies. Access in memory. Expire after 15min."

### Imperative Language

**Pattern:**
- Use commands: "Read X before Y"
- Not suggestions: "It would be helpful to read X"
- Direct: "Never do X"
- Not hedging: "Try to avoid X"

### Layer-Appropriate Detail

**Pattern:**
- **Strategy:** WHY (strategic reasons, constraints)
- **Product:** WHAT (features, use cases, workflows)
- **Patterns:** HOW (patterns applied consistently)
- **Architecture:** HOW (architecture, connections)
- **Surface:** WHAT (API, components, implementation)

## Cost Tracking Pattern

### Token Estimation

**Pattern:**
```
input_tokens = prompt_size + context_size
output_tokens = estimated_response_size
cost_usd = (input * rate_in + output * rate_out) / 1_000_000
```

**Rates (Haiku):**
- Input: $0.25 per million tokens
- Output: $1.25 per million tokens

**Typical:**
- Guardian: ~2000 input + 500 output = ~$0.003

### Value Scoring

**Pattern:**
- Naming violation: 1 point (trivial)
- Documentation gap: 3 points (medium)
- Pattern inconsistency: 5 points (high)
- Strategic violation: 10 points (critical)

**Target:** Value-to-cost ratio > 500 points/dollar

### Cost Projection

**Pattern:**
```
daily_avg = total_cost / days_tracked
monthly_projection = daily_avg * 30
yearly_projection = monthly_projection * 12
```

**Report:** In `/ant-validation-report`

## Collaboration Mode Pattern

### Local-Only vs Team-Shared

**Pattern:** alexANTria supports two collaboration modes for different adoption stages.

**Modes:**

**Local-Only (Private Experimentation):**
- All alexANTria files (except config.json) gitignored
- User tests privately without team coordination
- Worker ant, guardians, validation all work normally
- Team doesn't see any ANT-* docs
- Transition to team-shared via `/ant-publish`

**Team-Shared (Standard Adoption):**
- All alexANTria files tracked in git
- Team sees all ANT-* docs from day 1
- Standard collaboration model
- Can't transition back to local-only (one-way)

### Gitignore Management

**Pattern for local-only mode:**

```gitignore
# alexANTria (local-only mode)
.alexantria/
!.alexantria/config.json
CLAUDE.md
.claude/
**/ANT-SURFACE.md
ANT-ARCHITECTURE.md
ANT-PATTERNS.md
ANT-PRODUCT.md
ANT-STRATEGY.md

```

**Why config.json is NOT gitignored:**
- Documents your configuration choices
- No secrets (just settings)
- Makes publishing smoother (team sees what you configured)
- Historical record of decisions

### Publishing Workflow

**Pattern:** One-way transition from local-only to team-shared.

```
User runs /ant-publish
  ↓
Validate currently in local-only mode
  ↓
Show what will be published (git status --ignored)
  ↓
Confirm with user
  ↓
Remove .gitignore section
  ↓
Update config.collaboration.mode = "team_shared"
  ↓
Update config.collaboration.published_at = now()
  ↓
Stage all alexANTria files
  ↓
Show team adoption checklist
  ↓
Suggest commit message
```

**No unpublishing:** Once team-shared, stays team-shared (prevents team disruption).

### Config Schema

**Pattern:**
```json
{
  "collaboration": {
    "mode": "local_only" | "team_shared",
    "gitignored_at": "ISO-8601 timestamp | null",
    "published_at": "ISO-8601 timestamp | null"
  }
}
```

**Field meanings:**
- `mode`: Current collaboration mode
- `gitignored_at`: When local-only mode was enabled (preserved after publishing)
- `published_at`: When published to team (null if never published or always team-shared)

### Migration Awareness

**Pattern:** `/ant-migrate` respects collaboration mode.

When migrating README.md → ANT-SURFACE.md in local-only mode:
```bash
# After creating ANT-SURFACE.md
mode=$(jq -r '.collaboration.mode' .alexantria/config.json)
if [ "$mode" = "local_only" ]; then
  echo "<directory>/ANT-SURFACE.md" >> .gitignore
  echo "📍 Local-only mode: ANT-SURFACE.md gitignored"
fi
```

Ensures migrated files respect user's privacy intent.

### Status Display

**Pattern:** `/ant-status` shows collaboration mode at top.

```
📍 Collaboration Mode: Local-only (private)
   Gitignored since: 2026-02-11 10:30
   Files private: .alexantria/, CLAUDE.md, .claude/, ANT-*.md

   → Run /ant-publish to share with team
```

Makes current mode immediately visible.

### Edge Cases

**Edge Case 1: .gitignore in .gitignore**
- Detect: `git check-ignore .gitignore`
- Action: Warn user, pause init/publish
- Why: Can't manage gitignore if it's itself ignored

**Edge Case 2: Already published**
- Detect: `config.collaboration.mode == "team_shared"`
- Action: Show "Already in team-shared mode", exit gracefully
- Why: Prevents confusion, no-op is safe

**Edge Case 3: Partial gitignore state**
- Detect: Some alexANTria files ignored, section missing
- Action: Show warning, ask user to clean up manually
- Why: Unknown state, let user resolve

### Commands Affected

**Commands that check collaboration mode:**
- `/ant-init` - Asks for mode, creates gitignore if needed
- `/ant-publish` - Transitions local-only → team-shared
- `/ant-migrate` - Respects mode when creating ANT-SURFACE.md
- `/ant-status` - Shows current mode

**Commands that work the same in both modes:**
- `/ant-commit` - Worker ant operates identically
- `/ant-validate` - Validation works the same
- `/ant-review-suggestions` - Suggestions work the same
- `/ant-check-consistency` - Guardians work the same

## Benchmarking Pattern

### Quality Scoring Framework

**Pattern:** Objective measurement of output quality across 4 dimensions.

**Dimensions (100 points total):**
1. **Objective Criteria (40 points):** Automated checks against task success criteria
   - File naming conventions (regex checks)
   - Required sections present (structure validation)
   - YAML frontmatter valid (parse check)
   - No placeholder text (content validation)

2. **Pattern Adherence (30 points):** Compliance with documented patterns
   - Command structure matches ANT-PATTERNS.md
   - Naming conventions followed
   - Frontmatter format correct
   - Agent instructions follow format
   - Read-act-repair pattern demonstrated

3. **Correctness (20 points):** No hallucinations, valid references
   - All file references exist in repo
   - No made-up commands or tools
   - No placeholder/dummy content
   - Factually accurate

4. **Completeness (10 points):** Production-ready solution
   - All success criteria addressed
   - Required sections present
   - Edge cases handled

**Location:** `.alexantria/benchmarks/quality-scoring.md`

### Comparative Analysis Pattern

**Pattern:** Run identical tasks with different approaches, measure differences objectively.

**Structure:**
```json
{
  "task_id": "task-name",
  "control": {
    "approach": "raw_repo",
    "context_tokens": 1014096,
    "time_seconds": 65,
    "accuracy_score": 7
  },
  "test": {
    "approach": "ant_framework",
    "context_tokens": 6701,
    "time_seconds": 22,
    "accuracy_score": 9
  },
  "improvements": {
    "token_reduction": "151.3x",
    "speed_improvement": "3.0x",
    "accuracy_improvement": "+29%",
    "roi_improvement": "194.6x"
  }
}
```

**Process:**
1. Define benchmark task with clear success criteria
2. Run control approach (raw repo, all files loaded)
3. Run test approach (ANT framework, selective loading)
4. Score both outputs using quality framework
5. Calculate improvements across dimensions
6. Store results for historical tracking

**Location:** `.alexantria/benchmarks/comparison-results.md`

### LLM-as-Judge Pattern

**Pattern:** Use third-party agent to evaluate outputs objectively.

**Evaluation Criteria:**
- Clarity (0-10): How understandable is the output?
- Pattern Adherence (0-10): Does it follow documented patterns?
- Completeness (0-10): Does it fully address the task?
- Production-Readiness (0-10): Could this be merged as-is?

**Implementation:**
```markdown
You are a code reviewer evaluating two implementations.

Rate each on:
1. Clarity (0-10)
2. Adherence to Patterns (0-10)
3. Completeness (0-10)
4. Production-Readiness (0-10)

Provide scores and brief justification.
```

**Why:** Provides consistent, unbiased evaluation across multiple outputs.

### Anti-Pattern Detection

**Pattern:** Identify common failures in agent outputs.

**Control (too much context) anti-patterns:**
- References files that don't exist (hallucinations)
- Verbose, unfocused explanations
- Copies patterns from wrong sources
- Includes irrelevant information
- Inconsistent with established patterns

**Test (ideal) characteristics:**
- References only relevant files
- Concise, focused implementation
- Follows ANT-PATTERNS.md precisely
- Relevant information only
- Consistent with existing commands

**Commands:**
- `/ant-benchmark` - Run comparative benchmarks
- `/ant-validate-rlm` - Validate RLM selective loading

**Enforcement:** Patterns Guardian validates benchmarking infrastructure follows this pattern.

## Recent Changes (Last 5-10 Commits)

- Established guardian pattern (all 5 guardians follow consistent structure)
- Defined smart trigger pattern (only spawn affected guardians)
- Created validation logging pattern (track violations + cost)
- Standardized command structure across all commands
- Enforced naming conventions via bash checks

## Higher-Layer Impacts (Detected by Worker Ant)

None currently - this file is new as part of migration to consistent structure.
