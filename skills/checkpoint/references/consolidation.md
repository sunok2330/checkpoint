# Memory Consolidation — Algorithm Reference

> Automated detection and resolution of duplicate, stale, and orphaned memories.

## Why Consolidation Matters

As memory accumulates across sessions, entropy increases:
- **Duplicates**: Two files capturing the same lesson from different sessions
- **Overlaps**: Separate files covering related subtopics that belong together
- **Ghosts**: MEMORY.md entries pointing to deleted files
- **Orphans**: Memory files that exist but aren't indexed in MEMORY.md
- **Stale entries**: Project memories with expired deadlines or superseded decisions

Without periodic consolidation, the memory system degrades — the AI wastes tokens reading redundant entries, risks contradictory guidance, and the index becomes unreliable.

## Consolidation Pipeline

```
┌─────────────────────────────────────┐
│  Phase 1: INVENTORY                 │
│  ─────────────────────────────────  │
│  • Read every .md file in memory/   │
│  • Parse frontmatter (name, desc,   │
│    type) from each file             │
│  • Read MEMORY.md index entries     │
│  • Build: file_map + index_map      │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  Phase 2: DETECT                    │
│  ─────────────────────────────────  │
│  Run all detectors (see below)      │
│  Output: categorized issue list     │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  Phase 3: PLAN                      │
│  ─────────────────────────────────  │
│  For each issue, propose action:    │
│  • MERGE — combine into one file    │
│  • DELETE — remove redundant file   │
│  • REINDEX — fix MEMORY.md entry    │
│  • FLAG — present to user for       │
│    decision (ambiguous cases)       │
│  Present plan to user for approval  │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  Phase 4: EXECUTE                   │
│  ─────────────────────────────────  │
│  Apply approved actions:            │
│  • Write merged files               │
│  • Delete redundant files           │
│  • Rebuild MEMORY.md index          │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  Phase 5: REPORT                    │
│  ─────────────────────────────────  │
│  • Before/after file count          │
│  • List of actions taken            │
│  • Items flagged for user review    │
└─────────────────────────────────────┘
```

## Detectors

### 1. Duplicate Detector

Two memories are **duplicates** when they share the same `type` AND describe the same core topic.

**Signals** (any two or more → duplicate candidate):
- File names share a common keyword (e.g., `project_auth_tenant.md` + `project_azure_enterprise_auth.md`)
- Descriptions overlap significantly (>60% keyword overlap)
- Content references the same systems, APIs, or error messages
- One file is a strict subset of the other

**Resolution**: Merge into the richer file. Preserve all unique information from both.

### 2. Overlap Detector

Two memories **overlap** when they cover related but distinct subtopics that would be more useful combined.

**Signals**:
- Same `type` + closely related domain (e.g., two `project` memories about the same external system)
- Cross-references between files (one mentions the other's topic)
- Reading one file is necessary context for understanding the other

**Resolution**: Merge if combined content stays under ~60 lines. Otherwise keep separate but add cross-references.

### 3. Ghost Detector

A **ghost** is a MEMORY.md index entry whose target file does not exist.

**Detection**: For each `[text](filename.md)` link in MEMORY.md, check if the file exists.

**Resolution**: Remove the ghost entry from MEMORY.md. No further action needed.

### 4. Orphan Detector

An **orphan** is a memory file that exists in the directory but has no entry in MEMORY.md.

**Detection**: Compare the set of `.md` files (excluding MEMORY.md) against links in MEMORY.md.

**Resolution**: Read the orphan's frontmatter and add a proper entry to MEMORY.md under the correct type section.

### 5. Staleness Detector

A memory is **stale** when its content is likely outdated.

**Signals**:
- `project` type memories referencing past dates/deadlines
- Content contradicts what is currently observable in the codebase
- References to tools, APIs, or versions that have been superseded
- `feedback` memories about workflows that no longer exist

**Resolution**: FLAG for user review — never auto-delete stale memories. Present the memory content and ask: "Is this still accurate?"

### 6. Quality Detector

A memory has **quality issues** when it doesn't follow the expected structure.

**Signals**:
- Missing frontmatter fields (name, description, type)
- `feedback`/`project` type missing **Why:** or **How to apply:** sections
- Description is too vague to be useful for relevance matching
- Content is a single line with no actionable detail

**Resolution**: FLAG for user review with specific suggestions for improvement.

## Merge Protocol

When merging two memory files A and B:

1. **Select canonical file**: Pick the one with richer content as the base
2. **Extract unique content**: Identify information in the secondary file that doesn't exist in the canonical
3. **Integrate**: Add unique content to the canonical file in the appropriate section
4. **Update frontmatter**:
   - `name`: Use the more descriptive name
   - `description`: Combine key terms from both descriptions
   - `type`: Must match (only merge within same type)
5. **Delete secondary file**
6. **Update MEMORY.md**: Remove the secondary entry, update the canonical entry's description if changed

### Merge Safety Rules

- **Never merge across types**: A `feedback` memory and a `project` memory stay separate even if related
- **Never merge if ambiguous**: If it's unclear whether two memories describe the same thing, FLAG instead of merging
- **Preserve all Why/How to apply sections**: These represent user intent and must not be lost
- **Keep the more specific file name**: `feedback_no_admin_suggestions.md` is better than `feedback_permissions.md`

## Cross-Scope Consolidation

Memory exists in two scopes:
- **Global** (`~/.claude/memory/`) — applies across all projects
- **Project** (`~/.claude/projects/{key}/memory/`) — project-specific

Cross-scope duplicates arise from three scenarios:

### Scenario 1: Promotion Residue

A project memory was promoted to global (via `/checkpoint:global`) but the project copy was not deleted.

**Detection**: Same `name` or `description` exists in both scopes.

**Resolution**: DELETE the project copy. Global is the canonical source — keeping both causes confusion about which version is authoritative.

### Scenario 2: Scope Mismatch

A memory was saved to project scope but its content is universally applicable (e.g., a `user` preference or a `feedback` rule that applies everywhere).

**Signals**:
- `type: user` in project scope (user identity is inherently global)
- `type: feedback` with no project-specific references (e.g., "always add unit tests" applies everywhere)
- Content has no project-specific file paths, APIs, or context

**Resolution**: FLAG and suggest promotion to global. Present to user:
> "This memory appears universally applicable. Promote to global? [memory name]"

### Scenario 3: Scope Conflict

Global and project memories cover the same topic but with different or contradictory content (e.g., global says "use SDK v0.4.0" but project has updated to v1.x).

**Detection**: Same type + overlapping topic across scopes.

**Resolution**:
- If project memory is **more specific/recent** → FLAG: suggest updating global OR keeping both (project overrides global in practice)
- If global memory is **more complete** → FLAG: suggest deleting the project copy
- **Never auto-resolve conflicts** — always present both versions to the user

### Cross-Scope Merge Rules

1. **Project scope cannot override global without user consent** — global memories represent cross-project truths
2. **`user` type defaults to global** — identity is not project-scoped
3. **`feedback` type requires judgment** — "always add unit tests" is global; "use pytest not unittest in this repo" is project
4. **`project` type stays in project scope** — by definition, project context is project-specific
5. **`reference` type requires judgment** — a Jira URL may be global; a repo-specific API endpoint is project
6. **When in doubt, keep both** — redundancy is cheaper than lost context

## Integration with Checkpoint Workflow

Consolidation can run in two modes:

### Standalone Mode (`/checkpoint:consolidate`)
Runs the full pipeline on existing memories without scanning the current conversation. Use this for periodic maintenance.

### Integrated Mode (during `/checkpoint`)
After Step 2 (CHECK existing memory) and before Step 3 (SAVE new discoveries), run a lightweight consolidation pass:
- Skip Phase 1 (already done during CHECK)
- Run Ghost + Orphan detectors only (fast, non-destructive)
- Flag duplicates/staleness but don't resolve (save that for standalone mode)
- Auto-fix index issues (ghosts, orphans)

This keeps the main checkpoint fast while ensuring the index stays healthy.
