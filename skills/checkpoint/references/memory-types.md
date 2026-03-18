# Memory Types — Detailed Guide

Checkpoint organizes knowledge into four memory types. Each type serves a different purpose and has specific triggers for when to save.

## 1. User Memories

**Purpose**: Build understanding of who the user is to tailor future interactions.

**When to save**:
- User mentions their role, team, or expertise
- User reveals preferences for communication style
- User shows domain knowledge (or lack thereof)

**Example**:
```markdown
---
name: User is senior backend engineer
description: 10+ years Go experience, new to React frontend
type: user
---

Deep Go expertise. Frame frontend explanations using backend analogues
(components = handlers, props = function params, state = in-memory cache).
```

## 2. Feedback Memories

**Purpose**: Record corrections AND confirmations so the AI doesn't repeat mistakes or drift from validated approaches.

**When to save**:
- User corrects: "no not that", "don't do X", "stop doing Y"
- User confirms: "yes exactly", "perfect", accepts unusual choice
- **Both are important** — corrections prevent mistakes, confirmations anchor good behavior

**Structure**: Rule → **Why** → **How to apply**

**Example**:
```markdown
---
name: Use real database in integration tests
description: Never mock the database — prior incident with mock/prod divergence
type: feedback
---

Integration tests must hit a real database, not mocks.

**Why:** Last quarter, mocked tests passed but prod migration failed because mock
behavior diverged from actual PostgreSQL constraints.

**How to apply:** When writing or modifying integration tests, always connect to
the test database. Only use mocks for unit tests of pure business logic.
```

## 3. Project Memories

**Purpose**: Capture context, motivations, and decisions that aren't in the code.

**When to save**:
- Learning about deadlines, constraints, or stakeholder requirements
- Understanding why a decision was made (not just what)
- Discovering cross-team dependencies or blockers

**Structure**: Fact/decision → **Why** → **How to apply**

**Example**:
```markdown
---
name: Auth middleware rewrite for compliance
description: Legal/compliance requirement driving auth rewrite, not tech debt
type: project
---

Auth middleware rewrite is driven by legal/compliance requirements around
session token storage.

**Why:** Legal flagged current implementation for storing session tokens in a
way that doesn't meet new compliance requirements. This is NOT a tech-debt cleanup.

**How to apply:** Scope decisions should favor compliance over ergonomics.
Don't simplify the token handling if it compromises the compliance fix.
```

## 4. Reference Memories

**Purpose**: Store pointers to external systems and resources.

**When to save**:
- Discovering where information lives (Linear, Jira, Grafana, Slack)
- Learning about monitoring dashboards or alerting systems
- Finding documentation or runbooks

**Example**:
```markdown
---
name: Pipeline bugs tracked in Linear INGEST
description: Linear project INGEST tracks all pipeline-related bugs
type: reference
---

Pipeline bugs are tracked in Linear project "INGEST".
Use this when investigating pipeline-related issues or creating new bug reports.
```

## What NOT to Save

| Don't save | Why | Use instead |
|-----------|-----|-------------|
| Code patterns | Derivable from codebase | Read the code |
| Git history | Changes over time | `git log` / `git blame` |
| Fix recipes | Solution is in the code | Read the commit |
| CLAUDE.md content | Already loaded | It's already there |
| Temp task state | Only useful now | Use todo lists |
