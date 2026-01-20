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
cp "$SCRIPT_DIR/user-level/commands/"* "$CLAUDE_DIR/commands/"

echo ""
echo "Installed:"
echo "  $CLAUDE_DIR/CLAUDE.md"
echo "  $CLAUDE_DIR/commands/ant-init.md"
echo "  $CLAUDE_DIR/commands/ant-update.md"
echo ""
echo "🐜 Colony commands available:"
echo "  /ant-init    - Scout and establish colony structure"
echo "  /ant-update  - Worker ant: update docs after commits"
echo ""
echo "Next steps:"
echo "  1. cd into any project"
echo "  2. Run /ant-init to establish the colony"
echo ""
echo "Done."
