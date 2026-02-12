---
description: Capture intent during commits
allowed-tools: Read, Glob, Grep, Bash, Write, Edit
---

# 🐜 Ant Capture: Capture Intent During Commits

Wrapper around `git commit` that captures human intent to appropriate documentation layers.

**Human-in-loop:** Agent analyzes staged changes → prompts for "why" → captures to right layer → commits atomically.

**When to use:**
- Every commit (instead of plain `git commit`)
- When changes introduce new patterns
- When changes affect strategic areas (auth, architecture, core modules)

---

## Instructions

When the user runs `/ant-capture` or `/ant-capture -m "commit message"`:

### Step 1: Check Staged Changes

```bash
# Check what's staged
git diff --cached --name-status
git diff --cached --stat
```

If nothing staged:
```
❌ No changes staged. Use `git add` first.
```

### Step 2: Analyze Staged Changes

Categorize staged files:

**Code changes (Programmatic):**
- New source files (*.js, *.ts, *.py, etc.)
- Config changes (package.json, tsconfig.json)
- Test files

**Documentation changes (Tokenized):**
- Markdown files (*.md)
- ANT-* files
- README updates

**Infrastructure changes:**
- CI/CD configs (.github/workflows/)
- Docker, deployment configs

### Step 3: Detect If Intent Capture Is Needed

Check if ANY of these are true:

**New pattern introduced:**
- New directory created (suggests new module/concept)
- Multiple related files (suggests pattern)
- Config changes that affect structure

**Strategic change:**
- Core area modified (auth, database, API architecture)
- Breaking changes (determined from file diffs)
- Large refactoring (>200 lines changed in key files)

**Documentation updated:**
- ANT-TOKENIZED.md or ANT-INTENTIONAL.md changed
- Pattern docs updated

If YES to any → Prompt for intent
If NO → Just commit normally (skip to Step 6)

### Step 4: Prompt for Intent (If Needed)

**For new patterns:**
```
🐜 New pattern detected

Changes suggest a new pattern:
  • New directory: src/auth/
  • New files: login.ts, register.ts, middleware.ts

Should I document this in ANT-TOKENIZED.md?

What pattern are you introducing?
> [User provides: "JWT-based authentication with Express middleware"]

Where should this pattern be documented?
  1. ANT-TOKENIZED.md (pattern explanation)
  2. ANT-INTENTIONAL.md (why we chose this)
  3. Both
  4. Skip (no docs needed)
> [User selects: 3]
```

**For strategic changes:**
```
🐜 Strategic change detected

You modified core authentication (src/auth/):
  • Deleted: session-auth.js
  • Added: jwt-auth.ts

Why did we make this change?
> [User provides: "Sessions don't scale across multiple servers. JWTs enable stateless auth."]

I'll capture this to ANT-INTENTIONAL.md.
```

**For breaking changes:**
```
🐜 Breaking change detected

This change may break existing behavior:
  • Changed API endpoint structure
  • Removed /api/v1/users route

Why break this? What's the migration path?
> [User provides: "Consolidating to /api/v2. Old v1 endpoints deprecated, docs updated."]
```

### Step 5: Capture Intent to Appropriate Layer

Based on user responses, update docs BEFORE committing:

**For ANT-TOKENIZED.md (patterns):**
```markdown
## [Pattern Name]

[User's explanation of the pattern]

**Files involved:**
- src/auth/login.ts
- src/auth/middleware.ts

**When to use:**
[Brief usage guidance if provided]
```

**For ANT-INTENTIONAL.md (intent):**
```markdown
## [Decision Title]

**Date:** 2026-02-11
**Context:** [What was the situation?]
**Decision:** [What did we decide?]
**Why:** [User's reasoning]
**Trade-offs:** [Any downsides or considerations]

**Related commits:** [commit hash]
```

**For ANT-PROGRAMMATIC.md (file index):**
Just add/remove file references:
```markdown
- `src/auth/login.ts` — JWT authentication login
- `src/auth/register.ts` — User registration
```

### Step 6: Commit Everything Atomically

Stage doc updates:
```bash
git add .alexantria/ANT-TOKENIZED.md .alexantria/ANT-INTENTIONAL.md .alexantria/ANT-PROGRAMMATIC.md
```

Commit with user's message (or generate one):
```bash
git commit -m "feat: Add JWT authentication

Introduced JWT-based auth to replace session-based approach.
See ANT-INTENTIONAL.md for reasoning."
```

**IMPORTANT:** Follow .claude/rules/commands.md — NO AI attribution in commits. Plain commit messages.

### Step 7: Confirm

```
✅ Committed changes
   • Code: src/auth/*.ts
   • Docs: ANT-TOKENIZED.md (JWT pattern)
   • Strategy: ANT-INTENTIONAL.md (auth decision)

Commit: abc1234
Message: "feat: Add JWT authentication"
```

---

## Decision Tree

```
Staged changes exist?
├─ NO → Error: "Nothing staged"
└─ YES → Analyze changes
    ├─ New pattern? → Prompt: "What pattern?"
    ├─ Strategic change? → Prompt: "Why?"
    ├─ Breaking change? → Prompt: "Why break? Migration?"
    └─ None of above → Just commit (no prompts)

User provides intent?
├─ YES → Update docs → Stage docs → Commit all
└─ NO/Skip → Commit without doc updates
```

---

## Command Variants

**Basic usage:**
```bash
/ant-capture
```
Analyzes staged changes, prompts if needed, commits.

**With message:**
```bash
/ant-capture -m "Add authentication"
```
Use provided message, still prompt for intent if pattern/strategic change detected.

**Skip intent capture:**
```bash
/ant-capture --no-capture
```
Just commit without prompting (fallback to regular git commit behavior).

---

## Implementation Notes

**DO:**
- Analyze staged changes (git diff --cached)
- Detect new patterns, strategic changes, breaking changes
- Prompt user for "why" when appropriate
- Update relevant ANT-* files BEFORE committing
- Stage doc updates with code
- Commit atomically (code + docs together)
- Use plain commit messages (no AI attribution)

**DON'T:**
- Prompt for every trivial commit (typo fixes, formatting)
- Generate commit messages without user input (unless clearly derivable)
- Update docs without user approval/input
- Commit docs separately from code (atomic commits)

**Key Principle:** Capture human intent at the moment of decision (during commit), when context is fresh. Make it easy to record "why" without interrupting flow.
