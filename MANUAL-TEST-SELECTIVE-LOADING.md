# Manual Test: Prove RLM Selective Loading

## Prerequisites
- Start a **NEW Claude Code conversation** (fresh context)
- Be in `/Users/matt/code/fun/alexANTria` directory
- Have the project open in your IDE

---

## TEST 1: Baseline - What's Always Loaded?

### Step 1.1: Ask About the Project (No File Reading)

**Say this to Claude:**
```
What documentation exists in this project? Don't read any files yet -
just tell me what you know from CLAUDE.md.
```

**Expected Response:**
- Claude should describe the 5-layer hierarchy
- Claude should mention: Strategy, Product, Patterns, Architecture, Service layers
- Claude should mention the "When to Read" table
- **KEY:** No Read tool calls (not reading ANT-* files yet)

**What This Proves:**
✅ CLAUDE.md is always loaded (~5KB)
✅ Claude knows the structure without reading all docs

---

## TEST 2: Selective Reading - Strategy Layer

### Step 2.1: Ask About Strategic Principles

**Say this to Claude:**
```
Tell me about the strategic principles and core constraints of alexANTria.
```

**Expected Response:**
- Claude should use Read tool on `ANT-STRATEGY.md`
- Claude should NOT read ANT-PRODUCT.md, ANT-PATTERNS.md, etc.
- Claude should describe the strategic principles

**What to Observe:**
- 🔍 Look for: `Read tool called on .alexantria/ANT-STRATEGY.md`
- 🔍 Should NOT see: Read calls for other ANT-* files

**What This Proves:**
✅ Claude reads selectively based on task
✅ Only loads intentional pool when needed

---

## TEST 3: Different Task = Different Context

### Step 3.1: Ask About Product Features

**Say this to Claude:**
```
Now tell me about the product features and use cases of alexANTria.
```

**Expected Response:**
- Claude should use Read tool on `ANT-PRODUCT.md`
- Claude should NOT re-read ANT-STRATEGY.md (already in context)
- Claude should NOT read ANT-PATTERNS.md or ANT-ARCHITECTURE.md

**What to Observe:**
- 🔍 Look for: `Read tool called on .alexantria/ANT-PRODUCT.md`
- 🔍 Should NOT see: Read calls for ANT-STRATEGY.md again
- 🔍 Should NOT see: Read calls for ANT-PATTERNS.md or ANT-ARCHITECTURE.md

**What This Proves:**
✅ Context rotates based on work
✅ Claude doesn't re-read files already in context
✅ Selective loading is working

---

## TEST 4: Path-Based Rule Loading

### Step 4.1: Open a Command File

**Do this:**
1. In your IDE, open: `user-level/commands/ant-init.md`
2. Make a trivial edit (add a space somewhere)

### Step 4.2: Ask Claude About Commands

**Say this to Claude:**
```
I'm looking at ant-init.md. What should I know before modifying commands?
```

**Expected Response:**
- Claude should reference the commands rule: `.claude/rules/commands.md`
- Claude should mention: "Before modifying commands, read ANT-FRAMEWORK.md"
- Claude should mention the command philosophy (read, act, repair)

**What This Proves:**
✅ Path-based rules auto-load when you edit matching files
✅ Rules guide Claude's behavior

---

## TEST 5: Hierarchy Filtering

### Step 5.1: Ask for Guidance

**Say this to Claude:**
```
I want to add a new authentication feature. What docs should I read first?
```

**Expected Response:**
- Claude should reference the "When to Read" table from CLAUDE.md
- Claude should suggest reading (in order):
  1. ANT-STRATEGY.md (strategic constraints)
  2. ANT-PRODUCT.md (product context)
  3. ANT-PATTERNS.md (patterns for auth)
  4. ANT-ARCHITECTURE.md (where auth fits)
- Claude should NOT just read all docs and dump them

**What This Proves:**
✅ CLAUDE.md hierarchy guides reading
✅ Claude filters what to read based on task
✅ Intentional pool (human knowledge) consulted first

---

## TEST 6: Prove Context Isn't Bloated

### Step 6.1: Ask About Files NOT Read

**Say this to Claude:**
```
Have you read user-level/commands/ant-validate.md yet?
```

**Expected Response:**
- Claude should say "No, I haven't read that file yet"
- Claude may offer to read it if needed

### Step 6.2: Ask About Templates

**Say this to Claude:**
```
Have you read any files from the templates/ directory?
```

**Expected Response:**
- Claude should say "No" or "Not yet"
- Claude should NOT have these in active context

**What This Proves:**
✅ Claude hasn't read everything in the codebase
✅ Most docs (97.7%) are NOT in active attention
✅ Context is selective, not bloated

---

## TEST 7: Compare to Full Context Loading

### Step 7.1: Simulate Full Loading (Don't Actually Do This)

**Ask Claude to estimate:**
```
If you had to read ALL documentation files in this project upfront,
how many tokens would that be versus what you currently have loaded?
```

**Expected Response:**
- Claude should reference the metrics:
  - Total docs: ~282 KB = ~70,000 tokens
  - Currently loaded: ~6.5 KB = ~1,600 tokens
  - Reduction: 43x
- Claude should explain this prevents attention degradation

**What This Proves:**
✅ Massive context savings
✅ Prevents RLM soft limit degradation

---

## Scoring Your Results

### Full Pass (RLM Working Perfectly)
- ✅ CLAUDE.md always available without Read calls
- ✅ ANT-* files read selectively (not all at once)
- ✅ Different tasks trigger different reads
- ✅ Path-based rules mentioned when editing matching files
- ✅ Hierarchy table guides which docs to read
- ✅ Most files remain unread (context savings)

### Partial Pass (Some Issues)
- ⚠️ Claude reads more files than necessary
- ⚠️ Claude doesn't reference the hierarchy
- ⚠️ Rules don't seem to load for paths

### Fail (Not Working)
- ❌ Claude reads all ANT-* files immediately
- ❌ No mention of hierarchy or selective loading
- ❌ Rules never referenced

---

## Expected Timeline

This test should take **5-10 minutes** to complete.

You'll make about 7-8 requests to Claude and observe:
- ~3-4 Read tool calls (selective)
- References to CLAUDE.md hierarchy (always loaded)
- References to path-based rules (when editing files)
- Most docs remain unread (context efficiency)

---

## Recording Your Results

Create a results file:

```bash
# Test Results: [Date]

TEST 1 (Baseline): PASS/FAIL
- CLAUDE.md loaded without Read: YES/NO
- Described hierarchy: YES/NO

TEST 2 (Selective Reading - Strategy): PASS/FAIL
- Read ANT-STRATEGY.md only: YES/NO
- Didn't read other layers: YES/NO

TEST 3 (Different Context): PASS/FAIL
- Read ANT-PRODUCT.md: YES/NO
- Didn't re-read ANT-STRATEGY.md: YES/NO

TEST 4 (Path-Based Rules): PASS/FAIL
- Mentioned commands rule: YES/NO
- Guided by rule: YES/NO

TEST 5 (Hierarchy Filtering): PASS/FAIL
- Referenced "When to Read": YES/NO
- Suggested order: YES/NO

TEST 6 (Context Not Bloated): PASS/FAIL
- Unread files exist: YES/NO
- Context selective: YES/NO

TEST 7 (Savings Calculation): PASS/FAIL
- Understands 43x reduction: YES/NO
- Explains benefit: YES/NO

OVERALL: PASS/FAIL
```

---

## What You're Actually Proving

1. **Structure**: Tests validate files/paths exist
2. **Behavior**: This manual test validates Claude uses them correctly
3. **Efficiency**: Observing Read tool calls proves selective loading
4. **Intelligence**: Hierarchy filtering shows intentional context design

All together: **RLM architecture is working as designed** ✅

---

## Troubleshooting

**If Claude reads everything upfront:**
- Check CLAUDE.md exists and is properly formatted
- Check "When to Read" table is present
- Verify you started a NEW conversation

**If rules don't load:**
- Check .claude/rules/*.md have proper frontmatter
- Verify paths: match your file locations
- Try editing a file in a matching path

**If selective loading seems broken:**
- Run automated tests: `./test-suite-rlm.sh`
- Check CLAUDE.md is in system prompt
- Verify ANT-* files exist

---

## Next Steps

After completing this test:
1. ✅ You've proven selective loading works
2. ✅ You understand the three-pool architecture
3. ✅ You can explain RLM to others
4. → Use this as a demo for stakeholders
5. → Run automated tests in CI/CD
6. → Build on this pattern for your own projects
