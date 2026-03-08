# Example PATTERNS.md — Tacit Knowledge

This is an example of what a well-developed PATTERNS.md looks like after a few weeks of use.

---

# Tacit Knowledge — Durable Patterns & Lessons

Updated: 2024-03-15

## Communication Preferences
- Prefers bullet points over paragraphs — never send wall-of-text messages
- Blank line before and after every header in formatted messages
- Max 3 bullets per section before a visual break
- One topic per message when possible
- Links must be clickable — raw URLs are acceptable as fallback

## Work Patterns
- Active until ~1 AM during deep work sessions — don't suggest breaks
- Morning = planning and review, afternoon = execution
- Quiet periods (no messages for 2+ hours) = deep focus, not AFK
- Values autonomous work during offline hours — proactive builds appreciated

## Tool Preferences
- Always read a file before editing it — exact text match required for edits
- Check ~/Projects/ before building ad-hoc solutions — tools may already exist
- Search broadly with `find` and `grep` before guessing paths
- Pin exact package versions, never use "latest"

## Debugging Discipline
- Stay scoped to the active system — don't mention unrelated systems when debugging
- Check skill docs FIRST before ad-hoc debugging
- Root cause first: isolate the problem before changing anything
- "Adjacent optimization" is a trap — fix the bug, ship it, then propose improvements separately
- Escalate after 3 retries on rate-limited APIs

## Decision Patterns
- Benchmark before implementing — run evaluation first, present findings, get approval
- Lean version first — present the optimized approach, expand if asked
- Research before building — look for existing solutions in the workspace
- Efficiency > thoroughness — fast and right beats slow and comprehensive
- Empirical proof > assumption — testing to confirm is always valued

## Credential & Security Handling
- Never use cached/memorized API keys — always read from source at invocation time
- Don't ask permission to investigate security alerts — investigate first, present findings
- Test config changes on ONE system before batch rollout

## Deployment Discipline
- Always verify cron jobs after OpenClaw updates — model names and config formats can change
- Read changelogs before updating — breaking changes happen
- Service bounce required after config file edits — running processes don't pick up changes

## Lessons Learned
- 2024-01-15: Edit tool requires exact match — one read call saves 3 failed edit attempts
- 2024-01-20: Creating prep files ≠ successful delivery — user-facing delivery is the only measure
- 2024-02-01: Tool creation without integration is waste — same-day application rule
- 2024-02-10: Short user messages reference the IMMEDIATE prior topic — don't fill gaps with guesses
- 2024-02-15: Conversation recency > memory salience — what was said 2 min ago matters most
