---
description: Initialize alexANTria in project
allowed-tools: Read, Write, Glob, Grep, Bash
---

# 🐜 Ant Init: Scaffold Structure

Initialize alexANTria documentation structure in your project.

**What it does:**
- Creates CLAUDE.md (hierarchy map)
- Creates .alexantria/ directory with ANT-* templates
- Creates .claude/rules/ if needed
- Scaffolds basic structure

**Simple, not magical.** Just creates files. You edit them to fit your project.

---

## Instructions

When the user runs `/ant-init`:

### Step 1: Check If Already Initialized

```bash
test -f CLAUDE.md && echo "exists" || echo "missing"
test -d .alexantria && echo "exists" || echo "missing"
```

If .alexantria/ already exists:
```
⚠️  alexANTria already initialized here.

Found:
  • .alexantria/

Run /ant-validate to check health, or manually edit these files.
```

Stop here. Don't overwrite existing setup.

**Note:** If CLAUDE.md exists but .alexantria/ doesn't, continue with initialization (preserve existing CLAUDE.md).

### Step 2: Discover Project Structure

Use one bash command to understand project:

```bash
{
  echo "=== DOCS ==="
  find . -maxdepth 2 -name "*.md" -type f 2>/dev/null | grep -v node_modules | head -20

  echo "=== CODE ==="
  ls -d src/ app/ lib/ packages/ 2>/dev/null || echo "none"

  echo "=== GIT ==="
  git remote get-url origin 2>/dev/null || echo "no remote"
}
```

Process this internally. Use it to populate templates with reasonable defaults.

### Step 3: Create Directory Structure

```bash
mkdir -p .alexantria
mkdir -p .claude/rules
```

### Step 4: Create CLAUDE.md (If Needed)

**Check if CLAUDE.md already exists:**
```bash
test -f CLAUDE.md && echo "exists" || echo "missing"
```

**If CLAUDE.md exists:** Skip creating it (preserve existing file). Note this for the final output.

**If CLAUDE.md doesn't exist:** Write CLAUDE.md to project root. Use template:

```markdown
# alexANTria – Context

Documentation hierarchy for this project.

## Docs

**RLM:** Programmatic (code) → Tokenized (attention) → Intentional (intent)

### Programmatic

**Surface** — [.alexantria/ANT-PROGRAMMATIC.md](./.alexantria/ANT-PROGRAMMATIC.md)

File index. What exists, where to find it.

### Tokenized

**Docs** — [.alexantria/ANT-TOKENIZED.md](./.alexantria/ANT-TOKENIZED.md)

Patterns, conventions, system structure. What can't be inferred from code.

### Intentional

**Strategy** — [.alexantria/ANT-INTENTIONAL.md](./.alexantria/ANT-INTENTIONAL.md)

Why decisions were made, who this is for, core principles.

## Quick Reference

| Working on... | Read | Level |
|--------------|------|-------|
| Understanding project | ANT-PROGRAMMATIC.md | Programmatic |
| Following patterns | ANT-TOKENIZED.md | Tokenized |
| Making decisions | ANT-INTENTIONAL.md | Intentional |

## Commands

- `/ant-validate` — Check documentation health
- `/ant-suggest` — Analyze changes, propose doc updates
- `/ant-capture` — Capture intent during commits

## After Changes

When you make changes:
- **New files or structure** → Update ANT-PROGRAMMATIC.md
- **New patterns or conventions** → Update ANT-TOKENIZED.md
- **Strategic decisions** → Update ANT-INTENTIONAL.md

Run `/ant-suggest` to get automated proposals.
```

### Step 5: Create ANT-PROGRAMMATIC.md Template

Write `.alexantria/ANT-PROGRAMMATIC.md`:

```markdown
# ANT-PROGRAMMATIC: File Index

> **Level: Programmatic** — What exists and where to find it.

## Core Documentation

- [README.md](../README.md) — Project overview
[List other key markdown files found]

## Code Structure

[Describe directory structure based on what was discovered]

Example:
```
src/
├── components/    — UI components
├── utils/         — Shared utilities
└── main.ts        — Entry point
```

## Important Files

[List configuration files, entry points, etc.]

---

*Edit this file to match your project structure. Run `/ant-validate` to check for drift.*
```

Populate this with actual files found during discovery (Step 2).

### Step 6: Create ANT-TOKENIZED.md Template

Write `.alexantria/ANT-TOKENIZED.md`:

```markdown
# ANT-TOKENIZED: Patterns & Conventions

> **Level: Tokenized** — What can't be inferred from code alone.

## Patterns

[Document your project's patterns here]

### Example: API Pattern
```
/api/v1/[resource]/[action]
```

### Example: Component Pattern
```
All React components in src/components/
Named exports, PascalCase
```

## Conventions

[Document conventions here]

- Naming: [your conventions]
- Testing: [your patterns]
- Imports: [your patterns]

## Tech Stack

[List key technologies]

---

*Add patterns as they emerge. Run `/ant-suggest` after major changes to get automated proposals.*
```

### Step 7: Create ANT-INTENTIONAL.md Template

Write `.alexantria/ANT-INTENTIONAL.md`:

```markdown
# ANT-INTENTIONAL: Intent & Decisions

> **Level: Intentional** — Why decisions were made, who this is for.

## Purpose

[What is this project for? Who uses it?]

## Core Principles

[What principles guide this project?]

Example:
- Performance over convenience
- Explicit over implicit
- Security by default

## Decision Log

[Record major decisions here]

### [Decision Title]

**Date:** YYYY-MM-DD
**Context:** [What was the situation?]
**Decision:** [What did we decide?]
**Why:** [Reasoning]
**Trade-offs:** [What did we give up?]

---

*Use `/ant-capture` during commits to automatically add decision log entries.*
```

### Step 8: Create Basic Rules (Optional)

If code structure detected (src/, app/, etc.), create basic path-based rules.

Example `.claude/rules/codebase.md`:

```markdown
---
paths:
  - "**/*.ts"
  - "**/*.js"
---

# Codebase Rules

Before making changes, read:
- [ANT-TOKENIZED.md](../../.alexantria/ANT-TOKENIZED.md) — Patterns and conventions

Follow the project's established patterns.
```

### Step 9: Install Git Hook (Automatic)

If .git/ directory exists, install pre-commit hook automatically:

```bash
if [ -d .git ]; then
  cat > .git/hooks/pre-commit <<'EOF'
#!/bin/bash
# alexANTria: Automatic documentation maintenance
# Runs /ant-capture before every commit

if [ -f .alexantria/ANT-PROGRAMMATIC.md ]; then
  if command -v claude &> /dev/null; then
    # Run ant-capture to maintain docs
    claude /ant-capture
  else
    echo ""
    echo "⚠️  alexANTria installed but Claude not in PATH"
    echo "    Documentation will not be updated automatically."
    echo ""
    echo "Continue commit without doc updates? [Y/n]"
    read -r response
    if [[ "$response" =~ ^[Nn]$ ]]; then
      echo "Commit cancelled. Fix PATH and try again."
      exit 1
    fi
  fi
fi
EOF
  chmod +x .git/hooks/pre-commit
  echo "✅ Git pre-commit hook installed (runs /ant-capture automatically)"
else
  echo "⚠️  No .git directory found. Git hook not installed."
  echo "    Initialize git repo first: git init"
fi
```

### Step 10: Confirm

**If CLAUDE.md was created (didn't exist before):**

```
✅ alexANTria structure created

Created:
  • CLAUDE.md — Hierarchy map
  • .alexantria/ANT-PROGRAMMATIC.md — File index and code structure
  • .alexantria/ANT-TOKENIZED.md — Patterns and conventions
  • .alexantria/ANT-INTENTIONAL.md — Strategic decisions and principles
  • .claude/rules/codebase.md — Path-based rules
  • .git/hooks/pre-commit — Automatic doc maintenance

🤖 Automatic Features Enabled:
  • Commits will automatically run /ant-capture (via git hook)
  • Project open will validate docs health
  • Commands run proactively when needed

Next steps:
  1. Review the ANT-* files and customize them for your needs
  2. Make a commit - /ant-capture runs automatically
  3. Run /ant-validate anytime to check health
  4. Run /ant-suggest after major changes for proposals

Documentation: https://github.com/hoop71/alexANTria
```

**If CLAUDE.md already existed (was preserved):**

```
✅ alexANTria structure created

Created:
  • .alexantria/ANT-PROGRAMMATIC.md — File index and code structure
  • .alexantria/ANT-TOKENIZED.md — Patterns and conventions
  • .alexantria/ANT-INTENTIONAL.md — Strategic decisions and principles
  • .claude/rules/codebase.md — Path-based rules for [detected language] files
  • .git/hooks/pre-commit — Automatic doc maintenance

Note: Your existing CLAUDE.md was preserved (not overwritten) since it contains custom project documentation.

🤖 Automatic Features Enabled:
  • Commits will automatically run /ant-capture (via git hook)
  • Project open will validate docs health
  • Commands run proactively when needed

---
Integration Suggestion

You have two options:

Option 1: Add alexANTria hierarchy to existing CLAUDE.md

Add this section to your existing CLAUDE.md:

## alexANTria Documentation Hierarchy

**RLM:** Programmatic → Tokenized → Intentional

- [ANT-PROGRAMMATIC.md](./.alexantria/ANT-PROGRAMMATIC.md) — File index and structure
- [ANT-TOKENIZED.md](./.alexantria/ANT-TOKENIZED.md) — Patterns and conventions
- [ANT-INTENTIONAL.md](./.alexantria/ANT-INTENTIONAL.md) — Strategic decisions

When making changes:
- New files/structure → Update ANT-PROGRAMMATIC.md
- New patterns → Update ANT-TOKENIZED.md
- Strategic decisions → Update ANT-INTENTIONAL.md

Option 2: Keep separate

Leave CLAUDE.md as-is (detailed technical guide) and use the ANT-* files for higher-level documentation organization.

---
Next Steps

1. Review the ANT-* files and customize them for your needs
2. Run /ant-validate to check documentation health
3. Use /ant-capture during commits to capture intent
4. Use /ant-suggest after major changes for doc update proposals

Documentation: https://github.com/hoop71/alexANTria
```

---

## Implementation Notes

**DO:**
- Create basic file structure
- Populate templates with discovered info (files, structure)
- Keep templates simple and obvious
- Check if already initialized (don't overwrite)

**DON'T:**
- Ask multiple questions (just create sensible defaults)
- Create complex configurations
- Try to be too smart (simple scaffolding)
- Overwrite existing files

**Key Principle:** This is *scaffolding*, not magic. Create structure, let user customize. Make it obvious what each file is for and how to use it.
