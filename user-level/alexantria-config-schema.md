# alexANTria Config Schema

`.alexantria/config.json` - Project-level configuration for worker ant behavior.

## Schema

```json
{
  "version": "0.1",
  "worker_ant": {
    "enabled": boolean,
    "mode": "auto" | "agent-only" | "manual",
    "auto_update_ant_files": boolean
  },
  "commit_tracking": {
    "enabled": boolean,
    "require_manifest_updates": boolean
  }
}
```

## Fields

### `worker_ant.enabled`
- **Type:** boolean
- **Default:** true
- **Description:** Master switch for worker ant functionality. If false, all worker ant behavior is disabled.

### `worker_ant.mode`
- **Type:** string
- **Options:** "auto", "agent-only", "manual"
- **Default:** "auto"
- **Description:** How worker ant should be triggered

**Mode Details:**

| Mode | Agent Commits | Human Commits (terminal) | Human Commits (Claude Code) |
|------|---------------|-------------------------|---------------------------|
| **auto** | Spawns worker ant (sub-agent) | Hook warns to run /ant-update | Hook tries to spawn (future) |
| **agent-only** | Spawns worker ant (sub-agent) | Hook warns to use agent | Hook warns to use agent |
| **manual** | Manual /ant-update after | Manual /ant-update after | Manual /ant-update after |

### `worker_ant.auto_update_ant_files`
- **Type:** boolean
- **Default:** true
- **Description:** Whether worker ant should auto-update ANT-* files. If false, worker ant only tracks in manifest but doesn't modify any docs.

### `commit_tracking.enabled`
- **Type:** boolean
- **Default:** true
- **Description:** Whether to track commits in manifest at all. If false, manifest is not updated.

### `commit_tracking.require_manifest_updates`
- **Type:** boolean
- **Default:** false
- **Description:** If true, commits will fail if manifest can't be updated. Use with caution - can block commits.

## Examples

### Solo Developer (Agent-Friendly)
```json
{
  "version": "0.1",
  "worker_ant": {
    "enabled": true,
    "mode": "auto",
    "auto_update_ant_files": true
  },
  "commit_tracking": {
    "enabled": true,
    "require_manifest_updates": false
  }
}
```

### Team (Agent-Only Policy)
```json
{
  "version": "0.1",
  "worker_ant": {
    "enabled": true,
    "mode": "agent-only",
    "auto_update_ant_files": true
  },
  "commit_tracking": {
    "enabled": true,
    "require_manifest_updates": false
  }
}
```

### Minimal Adoption (Manual Mode)
```json
{
  "version": "0.1",
  "worker_ant": {
    "enabled": false,
    "mode": "manual",
    "auto_update_ant_files": false
  },
  "commit_tracking": {
    "enabled": true,
    "require_manifest_updates": false
  }
}
```

## Team Adoption

**Critical:** All team members must have the same config. This file is committed to git.

**Partial adoption is worse than no adoption** - if only some commits get worker ant processing, manifest and suggested reviews become unreliable.

## Changing Modes

To change mode:
1. Edit `.alexantria/config.json`
2. Commit the change
3. Push to remote
4. Team members pull and see new behavior

The pre-commit hook reads config fresh every time, so changes take effect immediately.
