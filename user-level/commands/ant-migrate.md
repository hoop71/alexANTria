---
description: Migrate README.md to ANT-SURFACE.md
allowed-tools: Read, Write, Edit, Bash, AskUserQuestion
---

# /ant-migrate - Migrate README.md to ANT-SURFACE.md

**Purpose:** Convert existing README.md files to ANT-SURFACE.md format, enabling full automation.

**Layer:** Surface (🌱)

## Overview

The `/ant-migrate` command helps teams migrate from traditional README.md files to the ANT-SURFACE.md format. This is a key step in the adoption ramp from "Hybrid-to-ANT" mode to "ANT-only" mode.

## Problem

During the pilot or active adoption stages, projects may have:
- Existing README.md files (maintained manually)
- New ANT-SURFACE.md files (maintained by worker ant)

This coexistence is intentional during evaluation, but eventually you must choose one:
- **Keep README.md** - Rip out alexANTria
- **Migrate to ANT-SURFACE.md** - Full automation

## Workflow

```
User: "/ant-migrate src/auth"

1. Check if src/auth/README.md exists
   - If not: Error "No README.md found"

2. Read src/auth/README.md content

3. Analyze content (LLM-assisted):
   - Identify sections (Overview, API, Examples, etc.)
   - Determine what should go in ANT-SURFACE.md
   - Detect any content that doesn't fit (suggest where it goes)

4. Generate ANT-SURFACE.md:
   - Use template from templates/ANT-SURFACE.md.template
   - Populate with content from README.md
   - Add Recent Changes section (empty, will be maintained by worker ant)
   - Add Higher-Layer Impacts section (empty, maintained by worker ant)

5. Show diff to user:
   - What's being kept
   - What's being removed/relocated
   - Ask: "Proceed with migration?"

6. If approved:
   - Write ANT-SURFACE.md
   - Stage: git add src/auth/ANT-SURFACE.md
   - Remove: git rm src/auth/README.md
   - Update manifest: Mark directory as migrated
   - Stage: git add .alexantria/manifest.json

7. Suggest commit:
   "Ready to commit. Run: /ant-commit 'Migrate src/auth to ANT-SURFACE'"
```

## Agent Instructions

```markdown
When the user says "/ant-migrate <directory>":

1. **Validate directory:**
   ```bash
   ls <directory>/README.md
   ```

   If doesn't exist:
   - Check if ANT-SURFACE.md already exists
   - If yes: "Already migrated to ANT-SURFACE.md"
   - If no: "No README.md found in <directory>"

2. **Read existing content:**
   ```
   Use Read tool to read <directory>/README.md
   ```

3. **Analyze content:**
   - Identify what belongs in ANT-SURFACE.md (surface-level: API, components, usage)
   - Identify what belongs elsewhere:
     - Architecture diagrams → ANT-TUNNELS.md
     - Cross-cutting patterns → ANT-CHAMBERS.md
     - Product context → ANT-NEST.md
     - Strategic vision → ANT-QUEEN.md

4. **Read template:**
   ```
   Use Read tool to read templates/ANT-SURFACE.md.template
   ```

5. **Generate ANT-SURFACE.md:**
   - Follow template structure
   - Populate sections with content from README.md
   - Add placeholders for worker-ant-maintained sections:
     - ## Recent Changes (Last 5-10 Commits)
     - ## Higher-Layer Impacts (Detected by Worker Ant)

6. **Show diff to user:**
   Use AskUserQuestion:
   ```
   Question: "Ready to migrate src/auth/README.md → ANT-SURFACE.md?"
   Options:
   - Yes, proceed (Recommended)
     Description: Create ANT-SURFACE.md and remove README.md
   - Show me the content first
     Description: Display full ANT-SURFACE.md before migrating
   - Cancel
     Description: Keep README.md, don't migrate
   ```

7. **If approved, execute migration:**
   ```bash
   # Write new file
   Use Write tool to create <directory>/ANT-SURFACE.md

   # Stage new file and remove old file
   git add <directory>/ANT-SURFACE.md && git rm <directory>/README.md

   # Update manifest
   Use Edit tool to add migration record to .alexantria/manifest.json

   # Stage manifest
   git add .alexantria/manifest.json
   ```

8. **Suggest commit:**
   Tell user: "Migration staged. Run: /ant-commit 'Migrate <directory> to ANT-SURFACE'"

## Content Mapping

### What Goes in ANT-SURFACE.md
- Module/directory overview
- Component/function/class descriptions
- API documentation
- Usage examples
- Configuration options
- Dependencies (for this module)

### What Goes Elsewhere
- **ANT-TUNNELS.md** (Architecture)
  - System architecture diagrams
  - Service interactions
  - Data flow
  - Integration points

- **ANT-CHAMBERS.md** (Patterns)
  - Cross-cutting patterns (logging, error handling)
  - Coding conventions
  - Shared utilities
  - Design patterns

- **ANT-NEST.md** (Product/Business)
  - Product context
  - User stories
  - Business rules
  - Use cases

- **ANT-QUEEN.md** (Strategic)
  - Strategic vision
  - Core principles
  - Technical philosophy
  - Architectural constraints

## Usage Examples

### Example 1: Simple migration
```
User: "/ant-migrate src/auth"
Agent: Found README.md in src/auth/. Analyzing content...
Agent: Content fits well in ANT-SURFACE.md format.
Agent: [Shows preview]
Agent: Migrate? [Yes/No]
User: "Yes"
Agent: [Writes ANT-SURFACE.md, removes README.md, updates manifest]
Agent: Migration staged. Run: /ant-commit 'Migrate src/auth to ANT-SURFACE'
```

### Example 2: Content needs relocation
```
User: "/ant-migrate src/core"
Agent: Found README.md in src/core/. Analyzing content...
Agent: ⚠️ Some content should be moved:
  - Architecture diagram → Create ANT-TUNNELS.md at repo root
  - Error handling pattern → Create ANT-CHAMBERS.md at repo root
Agent: I'll migrate the surface-level content to ANT-SURFACE.md.
Agent: You'll need to manually create the higher-layer docs.
Agent: Proceed? [Yes/No]
User: "Yes"
Agent: [Executes migration, lists content that needs manual relocation]
```

### Example 3: Bulk migration
```
User: "Migrate all src/ READMEs to ANT-SURFACE"
Agent: Found 8 README.md files in src/. Migrate all? [Yes/No]
User: "Yes"
Agent: [Iterates through each directory, shows summary of changes]
Agent: All migrations staged. Run: /ant-commit 'Migrate src/ docs to ANT-SURFACE'
```

## Verification

After migration:
```bash
# Verify README.md removed
ls <directory>/README.md  # Should not exist

# Verify ANT-SURFACE.md created
ls <directory>/ANT-SURFACE.md  # Should exist

# Verify staged correctly
git status  # Should show: deleted README.md, new ANT-SURFACE.md, modified manifest.json

# Verify content
cat <directory>/ANT-SURFACE.md  # Should match template structure
```

## Configuration Impact

After migration, the directory is fully in ANT-* mode:
- Worker ant will auto-update ANT-SURFACE.md
- No more manual README.md maintenance
- Can expand managed_paths to include this directory

## Rollback

If migration was a mistake:
```bash
git restore --staged <directory>/ANT-SURFACE.md <directory>/README.md .alexantria/manifest.json
git restore <directory>/README.md
rm <directory>/ANT-SURFACE.md
```

## Success Criteria

After running `/ant-migrate`:
- ✓ ANT-SURFACE.md created with template structure
- ✓ README.md removed (staged for deletion)
- ✓ Manifest updated with migration record
- ✓ User notified of content requiring relocation (if any)
- ✓ Ready to commit

## Related Commands

- `/ant-init` - Initialize alexANTria (creates migration path)
- `/ant-commit` - Commit the migration
- `/ant-validate` - Verify migration succeeded

## Notes

- Migration is **one-way** (README.md → ANT-SURFACE.md)
- Always stage changes, never commit automatically
- Content analysis is best-effort (may need manual review)
- Can migrate one directory at a time or bulk migrate
- After migration, worker ant takes over maintenance
