---
description: Validate pattern and rule consistency
allowed-tools: Read, Bash, Task
---

# /ant-check-consistency - Validate Pattern and Rule Consistency

**Purpose:** Run all guardian agents to validate that the project follows alexANTria patterns and rules.

**Layer:** Chambers (🏛️)

## Overview

The `/ant-check-consistency` command spawns all 5 guardian agents (Surface, Tunnels, Chambers, Nest, Queen) to validate consistency across the entire project. This is an on-demand deep check for pattern violations, rule compliance, and strategic alignment.

## Problem

alexANTria has many patterns and rules:
- Naming conventions (`ant-*`, `ANT-*.md`)
- Structural constraints (automation boundary, ANT-* only)
- Documentation coherence (schema matches config, commands listed in README)
- Strategic principles (read-act-repair, no coexistence, minimal docs)

Without systematic validation, violations accumulate and the system degrades.

## When to Use

**Run /ant-check-consistency:**
- After major changes (new features, refactoring)
- Before releasing updates
- When onboarding new contributors
- Periodically (monthly) to catch drift
- After implementing a plan (verify patterns followed)

**Don't run constantly:**
- Worker ant runs surface/tunnels guardians at commit time
- This is for comprehensive, cross-layer validation
- Cost is ~$0.01-0.02 per run (all 5 Haiku agents)

## Workflow

```
User: "/ant-check-consistency"

1. Read configuration
   - Check if validation enabled
   - Check validation level (critical | full)

2. Scan project for changes since last check
   - git log --oneline -20
   - Find all relevant files (commands, ANT-* docs, config, templates)

3. Spawn guardian agents (in parallel)
   - 🌱 Surface Guardian
   - 🚇 Tunnels Guardian
   - 🏛️ Chambers Guardian
   - 🐜 Nest Guardian
   - 👑 Queen Guardian

4. Collect reports from all guardians

5. Aggregate results
   - Count PASS vs FAIL vs REQUIRES_APPROVAL
   - List all violations by layer
   - Group by severity (critical vs warnings)

6. Display comprehensive report
   - Show status by layer
   - List violations with fixes
   - Suggest next steps

7. Update manifest
   - Record consistency check
   - Store violations for tracking
```

## Agent Instructions

```markdown
When the user says "/ant-check-consistency":

1. **Check if validation enabled:**
   ```
   Read .alexantria/config.json
   Check: validation.enabled (default: false)
   ```

   If not enabled:
   - Ask user: "Enable validation? This will run guardian checks at commit time."
   - If yes: Update config.json, continue
   - If no: Explain this is opt-in, exit

2. **Gather project context:**
   ```bash
   # Recent changes
   git log --oneline -20

   # All relevant files
   ls user-level/commands/*.md
   find . -name "ANT-*.md" -type f | grep -v node_modules
   ls .alexantria/*.json
   ls templates/*.template
   ```

3. **Spawn all 5 guardians in parallel:**

   Use Task tool for each guardian:

   **Surface Guardian:**
   ```
   - subagent_type: "general-purpose"
   - model: "haiku"
   - description: "Surface Guardian validation"
   - prompt: "Read user-level/commands/guardians/surface-guardian.md and follow instructions.

     Validate entire project for surface-level consistency:
     - All commands in user-level/commands/
     - All ANT-SURFACE.md files
     - All templates
     - commands/README.md coherence"
   ```

   **Tunnels Guardian:**
   ```
   - subagent_type: "general-purpose"
   - model: "haiku"
   - description: "Tunnels Guardian validation"
   - prompt: "Read user-level/commands/guardians/tunnels-guardian.md and follow instructions.

     Validate:
     - Config schema matches actual config
     - Command structure consistency
     - Worker ant configuration
     - Template structure"
   ```

   **Chambers Guardian:**
   ```
   - subagent_type: "general-purpose"
   - model: "haiku"
   - description: "Chambers Guardian validation"
   - prompt: "Read user-level/commands/guardians/chambers-guardian.md and follow instructions.

     Validate:
     - Pattern consistency across commands
     - Guardian prompts follow same structure
     - Cross-cutting conventions
     - Duplication detection"
   ```

   **Nest Guardian:**
   ```
   - subagent_type: "general-purpose"
   - model: "haiku"
   - description: "Nest Guardian validation"
   - prompt: "Read user-level/commands/guardians/nest-guardian.md and follow instructions.

     Validate:
     - Adoption stages are logical
     - Workflows are coherent
     - Product features align with vision
     - Business rules consistent"
   ```

   **Queen Guardian:**
   ```
   - subagent_type: "general-purpose"
   - model: "haiku"
   - description: "Queen Guardian validation"
   - prompt: "Read user-level/commands/guardians/queen-guardian.md and follow instructions.

     Validate:
     - Core principles not violated
     - ANT-* only constraint respected
     - Automation boundary enforced
     - Strategic alignment maintained"
   ```

4. **Collect all guardian reports:**

   Parse each report for:
   - Status (PASS | FAIL | REQUIRES_APPROVAL)
   - Violations list
   - Documentation gaps
   - Approved changes

5. **Generate comprehensive report:**
   ```
   🏛️ Consistency Check Report
   ════════════════════════════════════

   Overall Status: [PASS | FAIL | REQUIRES_APPROVAL]

   Guardian Results:
   🌱 Surface Guardian:   [✓ PASS | ✗ FAIL]
   🚇 Tunnels Guardian:   [✓ PASS | ✗ FAIL]
   🏛️ Chambers Guardian:  [✓ PASS | ✗ FAIL]
   🐜 Nest Guardian:      [✓ PASS | ✗ FAIL]
   👑 Queen Guardian:     [✓ PASS | ✗ FAIL]

   Critical Violations (must fix):
   1. [layer]: [violation]
      Fix: [action]

   Warnings (should fix):
   1. [layer]: [issue]
      Fix: [action]

   Documentation Gaps:
   - [what's missing]

   Next Steps:
   [Based on status, suggest what to do next]
   ```

6. **Update manifest:**
   ```
   Add to .alexantria/manifest.json:
   {
     "consistency_checks": [
       {
         "timestamp": "<ISO-8601>",
         "status": "PASS|FAIL",
         "violations": [...],
         "guardians_consulted": ["surface", "tunnels", "chambers", "nest", "queen"]
       }
     ]
   }
   ```

7. **Suggest next actions:**
   - If PASS: "All patterns followed. System is consistent."
   - If FAIL: "Fix violations listed above, then re-run /ant-check-consistency"
   - If REQUIRES_APPROVAL: "User must approve strategic changes before proceeding"
```

## Validation Levels

From config: `validation.level`

### critical (default)
- Only check naming conventions and structural violations
- Fast, catches high-impact issues
- Cost: ~$0.005 per check

### full
- Check everything (coherence, cross-references, duplication)
- Slower, comprehensive
- Cost: ~$0.01-0.02 per check

## Configuration

In `.alexantria/config.json`:

```json
{
  "validation": {
    "enabled": true,
    "level": "critical",
    "checkpoints": {
      "pre_commit": true,
      "on_demand": true
    }
  }
}
```

## Success Criteria

After running `/ant-check-consistency`:
- ✓ All 5 guardians consulted
- ✓ Comprehensive report generated
- ✓ Violations listed with fixes
- ✓ Next steps clear
- ✓ Manifest updated

## Related Commands

- `/ant-validate` - Check installation health (files exist)
- `/ant-commit` - Runs surface/tunnels guardians automatically
- `/ant-review-suggestions` - Apply higher-layer doc suggestions

## Notes

- This is opt-in (requires validation.enabled = true)
- Costs ~$0.01-0.02 per full check (5 Haiku agents)
- Run periodically, not constantly
- Worker ant runs subset of guardians at commit time
- Guardians are stateless (no learning, just validation)
