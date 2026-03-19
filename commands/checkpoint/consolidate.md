---
description: Consolidate memories — merge duplicates, fix index, flag stale entries
---

# Memory Consolidation

You are being asked to clean up and optimize the memory system. This is a maintenance operation.

## Phase 1: INVENTORY

1. Read **all** `.md` files in the memory directory (excluding MEMORY.md itself)
2. Parse each file's YAML frontmatter: extract `name`, `description`, `type`
3. Read MEMORY.md and extract all file links
4. If both global (`~/.claude/memory/`) and project memory directories exist, inventory both

Build two maps:
- **file_map**: `{ filename → { name, description, type, content_summary } }`
- **index_map**: `{ filename → description_in_index }`

## Phase 2: DETECT

Run each detector and collect all issues found:

### Detector 1 — Ghosts
For each link in MEMORY.md, verify the target file exists. Missing files are **ghosts**.

### Detector 2 — Orphans
For each `.md` file in the directory (excluding MEMORY.md), verify it has a corresponding link in MEMORY.md. Unlinked files are **orphans**.

### Detector 3 — Duplicates
Within each `type` group, compare all pairs:
- Do two files describe the same core topic?
- Does one file's content fully contain the other's?
- Do descriptions share >60% of their keywords?

Flag pairs as **duplicate candidates**.

### Detector 4 — Cross-Scope Duplicates
If both global and project memory directories exist:
- Compare files across scopes by name, description, and type
- Check for promotion residue (same file in both scopes)
- Check for scope mismatches (`user` type in project scope)

### Detector 5 — Staleness
For `project` type memories:
- Do they reference specific dates that have passed?
- Do they reference tools/versions that may be outdated?

For `feedback` type memories:
- Do they reference workflows or patterns that no longer exist in the codebase?

### Detector 6 — Quality
For all memories:
- Missing frontmatter fields?
- `feedback`/`project` type missing **Why:** or **How to apply:** sections?
- Description too vague for relevance matching?

## Phase 3: PLAN

Present findings to the user in a structured table:

```
## Consolidation Plan

| # | Issue | Files | Proposed Action |
|---|-------|-------|-----------------|
| 1 | Duplicate | file_a.md + file_b.md | MERGE → file_a.md |
| 2 | Ghost | missing_file.md | REINDEX — remove from MEMORY.md |
| 3 | Orphan | unlisted_file.md | REINDEX — add to MEMORY.md |
| 4 | Stale | old_project.md | FLAG — ask user |
| 5 | Cross-scope | proj + global | FLAG — suggest promotion |
| 6 | Quality | incomplete.md | FLAG — suggest improvement |
```

Wait for user approval before proceeding. User may:
- Approve all → execute everything
- Approve selectively → execute only approved items
- Reject → skip

## Phase 4: EXECUTE

For approved actions:

**MERGE**:
1. Read both files completely
2. Select the richer file as canonical base
3. Extract unique content from the secondary file
4. Integrate into canonical file, preserving all Why/How to apply sections
5. Update frontmatter with the better name and combined description keywords
6. Delete the secondary file
7. Update MEMORY.md: remove secondary entry, update canonical entry

**REINDEX**:
- Ghost: remove the dead link from MEMORY.md
- Orphan: read the file's frontmatter and add a proper entry under the correct type section

**DELETE** (only for confirmed duplicates after merge):
- Remove the redundant file
- Remove its MEMORY.md entry

**FLAG** items are presented to the user — no automatic action taken.

## Phase 5: REPORT

```
## Consolidation Complete

- Files before: X
- Files after: Y
- Merged: N pairs
- Index fixes: N entries
- Flagged for review: N items

### Actions Taken
1. MERGED file_a.md + file_b.md → file_a.md
2. REINDEXED orphan.md (added to MEMORY.md)
3. ...

### Items Requiring Your Attention
- [file.md] — appears stale (references date 2025-01-15)
- [file.md] — missing Why section
```

## Safety Rules

- **Never auto-delete** without user approval
- **Never merge across types** (feedback + project = always separate)
- **Never merge cross-scope** without explicit user consent
- **Preserve all Why/How to apply sections** during merges
- **Keep the more specific filename** when merging

## User's message

$ARGUMENTS
