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

# Clean and recreate commands directory (remove old commands)
rm -rf "$CLAUDE_DIR/commands"
mkdir -p "$CLAUDE_DIR/commands"

# Only copy ant-*.md command files (skip ANT-PROGRAMMATIC.md, worker-ant-prompt.md, README.md, etc.)
cp "$SCRIPT_DIR/user-level/commands/ant-"*.md "$CLAUDE_DIR/commands/"

# Configure automatic hooks for Claude Code
echo "Configuring automatic hooks..."
mkdir -p "$CLAUDE_DIR/config"
cat > "$CLAUDE_DIR/config/hooks.json" <<'EOF'
{
  "onProjectOpen": "if [ -f .alexantria/ANT-PROGRAMMATIC.md ] && command -v claude &> /dev/null; then claude /ant-validate --quiet; fi"
}
EOF

echo ""
echo "✅ Installed to $CLAUDE_DIR:"
echo "  • CLAUDE.md (global context)"
echo "  • commands/ant-*.md (4 commands)"
echo "  • config/hooks.json (automatic validation)"
echo ""
echo "🐜 Available Commands:"
echo "  /ant-init       Initialize alexANTria in project (auto-installs git hook)"
echo "  /ant-validate   Check documentation health and drift"
echo "  /ant-suggest    Analyze changes and propose doc updates"
echo "  /ant-capture    Capture intent during commits (runs via git hook)"
echo ""
echo "🤖 Automatic Features:"
echo "  • Git pre-commit hook runs /ant-capture (installed by /ant-init)"
echo "  • Project open validation checks docs health"
echo "  • Commands run proactively when needed"
echo ""
echo "Next steps:"
echo "  1. Restart Claude Code (if currently running)"
echo "  2. cd into any project"
echo "  3. Run /ant-init to scaffold structure + install git hook"
echo ""
echo "Documentation: https://github.com/hoop71/alexANTria"
echo ""
echo "Done."
