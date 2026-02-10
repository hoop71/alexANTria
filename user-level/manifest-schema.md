# alexANTria Manifest Schema

`.alexantria/manifest.json` - Project-level change tracking, validation log, and graduation history.

## Schema

```json
{
  "version": "0.1",
  "repo": string,
  "last_sync": string | null,
  "validation_log": ValidationEntry[],
  "changes": ChangeEntry[],
  "graduations": GraduationEntry[]
}
```

## Fields

### `version`
- **Type:** string
- **Description:** Schema version for forward compatibility
- **Current:** "0.1"

### `repo`
- **Type:** string
- **Description:** Repository name or identifier

### `last_sync`
- **Type:** string | null
- **Description:** ISO 8601 timestamp of last worker ant sync
- **Example:** "2026-02-10T12:00:00Z"

### `validation_log`
- **Type:** ValidationEntry[]
- **Description:** History of validation runs (bash checks + guardians)
- **See:** [validation-log-schema.md](./validation-log-schema.md) for full schema

### `changes`
- **Type:** ChangeEntry[]
- **Description:** History of commits and which docs were updated

#### ChangeEntry Schema

```json
{
  "commit": string,              // Commit hash or "pending"
  "timestamp": string,           // ISO 8601 timestamp
  "summary": string,             // Commit message or description
  "files_changed": string[],     // List of files modified
  "docs_updated": string[],      // ANT-* docs that were auto-updated
  "suggested_reviews": SuggestedReview[],
  "action": "updated" | "no-op",
  "reason": string               // Why action was taken
}
```

#### SuggestedReview Schema

```json
{
  "doc": string,                 // Path to doc that needs review
  "reason": string,              // Why it needs review
  "layer": string                // "strategy" | "product" | "patterns" | "architecture" | "service"
}
```

### `graduations`
- **Type:** GraduationEntry[]
- **Description:** History of ANT-* files graduated to native files
- **Added:** v0.1 (graduation feature)

#### GraduationEntry Schema

```json
{
  "timestamp": string,           // ISO 8601 timestamp
  "ant_file": string,            // Original ANT-* filename
  "native_file": string,         // Native filename it graduated to
  "backup_created": string,      // Backup filename (if existing file was replaced)
  "commit": string,              // Commit hash where graduation happened
  "pool": string,                // "programmatic" | "tokenized" | "intentional"
  "layer": string                // "strategy" | "product" | "patterns" | "architecture" | "service"
}
```

## Examples

### Minimal Manifest (New Project)

```json
{
  "version": "0.1",
  "repo": "my-project",
  "last_sync": null,
  "validation_log": [],
  "changes": [],
  "graduations": []
}
```

### Active Project with Graduations

```json
{
  "version": "0.1",
  "repo": "my-project",
  "last_sync": "2026-02-10T12:00:00Z",
  "validation_log": [
    {
      "timestamp": "2026-02-10T12:00:00Z",
      "commit": "abc1234",
      "trigger": "pre_commit",
      "validation_type": "bash",
      "bash_checks": {
        "run": true,
        "passed": true,
        "violations": [],
        "cost": 0.0
      },
      "guardians_consulted": [],
      "total_violations": 0,
      "total_cost_usd": 0.0,
      "prevented_issues": false
    }
  ],
  "changes": [
    {
      "commit": "abc1234",
      "timestamp": "2026-02-10T12:00:00Z",
      "summary": "Add authentication module",
      "files_changed": ["src/auth/login.ts", "src/auth/token.ts"],
      "docs_updated": ["src/auth/ANT-README.md"],
      "suggested_reviews": [],
      "action": "updated",
      "reason": "Added authentication module, updated service docs"
    }
  ],
  "graduations": [
    {
      "timestamp": "2026-02-10T13:00:00Z",
      "ant_file": "src/auth/ANT-README.md",
      "native_file": "src/auth/README.md",
      "backup_created": "src/auth/README.md.backup",
      "commit": "def5678",
      "pool": "programmatic",
      "layer": "service"
    }
  ]
}
```

## Usage

**Worker ant writes to this file:**
- After each commit (adds to `changes`)
- After validation runs (adds to `validation_log`)
- After graduation (adds to `graduations`)

**Commands read this file:**
- `/ant-validation-report` - Reads `validation_log` for metrics
- `/ant-review-suggestions` - Reads `changes` for suggested reviews
- `/ant-validate` - Reads last validation entry
- `/ant-graduate` - Writes to `graduations` after file graduation

## Backward Compatibility

- `graduations` field is optional (added in v0.1)
- If missing, assume no graduations have occurred
- Tools should handle missing fields gracefully

## Forward Compatibility

- `version` field allows future schema changes
- Tools should check version and handle accordingly
- Unknown fields should be preserved (don't delete)
