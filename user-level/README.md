# User-Level Configuration

This directory contains files that get installed to `~/.claude/` and apply to **all your projects**.

## What's Here

```
user-level/
├── CLAUDE.md          # Universal agent philosophy
└── commands/
    ├── ant-init.md    # /ant-init command
    └── ant-update.md  # /ant-update command
```

## How It Works

When you run `./install.sh`, these files are copied to `~/.claude/`:

| Source | Destination | Purpose |
|--------|-------------|---------|
| `CLAUDE.md` | `~/.claude/CLAUDE.md` | Loaded for every project |
| `commands/*.md` | `~/.claude/commands/*.md` | Available as slash commands |

## CLAUDE.md

The universal philosophy file. This teaches agents:
- Read before you act
- Document hierarchy pattern
- When to suggest updates
- How `.claude/rules/` works

This is the "how I work" baseline. Project-level CLAUDE.md files can override it.

## Commands

Slash commands available in any Claude Code session. See [commands/README.md](./commands/README.md) for details.

## Customizing

Edit these files **before** running `install.sh`:

1. **Change the philosophy** - Edit `CLAUDE.md` to match how you want agents to behave
2. **Modify commands** - Edit command files to change scaffolding behavior
3. **Add new commands** - Create new `.md` files in `commands/`

After editing, run `./install.sh` again to update `~/.claude/`.
