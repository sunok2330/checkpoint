# Checkpoint — Memory Archival for Codex CLI

When triggered, perform a complete knowledge archival to prevent amnesia across sessions.

## Steps

1. **SCAN**: Review conversation for solved problems, failed approaches, user preferences, and key config/API values
2. **CHECK**: Read `memory/MEMORY.md` index for existing entries
3. **CONSOLIDATE** (lightweight): Fix index issues before saving
   - Remove MEMORY.md links to missing files (ghosts)
   - Add unindexed memory files to MEMORY.md (orphans)
   - If both project and global memory exist, flag cross-scope duplicates
   - Note duplicate candidates (don't auto-merge)
4. **SAVE**: Write new discoveries as memory files with YAML frontmatter (types: user, feedback, project, reference). If an existing memory covers the same topic, update it instead of creating a duplicate.
5. **UPDATE**: Add entries to MEMORY.md index
6. **VERIFY**: List all saved entries and any consolidation findings

## Memory File Format

```markdown
---
name: {{descriptive name}}
description: {{one-line summary}}
type: {{user | feedback | project | reference}}
---

Content with Problem, Wrong approaches, Correct solution, Verification
```

## Memory Consolidation

For periodic deep maintenance, run consolidation separately. This performs:
- Duplicate detection and merging (within same type, with user approval)
- Staleness detection for project memories with past dates
- Quality checks for missing Why/How to apply sections
- Cross-scope duplicate resolution (project vs global memory)

## Anti-Amnesia Protocol

- Before work: check memory for prior discoveries
- After breakthroughs: save immediately
- Before retries: check if already solved
