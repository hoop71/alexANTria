---
description: Check documentation health and drift
allowed-tools: Read, Glob, Grep, Bash
---

# 🐜 Ant Validate: Health Check

Check for drift between documentation and code. Fully automated health check.

**What it checks:**
- Files referenced in ANT-PROGRAMMATIC.md actually exist
- Patterns claimed in ANT-TOKENIZED.md are actually used in code
- New files exist that aren't documented in SURFACE
- Core structure is intact

**Not in scope:** Performance metrics, complex validations (keep it simple)

---

## Instructions

When the user runs `/ant-validate`:

### Step 1: Check Core Structure

Use a single consolidated bash command to verify alexANTria is installed:

```bash
{
  echo "=== CORE STRUCTURE ==="
  test -f CLAUDE.md && echo "✓ CLAUDE.md" || echo "✗ CLAUDE.md MISSING"
  test -d .claude/rules && echo "✓ .claude/rules/" || echo "✗ .claude/rules/ MISSING"
  test -d .alexantria && echo "✓ .alexantria/" || echo "✗ .alexantria/ MISSING"

  echo ""
  echo "=== ANT DOCS ==="
  test -f .alexantria/ANT-PROGRAMMATIC.md && echo "✓ ANT-PROGRAMMATIC.md" || echo "✗ ANT-PROGRAMMATIC.md missing"
  test -f .alexantria/ANT-TOKENIZED.md && echo "✓ ANT-TOKENIZED.md" || echo "? ANT-TOKENIZED.md missing (optional)"
  test -f .alexantria/ANT-INTENTIONAL.md && echo "✓ ANT-INTENTIONAL.md" || echo "? ANT-INTENTIONAL.md missing (optional)"
}
```

If critical files are missing (CLAUDE.md, .alexantria/), stop here and report:
```
❌ alexANTria not installed. Run /ant-init first.
```

### Step 2: Validate ANT-PROGRAMMATIC.md References

Read .alexantria/ANT-PROGRAMMATIC.md and extract file paths mentioned in it.

For each path mentioned:
- Check if file exists: `test -f <path>`
- Report: `✓ path/to/file.md` or `✗ path/to/file.md (referenced but doesn't exist)`

### Step 3: Check for Undocumented Files

Find markdown and important files that exist but aren't in ANT-PROGRAMMATIC.md:

```bash
# Find markdown files (excluding node_modules, .git, etc.)
find . -name "*.md" \
  -not -path "./node_modules/*" \
  -not -path "./.git/*" \
  -not -path "./dist/*" \
  -not -path "./build/*" \
  | sort
```

Compare this list against files mentioned in ANT-PROGRAMMATIC.md.

Report files that exist but aren't documented:
```
? new-file.md (exists but not in SURFACE)
? docs/guide.md (exists but not in SURFACE)
```

### Step 4: Validate ANT-TOKENIZED.md Patterns (Optional)

If ANT-TOKENIZED.md exists:
- Read it and extract pattern claims (e.g., "We use X pattern", "All Y files follow Z convention")
- For each specific, verifiable claim, try to validate:
  - Example: "All API routes in src/api/" → check if src/api/ exists and has files
  - Example: "Using TypeScript" → check for .ts files or tsconfig.json

This is best-effort. Don't over-engineer. Just catch obvious drift.

### Step 5: Output Report

Show a formatted report:

```
🐜 Documentation Health Check
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📁 Core Structure
  [✓] CLAUDE.md
  [✓] .claude/rules/
  [✓] .alexantria/

📄 Referenced Files (from ANT-PROGRAMMATIC.md)
  [✓] README.md
  [✓] RLM-ARCHITECTURE.md
  [✗] PATTERNS.md (missing)
  [✓] ANT-FRAMEWORK.md

📝 Undocumented Files
  [?] new-feature.md (not in SURFACE)
  [?] docs/migration-guide.md (not in SURFACE)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Status: DRIFT DETECTED ⚠️

Issues Found:
  • 1 referenced file missing
  • 2 undocumented files

Run /ant-suggest to get update proposals
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Step 6: Exit Codes

Determine status:
- **Exit 0 (HEALTHY)**: No missing references, no (or few) undocumented files
- **Exit 1 (DRIFT)**: Missing references OR multiple undocumented files
- **Exit 2 (BROKEN)**: Core structure missing (not installed)

---

## Visual Guidelines

**Symbols:**
- `[✓]` Pass
- `[✗]` Fail
- `[?]` Warning/Info

**Statuses:**
- HEALTHY ✅ — All good
- DRIFT DETECTED ⚠️ — Docs out of sync
- BROKEN ❌ — Not installed

---

## Implementation Notes

**DO:**
- Keep it simple — file existence checks and basic pattern matching
- Use single consolidated bash command for file checks
- Read ANT-PROGRAMMATIC.md and parse file references
- Find undocumented files
- Output clear, visual report

**DON'T:**
- Make this complicated (no simulated metrics, no fake tests)
- Show raw bash output to user (consolidate into report)
- Claim to validate things you can't actually validate
- Try to validate complex semantic claims

**Key Principle:** This is a *drift detector*, not a comprehensive validator. It catches obvious issues:
- Files that should exist but don't
- Files that exist but aren't documented
- Basic structural problems

That's it. Simple, useful, honest.
