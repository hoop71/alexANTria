# Templates - Service Documentation

**Layer:** Surface (🌱)

**Location:** `templates/`

## Overview

This directory contains template files used by `/ant-init` to scaffold new projects. Templates use `{{PLACEHOLDER}}` syntax for substitution.

## Components

### Layer Templates

- **ANT-STRATEGY.md.template** - Strategic alignment template
  - Placeholders: {{PROJECT_NAME}}
  - Sections: Core principles, architectural constraints, security, team values

- **ANT-PRODUCT.md.template** - Product context template
  - Placeholders: {{PROJECT_NAME}}
  - Sections: Overview, features, use cases, workflows, domain model

- **ANT-PATTERNS.md.template** - Cross-cutting patterns template
  - Placeholders: {{PROJECT_NAME}}
  - Sections: Error handling, logging, auth, validation, conventions

- **ANT-ARCHITECTURE.md.template** - Architecture template
  - Placeholders: {{PROJECT_NAME}}
  - Sections: Architecture, service boundaries, data flow, tech stack

- **ANT-SURFACE.md.template** - Surface docs template
  - Placeholders: {{PROJECT_NAME}}, {{DIRECTORY_NAME}}
  - Sections: Overview, components, recent changes, impacts

### Context Templates

- **CLAUDE.md.template** - Hierarchy map template
  - Placeholders: {{PROJECT_NAME}}, {{LAYER_DOCS}}
  - Generates: 5-layer anthill structure with links

### Rule Templates

**Location:** `rules/`

- **frontend.md.template** - Frontend context template
- **backend.md.template** - Backend context template
- **ai.md.template** - AI/ML context template

## File Structure

```
templates/
├── ANT-STRATEGY.md.template
├── ANT-PRODUCT.md.template
├── ANT-PATTERNS.md.template
├── ANT-ARCHITECTURE.md.template
├── ANT-SURFACE.md.template
├── ANT-EXTERNAL.md.template
├── CLAUDE.md.template
├── rules/
│   ├── frontend.md.template
│   ├── backend.md.template
│   └── ai.md.template
├── hooks/
│   └── pre-commit (shell script)
├── README.md (legacy - describes template system)
└── ANT-SURFACE.md (this file)
```

## Usage

### ant-init Process

1. Reads appropriate template file
2. Detects placeholders ({{NAME}})
3. Asks user for values OR infers from project
4. Substitutes placeholders
5. Writes final file to target project

### Placeholder Syntax

**Pattern:** `{{PLACEHOLDER_NAME}}`

**Common placeholders:**
- `{{PROJECT_NAME}}` - Name of target project
- `{{DIRECTORY_NAME}}` - Name of directory (for ANT-SURFACE)
- `{{UX_DOC}}` - Path to UX doc (if found)
- `{{ARCHITECTURE_DOC}}` - Path to architecture doc (if found)
- `{{STARTING_LEVEL}}` - Chosen starting level

### Template Structure

Each template follows this pattern:

```markdown
# {{PROJECT_NAME}} - <Layer Name>

**Layer:** <Layer emoji + name>

## <Section 1>

<!-- Content or instructions -->

## Recent Changes (Last 5-10 Commits)

<!-- Maintained by worker ant -->

## Higher-Layer Impacts (Detected by Worker Ant)

<!-- Suggested updates to higher layers -->
```

## Customization

Users can customize templates before running `/ant-init`:

1. Edit `~/.claude/alexantria/templates/*.template` files
2. Add/remove sections
3. Change placeholder names (update ant-init logic too)
4. Add domain-specific templates

**Example:** Create `templates/rules/data.md.template` for data layer projects.

## Dependencies

Templates are plain markdown with minimal syntax:
- No complex templating language
- Simple `{{PLACEHOLDER}}` substitution
- Human-readable even with placeholders

## Recent Changes (Last 5-10 Commits)

- Renamed all layer templates to graduation-ready names (ANT-STRATEGY, ANT-PRODUCT, ANT-PATTERNS, ANT-ARCHITECTURE)
- Updated template references in documentation
- Aligned template naming with RLM language
- Removed old template files (ANT-QUEEN, ANT-NEST, ANT-CHAMBERS, ANT-TUNNELS)

## Higher-Layer Impacts (Detected by Worker Ant)

None currently detected.
