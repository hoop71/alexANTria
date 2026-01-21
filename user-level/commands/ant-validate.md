---
description: Check installation health
allowed-tools: Read, Glob, Grep, Bash
---

# 🐜 Ant Validate: Check Installation Health

Verify that alexANTria is properly installed and configured in the current project.

**Scope:** Installation health only (files exist, structure correct)
**Not in scope:** Pattern consistency, rule violations (use `/ant-check-consistency` for that)

## Instructions

When the user runs `/ant-validate`:

### Step 1: Gather Data Silently

Use a **single consolidated bash command** to check all file existence:

```bash
{
  echo "=== CORE ==="
  test -f CLAUDE.md && echo "CLAUDE.md=exists" || echo "CLAUDE.md=missing"
  test -d .claude/rules && echo "rules=exists" || echo "rules=missing"
  test -d .alexantria && echo "alexantria=exists" || echo "alexantria=missing"
  test -f .git/hooks/post-commit && echo "hook=exists" || echo "hook=missing"

  echo "=== RULES ==="
  ls -1 .claude/rules/*.md 2>/dev/null | wc -l | xargs echo "rule_count="

  echo "=== CONFIG ==="
  test -f .alexantria/config.json && jq -e '.version,.scope,.validation' .alexantria/config.json >/dev/null 2>&1 && echo "config=valid" || echo "config=invalid"

  echo "=== MANIFEST ==="
  test -f .alexantria/manifest.json && jq -e '.version,.repo,.changes' .alexantria/manifest.json >/dev/null 2>&1 && echo "manifest=valid" || echo "manifest=invalid"
  jq '.changes | length' .alexantria/manifest.json 2>/dev/null | xargs echo "commit_count=" || echo "commit_count=0"
}
```

### Step 2: Read Critical Files

Use Read tool (silent, no output to user) to check:
- CLAUDE.md structure (grep for layer emojis, sections)
- .alexantria/config.json (parse JSON)
- .alexantria/manifest.json (parse JSON)

### Step 3: Validate Structure

Check CLAUDEMD content for:
- All 5 layer emojis present (👑 🐜 🏛️ 🚇 🌱)
- "When to Read" section exists
- "After Completing Work" section exists

### Step 4: Output Formatted Report

**IMPORTANT:** After gathering all data, output a **single formatted report** to the user. Do NOT show individual bash commands or file reads. The user sees only the final report:

```
🐜 Colony Health Report
━━━━━━━━━━━━━━━━━━━━━━━━

📁 Core Structure
  [✓] CLAUDE.md
  [✓] .claude/rules/ (3 files)
  [✓] .alexantria/ directory
  [✗] Git post-commit hook

📋 CLAUDE.md
  [✓] All 5 layers present
  [✓] "When to Read" section
  [✓] "After Completing Work" section

⚙️  Configuration
  [✓] config.json valid
  [✓] manifest.json valid
  [✓] 6 commits tracked

━━━━━━━━━━━━━━━━━━━━━━━━
Status: HEALTHY ✓

Exit Code: 0
```

Use these symbols:
- `[✓]` Pass (green conceptually)
- `[✗]` Fail (red conceptually)
- `[?]` Warning (yellow conceptually)
- `[i]` Info

### Step 5: Exit Codes

Determine status:
- **0 (HEALTHY)**: All critical components present
- **1 (DEGRADED)**: Missing optional components
- **2 (BROKEN)**: Missing critical files

## Output Format Template

```
🐜 Colony Health Report
━━━━━━━━━━━━━━━━━━━━━━━━

Core Structure:
  [✓] CLAUDE.md exists
  [✓] .claude/rules/ exists (3 rules found)
  [✓] .alexantria/ exists
  [✗] .git/hooks/post-commit missing

CLAUDE.md Validation:
  [✓] Contains "The Anthill" section
  [✓] All 5 layers present
  [✓] "When to Read" table found
  [✓] "After Completing Work" section found

Rules Validation:
  [✓] frontend.md (2 paths configured)
  [✓] backend.md (1 path configured)
  [?] templates.md (no paths in frontmatter - is this intentional?)

Manifest Validation:
  [✓] .alexantria/manifest.json exists
  [✓] Valid JSON structure
  [✓] Required fields present
  [✓] 5 commit entries recorded

Git Hook:
  [✗] Hook not installed
  [i] Run /ant-init to install the post-commit hook

Overall Status: HEALTHY (1 warning, 1 missing component)

Recommendations:
  - Install git hook for automatic commit tracking
  - Consider adding paths to templates.md or move to docs/
```

## Visual Guidelines

**Symbols:**
- `[✓]` Pass (green conceptually)
- `[✗]` Fail (red conceptually)
- `[?]` Warning (yellow conceptually)
- `[i]` Info/suggestion

**Exit Codes:**
- **0 (HEALTHY)**: All critical components present
- **1 (DEGRADED)**: Missing optional components
- **2 (BROKEN)**: Missing critical files, run /ant-init

## Implementation Notes

**DO:**
- Consolidate all file checks into ONE bash command
- Use Read/Grep tools silently (don't show to user)
- Process and validate data internally
- Output ONE formatted report at the end
- Use emojis and box drawing for visual appeal

**DON'T:**
- Show individual bash commands (ls, test, grep, etc.)
- Show raw file reads
- Show intermediate validation steps
- Output multiple times during execution

The user should see:
1. Your initial message ("Running health check...")
2. ONE consolidated bash command (if needed for data gathering)
3. The final formatted report

That's it. Clean, visual, professional.
