# Checkpoint — Persistent Memory Archival

> **"What you don't save, you will rediscover — painfully."**

You are being asked to perform a complete knowledge archival. This is NOT optional.

## Overview

Checkpoint is a memory persistence skill that prevents AI coding assistants from losing critical discoveries between conversations. It systematically captures what worked, what failed, and why — so you never solve the same problem twice.

## Trigger

- User invokes `/checkpoint` command
- User says "save what we learned" or "記住這個"
- End of a long debugging session with breakthroughs
- Before the user explicitly ends the conversation

## Workflow

```
┌─────────────────────────────────────┐
│         /checkpoint triggered       │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  Step 1: SCAN conversation history  │
│  ─────────────────────────────────  │
│  Find ALL:                          │
│  • Solved technical problems        │
│  • Failed approaches (and why)      │
│  • User preferences & feedback      │
│  • API paths, config values, env    │
│  • Architecture decisions           │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  Step 2: CHECK existing memory      │
│  ─────────────────────────────────  │
│  Read MEMORY.md index               │
│  Compare: what's saved vs. what's   │
│  new in this conversation           │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  Step 3: SAVE new discoveries       │
│  ─────────────────────────────────  │
│  For each unsaved finding:          │
│  1. Classify type (see table below) │
│  2. Write memory file w/ frontmatter│
│  3. Update MEMORY.md index          │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  Step 4: VERIFY completeness        │
│  ─────────────────────────────────  │
│  List all saved entries             │
│  Confirm nothing was missed         │
└─────────────────────────────────────┘
```

## Memory Types

| Type | What to capture | When to save |
|------|----------------|--------------|
| **user** | Role, goals, preferences, expertise | Learning about the user |
| **feedback** | Corrections AND confirmations | User says "don't do X" or "yes, exactly" |
| **project** | Goals, decisions, deadlines, context | Learning who/what/why/when |
| **reference** | Pointers to external systems | Discovering external resources |

## Memory File Format

Each memory file MUST use this frontmatter format:

```markdown
---
name: {{descriptive name}}
description: {{one-line summary for relevance matching}}
type: {{user | feedback | project | reference}}
---

{{content body}}
```

## Quality Standards

### Every memory entry MUST include:
- **Problem**: What was the issue
- **Wrong approaches**: What didn't work (and why)
- **Correct solution**: The final fix, with concrete code/paths/values
- **Verification**: How to confirm the solution works

### What NOT to save:
- Code patterns derivable from reading the codebase
- Git history (use `git log` / `git blame`)
- Debugging solutions already captured in code/commits
- Anything already in CLAUDE.md files
- Ephemeral task details or temporary state

## Anti-Amnesia Protocol

Checkpoint works with a passive defense layer (the Anti-Amnesia Protocol) that can be added to CLAUDE.md. While Checkpoint is the active "save now" command, the Anti-Amnesia Protocol ensures the AI checks memory BEFORE starting work and saves AFTER breakthroughs — even without explicit user prompting.

See [references/anti-amnesia-protocol.md](references/anti-amnesia-protocol.md) for the full protocol.

## Real-World Example

```
User: /checkpoint

AI: Scanning conversation... Found 3 new discoveries:

1. [SAVED] project_auth_tenant.md
   - Tenant blocks app consent
   - Must use pre-authorized client ID
   - Type: project

2. [SAVED] feedback_no_admin.md
   - Never suggest "ask your admin"
   - User has no admin rights
   - Type: feedback

3. [UPDATED] reference_notebook_structure.md
   - Added new section IDs discovered today
   - Type: reference

Memory index updated. 3 entries saved/updated.
```

## Why This Matters

Without Checkpoint:
- Session 1: Spend 30 min discovering API needs site-based paths
- Session 2: Spend 30 min rediscovering the same thing
- Session 3: User is frustrated, AI has amnesia

With Checkpoint:
- Session 1: Discover + save with `/checkpoint`
- Session 2: Read memory → skip straight to working solution
- Session 3: User is happy, AI remembers everything
