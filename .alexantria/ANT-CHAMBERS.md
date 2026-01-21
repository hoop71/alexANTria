# alexANTria - Cross-Cutting Patterns

**Layer:** Chambers (🏛️)

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

**Enforcement:** Bash checks + Surface Guardian

### Layer Documentation

**Pattern:** `ANT-<LAYER>.md` (all caps for layer name)

**Examples:**
- `ANT-QUEEN.md` - Strategic alignment
- `ANT-NEST.md` - Product context
- `ANT-CHAMBERS.md` - Cross-cutting patterns
- `ANT-TUNNELS.md` - Architecture
- `ANT-SURFACE.md` - Individual service docs

**Location:**
- Queen/Nest/Chambers/Tunnels: Repo root
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

**Enforcement:** Chambers Guardian checks all commands follow this structure.

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

**Enforcement:** Chambers Guardian validates all guardians follow this pattern.

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
- **Tunnels:** Config/schema changed
- **Chambers:** 3+ files OR guardian prompts changed
- **Nest:** Adoption stages OR workflows changed
- **Queen:** Core principles OR ANT-* only logic changed

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
- **Queen:** WHY (strategic reasons, constraints)
- **Nest:** WHAT (features, use cases, workflows)
- **Chambers:** HOW (patterns applied consistently)
- **Tunnels:** HOW (architecture, connections)
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

## Recent Changes (Last 5-10 Commits)

- Established guardian pattern (all 5 guardians follow consistent structure)
- Defined smart trigger pattern (only spawn affected guardians)
- Created validation logging pattern (track violations + cost)
- Standardized command structure across all commands
- Enforced naming conventions via bash checks

## Higher-Layer Impacts (Detected by Worker Ant)

None currently - this file is new as part of migration to consistent structure.
