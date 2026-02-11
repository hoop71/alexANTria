---
description: Show validation metrics and ROI
allowed-tools: Read, Bash
---

# /ant-validation-report - Validation Metrics and ROI Analysis

**Purpose:** Analyze validation log to show violations caught, cost incurred, and value-to-cost ratio.

**Layer:** Architecture (Programmatic)

## Overview

The `/ant-validation-report` command reads the `validation_log` from the manifest and generates a comprehensive report showing:
- How many violations were caught
- How much it cost
- Which guardians are most valuable
- Whether the system is improving over time
- ROI (value vs cost)

## Problem

Without metrics, we can't answer:
- Are guardians worth the cost?
- Which guardians catch the most issues?
- Is the system getting better (fewer violations over time)?
- Should we increase/decrease validation frequency?

## Workflow

```
User: "/ant-validation-report"

1. Read .alexantria/manifest.json → validation_log array
2. Analyze all validation entries
3. Calculate summary metrics:
   - Total validations run
   - Total violations caught
   - Total cost incurred
   - Value-to-cost ratio
4. Generate reports:
   - Overall summary
   - By guardian (which catches most)
   - By time (trend analysis)
   - By type (naming vs semantic)
5. Display recommendations
```

## Agent Instructions

```markdown
When the user says "/ant-validation-report" or provides optional time range:

1. **Read validation log:**
   ```
   Read .alexantria/manifest.json
   Parse validation_log array
   ```

   Optional filters:
   - `/ant-validation-report --last 7d` (last 7 days)
   - `/ant-validation-report --last 30d` (last 30 days)
   - `/ant-validation-report --all` (all time, default)

2. **Calculate overall metrics:**

   ```
   total_validations = validation_log.length
   total_violations = sum(entry.total_violations for all entries)
   total_cost = sum(entry.total_cost_usd for all entries)

   bash_violations = count violations from bash_checks
   guardian_violations = count violations from guardians

   prevented_issues = count entries where prevented_issues = true
   ```

3. **Calculate value score:**

   Assign points based on violation type:
   - Naming/structure (bash): 1 point
   - Documentation gap: 3 points
   - Pattern inconsistency: 5 points
   - Strategic violation: 10 points

   ```
   total_value_points = sum of all violation scores
   value_to_cost_ratio = total_value_points / total_cost
   ```

4. **Analyze by guardian:**

   For each guardian (service, architecture, patterns, product, strategy):
   ```
   times_consulted = count entries with this guardian
   violations_caught = sum violations from this guardian
   cost_incurred = sum cost_usd from this guardian
   guardian_ratio = violations_caught / cost_incurred
   ```

5. **Analyze trends:**

   Group by time periods (weekly):
   ```
   violations_per_week = [week1_count, week2_count, ...]
   cost_per_week = [week1_cost, week2_cost, ...]

   trend = "improving" if violations decreasing
   trend = "stable" if roughly constant
   trend = "degrading" if violations increasing
   ```

6. **Generate report:**

   ```
   🏛️ Validation Report
   ════════════════════════════════════

   Time Period: [Last 7 days | Last 30 days | All time]
   Report Generated: <timestamp>

   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Overall Summary
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   Total Validations: <count>
   Total Violations Caught: <count>
     - Bash checks: <count> (free)
     - Guardian checks: <count> ($<cost>)

   Total Cost: $<total_cost>
   Value Score: <points> points
   Value-to-Cost Ratio: <ratio> points per dollar

   Issues Prevented: <count>/<total> validations caught problems

   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Guardian Performance
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   🌱 Service Guardian
      Times Consulted: <count>
      Violations Caught: <count>
      Cost: $<cost>
      Efficiency: <violations/cost> per dollar

   🚇 Architecture Guardian
      Times Consulted: <count>
      Violations Caught: <count>
      Cost: $<cost>
      Efficiency: <violations/cost> per dollar

   🏛️ Patterns Guardian
      Times Consulted: <count>
      Violations Caught: <count>
      Cost: $<cost>
      Efficiency: <violations/cost> per dollar

   🐜 Product Guardian
      Times Consulted: <count>
      Violations Caught: <count>
      Cost: $<cost>
      Efficiency: <violations/cost> per dollar

   👑 Strategy Guardian
      Times Consulted: <count>
      Violations Caught: <count>
      Cost: $<cost>
      Efficiency: <violations/cost> per dollar

   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Violation Types
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   Naming Violations: <count> (caught by bash + surface)
   Structure Violations: <count> (caught by bash + tunnels)
   Documentation Gaps: <count> (caught by tunnels + chambers)
   Pattern Inconsistencies: <count> (caught by chambers)
   Strategic Violations: <count> (caught by nest + queen)

   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Trend Analysis
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   Status: [Improving ✓ | Stable ~ | Degrading ✗]

   Weekly Breakdown:
   Week 1: <violations> violations, $<cost>
   Week 2: <violations> violations, $<cost>
   Week 3: <violations> violations, $<cost>
   Week 4: <violations> violations, $<cost>

   [If improving]: Violations decreasing over time - system learning!
   [If stable]: Consistent violation rate - system maintaining quality
   [If degrading]: Violations increasing - may need attention

   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Most Common Violations
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   1. <type>: <count> times
      Example: <most recent example>

   2. <type>: <count> times
      Example: <most recent example>

   3. <type>: <count> times
      Example: <most recent example>

   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Recommendations
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   [Based on metrics, suggest actions]

   If ratio > 1000: Excellent ROI - guardians provide great value
   If ratio 500-1000: Good ROI - guardians worth the cost
   If ratio 100-500: Marginal ROI - consider adjusting frequency
   If ratio < 100: Poor ROI - consider disabling guardians

   If violations decreasing: System improving, keep current approach
   If violations stable: System healthy, maintain current frequency
   If violations increasing: Investigate - new patterns? More complexity?

   If specific guardian has 0 violations: Consider removing it
   If specific guardian has high violations: Consider increasing frequency

   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Cost Projection
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   Current daily average: $<avg_daily>
   Projected monthly: $<monthly>
   Projected yearly: $<yearly>

   [If projection concerning]: Consider:
   - Reduce validation frequency
   - Disable less valuable guardians
   - Increase bash check coverage (free)
   ```

7. **Suggest actions based on findings:**

   If value-to-cost ratio is low:
   - "Consider disabling validation or reducing frequency"
   - "Focus on bash checks, disable guardians"

   If specific guardian finds nothing:
   - "Strategy Guardian has 0 violations in 30 days - consider removing it"

   If violations increasing:
   - "Violations trending up - review recent changes for systematic issues"

   If cost too high:
   - "Monthly projection: $50 - consider disabling or reducing frequency"
```

## Example Output

```
🏛️ Validation Report
════════════════════════════════════

Time Period: Last 30 days
Report Generated: 2026-01-20T15:30:00Z

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Overall Summary
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Total Validations: 47
Total Violations Caught: 12
  - Bash checks: 8 (free)
  - Guardian checks: 4 ($0.012)

Total Cost: $0.12
Value Score: 34 points
Value-to-Cost Ratio: 283 points per dollar

Issues Prevented: 12/47 validations caught problems

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Guardian Performance
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🌱 Service Guardian
   Times Consulted: 15
   Violations Caught: 3
   Cost: $0.045
   Efficiency: 67 per dollar

🚇 Architecture Guardian
   Times Consulted: 8
   Violations Caught: 1
   Cost: $0.024
   Efficiency: 42 per dollar

🏛️ Patterns Guardian
   Times Consulted: 12
   Violations Caught: 0
   Cost: $0.036
   Efficiency: 0 per dollar ⚠️

🐜 Product Guardian
   Times Consulted: 3
   Violations Caught: 0
   Cost: $0.009
   Efficiency: 0 per dollar ⚠️

👑 Strategy Guardian
   Times Consulted: 2
   Violations Caught: 0
   Cost: $0.006
   Efficiency: 0 per dollar ⚠️

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Violation Types
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Naming Violations: 6 (caught by bash + surface)
Structure Violations: 2 (caught by bash)
Documentation Gaps: 3 (caught by service + architecture)
Pattern Inconsistencies: 1 (caught by tunnels)
Strategic Violations: 0

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Trend Analysis
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Status: Improving ✓

Weekly Breakdown:
Week 1: 5 violations, $0.04
Week 2: 4 violations, $0.03
Week 3: 2 violations, $0.03
Week 4: 1 violation, $0.02

Violations decreasing over time - system learning!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Most Common Violations
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Naming convention: 6 times
   Example: "commit.md should be ant-commit.md"

2. Missing documentation: 3 times
   Example: "New command not listed in README"

3. JSON syntax: 2 times
   Example: "config.json trailing comma"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Recommendations
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️ Marginal ROI - Value-to-cost ratio is 283 (target: >500)

Consider:
- Patterns, Product, Strategy guardians found 0 violations in 30 days
- Recommend disabling these guardians, keep Service + Architecture only
- Would save ~$0.05/month with minimal risk

✓ System improving - violations decreasing over time
- Keep current approach for Service + Architecture guardians
- Bash checks catching most issues (free)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Cost Projection
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Current daily average: $0.004
Projected monthly: $0.12
Projected yearly: $1.44

Cost is reasonable. If disabled Patterns/Product/Strategy:
Projected monthly: $0.07
Projected yearly: $0.84
```

## Success Criteria

After running `/ant-validation-report`:
- ✓ Clear metrics on violations caught
- ✓ Cost breakdown by guardian
- ✓ Value-to-cost ratio calculated
- ✓ Trends analyzed (improving/stable/degrading)
- ✓ Actionable recommendations provided
- ✓ Can prove ROI to justify cost

## Related Commands

- `/ant-check-consistency` - Run full validation check
- `/ant-commit` - Triggers validation at commit time
- `/ant-validate` - Check installation health

## Notes

- Report is based on validation_log in manifest
- First run may show "no data" if validation just enabled
- Run after 10-20 commits to get meaningful metrics
- Use to justify keeping or removing guardians
- Share with team to show value of validation system
