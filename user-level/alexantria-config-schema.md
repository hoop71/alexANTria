# alexANTria Config Schema

`.alexantria/config.json` - Project-level configuration for scope, updates, and adoption stage.

## Schema

```json
{
  "version": "0.1",
  "worker_ant": {
    "enabled": boolean,
    "mode": "auto" | "agent-only" | "manual"
  },
  "scope": {
    "managed_paths": string[],
    "exclude_paths": string[],
    "starting_level": "surface" | "tunnels" | "chambers"
  },
  "auto_update": {
    "ant_files": boolean
  },
  "commit_tracking": {
    "enabled": boolean
  },
  "validation": {
    "enabled": boolean,
    "level": "critical" | "full",
    "checkpoints": {
      "pre_commit": boolean,
      "on_demand": boolean
    }
  },
  "adoption_stage": "pilot" | "active" | "full"
}
```

## Fields

### `worker_ant.enabled`
- **Type:** boolean
- **Default:** true
- **Description:** Master switch. If false, all worker ant behavior disabled.

### `worker_ant.mode`
- **Type:** string
- **Options:** "auto", "agent-only", "manual"
- **Default:** "auto"
- **Description:** How worker ant triggers

| Mode | Agent Commits | Human Commits |
|------|---------------|---------------|
| **auto** | Spawns worker ant | Hook warns/tries to spawn |
| **agent-only** | Spawns worker ant | Hook warns to use agent |
| **manual** | Manual /ant-update | Manual /ant-update |

### `scope.managed_paths`
- **Type:** string[] (glob patterns)
- **Default:** ["**"]
- **Description:** Which directories worker ant manages. Use globs.
- **Examples:**
  - `["src/**"]` - Only src/
  - `["src/auth/**", "src/api/**"]` - Specific modules
  - `["**"]` - Everything (full adoption)

### `scope.exclude_paths`
- **Type:** string[] (glob patterns)
- **Default:** []
- **Description:** Paths to never touch, even if in managed_paths
- **Examples:**
  - `["src/legacy/**"]` - Don't touch legacy code
  - `["**/vendor/**", "**/node_modules/**"]` - Exclude deps

### `scope.starting_level`
- **Type:** string
- **Options:** "surface", "tunnels", "chambers"
- **Default:** "surface"
- **Description:** Highest layer worker ant auto-maintains. Everything below = automated, everything above = suggestions only.
- **Layers:**
  - **surface** - Only ANT-SURFACE.md (directory-level docs)
  - **tunnels** - ANT-SURFACE.md + ANT-TUNNELS.md (architecture)
  - **chambers** - ANT-SURFACE.md + ANT-TUNNELS.md + ANT-CHAMBERS.md (patterns)
- **Note:** ANT-NEST.md and ANT-QUEEN.md always require manual updates (strategic/product layers)

### `auto_update.ant_files`
- **Type:** boolean
- **Default:** true
- **Description:** Auto-update ANT-* files at or below starting_level
- **Note:** Worker ant only touches ANT-* files. README.md and other docs require explicit migration via /ant-migrate

### `commit_tracking.enabled`
- **Type:** boolean
- **Default:** true
- **Description:** Track commits in manifest

### `validation.enabled`
- **Type:** boolean
- **Default:** false
- **Description:** Enable guardian agent validation system (opt-in)
- **Note:** When enabled, worker ant consults guardian agents to validate consistency

### `validation.level`
- **Type:** string
- **Options:** "critical", "full"
- **Default:** "critical"
- **Description:** Validation thoroughness level
- **Levels:**
  - **critical:** Only naming conventions and structural violations (fast, ~$0.005/check)
  - **full:** Everything including coherence, cross-references, duplication (comprehensive, ~$0.01-0.02/check)

### `validation.checkpoints.pre_commit`
- **Type:** boolean
- **Default:** true
- **Description:** Run guardians before commits (worker ant consults them)
- **Note:** Only runs guardians for affected layers (cost scales with changes)

### `validation.checkpoints.on_demand`
- **Type:** boolean
- **Default:** true
- **Description:** Allow /ant-check-consistency command
- **Note:** Runs all 5 guardians for comprehensive validation

### `adoption_stage`
- **Type:** string
- **Options:** "pilot", "active", "full"
- **Default:** "pilot"
- **Description:** Adoption stage (informational, affects defaults)

## Adoption Stages

### Pilot (Prove It Works)
**Goal:** Test in single directory with minimal risk
```json
{
  "scope": {
    "managed_paths": ["src/auth/**"],
    "starting_level": "surface"
  },
  "auto_update": {
    "ant_files": true
  },
  "adoption_stage": "pilot"
}
```
**Result:**
- ANT-SURFACE.md auto-maintained in src/auth/
- Higher layers (tunnels, chambers, nest, queen) get suggestions only
- README.md untouched (use /ant-migrate to convert later)

### Active (Expanding Scope)
**Goal:** Multiple directories, begin architecture docs
```json
{
  "scope": {
    "managed_paths": ["src/**", "lib/**"],
    "exclude_paths": ["src/legacy/**"],
    "starting_level": "surface"
  },
  "auto_update": {
    "ant_files": true
  },
  "adoption_stage": "active"
}
```
**Result:**
- ANT-SURFACE.md auto-maintained across src/ and lib/
- Optionally upgrade starting_level to "tunnels" to auto-maintain ANT-TUNNELS.md
- Can migrate README.md → ANT-SURFACE.md directory-by-directory

### Full (Complete Automation)
**Goal:** Entire repo, potentially including architecture layer
```json
{
  "scope": {
    "managed_paths": ["**"],
    "starting_level": "tunnels"
  },
  "auto_update": {
    "ant_files": true
  },
  "adoption_stage": "full"
}
```
**Result:**
- ANT-SURFACE.md auto-maintained everywhere
- ANT-TUNNELS.md auto-maintained (architecture)
- ANT-CHAMBERS.md, ANT-NEST.md, ANT-QUEEN.md get suggestions only
- All README.md files migrated to ANT-SURFACE.md

## Migration Paths

### Path 1: New Repo (Greenfield)
```
1. Run /ant-init
2. Choose "ANT-only" mode
3. Choose starting_level: "surface" (recommended)
4. ANT-SURFACE.md created in all directories
5. Fully automated from day 1
```

### Path 2: Existing Repo (Brownfield - Cautious)
```
1. Run /ant-init
2. Choose "Hybrid-to-ANT" mode
3. Set managed_paths: ["src/auth/**"] (single directory pilot)
4. Set starting_level: "surface"
5. ANT-SURFACE.md created, README.md stays
6. Test for 5-10 commits
7. Run /ant-migrate src/auth (README → ANT-SURFACE)
8. Expand scope to src/**
9. Repeat migration per directory
10. Eventually: full adoption
```

### Path 3: Existing Repo (Brownfield - Aggressive)
```
1. Run /ant-init
2. Choose "ANT-only" mode
3. Set managed_paths: ["src/**"]
4. Set starting_level: "surface"
5. Manually migrate existing READMEs:
   for dir in $(find src -type f -name README.md); do
     /ant-migrate $(dirname $dir)
   done
6. Full automation across src/
```

### Path 4: Rip It Out
```bash
git rm -r ANT-*.md .alexantria/ .claude/
git rm .git/hooks/pre-commit
git commit -m "Remove alexANTria"
```
Clean removal. No trace left.

## Team Adoption

**Critical:** All team members must have the same config. This file is committed to git.

**Scope control prevents partial adoption issues** - if src/auth/ is managed, ALL commits to src/auth/ get worker ant processing (via hook detection).
