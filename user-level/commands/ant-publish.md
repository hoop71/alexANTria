---
description: Publish local-only alexANTria to team
allowed-tools: Read, Edit, Bash, AskUserQuestion
---

# 🐜 Ant Publish: Share Your Colony with the Team

Transition from local-only (private experimentation) to team-shared mode. This makes all alexANTria files visible to your team by removing gitignore entries and staging everything.

## Philosophy

You've been testing alexANTria privately. It works. Now you want your team to benefit from it too.

**This is a one-way transition:**
- Local-only → Team-shared (this command)
- No unpublishing (prevents team disruption)

## Phase 1: Validate

### Check Local-Only Mode

```bash
# Read config to verify we're in local-only mode
jq -r '.collaboration.mode' .alexantria/config.json
```

If not "local_only":
- Show: "Already in team-shared mode. Files are tracked in git."
- Exit gracefully

### Show What Will Be Published

```bash
# Show currently ignored alexANTria files
git status --ignored | grep -E '(\.alexantria|CLAUDE\.md|\.claude|ANT-.*\.md)' || echo "No ignored files found"
```

Present to user:
```
📍 Publishing to Team

These files will become visible to your team:
  .alexantria/ (except config.json, already tracked)
  CLAUDE.md
  .claude/
  ANT-ARCHITECTURE.md
  ANT-PATTERNS.md
  ANT-PRODUCT.md
  ANT-STRATEGY.md
  **/ANT-SURFACE.md

Your team will see your documentation structure.
```

### Confirm Intent

Use `AskUserQuestion`:
```
Question: "Ready to publish alexANTria to your team?"
Header: "Publish"
Options:
1. Yes, publish (Recommended if tested)
   Description: Remove gitignore entries, stage all files, update config. Team will see all ANT-* docs.

2. Show me what's different first
   Description: Run git diff on ANT-* files to review content before sharing.

3. Cancel
   Description: Stay in local-only mode, keep testing privately.
```

## Phase 2: Remove Gitignore Section

If user chooses "Show me what's different first":
```bash
# Show diffs of all ANT-* files
git diff HEAD .alexantria/ CLAUDE.md .claude/ 2>/dev/null || echo "No local changes to ANT files"
find . -name "ANT-SURFACE.md" -exec git diff HEAD {} \; 2>/dev/null
```

Then ask again (loop back to Phase 1 confirmation).

If user chooses "Yes, publish":

### Remove alexANTria Section from .gitignore

**Strategy:** Use sed to remove the section between marker comment and blank line.

```bash
# Remove the alexANTria section
sed -i.bak '/# alexANTria (local-only mode)/,/^$/d' .gitignore

# Stage the updated .gitignore
git add .gitignore

# Verify section removed
echo "✓ Removed alexANTria section from .gitignore"
```

**Edge case:** If `.gitignore` doesn't have the section (malformed state):
- Show: "⚠️  .gitignore doesn't contain expected section. Continuing anyway..."
- Still stage `.gitignore`

## Phase 3: Update Config

Read current config, update collaboration section:

```json
{
  "collaboration": {
    "mode": "team_shared",
    "gitignored_at": "2026-02-11T10:30:00Z",
    "published_at": "2026-02-11T11:45:00Z"
  }
}
```

Use Edit tool to update the collaboration section in `.alexantria/config.json`:
- Set `mode: "team_shared"`
- Set `published_at: <current ISO timestamp>`
- Keep `gitignored_at` unchanged (historical record)

```bash
# Stage updated config
git add .alexantria/config.json
```

## Phase 4: Stage All alexANTria Files

```bash
# Stage all previously-ignored files
git add .alexantria/
git add CLAUDE.md
git add .claude/

# Stage all ANT-* docs at repo root
git add ANT-*.md 2>/dev/null || echo "No root ANT-* files"

# Stage all ANT-SURFACE.md files in subdirectories
find . -name "ANT-SURFACE.md" -exec git add {} \;

echo "✓ Staged all alexANTria files"
```

## Phase 5: Show Team Adoption Checklist

Present this checklist:

```
✅ Publishing Complete

Your alexANTria files are now staged for commit.

📋 Team Adoption Checklist

Before committing:
  [ ] Review what's staged: git status
  [ ] Scan file content: git diff --cached
  [ ] Remove any sensitive info (if accidentally documented)

After committing:
  [ ] Communicate to team
      - Heads-up in Slack/email: "Added alexANTria to [project]"
      - Link to alexANTria docs: https://github.com/hoop71/alexANTria
      - Explain what it does: "Auto-maintains our ANT-* docs"

  [ ] Team setup
      - Each member installs: curl -fsSL https://raw.githubusercontent.com/hoop71/alexANTria/main/install.sh | bash
      - Each member restarts Claude Code
      - Test: Each runs /ant-validate in the repo

  [ ] Monitor first commits
      - Watch first 5-10 team commits for quality
      - Run /ant-validation-report after a week
      - Adjust scope/starting_level if needed

  [ ] Document for new hires
      - Add "Install alexANTria" to onboarding
      - Include link to repo README
```

## Phase 6: Suggest Commit

Show user:
```
Ready to commit. Run:

  /ant-commit "feat: add alexANTria documentation framework"

Or customize the message:

  /ant-commit "docs: add auto-maintained context structure"
```

**Do NOT commit automatically.** User must run `/ant-commit` to create the commit.

## Edge Cases

### Edge Case 1: .gitignore is in .gitignore

Detect before attempting changes:
```bash
git check-ignore .gitignore
```

If exits 0 (is ignored):
- Show: "⚠️  .gitignore is gitignored. This will cause issues."
- Show: "Remove .gitignore from .gitignore first, then retry."
- Pause: Exit command without making changes

### Edge Case 2: Existing .gitignore with Partial Entries

If `.gitignore` has some alexANTria entries but not the full section:
- Detect: Section marker missing but files like `.alexantria/` present
- Show: "⚠️  Incomplete gitignore state detected"
- Show: "Manually review .gitignore before publishing"
- Ask: "Continue anyway? [Yes/No]"

### Edge Case 3: Already Team-Shared

Detected in Phase 1:
```bash
mode=$(jq -r '.collaboration.mode' .alexantria/config.json)
if [ "$mode" = "team_shared" ]; then
  echo "Already in team-shared mode. Files are tracked in git."
  exit 0
fi
```

### Edge Case 4: No Config File

If `.alexantria/config.json` doesn't exist:
- Show: "⚠️  No config.json found. Run /ant-init first."
- Exit

### Edge Case 5: Config Missing Collaboration Field

Since we're not supporting backward compatibility (user of one), treat missing field as error:
- Show: "⚠️  Config missing collaboration field. Run /ant-init again."
- Exit

## Verification

After running `/ant-publish`:

```bash
# Verify .gitignore no longer has alexANTria section
grep "alexANTria (local-only mode)" .gitignore
# Should return nothing (exit code 1)

# Verify config updated
jq -r '.collaboration.mode' .alexantria/config.json
# Should return "team_shared"

# Verify files staged
git status
# Should show all ANT-* files, .alexantria/, CLAUDE.md, .claude/, .gitignore as staged

# Verify files no longer ignored
git status --ignored | grep alexANTria
# Should return nothing
```

## Success Criteria

After running `/ant-publish`:
- ✓ .gitignore alexANTria section removed
- ✓ config.collaboration.mode = "team_shared"
- ✓ config.collaboration.published_at set to current timestamp
- ✓ All alexANTria files staged for commit
- ✓ Team adoption checklist shown to user
- ✓ Commit suggestion provided
- ✓ No automatic commit (user controls when)

## Related Commands

- `/ant-init` - Initialize colony (sets initial collaboration mode)
- `/ant-commit` - Commit the publishing changes
- `/ant-status` - Check current collaboration mode
- `/ant-validate` - Verify installation after publishing

## Notes

- **One-way transition:** No `/ant-unpublish` command (prevents team disruption)
- **Requires confirmation:** User must explicitly approve publishing
- **Does not commit:** User commits via `/ant-commit` when ready
- **Team coordination:** User responsible for communicating to team
- **config.json stays tracked:** Even in local-only mode, config.json is tracked (documents configuration)
- **gitignored_at preserved:** Historical record of when local-only mode was enabled
