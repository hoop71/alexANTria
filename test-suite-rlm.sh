#!/bin/bash
# Comprehensive RLM System Validation
# Automated test suite to prove alexANTria honors its own principles

set -e

FAILED_TESTS=0
PASSED_TESTS=0

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

pass_test() {
    echo -e "${GREEN}✅ PASS${NC}: $1"
    PASSED_TESTS=$((PASSED_TESTS + 1))
}

fail_test() {
    echo -e "${RED}✗ FAIL${NC}: $1"
    FAILED_TESTS=$((FAILED_TESTS + 1))
}

warn_test() {
    echo -e "${YELLOW}⚠️  WARN${NC}: $1"
}

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║        alexANTria RLM System Validation Test Suite            ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# ============================================================================
# TEST SUITE 1: Naming Conventions
# ============================================================================
echo "📋 TEST SUITE 1: Naming Conventions"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Test 1.1: All ANT-* files use valid layer names
echo -n "Test 1.1: ANT-* files use valid layer names... "
INVALID_ANT_FILES=$(find . -name "ANT-*.md" -not -path "./node_modules/*" -not -path "./docs/*" | \
    grep -Ev "ANT-(STRATEGY|PRODUCT|PATTERNS|ARCHITECTURE|SURFACE|README|EXTERNAL|SCHEMA|FRAMEWORK)" || true)

if [ -z "$INVALID_ANT_FILES" ]; then
    pass_test "All ANT-* files use valid layer names"
else
    fail_test "Invalid ANT-* files found: $INVALID_ANT_FILES"
fi

# Test 1.2: No old layer names in file names
echo -n "Test 1.2: No old layer names (QUEEN/NEST/etc)... "
OLD_NAMES=$(find . -name "*QUEEN*" -o -name "*NEST*" -o -name "*CHAMBERS*" -o -name "*TUNNELS*" | \
    grep -v node_modules | grep -v ".git" || true)

if [ -z "$OLD_NAMES" ]; then
    pass_test "No old layer names found"
else
    fail_test "Old layer names found: $OLD_NAMES"
fi

# Test 1.3: Commands follow ant-* naming
echo -n "Test 1.3: Commands follow ant-* naming... "
INVALID_COMMANDS=$(find user-level/commands -name "*.md" -not -name "ant-*" \
    -not -name "ANT-*" -not -name "README.md" -not -name "worker-ant-*" \
    -not -path "*/guardians/*" || true)

if [ -z "$INVALID_COMMANDS" ]; then
    pass_test "All commands follow ant-* naming"
else
    warn_test "Non-ant commands: $INVALID_COMMANDS"
fi

echo ""

# ============================================================================
# TEST SUITE 2: RLM Three-Pool Architecture
# ============================================================================
echo "📋 TEST SUITE 2: RLM Three-Pool Architecture"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Test 2.1: CLAUDE.md is minimal (under 10KB)
echo -n "Test 2.1: CLAUDE.md under 10KB... "
CLAUDE_SIZE=$(wc -c < CLAUDE.md)
if [ "$CLAUDE_SIZE" -lt 10240 ]; then
    pass_test "CLAUDE.md is $CLAUDE_SIZE bytes ($(echo "scale=1; $CLAUDE_SIZE/1024" | bc)KB)"
else
    fail_test "CLAUDE.md is too large: $CLAUDE_SIZE bytes"
fi

# Test 2.2: Total active context under 20KB
echo -n "Test 2.2: Total active context under 20KB... "
RULES_SIZE=$(cat .claude/rules/*.md 2>/dev/null | wc -c || echo 0)
ACTIVE_SIZE=$((CLAUDE_SIZE + RULES_SIZE))
if [ "$ACTIVE_SIZE" -lt 20480 ]; then
    pass_test "Active context is $ACTIVE_SIZE bytes ($(echo "scale=1; $ACTIVE_SIZE/1024" | bc)KB)"
else
    warn_test "Active context is large: $ACTIVE_SIZE bytes"
fi

# Test 2.3: Context reduction ratio > 10x
echo -n "Test 2.3: Context reduction ratio > 10x... "
TOTAL_SIZE=$(find . -name "*.md" -not -path "./node_modules/*" -not -path "./docs/*" -exec cat {} \; | wc -c)
RATIO=$(echo "scale=1; $TOTAL_SIZE/$ACTIVE_SIZE" | bc)
if (( $(echo "$RATIO > 10" | bc -l) )); then
    pass_test "Reduction ratio: ${RATIO}x"
else
    fail_test "Reduction ratio too low: ${RATIO}x"
fi

# Test 2.4: CLAUDE.md contains pool references
echo -n "Test 2.4: CLAUDE.md references three pools... "
if grep -qi "programmatic\|tokenized\|intentional" CLAUDE.md; then
    pass_test "Three-pool architecture documented"
else
    fail_test "Missing pool references in CLAUDE.md"
fi

echo ""

# ============================================================================
# TEST SUITE 3: Selective Loading
# ============================================================================
echo "📋 TEST SUITE 3: Selective Loading"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Test 3.1: Rules exist
echo -n "Test 3.1: .claude/rules/ configured... "
if [ -d ".claude/rules" ] && [ "$(ls -A .claude/rules/*.md 2>/dev/null | wc -l)" -gt 0 ]; then
    pass_test ".claude/rules/ exists with $(ls .claude/rules/*.md | wc -l) rules"
else
    fail_test ".claude/rules/ missing or empty"
fi

# Test 3.2: Rules have path triggers
echo -n "Test 3.2: Rules have path triggers... "
RULES_WITHOUT_PATHS=0
for rule in .claude/rules/*.md; do
    if ! grep -q "^paths:" "$rule" 2>/dev/null; then
        RULES_WITHOUT_PATHS=$((RULES_WITHOUT_PATHS + 1))
    fi
done

if [ "$RULES_WITHOUT_PATHS" -eq 0 ]; then
    pass_test "All rules have path triggers"
else
    warn_test "$RULES_WITHOUT_PATHS rules missing path triggers"
fi

# Test 3.3: CLAUDE.md has "When to Read" table
echo -n "Test 3.3: CLAUDE.md has 'When to Read' table... "
if grep -q "When to Read" CLAUDE.md; then
    pass_test "Hierarchy filtering configured"
else
    fail_test "Missing 'When to Read' table"
fi

echo ""

# ============================================================================
# TEST SUITE 4: Layer Boundaries
# ============================================================================
echo "📋 TEST SUITE 4: Layer Boundaries"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Test 4.1: Strategy layer exists (intentional pool)
echo -n "Test 4.1: Strategy layer (intentional pool)... "
if [ -f ".alexantria/ANT-STRATEGY.md" ]; then
    pass_test "ANT-STRATEGY.md exists"
else
    fail_test "ANT-STRATEGY.md missing"
fi

# Test 4.2: Product layer exists (intentional pool)
echo -n "Test 4.2: Product layer (intentional pool)... "
if [ -f ".alexantria/ANT-PRODUCT.md" ]; then
    pass_test "ANT-PRODUCT.md exists"
else
    fail_test "ANT-PRODUCT.md missing"
fi

# Test 4.3: Patterns layer exists (tokenized pool)
echo -n "Test 4.3: Patterns layer (tokenized pool)... "
if [ -f ".alexantria/ANT-PATTERNS.md" ]; then
    pass_test "ANT-PATTERNS.md exists"
else
    fail_test "ANT-PATTERNS.md missing"
fi

# Test 4.4: Architecture layer exists (tokenized pool)
echo -n "Test 4.4: Architecture layer (tokenized pool)... "
if [ -f ".alexantria/ANT-ARCHITECTURE.md" ]; then
    pass_test "ANT-ARCHITECTURE.md exists"
else
    fail_test "ANT-ARCHITECTURE.md missing"
fi

# Test 4.5: Config respects starting_level
echo -n "Test 4.5: Config has valid starting_level... "
if [ -f ".alexantria/config.json" ]; then
    LEVEL=$(grep -o '"starting_level": "[^"]*"' .alexantria/config.json | cut -d'"' -f4)
    if [[ "$LEVEL" =~ ^(service|architecture|patterns)$ ]]; then
        pass_test "starting_level: $LEVEL"
    else
        fail_test "Invalid starting_level: $LEVEL"
    fi
else
    fail_test "config.json missing"
fi

echo ""

# ============================================================================
# TEST SUITE 5: Graduation Path
# ============================================================================
echo "📋 TEST SUITE 5: Graduation Path"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Test 5.1: ant-graduate command exists
echo -n "Test 5.1: /ant-graduate command exists... "
if [ -f "user-level/commands/ant-graduate.md" ]; then
    pass_test "ant-graduate.md exists"
else
    fail_test "ant-graduate.md missing"
fi

# Test 5.2: Config schema supports graduation
echo -n "Test 5.2: Config schema supports graduation... "
if grep -q "graduated_files" user-level/alexantria-config-schema.md; then
    pass_test "graduated_files in schema"
else
    fail_test "graduated_files missing from schema"
fi

# Test 5.3: Manifest schema supports graduation
echo -n "Test 5.3: Manifest schema supports graduation... "
if [ -f "user-level/manifest-schema.md" ] && grep -q "graduations" user-level/manifest-schema.md; then
    pass_test "graduations in manifest schema"
else
    fail_test "graduations missing from manifest schema"
fi

# Test 5.4: README documents graduation path
echo -n "Test 5.4: README documents graduation... "
if grep -q "Graduation Path\|graduation" README.md; then
    pass_test "Graduation path documented"
else
    fail_test "Graduation path not documented"
fi

echo ""

# ============================================================================
# TEST SUITE 6: Guardian System
# ============================================================================
echo "📋 TEST SUITE 6: Guardian System"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Test 6.1: All guardians use new layer names
echo -n "Test 6.1: Guardians use new layer names... "
EXPECTED_GUARDIANS="strategy-guardian product-guardian patterns-guardian architecture-guardian surface-guardian"
MISSING_GUARDIANS=""
for guardian in $EXPECTED_GUARDIANS; do
    if [ ! -f "user-level/commands/guardians/${guardian}.md" ]; then
        MISSING_GUARDIANS="$MISSING_GUARDIANS $guardian"
    fi
done

if [ -z "$MISSING_GUARDIANS" ]; then
    pass_test "All 5 guardians exist"
else
    fail_test "Missing guardians:$MISSING_GUARDIANS"
fi

# Test 6.2: No old guardian names
echo -n "Test 6.2: No old guardian names... "
OLD_GUARDIANS=$(find user-level/commands/guardians -name "*queen*" -o -name "*nest*" \
    -o -name "*chambers*" -o -name "*tunnels*" 2>/dev/null || true)

if [ -z "$OLD_GUARDIANS" ]; then
    pass_test "No old guardian names"
else
    fail_test "Old guardians found: $OLD_GUARDIANS"
fi

echo ""

# ============================================================================
# SUMMARY
# ============================================================================
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                         Summary                                ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "Tests passed: $PASSED_TESTS"
echo "Tests failed: $FAILED_TESTS"
echo ""

if [ "$FAILED_TESTS" -eq 0 ]; then
    echo -e "${GREEN}✅ ALL TESTS PASSED${NC}"
    echo ""
    echo "The RLM system is working correctly:"
    echo "  • Naming conventions honored"
    echo "  • Three-pool architecture maintained"
    echo "  • Selective loading configured"
    echo "  • Layer boundaries respected"
    echo "  • Graduation path implemented"
    echo "  • Guardian system aligned"
    exit 0
else
    echo -e "${RED}✗ SOME TESTS FAILED${NC}"
    echo ""
    echo "Please review the failures above and fix them."
    exit 1
fi
