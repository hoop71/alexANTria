# Quality Scoring Framework

## How We Prove Quality Differences

To objectively compare ANT vs raw repo approaches, we measure outputs across multiple dimensions.

## Scoring Dimensions

### 1. Objective Criteria (40 points)

Automated checks against task success_criteria:

```python
def score_objective_criteria(output, criteria):
    """
    Binary checks that can be automated:
    - File naming conventions
    - Required sections present
    - YAML frontmatter valid
    - References to correct files
    """
    points = 0
    max_points = len(criteria) * 4

    for criterion in criteria:
        if check_criterion_met(output, criterion):
            points += 4

    return (points / max_points) * 40
```

**Example checks:**
- ✓ Filename matches `ant-*.md` pattern (4 pts)
- ✓ Has valid YAML frontmatter (4 pts)
- ✓ Contains `## Agent Instructions` section (4 pts)
- ✓ Includes example output (4 pts)
- ✓ No placeholder text like "TODO" or "[INSERT]" (4 pts)

### 2. Pattern Adherence (30 points)

Compare output against established patterns in ANT-PATTERNS.md:

```python
def score_pattern_adherence(output):
    """
    Check if output follows documented patterns:
    - Command structure pattern
    - Naming conventions
    - Frontmatter format
    - Agent instruction format
    - Read-act-repair pattern
    """
    pattern_checks = {
        'command_structure': check_command_structure(output),
        'naming_convention': check_naming_convention(output),
        'frontmatter_format': check_frontmatter_format(output),
        'agent_instructions': check_agent_instructions(output),
        'read_act_repair': check_read_act_repair_pattern(output)
    }

    score = sum(1 for passed in pattern_checks.values() if passed)
    return (score / len(pattern_checks)) * 30
```

**Pattern checks:**
- ✓ Follows command structure from ANT-PATTERNS.md (6 pts)
- ✓ Uses ant-* naming consistently (6 pts)
- ✓ Frontmatter matches template (6 pts)
- ✓ Agent instructions follow format (6 pts)
- ✓ Demonstrates read-act-repair pattern (6 pts)

### 3. Correctness (20 points)

Verify factual accuracy and no hallucinations:

```python
def score_correctness(output, repo_files):
    """
    Check for hallucinations and incorrect references:
    - All file references exist in repo
    - Command references are valid
    - Tool names are correct
    - No made-up concepts
    """
    deductions = 0

    # Check file references
    referenced_files = extract_file_references(output)
    for file in referenced_files:
        if file not in repo_files:
            deductions += 2  # Hallucinated file

    # Check command references
    referenced_commands = extract_command_references(output)
    for cmd in referenced_commands:
        if cmd not in valid_commands:
            deductions += 2  # Invalid command

    return max(0, 20 - deductions)
```

**Correctness checks:**
- ✓ All file references exist in repo
- ✓ No made-up commands or tools
- ✓ No placeholder/dummy content
- ✓ Factually accurate about alexANTria

### 4. Completeness (10 points)

Is the solution complete and production-ready?

```python
def score_completeness(output, success_criteria):
    """
    Check if solution is complete:
    - All success criteria addressed
    - No missing sections
    - Example output provided
    - Edge cases handled
    """
    completeness_score = 0

    # All criteria addressed
    criteria_met = sum(1 for c in success_criteria if criterion_addressed(output, c))
    completeness_score += (criteria_met / len(success_criteria)) * 5

    # Required sections present
    required_sections = ['description', 'workflow', 'agent instructions', 'example']
    sections_present = sum(1 for s in required_sections if section_exists(output, s))
    completeness_score += (sections_present / len(required_sections)) * 5

    return completeness_score
```

## Total Score: 100 Points

```
Score = Objective (40) + Patterns (30) + Correctness (20) + Completeness (10)

90-100: Excellent (production-ready, follows all patterns)
80-89:  Good (mostly correct, minor issues)
70-79:  Acceptable (works but has gaps)
60-69:  Needs improvement (significant issues)
<60:    Poor (major problems)
```

## Automated Scoring Script

```python
#!/usr/bin/env python3
import json
import re
import yaml
from pathlib import Path

def score_output(output_text, task_definition, repo_files):
    """
    Automatically score command output against quality framework.
    Returns score breakdown and total.
    """
    scores = {}

    # 1. Objective Criteria (40 points)
    scores['objective'] = score_objective_criteria(
        output_text,
        task_definition['success_criteria']
    )

    # 2. Pattern Adherence (30 points)
    scores['patterns'] = score_pattern_adherence(output_text)

    # 3. Correctness (20 points)
    scores['correctness'] = score_correctness(output_text, repo_files)

    # 4. Completeness (10 points)
    scores['completeness'] = score_completeness(
        output_text,
        task_definition['success_criteria']
    )

    scores['total'] = sum(scores.values())
    scores['grade'] = get_grade(scores['total'])

    return scores

def get_grade(score):
    if score >= 90: return 'A (Excellent)'
    if score >= 80: return 'B (Good)'
    if score >= 70: return 'C (Acceptable)'
    if score >= 60: return 'D (Needs Improvement)'
    return 'F (Poor)'
```

## LLM-as-Judge (Validation Layer)

For subjective quality assessment, use a third agent:

```markdown
You are a code reviewer evaluating two implementations of the same task.

Task: {task_description}

Success Criteria:
{criteria}

Implementation A:
{control_output}

Implementation B:
{test_output}

Rate each implementation on:
1. Clarity (0-10): How clear and understandable is it?
2. Adherence to Patterns (0-10): Does it follow documented patterns?
3. Completeness (0-10): Does it fully address the task?
4. Production-Readiness (0-10): Could this be merged as-is?

Provide scores and brief justification for each.
```

## Quality Dimensions Summary

| Dimension | Weight | Measurement |
|-----------|--------|-------------|
| **Objective Criteria** | 40% | Automated checks (file structure, required elements) |
| **Pattern Adherence** | 30% | Compliance with ANT-PATTERNS.md |
| **Correctness** | 20% | No hallucinations, valid references |
| **Completeness** | 10% | All criteria met, production-ready |

## Expected Hypotheses

**Hypothesis 1: Control (Raw) produces hallucinations**
- With 1M tokens of context, agent loses track of what's real
- May reference non-existent files or made-up patterns
- **Testable:** Count file references that don't exist

**Hypothesis 2: Test (ANT) follows patterns better**
- Focused context on ANT-PATTERNS.md
- Direct examples from existing commands
- **Testable:** Score pattern adherence objectively

**Hypothesis 3: Control is verbose, Test is concise**
- More context → longer, less focused output
- ANT guidance → targeted, pattern-following output
- **Testable:** Measure output token count and density

**Hypothesis 4: Both succeed, but Test is cleaner**
- Control might work but be messier
- Test should be more maintainable/production-ready
- **Testable:** LLM-as-judge for production-readiness

## Anti-Patterns to Detect

In control output (too much context):
- ❌ References files that don't exist
- ❌ Verbose, unfocused explanations
- ❌ Copies patterns from wrong sources
- ❌ Includes irrelevant information
- ❌ Inconsistent with established patterns

In test output (ideal):
- ✓ References only relevant files
- ✓ Concise, focused implementation
- ✓ Follows ANT-PATTERNS.md precisely
- ✓ Relevant information only
- ✓ Consistent with existing commands
