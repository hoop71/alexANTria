# alexANTria Config Schema

`.alexantria/config.json` - Project-level configuration for alexANTria documentation system.

## Schema

```json
{
  "version": "0.2",
  "scope": {
    "managed_paths": string[],
    "exclude_paths": []
  },
  "adoption_stage": "pilot" | "active" | "full"
}
```

**Note:** alexANTria is automatic by default. If `.alexantria/` exists, documentation maintenance is active.

## Fields

### `version`
- **Type:** string
- **Current:** "0.2"
- **Description:** Config schema version

### `scope.managed_paths`
- **Type:** string[] (glob patterns)
- **Default:** ["**"]
- **Description:** Which paths worker ant manages
- **Examples:**
  - `["src/**"]` - Only src/
  - `["src/auth/**", "src/api/**"]` - Specific modules
  - `["**"]` - Everything (full adoption)

### `scope.exclude_paths`
- **Type:** string[] (glob patterns)
- **Default:** []
- **Description:** Paths to never touch
- **Examples:**
  - `["src/legacy/**"]` - Don't touch legacy code
  - `["**/vendor/**", "**/node_modules/**"]` - Exclude deps

### `adoption_stage`
- **Type:** string
- **Options:** "pilot", "active", "full"
- **Default:** "pilot"
- **Description:** Adoption stage (informational, affects defaults)


## Example Configurations

### Pilot (Test in One Directory)
```json
{
  "version": "0.2",
  "scope": {
    "managed_paths": ["src/auth/**"]
  },
  "adoption_stage": "pilot"
}
```

**Result:** Documentation maintained for src/auth/ only.

### Active (Expanding Scope)
```json
{
  "version": "0.2",
  "scope": {
    "managed_paths": ["src/**", "lib/**"],
    "exclude_paths": ["src/legacy/**"]
  },
  "adoption_stage": "active"
}
```

**Result:** Documentation maintained across src/ and lib/, excluding legacy code.

### Full (Complete Automation)
```json
{
  "version": "0.2",
  "scope": {
    "managed_paths": ["**"]
  },
  "adoption_stage": "full"
}
```

**Result:** Documentation maintained for entire repository.

## RLM Three-Pool Architecture

alexANTria implements the three-pool RLM architecture:

1. **Programmatic Pool** - File index, discoverable from code
2. **Tokenized Pool** - Patterns and conventions, must be documented
3. **Intentional Pool** - Strategy and principles, human knowledge

Higher levels constrain lower levels. The `starting_level` determines automation boundary.

## Migration and Removal

### Remove alexANTria
```bash
git rm -r .alexantria/ .claude/ CLAUDE.md
git commit -m "Remove alexANTria"
```

Clean removal. No trace left.
