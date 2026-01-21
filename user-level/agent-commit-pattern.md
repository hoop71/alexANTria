# Agent Commit Pattern

How agents should commit code with automatic doc maintenance.

## The Pattern

```
1. Make code changes
2. Stage changes: git add <files>
3. Spawn worker ant sub-agent (Task tool - BLOCKS)
4. Worker ant updates docs/manifest, stages them
5. Task tool returns (worker ant done)
6. Commit everything: git commit -m "message"
```

## Implementation

**Step 1-2: Make and stage changes**
```bash
# Make your changes
vim src/auth/login.ts

# Stage them
git add src/auth/login.ts
```

**Step 3-4: Spawn worker ant**

Use the Task tool with this configuration:

```
Tool: Task
subagent_type: "general-purpose"
description: "Update docs before commit"
prompt: <contents of user-level/commands/worker-ant-prompt.md>
```

**Key:** Do NOT use `run_in_background: true`. You want the tool to block until the worker ant finishes.

**Step 5-6: Worker ant completes, then commit**

The Task tool returns when the worker ant is done. At this point:
- Surface docs are updated (if needed)
- Manifest has new entry with suggested_reviews
- Everything is staged

Now commit:

```bash
git commit -m "Refactor auth to use refresh tokens"
```

This single commit contains:
- Your code changes
- Updated surface docs
- Updated manifest with suggested higher-layer reviews

## Example Flow

```
Agent: "I'm refactoring authentication. Let me stage my changes."
Agent: git add src/auth/login.ts src/auth/session.ts

Agent: "Now spawning worker ant to maintain docs before committing."
Agent: <Task tool call with worker-ant-prompt>

[Worker Ant spawns]
Worker: Analyzing staged changes...
Worker: Found changes in src/auth/
Worker: Updating src/auth/README.md
Worker: Detecting higher-layer impacts: docs/security-patterns.md
Worker: Updating manifest with suggested_reviews
Worker: Staging changes
Worker: Done

[Task tool returns - worker ant finished]

Agent: "Worker ant completed. Committing everything."
Agent: git commit -m "Refactor auth to use refresh tokens"

[Commit created with code + docs + manifest]
```

## Why This Works

- **Blocking Task tool** ensures worker ant completes before commit
- **Single commit** includes all changes (no follow-up commits)
- **Suggested reviews** in manifest flag higher-layer docs for manual review
- **Autonomous** - no manual /ant-update commands needed

## When to Use

**Always** when committing code changes that might affect docs.

**Skip** if:
- Committing only docs (already in sync)
- Committing only tests
- Trivial changes (typos, formatting)

But the worker ant is fast and will no-op if there's nothing to do, so when in doubt, spawn it.

## Troubleshooting

**Worker ant didn't update anything:**
- Check the Task tool result for the worker ant's report
- It may have determined changes didn't warrant doc updates (action: "no-op")
- Manifest still gets updated with an entry

**Worker ant suggested reviews but I disagree:**
- That's fine - suggested_reviews are just flags, not requirements
- You can ignore them or edit the manifest before committing

**Worker ant is too slow:**
- It should be fast (< 30 seconds for most repos)
- If slow, check if it's reading huge files or diffs
- Consider adding quick-exit logic for certain file patterns

## Future Enhancement

This pattern could be baked into a `/commit` skill that:
1. Stages changes
2. Spawns worker ant
3. Commits with proper message
4. All in one command

For now, follow the pattern manually when committing code.
