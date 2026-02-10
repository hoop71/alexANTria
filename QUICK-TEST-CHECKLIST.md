# Quick Test Checklist: Prove Selective Loading

## Setup
- [ ] Start NEW Claude Code conversation
- [ ] Be in alexANTria directory
- [ ] Have this checklist handy

---

## Test Sequence

### 1. Baseline Test
**Say:** "What documentation exists? Don't read files yet."

**Check:**
- [ ] Claude describes hierarchy (Strategy/Product/Patterns/Architecture/Service)
- [ ] NO Read tool calls
- [ ] References CLAUDE.md

**Result:** ⬜ PASS  ⬜ FAIL

---

### 2. Selective Reading Test
**Say:** "Tell me about strategic principles."

**Check:**
- [ ] Read tool called on ANT-STRATEGY.md
- [ ] NO reads on ANT-PRODUCT.md, ANT-PATTERNS.md, etc.

**Result:** ⬜ PASS  ⬜ FAIL

---

### 3. Context Rotation Test
**Say:** "Now tell me about product features."

**Check:**
- [ ] Read tool called on ANT-PRODUCT.md
- [ ] NO re-read of ANT-STRATEGY.md
- [ ] NO reads on other layers

**Result:** ⬜ PASS  ⬜ FAIL

---

### 4. Path-Based Rule Test
**Do:** Open `user-level/commands/ant-init.md`
**Say:** "What should I know before modifying commands?"

**Check:**
- [ ] Mentions commands rule
- [ ] Says "read ANT-FRAMEWORK.md first"
- [ ] Mentions command philosophy

**Result:** ⬜ PASS  ⬜ FAIL

---

### 5. Hierarchy Filter Test
**Say:** "I want to add auth. What docs should I read?"

**Check:**
- [ ] References "When to Read" table
- [ ] Suggests reading Strategy → Product → Patterns → Architecture
- [ ] Doesn't just dump all docs

**Result:** ⬜ PASS  ⬜ FAIL

---

### 6. Context Efficiency Test
**Say:** "Have you read ant-validate.md or templates/ files?"

**Check:**
- [ ] Claude says "No" or "Not yet"
- [ ] Confirms most docs unread

**Result:** ⬜ PASS  ⬜ FAIL

---

### 7. Savings Calculation
**Say:** "What's the context reduction compared to loading everything?"

**Check:**
- [ ] Mentions 43x reduction
- [ ] Explains 282KB → 6.5KB
- [ ] Explains prevents attention degradation

**Result:** ⬜ PASS  ⬜ FAIL

---

## Final Score

**Tests Passed:** ___ / 7

**Overall:** ⬜ PASS (6-7/7)  ⬜ PARTIAL (4-5/7)  ⬜ FAIL (<4/7)

---

## Key Observations

**Read tool calls observed:**
- [ ] ANT-STRATEGY.md
- [ ] ANT-PRODUCT.md
- [ ] (Others:_________________)

**Files NOT read:**
- [ ] Most ANT-* files
- [ ] Templates
- [ ] Most command files

**Context active:**
- ~6.5 KB (2.3% of total)

**Reduction:** 43x smaller than full docs

---

## Conclusion

If 6+ tests passed: ✅ **RLM selective loading is working!**

If 4-5 tests passed: ⚠️ **Some issues, check configuration**

If <4 tests passed: ❌ **System not working, investigate**

---

Time to complete: **5-10 minutes**

Questions? Run: `./test-suite-rlm.sh` for automated validation
