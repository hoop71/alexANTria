---
description: Automated commit with worker ant
allowed-tools: Read, Write, Edit, Bash, Task
---

# /ant-commit - Automated Commit with Worker Ant

**Purpose:** Single command that wraps the entire agent commit workflow: spawn worker ant → update docs → create commit.

**Layer:** Surface (🌱)

## Overview

The `/ant-commit` command automates the full commit workflow when the agent makes code changes. It replaces the manual process of staging files, running worker ant, and committing separately.

## Workflow

```
User: "Refactor auth flow"
Agent: [Makes code changes]
Agent: /ant-commit "Refactor auth flow"

Behind the scenes:
1. Check if files are staged (git diff --cached)
2. If not staged, offer to stage modified files
3. Spawn worker ant sub-agent (blocking Task tool)
4. Worker ant:
   - Reads staged changes
   - Updates ANT-* files at or below starting_level
   - Detects higher-layer impacts
   - Updates manifest with suggested_reviews
   - Stages all changes (ANT-* + manifest)
5. Worker ant exits
6. Task tool returns (blocking complete)
7. Create commit with message + co-author
8. Run git status to verify
```

## Agent Instructions

```markdown
When the user says "/ant-commit <message>" or you're ready to commit your changes:

1. **Check staging area:**
   ```bash
   git diff --cached --name-only
   ```

   If nothing staged:
   - Run `git status` to see modified files
   - Ask user: "Stage all modified files?" or "Which files to stage?"
   - Stage the files: `git add <files>`

2. **Spawn worker ant (blocking):**
   ```
   Use Task tool with:
   - subagent_type: "general-purpose"
   - description: "Worker ant: update docs"
   - prompt: "You are the worker ant. Read the worker-ant-prompt.md instructions at user-level/commands/worker-ant-prompt.md and follow them. Analyze staged changes, update ANT-* files, and stage everything."
   - run_in_background: false (MUST block)
   ```

   **CRITICAL:** Do NOT proceed until Task tool returns. The worker ant MUST finish before committing.

3. **Verify worker ant completed:**
   ```bash
   git diff --cached --name-only
   ```

   Should now include:
   - Original code changes
   - ANT-SURFACE.md (or higher-layer ANT-* files)
   - .alexantria/manifest.json

4. **Create commit:**
   ```bash
   git commit -m "$(cat <<'EOF'
   <user-provided commit message>

   Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
   EOF
   )"
   ```

5. **Verify commit:**
   ```bash
   git status
   git log -1 --stat
   ```

   Show user what was committed.

## Handling Errors

**If worker ant fails:**
- Show the error from Task tool output
- Ask user if they want to retry or commit without doc updates
- Offer to run `/ant-update` manually

**If pre-commit hook fails:**
- Show the hook output
- Fix the issue
- Create a NEW commit (never --amend unless explicitly requested)

**If nothing to commit:**
- Tell user there are no changes
- Don't create an empty commit

## Usage Examples

### Example 1: Agent-driven commit
```
User: "Add logout button to the header"
Agent: [Implements logout button in src/components/Header.tsx]
Agent: Let me commit these changes.
Agent: /ant-commit "Add logout button to header"

[Agent stages files, spawns worker ant, creates commit]
```

### Example 2: User-requested commit
```
User: "/ant-commit Refactor authentication flow"
Agent: I see you have changes in src/auth/. Let me stage them and commit.
Agent: [Stages files, spawns worker ant, creates commit]
```

### Example 3: Partial staging
```
User: "/ant-commit Fix typo in login form"
Agent: You have modified 3 files. Which should I stage?
User: "Just src/auth/LoginForm.tsx"
Agent: [Stages that file, spawns worker ant, creates commit]
```

## Configuration Requirements

**Worker ant must be enabled:**
```json
{
  "worker_ant": {
    "enabled": true,
    "mode": "auto"
  }
}
```

If worker ant is disabled, `/ant-commit` should warn and fall back to regular git commit.

## Success Criteria

After running `/ant-commit`:
- ✓ Single commit created
- ✓ Commit includes code changes
- ✓ Commit includes ANT-* docs (if files in scope)
- ✓ Commit includes manifest update
- ✓ Co-author attribution added
- ✓ No manual steps required

## Related Commands

- `/ant-update` - Manual doc update (if /ant-commit skips it)
- `/ant-validate` - Check alexANTria installation
- `/ant-review-suggestions` - Review higher-layer doc suggestions

## Notes

- This command is for **agents only** (not pre-commit hook)
- Humans should use `git commit` directly (hook handles worker ant)
- The Task tool MUST block (run_in_background: false)
- Never push to remote unless user explicitly requests it
- Always use HEREDOC for commit message formatting
