# Anti-Amnesia Protocol

> Passive defense layer for CLAUDE.md — ensures memory is checked and saved automatically.

Copy this entire block into your project's `CLAUDE.md` file. It works alongside the `/checkpoint` command as a background safety net.

---

```markdown
# Anti-Amnesia Protocol

## Before Starting Any Task
1. Read `MEMORY.md` index to check for relevant prior discoveries
2. If the task involves a topic with existing memory entries, read those memory files FIRST
3. State what you already know from memory before beginning work

## After Any Breakthrough or Fix
1. **Immediately** save the key discovery to memory BEFORE moving to the next step
2. Include: what worked, what didn't work, and the correct approach
3. Do NOT wait until the user asks you to save — save proactively the moment something works

## Before Retrying a Failed Approach
1. Check memory: have we already solved this exact problem?
2. If yes, use the known solution — do NOT rediscover from scratch
3. If retrying, explain why this attempt differs from prior attempts

## The Prevention Rule
When the user asks you to "save and re-run" or "do it again":
- The code is already working. Do NOT rewrite or re-explore what was already proven.
- Build → test → done. Three steps, no detours.
- If you catch yourself re-solving a problem you already solved in this conversation, STOP and use the existing solution.
```

---

## How It Works

The Anti-Amnesia Protocol operates at three checkpoints:

1. **Before work** — Forces the AI to consult memory, preventing redundant exploration
2. **After breakthroughs** — Forces immediate persistence, preventing knowledge loss
3. **Before retries** — Forces deduplication, preventing circular problem-solving

Together with the `/checkpoint` command, this creates a two-layer defense:
- **Active layer**: User triggers `/checkpoint` to save explicitly
- **Passive layer**: Protocol in CLAUDE.md ensures saving happens even without user prompting
