---
description: Analyze changes and propose doc updates
allowed-tools: Read, Glob, Grep, Bash, Write, Edit
---

# 🐜 Ant Suggest: Analyze & Propose Updates

Analyze recent code changes and propose updates to ANT-PROGRAMMATIC, ANT-TOKENIZED, or ANT-INTENTIONAL.

**Semi-automated:** Agent analyzes and proposes; user approves; agent writes.

**When to use:**
- After merging a feature branch
- After significant refactoring
- Periodically (weekly/monthly) to catch accumulated drift
- When `/ant-validate` reports drift

---

## Instructions

When the user runs `/ant-suggest`:

### Step 1: Analyze Recent Changes

Get recent git history:

```bash
# Last 5 commits
git log -5 --oneline --name-status
```

OR if user specifies a range:
```bash
# Between branches or commits
git diff main...feature-branch --name-status
```

Extract:
- New files added
- Files deleted
- Files with significant changes (>50 lines changed)

### Step 2: Categorize Changes

Analyze changes and categorize:

**Programmatic (code):**
- New source files, scripts, configs
- New directories
- Deleted files

**Tokenized (patterns):**
- New patterns introduced (e.g., new API structure, new naming convention)
- Pattern changes (e.g., switched from REST to GraphQL)
- Tech stack changes (e.g., added a new framework)

**Intentional (strategy):**
- Breaking changes (why?)
- Architectural shifts (why?)
- New constraints (why?)

### Step 3: Read Current Docs

Read:
- `.alexantria/ANT-PROGRAMMATIC.md` — File index
- `.alexantria/ANT-TOKENIZED.md` — Patterns (if exists)
- `.alexantria/ANT-INTENTIONAL.md` — Intent (if exists)

Understand what's currently documented.

### Step 4: Generate Proposals

For each category, propose specific updates:

**Example Output:**

```markdown
🐜 Proposed Documentation Updates
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Based on analysis of recent commits (last 5):

## ANT-PROGRAMMATIC.md Updates

**Add these files:**
- `src/auth/login.ts` — New authentication module
- `docs/api-guide.md` — API documentation
- `tests/auth.test.ts` — Auth test suite

**Remove these files:**
- `src/old-auth.js` — Deleted in commit abc123

## ANT-TOKENIZED.md Updates

**New pattern detected:**

Current docs say: "API endpoints in /api/ directory"
Code now shows: "API endpoints in /src/routes/ and /src/api/"

**Proposed addition to ANT-TOKENIZED.md:**

> ### API Route Organization
>
> API endpoints are split across two directories:
> - `/src/routes/` — Public-facing REST endpoints
> - `/src/api/` — Internal API utilities
>
> All routes use Express middleware pattern.

## ANT-INTENTIONAL.md Updates

**Breaking change detected:**

Commit def456: "Migrate from session-based to JWT auth"

**Proposed addition to ANT-INTENTIONAL.md:**

> ### Authentication Strategy
>
> **Decision:** Migrated from session-based to JWT authentication (2026-02-11)
>
> **Why:** Session storage didn't scale across multiple servers. JWTs enable stateless auth.
>
> **Trade-off:** Slightly more complex token management, but better scalability.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Would you like me to apply these updates? (yes/no/edit)
```

### Step 5: User Approval

Present proposals and wait for user input:
- **yes** — Apply all updates
- **no** — Cancel, don't apply
- **edit** — User provides corrections/refinements
- **partial** — User specifies which to apply (e.g., "just SURFACE and DOCS, skip STRATEGY")

### Step 6: Apply Updates

If approved, use Write or Edit tool to update the appropriate ANT-* files:

1. For ANT-PROGRAMMATIC.md: Add/remove file references
2. For ANT-TOKENIZED.md: Add new pattern sections or update existing
3. For ANT-INTENTIONAL.md: Add decision log entries

After writing, confirm:
```
✅ Updated ANT-PROGRAMMATIC.md (added 3 files, removed 1)
✅ Updated ANT-TOKENIZED.md (added API route pattern)
✅ Updated ANT-INTENTIONAL.md (added auth decision)

Changes ready to commit. Use /ant-capture for next commit.
```

---

## Analysis Strategy

### Detecting New Files
Simple: compare git diff --name-status with ANT-PROGRAMMATIC.md

### Detecting Pattern Changes
Look for:
- New directories (suggests new module/area)
- Changes to config files (package.json, tsconfig.json) — tech stack changes
- Multiple files in same area with similar changes — pattern shift

### Detecting Strategic Changes
Look for:
- Commit messages with words: "migrate", "refactor", "breaking", "redesign"
- Large file deletions/additions (>500 lines) — architectural shift
- Changes to core modules (auth, db, api) — strategic areas

**Use heuristics, not magic.** This is assistant-powered analysis, not AI magic. Be transparent about what you're inferring.

---

## Output Format

Always structure proposals as:

```markdown
## [ANT-FILE].md Updates

**What changed:**
[Brief description of detected changes]

**Current state:**
[What docs currently say, if relevant]

**Proposed update:**
[Specific content to add/change/remove]

**Reasoning:**
[Why this update is suggested]
```

Make it easy for user to approve, reject, or refine.

---

## Implementation Notes

**DO:**
- Analyze git history (recent commits or specified range)
- Categorize changes (Programmatic/Tokenized/Intentional)
- Propose specific, concrete updates
- Show proposals BEFORE applying
- Wait for user approval
- Apply updates using Write/Edit tools

**DON'T:**
- Apply updates without approval
- Make vague proposals ("update docs")
- Guess at strategic reasoning (ask user if unclear)
- Over-analyze (keep it practical)

**Key Principle:** This is *analysis-assisted documentation maintenance*. The agent helps detect drift and propose fixes, but the user approves what matters.
