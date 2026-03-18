# Checkpoint — Memory Archival for Codex CLI

When triggered, perform a complete knowledge archival to prevent amnesia across sessions.

## Steps

1. **SCAN**: Review conversation for solved problems, failed approaches, user preferences, and key config/API values
2. **CHECK**: Read `memory/MEMORY.md` index for existing entries
3. **SAVE**: Write new discoveries as memory files with YAML frontmatter (types: user, feedback, project, reference)
4. **UPDATE**: Add entries to MEMORY.md index
5. **VERIFY**: List all saved entries

## Memory File Format

```markdown
---
name: {{descriptive name}}
description: {{one-line summary}}
type: {{user | feedback | project | reference}}
---

Content with Problem, Wrong approaches, Correct solution, Verification
```

## Anti-Amnesia Protocol

- Before work: check memory for prior discoveries
- After breakthroughs: save immediately
- Before retries: check if already solved
