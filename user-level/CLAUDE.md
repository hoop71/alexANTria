# How I Work With Project Documentation

## Core Principle: Read Before You Act

Every project has documentation that guides decisions. Before making changes:

1. **Identify what area** you're working in (UI? Backend? Agent behavior?)
2. **Check the project's CLAUDE.md** for its document hierarchy
3. **Read the relevant docs** before implementing
4. **After completing work**, ask if higher-level docs need updates

## Document Hierarchy Pattern

Most projects have layered documentation:

```
Philosophy/Constraints  ← Overrides everything below
    ↓
Product/Business Rules  ← Informs features
    ↓
Technical Patterns      ← Guides implementation
    ↓
Changelog/History       ← Records decisions
```

When you change something at a lower level that affects a higher level, suggest updating the upstream doc.

## When to Read Project Docs

Look for these common patterns in project CLAUDE.md files:

| Doc Type | Read Before |
|----------|-------------|
| "UX philosophy" / "design constraints" | Any UI work |
| "Product brief" / "business rules" | Scope decisions |
| "Architecture" / "technical patterns" | Implementation |
| "Interview methodology" / "agent behavior" | Prompt changes |
| "Changelog" / "decision log" | Understanding history |

## When to Suggest Updates

After completing work, ask yourself:

- Did I establish a **new pattern**? → Should it be documented?
- Did I change **existing behavior**? → Should constraints be updated?
- Did I make a **decision others should know**? → Should it be recorded?

If yes, ask the user if they want to update the relevant doc.

## How .claude/rules/ Works

Projects may have `.claude/rules/` with path-specific guidance:

```
.claude/rules/
├── frontend.md      # Auto-loads for src/components/**
├── backend.md       # Auto-loads for src/server/**
└── agents.md        # Auto-loads for src/agents/**
```

These files have frontmatter specifying which paths trigger them:

```yaml
---
paths:
  - "src/components/**/*.tsx"
---
```

When you edit a file matching those paths, the rule loads automatically. Follow its instructions.

## Conflict Resolution

If instructions conflict:

1. **Project CLAUDE.md** overrides this user-level file
2. **Higher-priority docs** override lower-priority docs (check the project's hierarchy)
3. **Explicit user requests** can override documented constraints (but note the deviation)

When uncertain, ask the user rather than guessing.
