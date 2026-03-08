---
name: fact-extraction
description: >
  Review conversations for durable facts and manage the three-layer memory system.
  Use when processing conversations that contain entity mentions, relationship updates,
  status changes, or milestones.
  Don't use for casual chat, temporary information, or already-processed facts.
---

# Fact Extraction & Memory Management

## When to Use
- Conversations contain mentions of people, companies, or projects
- Status changes, milestones, or relationship updates are discussed
- New preferences or important information emerges
- During heartbeat runs for fact extraction

## When NOT to Use
- Casual chat or temporary information
- Facts already extracted and stored
- Sensitive or private data that shouldn't be persisted

## Three-Layer Memory System

### Layer 1: Knowledge Graph (`life/areas/`)
Entity-based storage for people, companies, projects.

```
life/areas/
├── people/
│   └── [name]/
│       ├── summary.md    # Weekly-rewritten snapshot
│       └── items.json    # Atomic facts
└── companies/
    └── [name]/
        ├── summary.md
        └── items.json
```

**Rules:**
- Save new facts immediately to items.json
- Weekly: rewrite summary.md from active facts
- Never delete facts — supersede instead

### Layer 2: Daily Notes (`memory/YYYY-MM-DD.md`)
Raw event logs — what happened, when.

### Layer 3: Tacit Knowledge (`PATTERNS.md`)
Patterns about how the user works, not facts about entities.

## Fact Extraction Process

### What to Extract
- **Relationships** (who people are, how they relate to the user)
- **Status changes** (new job, moved, role change)
- **Milestones** (achievements, life events)
- **Preferences** (stated likes/dislikes)

### What to Skip
- Casual chat, temporary info
- Already-extracted facts
- Sensitive/private data

### Process Steps
1. Identify entities mentioned (people, companies, projects)
2. If new facts found, write to `life/areas/[type]/[name]/items.json`
3. Create entity folder + files if first mention
4. Use atomic fact schema

## Atomic Fact Schema

```json
{
  "id": "entity-001",
  "fact": "The actual fact",
  "category": "relationship|milestone|status|preference",
  "timestamp": "YYYY-MM-DD",
  "source": "conversation",
  "status": "active|superseded",
  "supersededBy": "entity-002"
}
```

## New Entity Creation

```bash
mkdir -p life/areas/people/[name]
echo "# [Name]\n\nSummary auto-generated weekly." > life/areas/people/[name]/summary.md
echo "[]" > life/areas/people/[name]/items.json
```

## Maintenance
- **Weekly**: Rewrite summary.md files from active facts
- **Never delete**: Use supersededBy to maintain history
- **Daily notes**: Write to `memory/YYYY-MM-DD.md` continuously
- **Quality > quantity**: Only extract truly durable facts
