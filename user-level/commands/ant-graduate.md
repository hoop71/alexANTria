---
description: Graduate ANT-* file to native file
allowed-tools: Read, Write, Edit, Bash, AskUserQuestion, Glob
---

# 🎓 Ant Graduate: Convert ANT-* to Native Files

Graduates an ANT-* file to its native equivalent, marking full adoption.

## Philosophy

You've been running alexANTria in pilot mode with ANT-* files alongside your existing docs. Now you're ready to adopt fully. This command converts ANT-* files to their native equivalents (README.md, ARCHITECTURE.md, etc.) and updates the system to maintain them directly.

**This is a one-way operation.** Once graduated, the ANT-* file is removed and the native file becomes the source of truth.

## Usage

```bash
/ant-graduate <file>

# Examples:
/ant-graduate ANT-README.md
/ant-graduate ANT-ARCHITECTURE.md
/ant-graduate .alexantria/ANT-STRATEGY.md
```

## What This Does

1. **Validates** the ANT-* file is well-maintained and up-to-date
2. **Backs up** existing native file (if it exists) to `<filename>.backup`
3. **Graduates** ANT-* file → native file (rename or merge)
4. **Updates config** to mark file as graduated
5. **Updates worker ant** to maintain the native file directly
6. **Stages changes** for review

## Graduation Targets

```
ANT-STRATEGY.md      → STRATEGY.md
ANT-PRODUCT.md       → PRODUCT.md
ANT-PATTERNS.md      → PATTERNS.md
ANT-ARCHITECTURE.md  → ARCHITECTURE.md
ANT-README.md        → README.md
```

## Prerequisites

Before graduating, ensure:
- ANT-* file is well-maintained (use `/ant-validate`)
- Content is accurate and up-to-date
- Team has reviewed and approved the content
- You're ready for full adoption (no going back)

## Phase 1: Validate

Check that the ANT-* file is ready to graduate:

```bash
{
  echo "=== FILE EXISTS ==="
  ls -lh <ant-file>

  echo "=== LAST MODIFIED ==="
  git log -1 --format="%h %ai %s" -- <ant-file>

  echo "=== TARGET FILE ==="
  ls -lh <native-file> 2>/dev/null || echo "Does not exist"

  echo "=== CONFIG ==="
  cat .alexantria/config.json | grep -A 10 "managed_files"
}
```

**Check:**
- ANT-* file exists and has recent updates
- Content looks accurate
- Native file either doesn't exist or is safe to replace

If validation fails, stop and ask user to review.

## Phase 2: Confirm with User

Use `AskUserQuestion` to confirm:

```
Question: "Graduate ANT-README.md → README.md?"
Header: "Graduation"
Options:

1. Graduate (replace existing)
   Description: Remove ANT-README.md, replace README.md with its content. Existing README.md backed up to README.md.backup.

2. Graduate (merge)
   Description: Merge ANT-README.md content into existing README.md. Preserve existing sections, add ANT content. More manual work.

3. Cancel
   Description: Don't graduate yet. Keep ANT-* file for now.
```

## Phase 3: Execute Graduation

Based on user selection:

### Option 1: Replace

```bash
# Back up existing file
if [ -f <native-file> ]; then
  cp <native-file> <native-file>.backup
  git add <native-file>.backup
fi

# Graduate
git mv <ant-file> <native-file>
```

### Option 2: Merge

1. Read both files
2. Show user a proposed merge (preserve native file structure, inject ANT-* content)
3. Ask user to review and approve
4. Write merged content to native file
5. Remove ANT-* file

### Option 3: Cancel

Stop. Don't graduate.

## Phase 4: Update Config

Update `.alexantria/config.json` to track graduation:

```json
{
  "scope": {
    "graduated_files": {
      "README.md": {
        "graduated_from": "ANT-README.md",
        "graduated_at": "2026-02-10T12:00:00Z",
        "auto_maintain": true,
        "pool": "programmatic",
        "native_target": "README.md"
      }
    }
  }
}
```

**This tells worker ant:**
- Maintain README.md directly (no longer ANT-README.md)
- File has graduated (no longer in pilot mode)
- Track which ANT-* file it came from (for history)

## Phase 5: Update Manifest

Add graduation record to `.alexantria/manifest.json`:

```json
{
  "graduations": [
    {
      "timestamp": "2026-02-10T12:00:00Z",
      "ant_file": "ANT-README.md",
      "native_file": "README.md",
      "backup_created": "README.md.backup",
      "commit": "abc1234"
    }
  ]
}
```

## Phase 6: Summary

Show user what was done:

```
🎓 Graduation Complete

Graduated:
  ANT-README.md → README.md

Actions:
  ✓ Backed up existing README.md → README.md.backup
  ✓ Moved ANT-README.md → README.md
  ✓ Updated config (graduated_files)
  ✓ Updated manifest (graduations log)
  ✓ Staged all changes

Next steps:
  1. Review the changes (git diff --staged)
  2. Commit when ready (/ant-commit "Graduate ANT-README.md → README.md")
  3. Worker ant will now maintain README.md directly

To revert (if needed):
  git reset HEAD
  git checkout .
  git mv README.md ANT-README.md
  git mv README.md.backup README.md
```

## Safety

- **Always backs up** existing native files
- **Stages changes** for user review before committing
- **One file at a time** (no bulk graduation)
- **Reversible** (before commit) via git operations

## Team Adoption

When graduating in a team environment:

1. Coordinate with team (don't surprise them)
2. Graduate one file at a time
3. Verify CI/CD still works
4. Update team docs about which files are now native
5. Consider graduating lower layers first (ANT-README.md) before higher layers (ANT-STRATEGY.md)

## Notes

- Graduation is per-file, not per-layer
- Can graduate files in any order (but recommend bottom-up)
- Once graduated, ANT-* prefix is removed from that file
- Worker ant adapts automatically (config tells it what to maintain)
- Can graduate some files while keeping others as ANT-* (mixed mode)

## When NOT to Graduate

Keep ANT-* files if:
- Still in pilot mode (testing the system)
- Team hasn't fully bought in yet
- Want clear separation between "maintained by alexANTria" vs "maintained manually"
- Need easy removal path (delete all ANT-* = system gone)

Graduate when:
- Team has adopted alexANTria fully
- Content is proven accurate and valuable
- Want ANT-* files to become the canonical docs
- Ready for long-term commitment
