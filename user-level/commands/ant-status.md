---
description: Show installation state, validation status, and recent commits
allowed-tools: Read, Bash, Glob, Grep
---

# 🐜 Ant Status: Colony Health at a Glance

Show the current state of alexANTria: what's installed, what's working, recent changes, and suggested next actions.

**Scope:** Installation state + validation status + commit history + recommended actions
**Not in scope:** Deep troubleshooting (use `/ant-validate` for that), manual repairs

## Philosophy

When working with alexANTria, you need to know:
- Is the colony properly installed?
- Are the docs and code in sync?
- What changed recently?
- What should I do next?

This command answers those questions in **one consolidated view** - no hunting through logs or files.

## Instructions

When the user runs `/ant-status`:

### Step 1: Gather Installation State

Use a single consolidated bash command to check all critical files:

```bash
{
  echo "=== INSTALLATION ==="
  test -f CLAUDE.md && echo "claude_md=yes" || echo "claude_md=no"
  test -d .claude && echo "claude_rules=yes" || echo "claude_rules=no"
  test -d .alexantria && echo "alexantria_dir=yes" || echo "alexantria_dir=no"
  test -f .alexantria/config.json && echo "config=yes" || echo "config=no"
  test -f .alexantria/manifest.json && echo "manifest=yes" || echo "manifest=no"
  test -d .git/hooks && ls .git/hooks/pre-commit >/dev/null 2>&1 && echo "hook=yes" || echo "hook=no"

  echo "=== CONFIGURATION ==="
  if [ -f .alexantria/config.json ]; then
    jq -r '.scope.starting_level // "unknown"' .alexantria/config.json 2>/dev/null | xargs echo "starting_level="
    jq -r '.scope.adoption_stage // "unknown"' .alexantria/config.json 2>/dev/null | xargs echo "adoption_stage="
    jq -r '.collaboration.mode // "team_shared"' .alexantria/config.json 2>/dev/null | xargs echo "collaboration_mode="
    jq -r '.collaboration.gitignored_at // "null"' .alexantria/config.json 2>/dev/null | xargs echo "gitignored_at="
    jq -r '.collaboration.published_at // "null"' .alexantria/config.json 2>/dev/null | xargs echo "published_at="
  fi

  echo "=== MANIFEST ==="
  if [ -f .alexantria/manifest.json ]; then
    jq '.changes | length' .alexantria/manifest.json 2>/dev/null | xargs echo "commits_tracked="
    jq '.suggested_reviews | length' .alexantria/manifest.json 2>/dev/null | xargs echo "pending_reviews="
  fi

  echo "=== RECENT COMMITS ==="
  git log --oneline -5 2>/dev/null | head -5 || echo "no_git_history"

  echo "=== VALIDATION STATUS ==="
  test -f .alexantria/.last_validation && cat .alexantria/.last_validation || echo "never_validated"
}
```

### Step 2: Read Configuration Files

Use Read tool (silently) to extract:
- `.alexantria/config.json` — scope, starting_level, adoption_stage
- `.alexantria/manifest.json` — recent changes, pending reviews

Parse JSON to get:
- Worker ant enabled/disabled
- Which directories are managed
- How many commits tracked
- Any pending doc review suggestions

### Step 3: Check Recent Commits

Run git log to find:
- Last 5 commits
- Which ones included ANT-* file updates
- Pattern of doc changes (increasing/decreasing)

### Step 4: Determine Status Code

Categorize the installation state:

**HEALTHY** (green):
- CLAUDE.md exists
- .alexantria/ directory exists with config.json and manifest.json
- At least one commit tracked
- No pending reviews older than 7 days

**DEGRADED** (yellow):
- Missing optional components (hook, some ANT-* files)
- Pending reviews without recent action
- Config exists but missing fields
- Installation incomplete but functional

**BROKEN** (red):
- CLAUDE.md missing
- .alexantria/config.json or manifest.json invalid
- No commits tracked (initialization incomplete)
- Cannot parse configuration

**UNINITIALIZED** (gray):
- No .alexantria/ directory
- Run `/ant-init` to set up

### Step 5: Suggest Next Actions

Based on status, recommend:

**If HEALTHY:**
- "Ready to commit" (if changes staged)
- "Review pending suggestions" (if any)
- "Run /ant-validate for detailed health check"

**If DEGRADED:**
- "Fix pending reviews" (link to /ant-review-suggestions)
- "Complete initialization" (if missing config)
- "Reinstall hook" (if hook missing but enabled in config)

**If BROKEN:**
- "Run /ant-validate to diagnose"
- "Run /ant-init to reinitialize"

**If UNINITIALIZED:**
- "Run /ant-init to establish the colony"

### Step 6: Output Formatted Report

**IMPORTANT:** After gathering all data, output a **single formatted report** to the user. Do NOT show individual bash commands or file reads.

```
🐜 Colony Status Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📍 Collaboration Mode
  [If local_only:]
    Mode: Local-only (private)
    Gitignored since: [timestamp]
    Files private: .alexantria/ (except config.json), CLAUDE.md, .claude/, ANT-*.md

    → Run /ant-publish to share with team

  [If team_shared:]
    Mode: Team-shared
    [If published_at not null:] Published: [timestamp]
    Files tracked in git

📊 Installation State
  [✓] CLAUDE.md found
  [✓] .alexantria/ directory found
  [✓] config.json valid
  [✓] manifest.json valid

⚙️  Configuration
  Starting Level: tunnels
  Adoption Stage: active
  Managed Paths: ["src/**", "lib/**"]
  Worker Ant: enabled (auto mode)

📝 Change Tracking
  Commits Tracked: 12
  Last Commit: "feat: add ant-status command" (2h ago)
  Pending Reviews: 1 (from 5h ago)

🔄 Recent Changes
  5 days ago:  feat: add visual charts and marketing (ANT-PATTERNS.md updated)
  6 days ago:  feat: add /ant-validate-rlm (ANT-SURFACE.md updated)
  7 days ago:  fix: remove git hook requirement (ANT-STRATEGY.md updated)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Status: HEALTHY ✓

🎯 Suggested Actions
  1. Review 1 pending suggestion
     Run: /ant-review-suggestions

  2. Ready for next commit
     Staged files: 0
     Run: Make changes or /ant-commit when ready

  3. Detailed health check
     Run: /ant-validate
     (Shows RLM validation, rule compliance, structure)

Next Step: /ant-review-suggestions or make code changes
```

Use these symbols:
- `[✓]` Pass (green)
- `[✗]` Fail (red)
- `[?]` Warning (yellow)
- `[i]` Info

### Step 7: Exit Codes and Status Summary

Determine final status:
- **0 (HEALTHY)**: All components present, no critical issues
- **1 (DEGRADED)**: Some components missing or issues present
- **2 (BROKEN)**: Critical components missing, cannot function
- **3 (UNINITIALIZED)**: No .alexantria/ directory found

## Output Format Template

```
🐜 Colony Status Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📍 Collaboration Mode: [Local-only | Team-shared]
  [If local-only:]
    Gitignored since: [timestamp]
    Files private: .alexantria/, CLAUDE.md, .claude/, ANT-*.md
    → Run /ant-publish to share with team
  [If team-shared:]
    [If published:] Published: [timestamp]

📊 Installation State
  [✓] CLAUDE.md
  [✓] .claude/ rules directory
  [✓] .alexantria/ configuration
  [i] .git/hooks/pre-commit not found (optional)

⚙️  Configuration
  Starting Level: [surface|tunnels|chambers]
  Adoption Stage: [pilot|active|full]
  Managed Paths: [list]
  Worker Ant Enabled: [yes|no]

📝 Change Tracking
  Commits Tracked: [count]
  Last Sync: [timestamp or never]
  Pending Reviews: [count]

🔄 Recent Commits
  [5 most recent commits with ANT-* file markers]
  [X] feat: add feature (ANT-SURFACE.md updated)
  [X] fix: bug fix (no ANT-* changes)
  [ ] docs: update docs (manual update)

🔍 Validation Status
  Last Validated: [timestamp or never run]
  RLM Tests: [passed/failed if run]
  Structure: [valid/invalid]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Status: [HEALTHY|DEGRADED|BROKEN|UNINITIALIZED]

🎯 Suggested Next Actions
  [3-5 specific actionable items based on status]
  [If healthy: suggest review, validate, or next work]
  [If degraded: suggest fixes with commands]
  [If broken: suggest /ant-validate or /ant-init]
  [If uninitialized: suggest /ant-init]

Tip: Run /ant-validate for deep health check
```

## Visual Guidelines

**Symbols:**
- `[✓]` Pass (installation/validation successful)
- `[✗]` Fail (critical issue found)
- `[?]` Warning (optional component missing)
- `[i]` Info (informational, not required)
- `[X]` Change marker (file was updated)
- `[ ]` No change marker (file not updated)

**Status Colors (conceptual):**
- **HEALTHY** (0): Green ✓
- **DEGRADED** (1): Yellow ⚠
- **BROKEN** (2): Red ✗
- **UNINITIALIZED** (3): Gray —

**Progress indicators:**
- Commits tracked: Show as list with recent timestamps
- Pending reviews: Show count and age
- Configuration: Show key settings (starting_level, adoption_stage)

## Implementation Notes

**DO:**
- Consolidate all file checks into ONE bash command
- Use Read tool silently (don't show output)
- Process JSON data internally
- Output ONE formatted report at the end
- Make it visual with emojis and box drawing
- Keep it concise (fits in one terminal window)
- Reference ANT patterns and command names

**DON'T:**
- Show individual bash commands
- Show raw JSON or file contents
- Output multiple times
- Make it too long or detailed
- Forget to suggest next actions

## Related Commands

- `/ant-validate` — Deep installation health check
- `/ant-review-suggestions` — Review pending doc update suggestions
- `/ant-commit` — Commit with worker ant
- `/ant-init` — Initialize colony
- `/ant-update` — Manual doc update

## Example Scenarios

### Scenario 1: Healthy, Ready to Work
```
User: /ant-status

Output: [HEALTHY] ✓
- Installation complete
- 12 commits tracked
- 1 pending review (old, can ignore)
- Ready to work

Next: Make changes or review suggestions
```

### Scenario 2: Degraded, Missing Reviews
```
User: /ant-status

Output: [DEGRADED] ⚠
- Installation mostly complete
- 8 commits tracked
- 3 pending reviews (1-2 days old)
- Missing pre-commit hook (optional)

Next: Run /ant-review-suggestions to address pending changes
```

### Scenario 3: Broken, Needs Init
```
User: /ant-status

Output: [BROKEN] ✗
- CLAUDE.md found
- .alexantria/ directory missing
- Config/manifest not found

Next: Run /ant-init to establish colony
```

### Scenario 4: Uninitialized
```
User: /ant-status

Output: [UNINITIALIZED] —
- .alexantria/ directory not found
- No configuration detected

Next: Run /ant-init to set up alexANTria
```

## Notes

- This command is **read-only** — it doesn't modify files
- Shows state **at this moment** — run again for updates
- Useful before starting work to understand what's changed
- Useful after `/ant-commit` to verify what was staged
- Can be run frequently without side effects
- Good for CI/CD status checks
- References ANT naming conventions (ant-*, ANT-*, .alexantria/)
