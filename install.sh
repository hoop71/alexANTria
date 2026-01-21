#!/bin/bash

# alexANTria installer
# Sets up user-level coding agent context automation

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "Installing alexANTria to $CLAUDE_DIR..."

# Create ~/.claude if it doesn't exist
mkdir -p "$CLAUDE_DIR"

# Back up existing files if they exist
if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
    echo "Backing up existing CLAUDE.md to CLAUDE.md.backup"
    cp "$CLAUDE_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md.backup"
fi

if [ -d "$CLAUDE_DIR/commands" ]; then
    echo "Backing up existing commands/ to commands.backup/"
    cp -r "$CLAUDE_DIR/commands" "$CLAUDE_DIR/commands.backup"
fi

# Copy user-level files (not symlink, so repo can be moved/deleted)
cp "$SCRIPT_DIR/user-level/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
mkdir -p "$CLAUDE_DIR/commands"
# Only copy ant-*.md command files (skip ANT-SURFACE.md, worker-ant-prompt.md, README.md)
cp "$SCRIPT_DIR/user-level/commands/ant-"*.md "$CLAUDE_DIR/commands/"

echo ""
echo "✅ Installed to $CLAUDE_DIR:"
echo "  • CLAUDE.md (global context)"
echo "  • commands/ant-*.md ($(ls -1 "$SCRIPT_DIR/user-level/commands/"*.md | wc -l | tr -d ' ') commands)"
echo ""
echo "🐜 Available Commands:"
echo "  /ant-init                  Scout and establish colony"
echo "  /ant-validate              Check installation health"
echo "  /ant-upgrade               Upgrade framework"
echo "  /ant-commit                Automated commit with docs"
echo "  /ant-migrate               Migrate README → ANT-SURFACE"
echo "  /ant-refresh-doc           Refresh specific doc"
echo "  /ant-review-suggestions    Review pending suggestions"
echo "  /ant-check-consistency     Run all guardians"
echo "  /ant-validation-report     Show metrics & ROI"
echo ""
echo "Next steps:"
echo "  1. Restart Claude Code (if currently running)"
echo "  2. cd into any project"
echo "  3. Run /ant-init to establish the colony"
echo ""
echo "Done."
