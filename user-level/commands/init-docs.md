---
description: Scaffold a CLAUDE.md and .claude/rules/ structure for this project
allowed-tools: Read, Write, Glob, Bash, AskUserQuestion
---

# Initialize Project Documentation Structure

Help the user set up context automation for this project.

## Steps

### 1. Understand the Project

First, look for existing documentation:

```bash
# Check for common doc files
ls -la *.md docs/*.md 2>/dev/null || true
```

Ask the user:
- What kind of project is this? (web app, CLI, library, API, etc.)
- What are the main documentation files? (or should we create them?)
- What's the directory structure for code? (src/? lib/? app/?)

### 2. Identify the Document Hierarchy

Help the user identify their docs in priority order. Common patterns:

**For product/app projects:**
1. UX/Design constraints (highest priority)
2. Product brief / business rules
3. Technical architecture
4. Decision changelog

**For libraries/tools:**
1. API design principles
2. Contributing guidelines
3. Architecture docs
4. Changelog

**For APIs/services:**
1. API contracts / OpenAPI spec
2. Security requirements
3. Architecture docs
4. Runbooks

### 3. Create CLAUDE.md

Create a `CLAUDE.md` in the project root with:

```markdown
# [Project Name] – Claude Context

## Document Hierarchy (Highest to Lowest Priority)

1. **[doc-name.md](./path)** — [What it governs]
2. **[doc-name.md](./path)** — [What it governs]
3. ...

## When to Read

| Working on... | Read first |
|--------------|------------|
| [area] | [doc link] |
| [area] | [doc link] |

## When to Suggest Updates

After completing work that affects:
- [area] → update [doc]
- [area] → update [doc]
```

### 4. Create .claude/rules/

Create path-specific rules based on the project structure:

```bash
mkdir -p .claude/rules
```

For each major code area, create a rule file:

**`.claude/rules/frontend.md`** (if applicable)
```markdown
---
paths:
  - "src/components/**/*.tsx"
  - "src/routes/**/*.tsx"
  - "app/**/*.tsx"
---

# Frontend Context

Before modifying UI, read:
- [Link to UX/design constraints doc]

## Quick Reference
- [Key UI guidelines from the project]
```

**`.claude/rules/backend.md`** (if applicable)
```markdown
---
paths:
  - "src/server/**/*.ts"
  - "api/**/*.ts"
  - "lib/**/*.ts"
---

# Backend Context

Before modifying server code, read:
- [Link to architecture doc]

## Quick Reference
- [Key backend patterns from the project]
```

**`.claude/rules/agents.md`** (if applicable, for AI/LLM projects)
```markdown
---
paths:
  - "src/agents/**/*.ts"
  - "prompts/**/*"
---

# Agent Context

Before modifying agents/prompts, read:
- [Link to agent behavior doc]

## Quick Reference
- [Key agent guidelines from the project]
```

### 5. Confirm Setup

After creating files, show the user what was created:

```
Created:
  CLAUDE.md              - Document hierarchy and reading instructions
  .claude/rules/         - Path-specific context rules
    ├── frontend.md      - UI component guidance
    ├── backend.md       - Server code guidance
    └── ...

Next: Review CLAUDE.md and customize the "When to Read" table for your docs.
```

## Notes

- Don't create docs that don't exist — just reference existing ones
- Keep rules files short — they should point to docs, not duplicate them
- Ask about the project rather than assuming structure
- If the user already has a CLAUDE.md, offer to enhance it rather than replace it
