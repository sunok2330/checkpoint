---
mode: agent
description: Save all discoveries from current session to persistent memory
---

Perform a complete knowledge archival:

1. Scan this conversation for all key discoveries: solved problems, failed approaches, user preferences, API paths, config values, and architecture decisions.

2. Read the `memory/MEMORY.md` index to check what's already saved.

3. For each new discovery, create a memory file in `memory/` with this format:

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

4. Update `memory/MEMORY.md` index with links to new files.

5. List all saved entries to confirm completeness.
