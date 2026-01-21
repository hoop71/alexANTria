# Validation Log Schema

**Purpose:** Track all validation checks (bash + guardian), violations caught, and cost incurred to measure value vs cost.

**Location:** `.alexantria/manifest.json` → `validation_log` array

## Schema

```json
{
  "validation_log": [
    {
      "timestamp": "2026-01-20T10:30:00Z",
      "commit": "abc123" | "pending",
      "trigger": "pre_commit" | "on_demand",
      "validation_type": "bash" | "guardian",

      "bash_checks": {
        "run": true,
        "passed": true,
        "violations": [
          {
            "type": "naming",
            "file": "user-level/commands/commit.md",
            "issue": "Must follow ant-*.md pattern",
            "fix": "Rename to ant-commit.md"
          }
        ],
        "cost": 0.0
      },

      "guardians_consulted": [
        {
          "layer": "surface",
          "reason": "New command file created",
          "status": "PASS" | "FAIL" | "REQUIRES_APPROVAL",
          "violations": [
            {
              "file": "user-level/commands/commit.md",
              "issue": "Wrong naming convention",
              "fix": "Rename to ant-commit.md"
            }
          ],
          "tokens_used": 2500,
          "cost_usd": 0.003
        }
      ],

      "total_violations": 2,
      "total_cost_usd": 0.003,
      "prevented_issues": true,
      "notes": "Caught naming violation before commit"
    }
  ]
}
```

## Fields

### Top Level

- **timestamp** (ISO-8601): When validation ran
- **commit** (string): Git commit hash or "pending"
- **trigger** (enum): What triggered validation
  - `pre_commit`: Worker ant during commit
  - `on_demand`: User ran /ant-check-consistency
- **validation_type** (enum): Type of validation run
  - `bash`: Only bash checks
  - `guardian`: Guardian agents consulted
  - `both`: Bash + guardians

### bash_checks

- **run** (boolean): Did bash checks run?
- **passed** (boolean): Did all bash checks pass?
- **violations** (array): List of violations found
  - `type`: Category (naming, structure, json_syntax)
  - `file`: File with violation
  - `issue`: Description of problem
  - `fix`: How to fix it
- **cost** (number): Always 0.0 (bash is free)

### guardians_consulted

Array of guardian results, one per guardian spawned:

- **layer** (enum): Which guardian ran (surface, tunnels, chambers, nest, queen)
- **reason** (string): Why this guardian was triggered
- **status** (enum): Result
  - `PASS`: No violations
  - `FAIL`: Violations found
  - `REQUIRES_APPROVAL`: Strategic decision needed
- **violations** (array): Issues found
  - `file`: File with issue
  - `issue`: Description
  - `fix`: Recommended fix
- **tokens_used** (number): Estimated tokens (for cost calculation)
- **cost_usd** (number): Calculated cost in USD

### Summary Fields

- **total_violations** (number): Count of all violations (bash + guardians)
- **total_cost_usd** (number): Sum of all guardian costs
- **prevented_issues** (boolean): Did validation catch something useful?
- **notes** (string): Brief description of what happened

## Cost Calculation

Based on model pricing (January 2026):

**Haiku (guardians):**
- Input: $0.25 per million tokens
- Output: $1.25 per million tokens
- Estimated per guardian: 1000 input + 500 output = ~$0.002-0.004

**Formula:**
```
cost = (input_tokens * 0.25 / 1_000_000) + (output_tokens * 1.25 / 1_000_000)
```

**Bash checks:** Always $0.00 (no LLM)

## Usage

### Worker Ant Records Validation

After running bash checks and/or guardians, worker ant adds entry to validation_log:

```markdown
1. Run bash checks, collect violations
2. If layers affected: spawn guardians, collect results
3. Calculate total cost
4. Add validation_log entry to manifest
5. Stage manifest
```

### Reporting

Use `/ant-validation-report` to analyze log:
- Total violations caught
- Total cost incurred
- Value-to-cost ratio
- Most common violations
- Which guardians catch the most issues

## Examples

### Bash Only (No Violations)

```json
{
  "timestamp": "2026-01-20T10:30:00Z",
  "commit": "abc123",
  "trigger": "pre_commit",
  "validation_type": "bash",
  "bash_checks": {
    "run": true,
    "passed": true,
    "violations": [],
    "cost": 0.0
  },
  "guardians_consulted": [],
  "total_violations": 0,
  "total_cost_usd": 0.0,
  "prevented_issues": false,
  "notes": "Clean commit, no violations"
}
```

### Bash + Surface Guardian (Violation Caught)

```json
{
  "timestamp": "2026-01-20T10:35:00Z",
  "commit": "def456",
  "trigger": "pre_commit",
  "validation_type": "both",
  "bash_checks": {
    "run": true,
    "passed": false,
    "violations": [
      {
        "type": "naming",
        "file": "user-level/commands/commit.md",
        "issue": "Must follow ant-*.md pattern",
        "fix": "Rename to ant-commit.md"
      }
    ],
    "cost": 0.0
  },
  "guardians_consulted": [
    {
      "layer": "surface",
      "reason": "New command file created",
      "status": "FAIL",
      "violations": [
        {
          "file": "user-level/commands/README.md",
          "issue": "New command not listed in Available Commands table",
          "fix": "Add /ant-commit to table"
        }
      ],
      "tokens_used": 2800,
      "cost_usd": 0.00325
    }
  ],
  "total_violations": 2,
  "total_cost_usd": 0.00325,
  "prevented_issues": true,
  "notes": "Caught naming violation + missing documentation"
}
```

### Full Check (All Guardians)

```json
{
  "timestamp": "2026-01-20T11:00:00Z",
  "commit": null,
  "trigger": "on_demand",
  "validation_type": "guardian",
  "bash_checks": {
    "run": false,
    "passed": null,
    "violations": [],
    "cost": 0.0
  },
  "guardians_consulted": [
    {
      "layer": "surface",
      "reason": "Full consistency check",
      "status": "PASS",
      "violations": [],
      "tokens_used": 3200,
      "cost_usd": 0.0035
    },
    {
      "layer": "tunnels",
      "reason": "Full consistency check",
      "status": "PASS",
      "violations": [],
      "tokens_used": 3500,
      "cost_usd": 0.004
    },
    {
      "layer": "chambers",
      "reason": "Full consistency check",
      "status": "FAIL",
      "violations": [
        {
          "file": "user-level/commands/guardians/*.md",
          "issue": "Guardian prompts don't follow consistent structure",
          "fix": "Standardize output format across all guardians"
        }
      ],
      "tokens_used": 4000,
      "cost_usd": 0.0045
    },
    {
      "layer": "nest",
      "reason": "Full consistency check",
      "status": "PASS",
      "violations": [],
      "tokens_used": 2900,
      "cost_usd": 0.0032
    },
    {
      "layer": "queen",
      "reason": "Full consistency check",
      "status": "PASS",
      "violations": [],
      "tokens_used": 3100,
      "cost_usd": 0.0034
    }
  ],
  "total_violations": 1,
  "total_cost_usd": 0.0186,
  "prevented_issues": true,
  "notes": "Monthly audit - found chambers consistency issue"
}
```

## Reporting Metrics

### Value Calculation

**Value per violation caught:**
- Naming violation: Low value (catches typo early)
- Documentation gap: Medium value (prevents stale docs)
- Pattern inconsistency: High value (prevents technical debt)
- Strategic violation: Critical value (prevents principle drift)

**Suggested scoring:**
- Naming/structure: 1 point
- Documentation coherence: 3 points
- Pattern consistency: 5 points
- Strategic alignment: 10 points

**Value-to-Cost Ratio:**
```
ratio = (total_points_from_violations) / (total_cost_usd)
```

Example:
- Caught 1 naming (1pt) + 1 doc gap (3pt) = 4 points
- Cost: $0.00325
- Ratio: 4 / 0.00325 = 1,230 points per dollar

**Goal:** Maintain ratio > 500 (proves guardians add value)

## Audit Schedule

**Recommended:**
- Bash checks: Every commit (free)
- Targeted guardians: When layers affected (~$0.003 per guardian)
- Full check: Weekly or before releases (~$0.02)

**Track over time:**
- Are violations decreasing? (system improving)
- Is cost stable? (not growing)
- Is ratio improving? (catching more per dollar)
