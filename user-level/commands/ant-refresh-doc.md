---
description: Refresh specific ANT-* doc
allowed-tools: Read, Write, Edit, Bash, Grep
---

# /ant-refresh-doc - Refresh Documentation

**Purpose:** Manually refresh a specific ANT-* documentation file based on recent changes.

**Layer:** Surface (🌱)

## Overview

The `/ant-refresh-doc` command provides a manual outlet for refreshing specific documentation files when:
- Worker ant's automatic updates are disabled
- You want to update a doc without committing code
- You need to apply a suggested review to a higher-layer doc
- Testing worker ant behavior on a specific file

## Problem

Worker ant normally runs automatically during commits, but sometimes you need:
- Update docs without committing (preview changes)
- Apply suggested reviews to higher-layer docs (ANT-TUNNELS.md, ANT-CHAMBERS.md)
- Force refresh a doc that got out of sync
- Test worker ant on a specific file

## Workflow

```
User: "/ant-refresh-doc ANT-TUNNELS.md"

1. Validate file exists and is ANT-* file
   - If not ANT-*: Error "Only ANT-* files supported"

2. Check manifest for suggested_reviews
   - Find suggestions related to this file
   - Show suggestions to user

3. Read recent git history
   - git log --oneline -10
   - git diff HEAD~5..HEAD

4. Read current doc content
   - Read ANT-TUNNELS.md

5. Analyze what needs updating:
   - Changes since last doc update
   - Suggested reviews from manifest
   - Detected inconsistencies

6. Generate updates:
   - Update relevant sections
   - Add new content based on code changes
   - Mark suggestions as applied

7. Show diff to user:
   - What's changing
   - Why it's changing
   - Ask: "Apply these updates?"

8. If approved:
   - Write updated file
   - Update manifest (mark suggestions as applied)
   - Stage both files
   - Suggest commit
```

## Agent Instructions

```markdown
When the user says "/ant-refresh-doc <path>":

1. **Validate file:**
   ```bash
   ls <path>
   ```

   Check if it's an ANT-* file:
   - ANT-SURFACE.md ✓
   - ANT-TUNNELS.md ✓
   - ANT-CHAMBERS.md ✓
   - ANT-NEST.md ✓
   - ANT-QUEEN.md ✓
   - README.md ✗ (not supported, use /ant-migrate)

2. **Read manifest:**
   ```
   Use Read tool to read .alexantria/manifest.json
   ```

   Find `suggested_reviews` for this file:
   ```json
   {
     "suggested_reviews": [
       {
         "doc": "ANT-TUNNELS.md",
         "reason": "Auth flow changed, architecture doc may be stale",
         "layer": "tunnels",
         "status": "pending"
       }
     ]
   }
   ```

   Show suggestions to user.

3. **Read recent changes:**
   ```bash
   # Recent commits
   git log --oneline -10

   # Recent code diff
   git diff HEAD~5..HEAD
   ```

   Focus on files related to the doc being updated.

4. **Read current doc:**
   ```
   Use Read tool to read <path>
   ```

5. **Analyze updates needed:**
   - What changed in the codebase?
   - What sections of the doc are affected?
   - Are there new patterns/components to document?
   - Are there suggestions from manifest?

6. **Generate updated content:**
   Use Edit tool to update the doc. Common patterns:

   **For ANT-SURFACE.md:**
   - Update "Recent Changes" section
   - Add new components/functions
   - Update usage examples

   **For ANT-TUNNELS.md:**
   - Update architecture diagrams (ASCII/mermaid)
   - Update service interactions
   - Update data flow

   **For ANT-CHAMBERS.md:**
   - Document new patterns
   - Update coding conventions
   - Add shared utilities

   **For ANT-NEST.md:**
   - Update product context
   - Update business rules
   - Update use cases

   **For ANT-QUEEN.md:**
   - Update strategic vision
   - Update core principles
   - Update architectural constraints

7. **Show diff and ask approval:**
   Use AskUserQuestion:
   ```
   Question: "Apply these updates to <path>?"
   Options:
   - Yes, apply updates (Recommended)
     Description: Update the doc and stage changes
   - Show me the full content first
     Description: Display entire updated doc
   - No, cancel
     Description: Don't update the doc
   ```

8. **If approved, apply updates:**
   ```bash
   # Already written via Edit tool

   # Update manifest (mark suggestions as applied)
   Use Edit tool to update .alexantria/manifest.json

   # Stage both files
   git add <path> .alexantria/manifest.json
   ```

9. **Suggest commit:**
   Tell user: "Updates staged. Run: /ant-commit 'Update <path>'"

## Usage Examples

### Example 1: Apply pending suggestions
```
User: "/ant-refresh-doc ANT-TUNNELS.md"
Agent: Found 2 pending suggestions for ANT-TUNNELS.md:
  1. Auth flow changed (commit abc123)
  2. New API endpoint added (commit def456)
Agent: Reading recent changes...
Agent: [Shows proposed updates]
Agent: Apply? [Yes/No]
User: "Yes"
Agent: [Updates doc, stages changes]
Agent: Updates staged. Run: /ant-commit 'Update architecture docs'
```

### Example 2: Manual refresh
```
User: "/ant-refresh-doc src/auth/ANT-SURFACE.md"
Agent: No pending suggestions found.
Agent: Checking recent changes in src/auth/...
Agent: Found 3 commits since last update.
Agent: [Shows proposed updates]
Agent: Apply? [Yes/No]
User: "Yes"
Agent: [Updates doc, stages changes]
```

### Example 3: Higher-layer doc
```
User: "The auth architecture changed, update the architecture doc"
Agent: Let me update ANT-TUNNELS.md.
Agent: /ant-refresh-doc ANT-TUNNELS.md
Agent: [Analyzes auth changes, updates architecture sections]
Agent: [Shows diff]
Agent: Apply? [Yes/No]
User: "Yes"
Agent: [Updates doc, stages changes]
```

### Example 4: Preview mode
```
User: "/ant-refresh-doc ANT-CHAMBERS.md"
Agent: Found 1 pending suggestion.
Agent: [Shows proposed updates]
Agent: Apply? [Yes/Show me the full content first/No]
User: "Show me the full content first"
Agent: [Displays entire updated doc]
Agent: Apply these changes? [Yes/No]
User: "Yes"
Agent: [Updates doc, stages changes]
```

## Configuration

This command works regardless of worker_ant.mode:
- **auto mode**: Can use this anytime
- **agent-only mode**: Can use this anytime
- **manual mode**: Primary way to update docs

## Verification

After update:
```bash
# Verify file updated
git diff --cached <path>

# Verify manifest updated
git diff --cached .alexantria/manifest.json

# Verify staging
git status
```

## When to Use

**Use /ant-refresh-doc when:**
- Applying suggested reviews from manifest
- Docs got out of sync, need to refresh
- Testing worker ant behavior
- Updating docs without committing code

**Don't use /ant-refresh-doc when:**
- Committing code changes (use /ant-commit instead)
- Creating new ANT-* files (use /ant-init)
- Migrating README.md (use /ant-migrate)

## Success Criteria

After running `/ant-refresh-doc`:
- ✓ Specified doc updated
- ✓ Updates based on recent code changes
- ✓ Suggestions marked as applied in manifest
- ✓ Both doc and manifest staged
- ✓ Ready to commit

## Related Commands

- `/ant-commit` - Normal commit workflow (auto-triggers worker ant)
- `/ant-review-suggestions` - Review all pending suggestions
- `/ant-validate` - Check doc health

## Notes

- Only works on ANT-* files (not README.md)
- Requires git history to analyze changes
- Shows diff before applying (never blindly updates)
- Can be run multiple times (idempotent)
- Useful for testing worker ant behavior
