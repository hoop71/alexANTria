---
description: Validate alexANTria installation in a project
allowed-tools: Read, Glob, Grep, Bash
---

# 🐜 Ant Validate: Check Installation Health

Verify that alexANTria is properly installed and configured in the current project.

**Scope:** Installation health only (files exist, structure correct)
**Not in scope:** Pattern consistency, rule violations (use `/ant-check-consistency` for that)

## Philosophy

You are a scout ant checking the colony's infrastructure. Your job is to:
- Verify critical files exist
- Check that file structure is correct
- Validate config/manifest JSON syntax
- Report installation health status clearly

This command checks IF alexANTria is installed correctly, not WHETHER it's being used correctly.

## Phase 1: Check Core Structure

### Verify Essential Files

```bash
# Check for project CLAUDE.md
ls -la CLAUDE.md 2>/dev/null || echo "MISSING: CLAUDE.md"
```

```bash
# Check for .claude directory and rules
ls -la .claude/ .claude/rules/ 2>/dev/null || echo "MISSING: .claude/ or .claude/rules/"
```

```bash
# Check for alexantria state directory
ls -la .alexantria/ 2>/dev/null || echo "MISSING: .alexantria/"
```

```bash
# Check for git hooks
ls -la .git/hooks/post-commit 2>/dev/null || echo "MISSING: .git/hooks/post-commit"
```

## Phase 2: Validate CLAUDE.md Structure

Read the CLAUDE.md and check for:
- Contains "The Anthill" section
- Has all 5 layers present:
  - 👑 Queen: Strategic Alignment
  - 🐜 Nest: Product/Business Context
  - 🏛️ Chambers: Cross-Cutting Patterns
  - 🚇 Tunnels: Architecture/Service Connections
  - 🌱 Surface: Individual Service Docs
- Has "When to Read" table
- Has "After Completing Work" section

## Phase 3: Validate Rules Files

Check each rule file in `.claude/rules/`:

```bash
# List all rule files
ls -1 .claude/rules/*.md 2>/dev/null
```

For each rule file, verify:
- Has frontmatter with `paths:` array
- Paths use glob patterns
- File references docs from the hierarchy

## Phase 4: Validate Manifest

Check `.alexantria/manifest.json`:

```bash
# Check if manifest exists and can be read
test -f .alexantria/manifest.json && echo "exists" || echo "missing"
```

If manifest exists, verify structure:
- Has `version` field
- Has `repo` field
- Has `changes` array
- Each change entry has required fields: `commit`, `timestamp`, `summary`, `action`

## Phase 5: Check Git Hook

If post-commit hook exists, verify:
- Hook is executable (`-x` permission)
- Hook contains alexANTria logic (mentions `.alexantria/pending.log`)
- Hook writes to correct location

```bash
# Check hook is executable
test -x .git/hooks/post-commit && echo "executable" || echo "not executable"
```

```bash
# Check hook content
grep -q "alexantria" .git/hooks/post-commit 2>/dev/null && echo "valid" || echo "invalid"
```

## Phase 6: Report Health Status

Generate a report with pass/fail for each component:

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

## Report Symbols

Use these symbols for clarity:
- `[✓]` - Passed
- `[✗]` - Failed
- `[?]` - Warning/Questionable
- `[i]` - Info/Suggestion

## Exit Codes

After reporting, set a mental exit code:
- **0 (healthy)**: All critical components present, minor warnings OK
- **1 (degraded)**: Missing some components but functional
- **2 (broken)**: Missing critical files, not functional

Report the status clearly:
```
Exit Code: 0 (HEALTHY)
Exit Code: 1 (DEGRADED - manual commit tracking required)
Exit Code: 2 (BROKEN - run /ant-init to set up)
```

## Notes

- **Be precise** - report exactly what's missing or wrong
- **Be helpful** - suggest fixes for each issue
- **Be fast** - this is a health check, not a repair tool
- **Don't modify anything** - validation is read-only
