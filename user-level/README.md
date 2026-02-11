# User-Level Configuration

Files here install to `~/.claude/` and apply to **all projects**.

## Structure

```
user-level/
├── CLAUDE.md          # Universal philosophy
└── commands/
    ├── ant-init.md    # /ant-init
    └── ant-update.md  # /ant-update
```

## Install

`./install.sh` copies these to `~/.claude/`:

| Source | Destination | Purpose |
|--------|-------------|---------|
| `CLAUDE.md` | `~/.claude/CLAUDE.md` | Every project |
| `commands/*.md` | `~/.claude/commands/*.md` | Slash commands |

## CLAUDE.md

Universal philosophy: read before acting, doc hierarchy, when to update, how `.claude/rules/` works.

Project-level CLAUDE.md overrides this.

## Commands

Slash commands for any session. See [commands/README.md](./commands/README.md).

## Customizing

Edit **before** `install.sh`:
1. Change philosophy → Edit `CLAUDE.md`
2. Modify commands → Edit command files
3. Add commands → Create `.md` files in `commands/`

Run `./install.sh` again to update `~/.claude/`.
