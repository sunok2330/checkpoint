# Checkpoint — Memory Archival Instructions

## Overview
Checkpoint is a persistent memory system. When invoked, systematically capture all discoveries from the current session into structured memory files.

## Memory Structure
- Store memories in `memory/` directory
- Maintain `memory/MEMORY.md` as the index
- Each memory is a separate `.md` file with YAML frontmatter

## Memory Types
- **user**: Who the user is (role, expertise, preferences)
- **feedback**: What the user corrected or confirmed
- **project**: Context, decisions, deadlines not in code
- **reference**: Pointers to external systems

## Workflow
1. Scan conversation for discoveries
2. Check existing memory index
3. Save new findings with frontmatter format
4. Update MEMORY.md index
5. Verify completeness

## Anti-Amnesia
- Always check memory before starting tasks
- Save breakthroughs immediately after they happen
- Never re-solve problems that are already in memory
