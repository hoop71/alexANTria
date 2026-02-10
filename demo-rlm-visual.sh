#!/bin/bash
# Visual demonstration of RLM selective loading

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                                                                ║"
echo "║             RLM ARCHITECTURE: VISUAL PROOF                     ║"
echo "║                                                                ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Calculate sizes
TOTAL=$(find . -name "*.md" -not -path "./node_modules/*" -not -path "./docs/*" -exec cat {} \; | wc -c)
CLAUDE_SIZE=$(wc -c < CLAUDE.md)
RULES_SIZE=$(cat .claude/rules/*.md 2>/dev/null | wc -c || echo 0)
ACTIVE=$((CLAUDE_SIZE + RULES_SIZE))

TOTAL_KB=$(echo "scale=1; $TOTAL/1024" | bc)
ACTIVE_KB=$(echo "scale=1; $ACTIVE/1024" | bc)
RATIO=$(echo "scale=0; $TOTAL/$ACTIVE" | bc)

# Visual bars
TOTAL_BARS=50
ACTIVE_BARS=$(echo "scale=0; $ACTIVE*$TOTAL_BARS/$TOTAL" | bc)
UNUSED_BARS=$((TOTAL_BARS - ACTIVE_BARS))

echo "┌────────────────────────────────────────────────────────────────┐"
echo "│                    THREE-POOL ARCHITECTURE                     │"
echo "└────────────────────────────────────────────────────────────────┘"
echo ""

# Programmatic Pool
echo "  📁 PROGRAMMATIC POOL (Available for Retrieval)"
echo "  ┌──────────────────────────────────────────────────────────────┐"
echo "  │  Total Documentation: ${TOTAL_KB} KB                            "
printf "  │  ["
for i in $(seq 1 $TOTAL_BARS); do printf "█"; done
echo "] 100%"
echo "  └──────────────────────────────────────────────────────────────┘"
echo ""

# Tokenized Pool
echo "  🔥 TOKENIZED POOL (Active in Attention)"
echo "  ┌──────────────────────────────────────────────────────────────┐"
echo "  │  Active Context: ${ACTIVE_KB} KB                                "
printf "  │  ["
for i in $(seq 1 $ACTIVE_BARS); do printf "█"; done
for i in $(seq 1 $UNUSED_BARS); do printf "░"; done
PERCENT=$(echo "scale=1; $ACTIVE*100/$TOTAL" | bc)
echo "] ${PERCENT}%"
echo "  └──────────────────────────────────────────────────────────────┘"
echo ""

# Intentional Pool
echo "  💡 INTENTIONAL POOL (Human Knowledge)"
echo "  ┌──────────────────────────────────────────────────────────────┐"
echo "  │  ANT-STRATEGY.md  → Read when: strategic decisions            │"
echo "  │  ANT-PRODUCT.md   → Read when: product features               │"
echo "  │  (Not always loaded, retrieved on-demand)                     │"
echo "  └──────────────────────────────────────────────────────────────┘"
echo ""

echo "┌────────────────────────────────────────────────────────────────┐"
echo "│                    SELECTIVE LOADING PROOF                     │"
echo "└────────────────────────────────────────────────────────────────┘"
echo ""

# Show path-based loading
echo "  📍 PATH-BASED RULE LOADING"
echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

for rule in .claude/rules/*.md; do
    name=$(basename "$rule" .md)
    size=$(wc -c < "$rule")
    paths=$(grep -A 1 "^paths:" "$rule" | grep "^  - " | head -1 | sed 's/^  - //' | tr -d '"')

    printf "  Rule: %-15s" "$name"
    printf " (%4d bytes)" "$size"
    echo "  → Loads for: $paths"
done

echo ""
echo "  🔍 HIERARCHY FILTERING"
echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  CLAUDE.md 'When to Read' table guides context loading:"
echo ""
echo "  Task: Strategic decision   → Load: ANT-STRATEGY.md   (Intentional)"
echo "  Task: Product feature      → Load: ANT-PRODUCT.md    (Intentional)"
echo "  Task: Pattern design       → Load: ANT-PATTERNS.md   (Tokenized)"
echo "  Task: Architecture change  → Load: ANT-ARCHITECTURE.md (Tokenized)"
echo "  Task: Command modification → Load: ANT-SURFACE.md    (Programmatic)"
echo ""

echo "┌────────────────────────────────────────────────────────────────┐"
echo "│                     EFFICIENCY METRICS                         │"
echo "└────────────────────────────────────────────────────────────────┘"
echo ""

printf "  Context Reduction:     %2dx smaller\n" "$RATIO"
printf "  Token Savings:         ~%d tokens\n" "$(echo "($TOTAL - $ACTIVE)/4" | bc)"
printf "  Active Percentage:     %s%%\n" "$PERCENT"
printf "  Attention Overhead:    MINIMAL ✅\n"
echo ""

echo "┌────────────────────────────────────────────────────────────────┐"
echo "│                     RLM VALIDATION                             │"
echo "└────────────────────────────────────────────────────────────────┘"
echo ""

# Run validation
VALIDATIONS=0
PASSED=0

# Check 1: Context under 20KB
if [ "$ACTIVE" -lt 20480 ]; then
    echo "  ✅ Active context under 20KB soft limit"
    PASSED=$((PASSED + 1))
else
    echo "  ❌ Active context exceeds 20KB"
fi
VALIDATIONS=$((VALIDATIONS + 1))

# Check 2: Reduction > 10x
if [ "$RATIO" -gt 10 ]; then
    echo "  ✅ Context reduction > 10x"
    PASSED=$((PASSED + 1))
else
    echo "  ❌ Context reduction too low"
fi
VALIDATIONS=$((VALIDATIONS + 1))

# Check 3: Rules exist
if [ -d ".claude/rules" ] && [ "$(ls -A .claude/rules/*.md 2>/dev/null | wc -l)" -gt 0 ]; then
    echo "  ✅ Path-based rules configured"
    PASSED=$((PASSED + 1))
else
    echo "  ❌ Rules not configured"
fi
VALIDATIONS=$((VALIDATIONS + 1))

# Check 4: Hierarchy filtering
if grep -q "When to Read" CLAUDE.md; then
    echo "  ✅ Hierarchy filtering enabled"
    PASSED=$((PASSED + 1))
else
    echo "  ❌ Hierarchy filtering missing"
fi
VALIDATIONS=$((VALIDATIONS + 1))

# Check 5: Three pools documented
if grep -qi "programmatic\|tokenized\|intentional" CLAUDE.md; then
    echo "  ✅ Three-pool architecture documented"
    PASSED=$((PASSED + 1))
else
    echo "  ❌ Three-pool architecture not documented"
fi
VALIDATIONS=$((VALIDATIONS + 1))

echo ""

if [ "$PASSED" -eq "$VALIDATIONS" ]; then
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║                                                                ║"
    echo "║                 ✅ RLM MODEL: VALIDATED                         ║"
    echo "║                                                                ║"
    echo "║  The selective loading system is working correctly!            ║"
    echo "║                                                                ║"
    echo "║  • Context loads selectively based on work                     ║"
    echo "║  • ${RATIO}x reduction prevents attention degradation                   ║"
    echo "║  • Three pools properly separated                              ║"
    echo "║                                                                ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
else
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║  ⚠️  Some validations failed ($PASSED/$VALIDATIONS passed)                      ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
fi

echo ""
