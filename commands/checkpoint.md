---
description: Checkpoint — Persistent Memory Archival
---

# Checkpoint — Persistent Memory Archival

You are being asked to perform a complete knowledge archival. This is NOT optional.

## Step 1: Scan current conversation for key discoveries

Review the entire conversation history and find ALL:
- Successfully solved technical problems (including the correct solution)
- Failed approaches (what didn't work and why)
- User preferences and feedback
- Important API paths, config values, environment info

## Step 2: Check existing memory

Read the memory/MEMORY.md index to determine which discoveries are already saved and which are new.

## Step 3: Consolidate (lightweight)

Before saving new entries, fix any existing index issues:
1. **Ghosts**: Check each MEMORY.md link — if the target file is missing, remove the entry
2. **Orphans**: Check each `.md` file in the memory directory — if not in MEMORY.md, add it
3. **Cross-scope**: If both project and global (`~/.claude/memory/`) memory directories exist, check for duplicates across scopes and flag them
4. **Duplicate candidates**: If any existing memories appear to duplicate each other, note them in the final report (do not auto-merge — use `/checkpoint:consolidate` for full consolidation)

## Step 4: Save new discoveries

For each unsaved discovery:
1. Classify its type (user / feedback / project / reference)
2. Check if an existing memory covers the same topic — if so, UPDATE that file instead of creating a new one
3. Write it to a dedicated memory file with full frontmatter

## Step 5: Update index

Add new entries to MEMORY.md. Update descriptions for any modified existing memories.

## Step 6: Verify

List all saved memory entries and confirm completeness. Include any consolidation findings (ghosts fixed, orphans indexed, duplicates flagged).

## Format requirements

Each memory file MUST include:
- **Problem**: What was the issue
- **Wrong approaches**: What didn't work (and why)
- **Correct solution**: The final fix, with concrete code/paths/values
- **Verification**: How to confirm the solution works

## User's message

$ARGUMENTS
