---
name: nightly-self-review
description: >
  Dual-model adversarial self-review that audits the assistant's performance from the past 24 hours.
  Two independent AI reviewers (different models) grade rule adherence, find missed tasks, detect
  patterns, and fix what they can. Reviews compound over time via carryover tracking and escalation.
  Use when: user says "run self-review", "audit yourself", "nightly review", or via cron at 1am daily.
  NOT for: real-time debugging, config changes, or skill installation.
argument-hint: "[--dry-run] [--model-a opus] [--model-b codex] [--days 1]"
allowed-tools:
  - read
  - write
  - edit
  - exec
  - sessions_spawn
  - sessions_yield
  - cron
  - memory_search
version: "1.0.0"
---

# Nightly Self-Review

Dual-model adversarial audit of assistant performance. Two independent reviewers grade the last 24h, then findings are merged, fixes applied, and unresolved items tracked with escalation pressure.

**Compatible with:** OpenClaw, Claude Code, Codex CLI, and any skill-aware coding agent.

## How It Works

Every run spawns two independent reviewers using different models. Each reads the same inputs (memory files, SOUL.md rules, prior reviews) and produces an independent audit. A synthesis phase merges findings, resolves disagreements, and implements safe fixes.

Cross-model review catches blind spots a single model would miss.

## Security & Safety

```
WRITE SCOPE LOCK (non-negotiable):
- Only write under: {workspace}/reviews/, {workspace}/SOUL.md, {workspace}/PATTERNS-ARCHIVE.md
- NEVER write to: ~/.openclaw/skills/, ~/.openclaw/*, ~/.nvm/*, or any path outside workspace
- DO NOT create/update/install skills during review
- Never execute destructive commands
- Never expose secrets/tokens in output
- If a fix requires out-of-scope writes → mark BLOCKED with reason + path
```

## Phases

### Phase 1 — Parallel Independent Reviews

Spawn two reviewers via `sessions_spawn` (mode: run), each with a **different model**:

- **Reviewer A** (primary model, e.g., opus): writes `reviews/reviewer-a-audit-YYYY-MM-DD.md`
- **Reviewer B** (secondary model, e.g., codex): writes `reviews/reviewer-b-audit-YYYY-MM-DD.md`

Each reviewer reads:
1. Last 24h of memory files (`memory/YYYY-MM-DD.md`)
2. SOUL.md active rules
3. Previous night's merged review (for carryover tracking)

Each reviewer audits these dimensions:

| Dimension | What to Check |
|---|---|
| A. Active Rule Adherence | Grade each SOUL.md rule PASS/WARN/FAIL with evidence |
| B. Missed Tasks | Things the user asked for that weren't completed |
| C. Carryover Items | Items from prior reviews still unresolved (track consecutive misses) |
| D. Memory Gaps | Important facts/decisions not written to memory |
| E. Cron Health | Run `cron list`, flag any jobs in error state |
| F. Security | Secrets in logs, permissions issues, exposed credentials |
| G. Pattern Detection | Recurring failures suggesting a skill or process fix |
| H. Recommended Fixes | Specific, actionable items with file paths |

Wait for both completions before proceeding.

### Phase 2 — Synthesis + Bounded Implementation

1. Read both audit files
2. Write merged review: `reviews/YYYY-MM-DD.md`
   - **Consensus**: where both agree (high confidence)
   - **Disagreements**: where they differ (needs human judgment)
   - **Active Rule Scorecard**: each rule with PASS/WARN/FAIL
   - **Health Score**: 1-10, track trend vs prior reviews
3. Implement P0/P1 fixes that are **within write scope**
4. Out-of-scope fixes → mark BLOCKED with reason + path + next-check timestamp
5. Rule rotation: if a rule hasn't been violated in 2+ weeks, swap for a more relevant one
   - Update SOUL.md active rules
   - Archive old rule text to PATTERNS-ARCHIVE.md
6. Append `## Fixes Applied` and `## Blocked` sections

### Phase 3 — Skill Candidates (Propose Only)

If recurring multi-step failure detected (3+ times across reviews):
- Add section: `## Skill Candidates (Approval Required)`
- For each: name, evidence of recurrence, trigger phrase, required tools, risk notes
- Write machine-readable: `reviews/skill-candidates-YYYY-MM-DD.json`
- **DO NOT write any SKILL.md files**

### Phase 4 — Verify

Re-read the final merged review. Every item must be:
- ✅ Fixed (with evidence)
- BLOCKED (with reason + path)
- Deferred (with justification)

No unchecked items allowed.

## Cron Setup

```
Schedule: 0 1 * * * (1am daily, local timezone)
Session: isolated
Model: opus (orchestrator)
Timeout: 900s
Delivery: none (morning digest surfaces findings)
```

The orchestrator (opus) spawns both reviewers. Use different models for each:
- Reviewer A: `anthropic/claude-opus-4-6`
- Reviewer B: `openai-codex/gpt-5.4-pro` (or `anthropic/claude-sonnet-4-6`)

## Gotchas

- **Same model = blind spots**: Always use two *different* models. Same model reviewing itself misses the same things twice.
- **Write scope is the safety rail**: Without it, the review can accidentally break config, install bad skills, or corrupt memory.
- **Carryover escalation**: Items unresolved 3+ consecutive nights get flagged harder. This creates real accountability.
- **Morning digest integration**: Set delivery to "none" — the morning digest cron should read `reviews/YYYY-MM-DD.md` and surface uncompleted items.
- **Cost**: ~30-90k tokens/run depending on models and workspace size. ~$0.50-2.00/night at opus pricing.
- **Reviews compound**: Week 1 finds obvious gaps. Week 2+ carryover tracking kicks in. Month 2+ it's self-correcting.

## Evolution Timeline

- **Week 1**: Broad findings, obvious gaps
- **Week 2**: Carryover tracking creates pressure on chronic issues
- **Week 3**: Pattern detection starts proposing skills
- **Month 2+**: Self-correcting loop — catches failures before the user notices

## Output Files

| File | Purpose |
|---|---|
| `reviews/reviewer-a-audit-YYYY-MM-DD.md` | Primary model's independent audit |
| `reviews/reviewer-b-audit-YYYY-MM-DD.md` | Secondary model's independent audit |
| `reviews/YYYY-MM-DD.md` | Merged final review (consensus + scorecard) |
| `reviews/skill-candidates-YYYY-MM-DD.json` | Machine-readable skill proposals |
