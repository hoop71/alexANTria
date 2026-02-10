---
description: Show current state of alexANTria installation
allowed-tools: Read, Bash, Glob, Grep
---

# 🐜 Ant Status: Installation & Activity Overview

**Purpose:** Display comprehensive snapshot of alexANTria state: files, validation status, recent commits with ANT updates, and suggested next actions.

**Layer:** Surface (🌱)

**Scope:** Installation health + manifest history + automation status + ANT doc updates + pending reviews
**Not in scope:** Deep validation (use `/ant-validate` for that) or metrics analysis (use `/ant-validation-report`)

## Overview

The `/ant-status` command answers:
- Is alexANTria properly installed?
- What adoption stage am I in?
- How healthy is the system?
- Which ANT docs were recently updated?
- Are there pending doc reviews?
- What should I do next?

## Problem

Without a status view, you can't quickly understand:
- Current installation readiness
- Validation status and recent violations
- Which commits modified ANT framework docs
- Whether pending reviews await
- System health at a glance

## Workflow

```
User: "/ant-status"

1. Gather installation files
   - Check core structure (CLAUDE.md, .claude/, .alexantria/)
   - Count rules and commands
2. Read configuration and manifest
   - Extract adoption stage, validation settings, worker ant status
   - Parse recent commits and pending reviews
3. Analyze recent commits
   - Identify which commits updated ANT files
   - Count docs updated per commit
4. Extract pending reviews
   - Group suggested_reviews by layer
   - Show detection timestamps
5. Calculate validation metrics
   - Total violations, costs, issues prevented
6. Display comprehensive report
   - Installation status, config, metrics
   - Recent ANT updates with summaries
   - Pending doc reviews with context
   - Actionable next steps
```

## Agent Instructions

When the user runs `/ant-status`:

### Step 1: Gather Installation Data

Use a **single consolidated bash command**:

```bash
{
  echo "=== CORE STRUCTURE ==="
  test -f CLAUDE.md && echo "CLAUDE.md=exists" || echo "CLAUDE.md=missing"
  test -d .claude && echo "dot_claude=exists" || echo "dot_claude=missing"
  test -d .alexantria && echo "alexantria=exists" || echo "alexantria=missing"

  echo "=== RULES ==="
  ls .claude/rules/*.md 2>/dev/null | wc -l | xargs echo "rules_count="

  echo "=== MANIFEST ==="
  test -f .alexantria/manifest.json && echo "manifest=exists" || echo "manifest=missing"
  test -f .alexantria/config.json && echo "config=exists" || echo "config=missing"

  echo "=== COMMANDS ==="
  ls user-level/commands/ant-*.md 2>/dev/null | wc -l | xargs echo "command_count="

  echo "=== GIT ==="
  git status --porcelain 2>/dev/null | wc -l | xargs echo "uncommitted_files="
  git log --oneline -1 2>/dev/null | head -1
}
```

### Step 2: Read Configuration and Manifest

Use Read tool (silent) to parse:
- `.alexantria/config.json` - Extract: adoption_stage, validation.enabled, worker_ant.enabled
- `.alexantria/manifest.json` - Extract: validation_log, changes array, suggested_reviews

### Step 3: Analyze Recent Commits with ANT Updates

From manifest.changes array:
- Identify commits that have docs_updated array containing ANT files
- Extract commit hash, timestamp, summary
- Count which ANT files were updated

From git log, correlate commits to recent changes

### Step 4: Extract Validation Metrics

From manifest.validation_log:
```
total_validations = count entries
total_violations = sum(entry.total_violations)
total_cost_usd = sum(entry.total_cost_usd)
prevented_issues = count(prevented_issues = true)
```

### Step 5: Extract Pending Reviews

From manifest.changes[].suggested_reviews array:
- Find all entries with suggested_reviews
- Group by layer and doc name
- Extract reason and detection timestamp

### Step 6: Output Formatted Report

**IMPORTANT:** Output ONE formatted report. Do NOT show individual commands or reads.

```
🐜 Colony Status Report
════════════════════════════════════

📁 Installation
  [✓] CLAUDE.md
  [✓] .claude/ (rules: 5)
  [✓] .alexantria/ (config, manifest)
  [✓] Commands: 15 available

⚙️  Configuration
  Adoption Stage: full
  Validation: disabled
  Worker Ant: enabled
  Starting Level: service

📊 Validation Status
  Total Validations: 42
  Violations Caught: 8 (6 bash, 2 guardian)
  Cost: $0.008
  Issues Prevented: 8/42

🔄 Recent ANT Document Updates (Last 5 Commits)

  ✓ accf480 feat: add visual charts and marketing
    Updated: user-level/commands/ANT-SURFACE.md
    [+] New command examples and visual improvements

  ✓ 3bfe788 refactor: rename layers to graduation-ready names
    Updated: ANT-STRATEGY.md, ANT-PRODUCT.md, ANT-PATTERNS.md, ANT-ARCHITECTURE.md
    [+] Major framework refactoring with graduation path

  ~ c8615cb feat: add RLM validation proof
    No ANT docs modified

📋 Pending Doc Reviews (4 Waiting)

  👑 Strategy Layer:
     ANT-STRATEGY.md
     Reason: Core framework principles updated with graduation-ready naming
     Detected: 2026-02-10

  🐜 Product Layer:
     ANT-PRODUCT.md
     Reason: Product positioning and adoption stages now include graduation path
     Detected: 2026-02-10

  🏛️ Patterns Layer:
     ANT-PATTERNS.md
     Reason: Guardian pattern updated with new layer naming
     Detected: 2026-02-10

  🚇 Architecture Layer:
     ANT-ARCHITECTURE.md
     Reason: Automation boundary updated with graduation-ready names
     Detected: 2026-02-10

💡 Suggested Next Steps
  1. Review pending changes: /ant-review-suggestions (4 awaiting)
  2. Check installation health: /ant-validate
  3. See validation ROI: /ant-validation-report

════════════════════════════════════
Status: HEALTHY ✓
```

Use these symbols:
- `[✓]` Present/healthy/updated
- `[✗]` Missing/broken
- `[?]` Warning/review needed
- `[~]` No change/neutral
- `[i]` Info

### Step 7: Exit Codes

Determine status:
- **0 (HEALTHY)**: All critical components, no issues
- **1 (DEGRADED)**: Some optional components missing
- **2 (BROKEN)**: Critical files missing, run `/ant-init`

## Visual Guidelines

**Sections:**
1. **Installation** - File existence (CLAUDE.md, .claude/, .alexantria/, commands)
2. **Configuration** - Current settings (adoption_stage, validation, worker_ant, starting_level)
3. **Validation Status** - Metrics from validation_log (runs, violations, cost, prevented)
4. **Recent ANT Document Updates** - Commits that modified ANT files, what changed
5. **Pending Doc Reviews** - Suggested_reviews grouped by layer
6. **Suggested Next Steps** - Actionable recommendations
7. **Status Line** - Overall health (HEALTHY, DEGRADED, BROKEN)

**Layout:** Use box drawing (`━`, `║`) and emojis for clarity.

## Example Output

```
🐜 Colony Status Report
════════════════════════════════════

📁 Installation
  [✓] CLAUDE.md (5-layer hierarchy present)
  [✓] .claude/ (rules: 5 files)
  [✓] .alexantria/ (config, manifest valid)
  [✓] Commands: 15 available

⚙️  Configuration
  Adoption Stage: full
  Validation: disabled
  Worker Ant: enabled (auto mode)
  Starting Level: service

📊 Validation Status (All Time)
  Total Validations: 42
  Total Violations: 8
    - Bash checks: 6 (free)
    - Guardian checks: 2 ($0.008)
  Cost: $0.008
  Issues Prevented: 8/42 validations

🔄 Recent ANT Document Updates

  ✓ accf480 (2026-02-10) feat: add visual charts
    Updated: user-level/commands/ANT-SURFACE.md
    [+] Enhanced command documentation with visual examples

  ✓ 3bfe788 (2026-02-09) refactor: graduation-ready names
    Updated: ANT-STRATEGY.md, ANT-PRODUCT.md, ANT-PATTERNS.md, ANT-ARCHITECTURE.md
    [+] Major framework refactoring with new layer naming convention

  ~ c8615cb (2026-02-08) feat: RLM validation proof
    No ANT docs modified

  ~ 2a1ba82 (2026-02-07) feat: add Astro documentation
    No ANT docs modified

📋 Pending Doc Reviews (4 Awaiting)

  👑 Strategy Layer (1 pending):
     ANT-STRATEGY.md
     Reason: Core framework principles updated with graduation-ready naming
     Detected: 2026-02-10
     Pending in: 1 commit

  🐜 Product Layer (1 pending):
     ANT-PRODUCT.md
     Reason: Product positioning and adoption stages now include graduation path
     Detected: 2026-02-10
     Pending in: 1 commit

  🏛️ Patterns Layer (1 pending):
     ANT-PATTERNS.md
     Reason: Guardian pattern updated with new layer naming, RLM language integrated
     Detected: 2026-02-10
     Pending in: 1 commit

  🚇 Architecture Layer (1 pending):
     ANT-ARCHITECTURE.md
     Reason: Automation boundary and layer hierarchy updated with graduation-ready names
     Detected: 2026-02-10
     Pending in: 1 commit

💡 Suggested Next Steps

  1. Review Pending Doc Changes
     /ant-review-suggestions
     → You have 4 pending doc reviews (strategy, product, patterns, architecture)
     → Detected from latest refactoring commit (3bfe788)

  2. Run Full Validation Check
     /ant-check-consistency
     → Last validation 2 days ago found 0 issues
     → Run again to verify current state

  3. View Validation ROI
     /ant-validation-report
     → Cost: $0.008, Value: 8 violations prevented
     → Guides whether to keep validation enabled

════════════════════════════════════
Status: HEALTHY ✓
Adoption Stage: full
Last Commit: accf480 feat: add visual charts and marketing
Next Action: Review 4 pending docs with /ant-review-suggestions
```

## Success Criteria

After running `/ant-status`:
- ✓ Clear view of core file status and readiness
- ✓ Configuration and adoption stage visible
- ✓ Validation metrics shown (violations, cost, prevented)
- ✓ Recent ANT doc updates highlighted with context
- ✓ Pending reviews listed by layer with reasons
- ✓ Actionable next steps provided
- ✓ Installation health assessed (HEALTHY/DEGRADED/BROKEN)

## Related Commands

- `/ant-validate` - Deep health check with RLM validation
- `/ant-review-suggestions` - Batch interface for pending doc reviews
- `/ant-check-consistency` - Run full validation
- `/ant-validation-report` - Show validation metrics and ROI
- `/ant-commit` - Make changes with automatic doc updates
- `/ant-init` - Initialize colony (if missing components)
- `/ant-graduate` - Promote adoption stage

## Notes

- Status focuses on readiness and recent activity, not code quality
- Pending reviews detected automatically by worker ant
- Validation metrics require validation log entries (enable to track)
- Use regularly to track ANT documentation updates and pending work
- Exit code 0 = ready to work; exit code 2 = run `/ant-init`
