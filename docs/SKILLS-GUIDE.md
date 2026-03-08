# Skills Guide

Skills are reusable instruction sets that teach your agent how to perform specific tasks consistently.

## What is a Skill?

A skill is a `SKILL.md` file (optionally with supporting scripts) that lives in `~/.openclaw/skills/<skill-name>/`. It contains:

- **When to use** — triggers that tell the agent when this skill applies
- **When NOT to use** — guardrails to prevent misapplication
- **Step-by-step instructions** — the actual procedure
- **Rules and gotchas** — lessons learned from past mistakes

## Anatomy of a Skill

```
~/.openclaw/skills/my-skill/
├── SKILL.md        # Required: instructions and metadata
└── script.js       # Optional: supporting automation
```

### SKILL.md Structure

```markdown
---
name: my-skill
description: >
  One-paragraph description of what this skill does and when to use it.
---

# My Skill

## When to Use
- Trigger condition 1
- Trigger condition 2

## When NOT to Use
- Anti-pattern 1
- Anti-pattern 2

## Steps

### Step 1: [Name]
- What to do
- How to do it

### Step 2: [Name]
- Next steps

## Rules
1. Important constraint
2. Common gotcha to avoid
```

## Creating a Skill

### Manual Creation

```bash
mkdir -p ~/.openclaw/skills/my-skill
# Create SKILL.md with the structure above
```

### Auto-Detection

Your agent should automatically detect when it's doing the same multi-step task 3+ times and offer to create a skill for it. This is configured in `HEARTBEAT.md` and `AGENTS.md`.

## Installing Skills

Skills from this starter kit can be installed by copying them:

```bash
cp -r skills/repo-analyzer ~/.openclaw/skills/
cp -r skills/morning-digest ~/.openclaw/skills/
```

The `setup.sh` script can do this for you interactively.

## Security Audit (MANDATORY)

Before installing any skill from an external source:

1. **Read every file** — understand what all scripts do
2. **Check for external URLs** — especially in install steps
3. **Verify dependencies** — look up unknown npm/pip packages
4. **Check permissions** — does the skill request more access than it needs?

### Red Flags
- Scripts that fetch from unknown URLs
- Obfuscated code or encoded payloads
- Requests for credentials beyond what the skill needs
- Scripts that remove security attributes

See `AGENTS.md` for the full security audit checklist.

## Included Skills

This starter kit includes these production-tested skills:

| Skill | What it does |
|-------|-------------|
| `repo-analyzer` | GitHub repo trust scoring — 29 analysis modules across 12 categories |
| `spawn-agent` | Deploy sub-agents for parallel or long-running tasks |
| `fact-extraction` | Extract durable facts from conversations into the knowledge graph |
| `morning-digest` | Daily morning briefing with calendar, weather, threads, and status |
| `post-update-health-check` | Verify system health after OpenClaw updates |
| `company-research` | Structured research briefs for companies and founders |

## Tips

- **Start with 2-3 skills** — don't install everything at once
- **Customize after installing** — skills are templates, not sacred texts
- **Track what works** — note skill performance in PATTERNS.md
- **Skills should be specific** — "research a company" is a skill; "do business" is not
- **Same-day application rule** — only create skills for workflows you'll use immediately
