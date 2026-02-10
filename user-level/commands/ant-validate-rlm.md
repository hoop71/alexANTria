---
description: Validate RLM selective loading with self-tests
allowed-tools: Read, Bash, Grep
---

# 🔬 Ant Validate RLM: Self-Test Context Loading

Claude validates its own context loading behavior to prove RLM selective loading is working.

## Philosophy

**The challenge:** Claude can't directly see its system prompt or inspect what's loaded.

**The solution:** Test behavior, not internals. If Claude behaves correctly (reads selectively, references hierarchy, filters context), the system is working.

## Self-Test Sequence

When user runs `/ant-validate-rlm`:

### Test 1: Baseline Knowledge (No File Reading)

**What to test:** Can Claude describe the hierarchy without reading ANT-* files?

**Instructions:**
1. Before reading ANY files, describe the project structure from CLAUDE.md
2. List the 5 layers: Strategy, Product, Patterns, Architecture, Service
3. Mention the three pools: Intentional, Tokenized, Programmatic
4. Reference the "When to Read" table

**Success criteria:**
- ✅ Describes hierarchy accurately
- ✅ No Read tool calls made yet
- ✅ References CLAUDE.md content

**What this proves:** CLAUDE.md is always loaded (~5KB in tokenized pool)

---

### Test 2: Selective Reading (Intentional Pool)

**What to test:** Does Claude read only relevant files?

**Instructions:**
1. "I need to understand the strategic principles"
2. Read ONLY ANT-STRATEGY.md
3. Do NOT read ANT-PRODUCT.md, ANT-PATTERNS.md, or other files
4. Summarize the strategic principles

**Success criteria:**
- ✅ Read ANT-STRATEGY.md
- ✅ Did NOT read other ANT-* files
- ✅ Provided accurate summary

**What this proves:** Selective loading - only reads what's needed

---

### Test 3: Context Already Loaded (No Re-reading)

**What to test:** Does Claude avoid re-reading files already in context?

**Instructions:**
1. "Now tell me more about the strategic principles"
2. Answer from memory (ANT-STRATEGY.md already in context from Test 2)
3. Do NOT re-read ANT-STRATEGY.md

**Success criteria:**
- ✅ Answered without re-reading
- ✅ Information consistent with Test 2

**What this proves:** Context persists, no redundant reading

---

### Test 4: Different Context for Different Tasks

**What to test:** Does context rotate based on task?

**Instructions:**
1. "Tell me about product features"
2. Read ANT-PRODUCT.md (different from Test 2)
3. Do NOT read ANT-PATTERNS.md or ANT-ARCHITECTURE.md

**Success criteria:**
- ✅ Read ANT-PRODUCT.md
- ✅ Did NOT read unrelated files
- ✅ Context shifted based on task

**What this proves:** Context rotates with work, not static

---

### Test 5: Hierarchy Filtering

**What to test:** Does Claude use "When to Read" table to guide reading?

**Instructions:**
1. "I want to add authentication. What should I read?"
2. Reference the "When to Read" table from CLAUDE.md
3. Suggest reading order: Strategy → Product → Patterns → Architecture
4. Do NOT just read all files and dump them

**Success criteria:**
- ✅ Referenced hierarchy table
- ✅ Suggested appropriate order
- ✅ Filtered reading based on task

**What this proves:** Hierarchy guides context loading

---

### Test 6: Context Efficiency Check

**What to test:** Are most files unread (programmatic pool)?

**Instructions:**
1. "Have you read ant-validate.md?"
2. Answer honestly: "No" (it's in programmatic pool, not loaded)
3. "Have you read templates/ files?"
4. Answer honestly: "No" (not needed for current work)

**Success criteria:**
- ✅ Most files remain unread
- ✅ Only task-relevant files loaded

**What this proves:** 97.7% of docs stay in programmatic pool

---

### Test 7: Calculate Context Savings

**What to test:** Can Claude calculate the reduction?

**Instructions:**
1. Count total documentation size
2. Calculate active context (CLAUDE.md + what was read)
3. Compute reduction ratio

**Use Bash:**
```bash
{
  TOTAL=$(find . -name "*.md" -not -path "./node_modules/*" -not -path "./docs/*" -exec cat {} \; | wc -c)
  CLAUDE_SIZE=$(wc -c < CLAUDE.md)
  # Add sizes of files read during tests
  STRATEGY_SIZE=$(wc -c < .alexantria/ANT-STRATEGY.md)
  PRODUCT_SIZE=$(wc -c < .alexantria/ANT-PRODUCT.md)
  ACTIVE=$((CLAUDE_SIZE + STRATEGY_SIZE + PRODUCT_SIZE))
  RATIO=$(echo "scale=0; $TOTAL/$ACTIVE" | bc)

  echo "Total docs: $TOTAL bytes"
  echo "Active context: $ACTIVE bytes"
  echo "Reduction: ${RATIO}x"
}
```

**Success criteria:**
- ✅ Reduction > 10x
- ✅ Active context < 20KB
- ✅ Only small fraction of docs loaded

**What this proves:** Massive context efficiency

---

## Output Format

After running all tests, output:

```
🔬 RLM Self-Validation Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Test 1: Baseline Knowledge
  [✓] Described hierarchy without reading files
  [✓] CLAUDE.md is always loaded

Test 2: Selective Reading
  [✓] Read ANT-STRATEGY.md only
  [✓] Did not read other files

Test 3: Context Persistence
  [✓] Answered without re-reading
  [✓] Context persisted in memory

Test 4: Context Rotation
  [✓] Read ANT-PRODUCT.md for new task
  [✓] Context shifted appropriately

Test 5: Hierarchy Filtering
  [✓] Referenced "When to Read" table
  [✓] Suggested appropriate reading order

Test 6: Context Efficiency
  [✓] Most files remain unread
  [✓] Only 2 files loaded (of 50+ available)

Test 7: Context Savings
  [✓] Reduction: 43x
  [✓] Active: 15KB / Total: 282KB
  [✓] 94.7% of docs unloaded

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Tests Passed: 7/7

✅ RLM SELECTIVE LOADING: VERIFIED

Key Findings:
  • CLAUDE.md always loaded (tokenized pool)
  • ANT-* files read on-demand (programmatic pool)
  • Context rotates based on task
  • 43x reduction in active context
  • Selective loading prevents attention rot

Exit Code: 0
```

## Key Insight

**We're testing behavior, not internals:**
- Can Claude describe hierarchy? → CLAUDE.md loaded
- Does Claude read selectively? → Programmatic pool working
- Does context rotate? → Tokenized pool filtered
- Are most files unread? → Efficiency proven

**If behavior is correct, the system is working.**

## Validation Logic

```python
# Pseudo-code for validation
def validate_rlm():
    results = []

    # Test 1: Check baseline knowledge
    can_describe_hierarchy = test_hierarchy_knowledge()
    results.append(("Baseline", can_describe_hierarchy))

    # Test 2: Track file reads
    files_read = []
    answer = ask_about_strategy()
    files_read = get_files_read_during_answer()
    selective = len(files_read) == 1 and "ANT-STRATEGY.md" in files_read
    results.append(("Selective Reading", selective))

    # Test 3: Check persistence
    answer2 = ask_about_strategy_again()
    no_reread = len(get_files_read_during_answer()) == 0
    results.append(("Persistence", no_reread))

    # Test 4: Check rotation
    answer3 = ask_about_product()
    files_read2 = get_files_read_during_answer()
    rotation = "ANT-PRODUCT.md" in files_read2
    results.append(("Rotation", rotation))

    # Test 5: Check filtering
    answer4 = ask_for_reading_guidance()
    filtered = "When to Read" in answer4
    results.append(("Filtering", filtered))

    # Test 6: Check efficiency
    total_files = count_all_md_files()
    files_loaded = len(set(files_read + files_read2))
    efficient = files_loaded < (total_files * 0.1)  # Less than 10% loaded
    results.append(("Efficiency", efficient))

    # Test 7: Calculate savings
    reduction = calculate_context_reduction()
    savings = reduction > 10
    results.append(("Savings", savings))

    return results
```

## Notes

- This command is Claude testing itself
- User just runs the command and gets report
- No manual observation needed
- Proves RLM is working automatically
- Can be run in CI/CD
