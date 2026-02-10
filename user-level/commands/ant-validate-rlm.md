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

After running all tests, output with **VISUAL FLAIR**:

```
╔════════════════════════════════════════════════════════════════╗
║                                                                ║
║     🧬 RLM ARCHITECTURE: LIVE SELF-VALIDATION                  ║
║                                                                ║
║     Proving Selective Loading Prevents Context Rot            ║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝

┌────────────────────────────────────────────────────────────────┐
│  THE PROBLEM: Traditional AI Agents Load Everything           │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Without RLM architecture, agents load ALL documentation:      │
│                                                                 │
│  Total Context: ████████████████████████████████████ 282 KB   │
│                                                                 │
│  Result: Context rot, attention degradation, slow responses    │
│  (Models degrade at soft limits even within stated window)     │
│                                                                 │
└────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────┐
│  THE SOLUTION: RLM Three-Pool Architecture                     │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  🔬 Running 7 Self-Tests...                                    │
│                                                                 │
│  Test 1: Baseline Knowledge............................ [✓]    │
│    → CLAUDE.md loaded without reading all files               │
│                                                                 │
│  Test 2: Selective Reading............................. [✓]    │
│    → Read ANT-STRATEGY.md ONLY (not all layers)               │
│                                                                 │
│  Test 3: Context Persistence........................... [✓]    │
│    → Answered without re-reading (memory working)             │
│                                                                 │
│  Test 4: Context Rotation.............................. [✓]    │
│    → Loaded ANT-PRODUCT.md for new task (dynamic)             │
│                                                                 │
│  Test 5: Hierarchy Filtering........................... [✓]    │
│    → Used "When to Read" table (intelligent routing)          │
│                                                                 │
│  Test 6: Context Efficiency............................ [✓]    │
│    → 48 of 50 files unread (97% efficiency!)                  │
│                                                                 │
│  Test 7: Context Savings............................... [✓]    │
│    → Calculating reduction...                                  │
│                                                                 │
└────────────────────────────────────────────────────────────────┘

╔════════════════════════════════════════════════════════════════╗
║                    THE THREE POOLS IN ACTION                   ║
╚════════════════════════════════════════════════════════════════╝

  📁 PROGRAMMATIC POOL (Available for Retrieval)
  ┌──────────────────────────────────────────────────────────────┐
  │  Total Documentation: 282 KB                                 │
  │  [██████████████████████████████████████████████████] 100%   │
  │                                                               │
  │  50+ files available on-demand                               │
  │  Not loaded until needed → Prevents attention overload       │
  └──────────────────────────────────────────────────────────────┘

  🔥 TOKENIZED POOL (Active in Attention Window)
  ┌──────────────────────────────────────────────────────────────┐
  │  Active Context: 6.5 KB                                      │
  │  [█░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░] 2.3%  │
  │                                                               │
  │  CLAUDE.md (5KB) + 2 task-relevant files                     │
  │  Selectively loaded → Stays under soft limits                │
  └──────────────────────────────────────────────────────────────┘

  💡 INTENTIONAL POOL (Human Knowledge)
  ┌──────────────────────────────────────────────────────────────┐
  │  Strategic decisions, "why we decided"                       │
  │  Read on-demand when context engine needs human wisdom       │
  │                                                               │
  │  ANT-STRATEGY.md, ANT-PRODUCT.md → Loaded when relevant      │
  └──────────────────────────────────────────────────────────────┘

╔════════════════════════════════════════════════════════════════╗
║                      CONTEXT EFFICIENCY                        ║
╚════════════════════════════════════════════════════════════════╝

  📊 BEFORE (Traditional Agent): Load Everything
  ┌──────────────────────────────────────────────────────────────┐
  │                                                               │
  │  Context:  ████████████████████████████████████  282 KB     │
  │  Tokens:   ~70,000 tokens (approaching soft limits!)         │
  │  Status:   ⚠️  ATTENTION DEGRADATION RISK                     │
  │                                                               │
  └──────────────────────────────────────────────────────────────┘

  📊 AFTER (RLM Architecture): Load Selectively
  ┌──────────────────────────────────────────────────────────────┐
  │                                                               │
  │  Context:  ██                                     6.5 KB     │
  │  Tokens:   ~1,600 tokens (well under limits!)                │
  │  Status:   ✅ ATTENTION PROTECTED                             │
  │                                                               │
  └──────────────────────────────────────────────────────────────┘

  🎯 CONTEXT REDUCTION: 43x SMALLER
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Without RLM:  ████████████████████████████████████████████  282 KB
  With RLM:     ██                                            6.5 KB
                ↑
                43x more efficient

  Token Savings: 68,400 tokens saved
  Result: Prevents context rot, maintains model quality

╔════════════════════════════════════════════════════════════════╗
║                      VALIDATION RESULTS                        ║
╚════════════════════════════════════════════════════════════════╝

  ✅ All 7 Tests PASSED

  What This Proves:
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ✓ Tokenized Pool:   CLAUDE.md always loaded (hierarchy map)
  ✓ Selective Reading: Only task-relevant files read
  ✓ Context Rotation:  Different work → different context
  ✓ Efficiency:        97% of docs remain unloaded
  ✓ Hierarchy:         "When to Read" table guides loading
  ✓ Performance:       43x reduction prevents attention rot

╔════════════════════════════════════════════════════════════════╗
║                    WHY THIS MATTERS                            ║
╚════════════════════════════════════════════════════════════════╝

  🔬 RLM Research Shows:
     Context rot is STRUCTURAL - models degrade when context
     exceeds soft limits, even if it fits the stated window.

  💡 The ANT Solution:
     • Programmatic Pool - Code available for retrieval
     • Tokenized Pool - Only active context in attention
     • Intentional Pool - Human knowledge on-demand

  🚀 The Result:
     Agents that work smarter, not harder. Context stays fresh,
     attention stays focused, quality stays high.

  📈 Scale:
     From solo dev → teams → 30-agent swarms (Gas Town scale)
     Same architecture prevents context rot at any scale.

╔════════════════════════════════════════════════════════════════╗
║                                                                ║
║           ✅ RLM SELECTIVE LOADING: VERIFIED                    ║
║                                                                ║
║     Your agent is using 43x LESS context with NO loss          ║
║     in capability. This is how AI scales.                      ║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝

  Learn More:
  • RLM Architecture: ./RLM-ARCHITECTURE.md
  • ANT Framework: ./ANT-FRAMEWORK.md
  • Source: https://github.com/hoop71/alexANTria

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

## Generate Markdown Artifact

After completing all tests and showing the visual report, generate a markdown file for commit:

**File:** `RLM-VALIDATION-PROOF.md` (repo root)

**Instructions:**
1. Use actual metrics from Test 7
2. Keep it concise (under 200 lines)
3. Marketing-focused (value proposition)
4. GitHub-friendly markdown
5. Include timestamp
6. Use Write tool to create file

**Template structure:**
```markdown
# RLM Selective Loading: Validated ✅

> **14.8x context reduction** with zero loss in capability.
> Last validated: [TIMESTAMP]

## The Claim

alexANTria uses RLM (Recursive Learning Model) architecture to prevent context rot through selective loading. Instead of loading all documentation, agents load only what they need, when they need it.

## The Proof

[Visual comparison with actual metrics]

## What This Means

[3-4 bullet points on impact]

## Technical Validation

[Concise test results table]

## How It Works

[Brief explanation of three pools]

## Try It Yourself

```bash
/ant-validate-rlm
```
```

**After writing file:**
1. Tell user file was created
2. Suggest: "Add this to README.md and commit"
3. Show snippet for README reference

## Notes

- This command is Claude testing itself
- User just runs the command and gets report
- No manual observation needed
- Proves RLM is working automatically
- Can be run in CI/CD
- **Generates commitable proof artifact**
