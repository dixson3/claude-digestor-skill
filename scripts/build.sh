#!/bin/bash
# Build script for digestor skill distribution

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
DIST_DIR="$PROJECT_ROOT/dist"
SKILL_NAME="digestor"

echo "Building $SKILL_NAME skill..."

# Clean previous build
rm -rf "$DIST_DIR"
mkdir -p "$DIST_DIR/$SKILL_NAME"

# Copy skill files only
cp "$PROJECT_ROOT/SKILL.md" "$DIST_DIR/$SKILL_NAME/"
cp -r "$PROJECT_ROOT/templates" "$DIST_DIR/$SKILL_NAME/"

# Create tarball
cd "$DIST_DIR"
tar -czf "$SKILL_NAME.tar.gz" "$SKILL_NAME"

echo ""
echo "Build complete!"
echo ""
echo "Distribution files:"
ls -la "$DIST_DIR/"
echo ""
echo "Package contents:"
tar -tzf "$DIST_DIR/$SKILL_NAME.tar.gz"
echo ""
echo "Install with:"
echo "  tar -xzf dist/$SKILL_NAME.tar.gz -C ~/.claude/skills/"
echo "  # or"
echo "  tar -xzf dist/$SKILL_NAME.tar.gz -C /path/to/project/.claude/skills/"
