# The Three-Layer Memory System

Your agent's memory isn't a single file — it's a structured system with three layers, each serving a different purpose.

## Layer 1: Knowledge Graph

**What it is:** Entity-based storage for people, companies, and projects.

**Where it lives:** `life/areas/`

```
life/areas/
├── people/
│   └── jane-doe/
│       ├── summary.md    ← Quick context (loaded first)
│       └── items.json    ← Atomic facts (loaded if needed)
└── companies/
    └── acme-corp/
        ├── summary.md
        └── items.json
```

**How it works:**
- When your agent learns something about a person or company, it writes an atomic fact to `items.json`
- Facts are never deleted — they're superseded (marked as replaced by a newer fact)
- Once a week, `summary.md` gets rewritten from the active facts in `items.json`
- When your agent needs context about an entity, it loads `summary.md` first (fast), then `items.json` if it needs more detail

**Atomic fact example:**
```json
{
  "id": "jane-001",
  "fact": "Jane is the CTO of Acme Corp",
  "category": "status",
  "timestamp": "2024-03-15",
  "source": "conversation",
  "status": "active"
}
```

## Layer 2: Daily Notes

**What it is:** A raw event log of what happened each day.

**Where it lives:** `memory/YYYY-MM-DD.md`

**How it works:**
- Your agent writes to today's memory file continuously throughout the day
- This captures everything: meetings, decisions, tasks completed, conversations
- Durable facts get extracted from daily notes into Layer 1 (the knowledge graph)
- Daily notes are the "source of truth" for what happened when

**Example entry:**
```markdown
## 2024-03-15

### Morning
- Reviewed PR #142 — approved with minor comments
- Meeting with Jane (Acme Corp) at 10 AM — discussed integration timeline

### Afternoon
- Deployed v2.3 to staging
- User reported bug in auth flow — investigated, root cause: expired token cache
```

## Layer 3: Tacit Knowledge

**What it is:** Patterns about how *you* work — not facts about other entities.

**Where it lives:** `PATTERNS.md`

**How it works:**
- When your agent notices a pattern in how you prefer things done, it adds it here
- This includes: communication preferences, debugging approaches, decision-making styles, tool preferences
- Updated occasionally when new patterns emerge — not on every conversation
- This file grows slowly over weeks and months

**Example patterns:**
- "Prefers bullet points over paragraphs"
- "Always benchmarks before implementing changes"
- "Works late — don't suggest breaks after midnight"

## Why Three Layers?

Each layer optimizes for different retrieval patterns:

- **Knowledge Graph**: "What do I know about Jane?" → Load `jane/summary.md`
- **Daily Notes**: "What happened on March 15th?" → Load `memory/2024-03-15.md`
- **Tacit Knowledge**: "How does the user like their reports formatted?" → Check `PATTERNS.md`

A single flat file would make all three queries slow. The layered system makes each fast.

## Key Rules

1. **Write immediately.** Don't wait for a "memory flush" — write when the fact emerges.
2. **Never delete facts.** Supersede them with newer facts instead.
3. **Quality over quantity.** Only extract truly durable facts into the knowledge graph.
4. **Weekly maintenance.** Rewrite summaries from active facts to keep them current.
5. **Daily notes are ephemeral.** They capture everything; the knowledge graph captures what matters.

## The Correction Loop

The most important memory pattern is the **correction loop**:

1. You correct your agent's behavior
2. Agent writes the correction to `SOUL.md` ACTIVE RULES (loaded every session)
3. Agent also writes the pattern to `PATTERNS.md` (loaded occasionally)
4. The correction persists because SOUL.md is always loaded

This is why corrections to SOUL.md are more reliable than corrections to PATTERNS.md. SOUL.md is guaranteed to be read every session. PATTERNS.md might not be.
