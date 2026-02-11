---
description: Review higher-layer doc suggestions
allowed-tools: Read, Write, Edit, Bash, AskUserQuestion
---

# /ant-review-suggestions - Review Higher-Layer Doc Suggestions

**Purpose:** Review and apply pending suggestions for higher-layer documentation that's above the automation boundary.

**Layer:** Architecture (Programmatic)

## Overview

The `/ant-review-suggestions` command provides a batch interface for reviewing all pending documentation suggestions detected by the worker ant. This is the primary way to maintain docs above the `starting_level` (e.g., ANT-PATTERNS.md, ANT-PRODUCT.md, ANT-STRATEGY.md).

## Problem

Worker ant auto-maintains docs at or below `starting_level`, but detects impacts to higher layers and records them as suggestions. Without a way to review these suggestions, they pile up in the manifest and docs get stale.

## Automation Boundary

```
Pool 3 (Intentional):
  ANT-STRATEGY.md         ← Suggestions only (strategic alignment)
  ANT-PRODUCT.md          ← Suggestions only (product/business)

Pool 2 (Tokenized):
  ANT-PATTERNS.md         ← Suggestions only (cross-cutting patterns)

─────────────────────── Automation Boundary (if starting_level = "architecture") ──

Pool 1 (Programmatic):
  ANT-ARCHITECTURE.md     ← Auto-maintained (architecture)
  ANT-SURFACE.md          ← Auto-maintained (service docs)
```

**If starting_level = "service":**
- Auto-maintained: ANT-SURFACE.md
- Suggestions: ANT-ARCHITECTURE.md, ANT-PATTERNS.md, ANT-PRODUCT.md, ANT-STRATEGY.md

**If starting_level = "architecture":**
- Auto-maintained: ANT-SURFACE.md, ANT-ARCHITECTURE.md
- Suggestions: ANT-PATTERNS.md, ANT-PRODUCT.md, ANT-STRATEGY.md

## Workflow

```
User: "/ant-review-suggestions"

1. Read manifest
   - Find all suggested_reviews with status: "pending"
   - Group by doc (ANT-ARCHITECTURE.md, ANT-PATTERNS.md, etc.)
   - Group by layer (tunnels, chambers, nest, queen)

2. Show summary:
   "Found 5 pending suggestions:
    - ANT-ARCHITECTURE.md (2 suggestions)
    - ANT-PATTERNS.md (2 suggestions)
    - ANT-STRATEGY.md (1 suggestion)"

3. Ask user:
   - Apply all
   - Review individually
   - Dismiss all

4. If "Apply all":
   - For each suggested doc:
     - Run /ant-refresh-doc <path>
     - Stage changes

5. If "Review individually":
   - For each suggestion:
     - Show suggestion details
     - Show related commits
     - Ask: Apply / Skip / Dismiss

6. If "Dismiss all":
   - Mark all suggestions as "dismissed" in manifest
   - Stage manifest

7. Show results:
   - X docs updated
   - Y suggestions applied
   - Z suggestions dismissed
```

## Agent Instructions

```markdown
When the user says "/ant-review-suggestions":

1. **Read manifest:**
   ```
   Use Read tool to read .alexantria/manifest.json
   ```

   Parse `suggested_reviews` array:
   ```json
   {
     "suggested_reviews": [
       {
         "doc": "ANT-ARCHITECTURE.md",
         "reason": "Auth flow changed, architecture doc may be stale",
         "layer": "docs",
         "status": "pending",
         "detected_at": "2026-01-20T10:30:00Z",
         "commits": ["abc123", "def456"]
       },
       {
         "doc": "ANT-PATTERNS.md",
         "reason": "New error handling pattern detected",
         "layer": "docs",
         "status": "pending",
         "detected_at": "2026-01-20T11:00:00Z",
         "commits": ["ghi789"]
       }
     ]
   }
   ```

   Filter for `status: "pending"`.

2. **Group and count suggestions:**
   - By doc (ANT-ARCHITECTURE.md, ANT-PATTERNS.md, etc.)
   - By layer (architecture, patterns, product, strategy)

3. **Show summary to user:**
   ```
   Found 5 pending suggestions:

   ANT-ARCHITECTURE.md (Architecture - Programmatic) - 2 suggestions
     - Auth flow changed (commits: abc123, def456)
     - New API endpoint added (commit: ghi789)

   ANT-PATTERNS.md (Patterns - Tokenized) - 2 suggestions
     - New error handling pattern detected (commit: jkl012)
     - Logging convention updated (commit: mno345)

   ANT-STRATEGY.md (Strategy - Intentional) - 1 suggestion
     - Security constraint may have been violated (commit: pqr678)
   ```

4. **Ask user how to proceed:**
   Use AskUserQuestion:
   ```
   Question: "How should I handle these suggestions?"
   Options:
   - Apply all (Recommended)
     Description: Update all docs with pending suggestions
   - Review individually
     Description: Go through each suggestion one by one
   - Dismiss all
     Description: Mark all as reviewed, don't apply
   ```

5. **If "Apply all":**
   For each unique doc with pending suggestions:
   ```
   Run /ant-refresh-doc <doc-path>
   (This will apply all suggestions for that doc)
   ```

   After all docs updated:
   ```bash
   git add <all-updated-docs> .alexantria/manifest.json
   ```

   Tell user: "All suggestions applied. Run: /ant-commit 'Update higher-layer docs'"

6. **If "Review individually":**
   For each suggestion (sorted by layer, highest first):
   ```
   Show:
   - Doc: ANT-ARCHITECTURE.md (Architecture - Programmatic)
   - Reason: Auth flow changed
   - Commits: abc123, def456
   - Detected: 2 days ago

   Ask: Apply this suggestion? [Yes/Skip/Dismiss]
   ```

   **Yes:** Run /ant-refresh-doc for that doc (if not already updated in this session)
   **Skip:** Leave as pending, move to next
   **Dismiss:** Mark as dismissed, move to next

   After all reviewed:
   ```bash
   git add <updated-docs> .alexantria/manifest.json
   ```

   Tell user summary and commit suggestion.

7. **If "Dismiss all":**
   ```
   Use Edit tool to update .alexantria/manifest.json
   Set all pending suggestions to status: "dismissed"
   ```

   ```bash
   git add .alexantria/manifest.json
   ```

   Tell user: "All suggestions dismissed. Run: /ant-commit 'Dismiss doc suggestions'"

## Usage Examples

### Example 1: Apply all suggestions
```
User: "/ant-review-suggestions"
Agent: Found 3 pending suggestions:
  - ANT-ARCHITECTURE.md (1 suggestion)
  - ANT-PATTERNS.md (2 suggestions)
Agent: Apply all / Review individually / Dismiss all?
User: "Apply all"
Agent: Updating ANT-ARCHITECTURE.md...
Agent: Updating ANT-PATTERNS.md...
Agent: All suggestions applied. Run: /ant-commit 'Update higher-layer docs'
```

### Example 2: Review individually
```
User: "/ant-review-suggestions"
Agent: Found 2 pending suggestions.
Agent: How to proceed? [Apply all/Review individually/Dismiss all]
User: "Review individually"
Agent:
  Suggestion 1/2:
  - Doc: ANT-STRATEGY.md (Strategy - Intentional)
  - Reason: Security constraint may have been violated
  - Commit: abc123 "Allow HTTP fallback in auth"
  - Detected: 1 day ago

  This is a strategic-level change. Review carefully.
  Apply? [Yes/Skip/Dismiss]
User: "Yes"
Agent: Updating ANT-STRATEGY.md...
Agent:
  Suggestion 2/2:
  - Doc: ANT-PATTERNS.md (Patterns - Tokenized)
  - Reason: New logging pattern detected
  - Commit: def456 "Add structured logging"
  - Detected: 3 hours ago

  Apply? [Yes/Skip/Dismiss]
User: "Yes"
Agent: Updating ANT-PATTERNS.md...
Agent: All suggestions reviewed. 2 applied, 0 skipped, 0 dismissed.
Agent: Run: /ant-commit 'Update strategic and pattern docs'
```

### Example 3: Dismiss all
```
User: "I've manually reviewed all the docs, dismiss the suggestions"
Agent: /ant-review-suggestions
Agent: Found 5 pending suggestions.
Agent: How to proceed? [Apply all/Review individually/Dismiss all]
Agent: (User requested dismiss)
Agent: Marking all suggestions as dismissed...
Agent: All suggestions dismissed. Run: /ant-commit 'Dismiss doc suggestions'
```

### Example 4: No suggestions
```
User: "/ant-review-suggestions"
Agent: No pending suggestions found. All docs are up to date!
```

## Suggestion Lifecycle

```
pending → applied   (via /ant-review-suggestions or /ant-refresh-doc)
pending → dismissed (via /ant-review-suggestions)
pending → pending   (skipped during individual review)
```

Dismissed suggestions are kept in manifest for audit trail.

## Configuration

Works with any `starting_level`:
- **starting_level: "service"** - All higher layers get suggestions
- **starting_level: "architecture"** - Patterns, product, strategy get suggestions
- **starting_level: "patterns"** - Only product and strategy get suggestions

## Verification

After applying suggestions:
```bash
# Verify docs updated
git diff --cached

# Verify manifest updated
git diff --cached .alexantria/manifest.json | grep status

# Verify no pending suggestions remain
grep -A 5 "pending" .alexantria/manifest.json  # Should be empty
```

## When to Use

**Use /ant-review-suggestions when:**
- Periodic maintenance (weekly/monthly)
- After major feature work
- Before releases
- When docs feel stale
- After multiple commits piled up suggestions

**Trigger frequency depends on adoption stage:**
- **Pilot:** Weekly (learning, high attention)
- **Active:** Bi-weekly (steady state)
- **Full:** Monthly (mature, autonomous)

## Success Criteria

After running `/ant-review-suggestions`:
- ✓ All pending suggestions reviewed
- ✓ Higher-layer docs updated or dismissed
- ✓ Manifest updated with new statuses
- ✓ Changes staged
- ✓ Ready to commit

## Related Commands

- `/ant-refresh-doc` - Update specific doc (called by this command)
- `/ant-commit` - Commit the updates
- `/ant-validate` - Check overall doc health

## Notes

- Suggestions never auto-apply (require human review)
- Higher layers = more strategic = more careful review
- Can dismiss suggestions if already manually addressed
- Dismissed suggestions kept for audit trail
- Worker ant continues detecting new suggestions
- This is the feedback loop for the "living brain"
