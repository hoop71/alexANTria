---
description: Upgrade framework to latest version
allowed-tools: Read, Write, Edit, Bash, Grep, Glob, AskUserQuestion
---

# /ant-upgrade - Upgrade Framework

**Purpose:** Upgrade the alexANTria framework itself to the latest version.

**Layer:** Tunnels (🚇)

## Overview

The `/ant-upgrade` command updates the alexANTria framework components in your project:
- Command files (user-level/commands/ant-*.md)
- Guardian prompts (user-level/commands/guardians/)
- Templates (templates/ANT-*.md.template)
- Config schema documentation
- Worker ant prompt

This is different from `/ant-refresh-doc` which refreshes your project's ANT-* docs.

## Problem

alexANTria evolves over time with:
- New commands and features
- Improved guardian validation logic
- Better templates
- Bug fixes and optimizations
- Config schema changes

Users need a safe way to upgrade without losing customizations.

## Workflow

```
User: "/ant-upgrade"

1. Check current version
   - Read .alexantria/config.json version field
   - Compare to latest available version

2. Show what's new
   - Display changelog for versions since current
   - Highlight breaking changes
   - Show new commands/features

3. Ask user what to upgrade:
   Use AskUserQuestion:
   - Commands (ant-*.md files)
   - Guardians (validation prompts)
   - Templates (ANT-*.md.template)
   - Worker ant prompt
   - All of the above (Recommended)

4. Backup current installation
   - Copy current files to .alexantria/backup/v{old_version}/
   - Include: commands/, guardians/, templates/, worker-ant-prompt.md

5. Download/update selected components
   - For framework repo: git pull latest
   - For installed projects: fetch from upstream or local framework repo

6. Handle config migration
   - If config schema changed:
     - Read current config
     - Migrate to new schema
     - Preserve custom values
     - Show diff before applying

7. Preserve customizations
   - Detect user-modified files (compare to templates)
   - Warn about conflicts
   - Offer to merge or keep custom version

8. Test upgraded installation
   - Run /ant-validate
   - Check config.json valid
   - Verify all commands present

9. Report results
```

## Agent Instructions

When the user says "/ant-upgrade":

### Step 1: Check Version & Fetch Updates

```bash
# Check current version
jq -r '.version' .alexantria/config.json

# If this IS the framework repo
git fetch origin
git log --oneline HEAD..origin/main | head -10

# Show available updates
echo "Updates available: <count> commits ahead"
```

### Step 2: Show Changelog

Read recent commits or CHANGELOG.md to show what's new.

Present to user:
```
🚀 alexANTria Upgrade Available
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Current: v0.1
Latest:  v0.2

📋 What's New:

✨ New Features:
  • ant-refresh-doc command (replaces ant-update-doc)
  • ant-upgrade command (this one!)
  • Improved validation with smart triggers
  • Cost tracking and ROI metrics

🔧 Improvements:
  • Consolidated bash commands for cleaner output
  • Better UX with emojis and formatting
  • AskUserQuestion for interactive selections

⚠️  Breaking Changes:
  • Config schema updated (auto-migrated)
  • ant-update-doc renamed to ant-refresh-doc

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Step 3: Ask What to Upgrade

Use AskUserQuestion:

```json
{
  "questions": [{
    "question": "What would you like to upgrade?",
    "header": "Components",
    "multiSelect": true,
    "options": [
      {
        "label": "Commands (Recommended)",
        "description": "Update all ant-*.md command files with latest features"
      },
      {
        "label": "Guardians (Recommended)",
        "description": "Update validation prompts with improved checks"
      },
      {
        "label": "Templates (Recommended)",
        "description": "Update ANT-*.md.template files for ant-init"
      },
      {
        "label": "Worker Ant Prompt",
        "description": "Update worker ant sub-agent logic"
      },
      {
        "label": "Config Schema",
        "description": "Migrate config.json to new schema (if changed)"
      }
    ]
  }]
}
```

### Step 4: Backup Current Installation

```bash
# Create backup directory
OLD_VERSION=$(jq -r '.version' .alexantria/config.json)
mkdir -p .alexantria/backup/v${OLD_VERSION}

# Backup selected components
cp -r user-level/commands/*.md .alexantria/backup/v${OLD_VERSION}/commands/
cp -r user-level/commands/guardians/ .alexantria/backup/v${OLD_VERSION}/guardians/
cp -r templates/*.template .alexantria/backup/v${OLD_VERSION}/templates/
cp user-level/commands/worker-ant-prompt.md .alexantria/backup/v${OLD_VERSION}/

echo "✓ Backup created at .alexantria/backup/v${OLD_VERSION}/"
```

### Step 5: Upgrade Components

**If this IS the framework repo (alexANTria itself):**
```bash
git pull origin main
```

**If this is a PROJECT using alexANTria:**
- Copy updated files from framework repo location
- Or fetch from a remote source
- User must specify where framework files are

### Step 6: Migrate Config

If config schema changed:

1. Read current config
2. Compare to new schema
3. Create migrated config with:
   - New required fields (defaults)
   - Preserved custom values
   - Removed deprecated fields
4. Show diff to user
5. Ask approval before applying

### Step 7: Preserve Customizations

Check for user modifications:

```bash
# Find files modified by user (git diff or timestamp check)
# Warn about conflicts
```

If conflicts found, ask user:
- Keep your custom version
- Use new version (lose customizations)
- Try to merge (manual review required)

### Step 8: Verify Installation

Run validation checks:

```bash
# Verify upgraded installation
/ant-validate

# Check all commands present
ls -1 user-level/commands/ant-*.md | wc -l
```

### Step 9: Report Results

```
✅ Upgrade Complete
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔄 Updated:
  [✓] 8 commands
  [✓] 5 guardians
  [✓] 5 templates
  [✓] worker-ant-prompt.md
  [✓] config.json (v0.1 → v0.2)

💾 Backup:
  [i] Previous version backed up to .alexantria/backup/v0.1/

✨ New Commands Available:
  • /ant-refresh-doc
  • /ant-upgrade

⚠️  Action Required:
  → Review config changes: git diff .alexantria/config.json
  → Test new features: /ant-validate
  → Commit upgrade: git add . && git commit -m "Upgrade alexANTria to v0.2"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Safety Measures

1. **Always backup** before upgrading
2. **Show diff** for config changes
3. **Preserve customizations** - warn about conflicts
4. **Validate after** - ensure installation still works
5. **Rollback option** - restore from backup if needed

## Rollback

If upgrade fails or user wants to rollback:

```bash
# Restore from backup
cp -r .alexantria/backup/v{old_version}/* user-level/commands/
git checkout .alexantria/config.json
```

## Success Criteria

After running `/ant-upgrade`:
- ✓ Config version updated
- ✓ Selected components updated
- ✓ Backup created
- ✓ Customizations preserved or merged
- ✓ Validation passes
- ✓ User knows what changed

## Related Commands

- `/ant-validate` - Check installation health after upgrade
- `/ant-refresh-doc` - Refresh project docs (not framework)
- `/ant-init` - Initial setup (not upgrade)

## Notes

- **Framework vs Project:** This command upgrades alexANTria itself, not your project's ANT-* docs
- **Customizations:** Always preserves user modifications when possible
- **Breaking changes:** Clearly highlighted in changelog
- **Rollback:** Backup ensures you can always go back
