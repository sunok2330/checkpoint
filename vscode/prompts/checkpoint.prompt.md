---
agent: agent
description: Save all discoveries from current session to persistent memory
---

Perform a complete knowledge archival:

1. Scan this conversation for all key discoveries: solved problems, failed approaches, user preferences, API paths, config values, and architecture decisions.

2. Read the `memory/MEMORY.md` index to check what's already saved.

3. Consolidate (lightweight) — fix index issues before saving new entries:
   - Remove MEMORY.md links to missing files (ghosts)
   - Add unindexed memory files to MEMORY.md (orphans)
   - If both project and global memory exist, flag cross-scope duplicates
   - Note any duplicate candidates in the final report

4. For each new discovery, create a memory file in `memory/` with this format. If an existing memory already covers the same topic, update that file instead of creating a new one:

```markdown
---
name: {{name}}
description: {{one-line summary}}
type: {{user | feedback | project | reference}}
---

**Problem**: ...
**Wrong approaches**: ...
**Correct solution**: ...
**Verification**: ...
```

5. Update `memory/MEMORY.md` index with links to new files.

6. List all saved entries to confirm completeness. Include any consolidation findings (ghosts fixed, orphans indexed, duplicates flagged).
