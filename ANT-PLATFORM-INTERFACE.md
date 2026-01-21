# Platform Adapter Interface

alexANTria is a universal organizational knowledge framework. This document defines the platform primitives needed to implement alexANTria on any system.

## Core Abstractions

### 1. Layers (Platform-Agnostic)

```
Queen (Layer 1)    - Strategic alignment
Nest (Layer 2)     - Department/team views
Chambers (Layer 3) - Cross-cutting patterns
Tunnels (Layer 4)  - Architecture/connections
Surface (Layer 5)  - Service/component docs
```

**Precedence:** Higher layers constrain lower layers.

**Implementation:** Markdown files in a directory structure.

### 2. Required Platform Primitives

#### A. Always-Loaded Context
**Purpose:** Load project hierarchy in every session.

**Claude Code:** `CLAUDE.md`
**Cursor:** `.cursorrules`
**VSCode:** `README.md` + extension support
**Generic:** `README.md` (user manually references)

#### B. Path-Based Rules
**Purpose:** Auto-load context based on file being edited.

**Claude Code:** `.claude/rules/*.md` with `paths:` frontmatter
**Cursor:** TBD (investigate .cursorrules capabilities)
**VSCode:** Extension with file watcher
**Generic:** Convention (user manually reads appropriate docs)

#### C. Executable Commands
**Purpose:** Scaffold and maintain structure.

**Claude Code:** `.claude/skills/*/SKILL.md`
**Cursor:** TBD (investigate prompt patterns)
**VSCode:** Extension commands
**Generic:** Shell scripts (bash, python)

#### D. Tool Primitives
**Required capabilities:**
- `read(path)` - Read file contents
- `write(path, content)` - Create/overwrite file
- `edit(path, old, new)` - Replace substring
- `bash(cmd)` - Execute shell command
- `ask_user(question, options)` - Prompt for input
- `glob(pattern)` - Find files by pattern
- `grep(pattern, path)` - Search file contents

**Claude Code:** Native tools
**Others:** Must provide equivalent capabilities

### 3. Core Business Logic (Platform-Agnostic)

These should be extractable to pure functions:

**Discovery:**
```typescript
function discoverDocs(rootPath: string): Document[] {
  // Find .md files, classify by content/location
  // Returns: [{path, layer, content, metadata}]
}
```

**Classification:**
```typescript
function classifyDocument(doc: Document): Layer {
  // Analyze content, determine which layer
  // Returns: 'queen' | 'nest' | 'chambers' | 'tunnels' | 'surface'
}
```

**Scaffolding:**
```typescript
function generateStructure(
  discovered: Document[],
  platform: Platform
): FileOperation[] {
  // Propose structure, return file operations
  // Platform-specific: where to put files
}
```

**Maintenance:**
```typescript
function assessCommit(
  commit: Commit,
  structure: Structure
): UpdateOperation[] {
  // Determine what docs need updating
  // Returns: [{file, reason, suggestedContent}]
}
```

## Implementation Strategy

### Phase 1: Claude Code Native (v1.0)
- Build fully on Claude infrastructure
- Keep business logic in pure functions where possible
- Document the abstractions (this file)

### Phase 2: Extract Core (v1.5)
- Move pure logic to `alexantria-core` package
- Create `Platform` interface
- Implement `ClaudeAdapter` using native tools
- Refactor ant-* commands to use adapter

### Phase 3: Multi-Platform (v2.0)
- Implement adapters: Cursor, VSCode, Generic
- Each adapter maps platform primitives to interface
- Core logic unchanged across platforms

## Example: Platform Adapter

```typescript
interface Platform {
  // Load context
  loadContext(path: string): Promise<string>

  // Execute tools
  read(path: string): Promise<string>
  write(path: string, content: string): Promise<void>
  bash(cmd: string): Promise<string>
  askUser(q: string, opts: string[]): Promise<string>

  // Platform-specific paths
  getRulesDir(): string      // .claude/rules/ or equivalent
  getSkillsDir(): string     // .claude/skills/ or equivalent
  getMemoryFile(): string    // CLAUDE.md or equivalent
}

// Claude implementation
class ClaudeAdapter implements Platform {
  getRulesDir() { return '.claude/rules' }
  getSkillsDir() { return '.claude/skills' }
  getMemoryFile() { return 'CLAUDE.md' }
  // ... tool implementations using Claude's Bash, Read, etc
}

// Generic implementation
class GenericAdapter implements Platform {
  getRulesDir() { return 'docs/rules' }
  getSkillsDir() { return 'scripts' }
  getMemoryFile() { return 'README.md' }
  // ... tool implementations using fs, child_process
}
```

## Migration Path

**v1.0:** Fully Claude-native, document abstractions
**v1.5:** Extracted core + Claude adapter
**v2.0:** Multi-platform support

## Why This Matters

**alexANTria is a pattern, not an implementation:**
- The 5-layer hierarchy works on any platform
- Read-act-repair works with any agent or human workflow
- Bidirectional flow is organizational, not technical

**Current state (v0.1.0):** Tightly coupled to Claude Code
**Target state (v2.0):** Universal framework with platform adapters

The pattern is bigger than any single platform. This document ensures we can port alexANTria to Cursor, VSCode, or even non-AI environments while keeping the core organizational principles intact.
