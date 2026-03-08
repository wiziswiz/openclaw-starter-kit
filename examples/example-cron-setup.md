# How to Set Up Crons in OpenClaw

This guide shows how to set up each recommended cron job using OpenClaw's CLI.

## Prerequisites

Make sure OpenClaw is installed and the gateway is running:

```bash
openclaw gateway status
# If not running:
openclaw gateway start
```

## Setting Up Crons

### Morning Digest (7:30 AM daily)

```bash
openclaw cron add \
  --name "morning-digest" \
  --schedule "30 7 * * *" \
  --task "Run morning-digest skill. Compile weather, calendar (next 2 days), open threads from pending-threads.json, uncompleted review items, and system status. Send as formatted digest."
```

### Nightly Self-Review (1:00 AM daily)

```bash
openclaw cron add \
  --name "nightly-self-review" \
  --schedule "0 1 * * *" \
  --task "Review today's memory file, pending-threads.json, and any open action items. Write a structured review to reviews/YYYY-MM-DD.md with completed items and recommendations for tomorrow."
```

### Config Watchdog (every 6 hours)

```bash
openclaw cron add \
  --name "config-watchdog" \
  --schedule "0 */6 * * *" \
  --task "Run openclaw cron list and check for error states. Verify gateway health. Check for available OpenClaw updates. Alert if anything is wrong."
```

### Git Backup (2:00 AM daily)

```bash
openclaw cron add \
  --name "git-backup" \
  --schedule "0 2 * * *" \
  --task "cd ~/clawd && git add -A && git diff --cached --quiet || git commit -m 'Auto-backup' && git push origin main 2>/dev/null || true"
```

### Meeting Prep (every 15 minutes)

```bash
openclaw cron add \
  --name "meeting-prep" \
  --schedule "*/15 * * * *" \
  --task "Check calendar for events in the next 30 minutes. For any meeting with unknown participants, run company-research skill and deliver findings before the meeting."
```

### Weekly Synthesis (Sunday 8 PM)

```bash
openclaw cron add \
  --name "weekly-synthesis" \
  --schedule "0 20 * * 0" \
  --task "Review this week's memory files. Rewrite entity summaries. Identify patterns for PATTERNS.md. Surface threads open >7 days. Write synthesis to reviews/weekly-YYYY-MM-DD.md."
```

### Thread Cleanup (6 PM daily)

```bash
openclaw cron add \
  --name "thread-cleanup" \
  --schedule "0 18 * * *" \
  --task "Read pending-threads.json. Draft follow-ups for threads >48h old. Force decision on threads >14 days old. Update lastCheck timestamps."
```

### Fact Extraction (10 PM daily)

```bash
openclaw cron add \
  --name "fact-extraction" \
  --schedule "0 22 * * *" \
  --task "Run fact-extraction skill on today's conversations. Extract durable facts to knowledge graph. Skip casual chat."
```

## Managing Crons

```bash
# List all crons
openclaw cron list

# Check a specific cron's recent runs
openclaw cron runs --name morning-digest

# Manually trigger a cron
openclaw cron run --name morning-digest

# Remove a cron
openclaw cron remove --name config-watchdog
```

## Tips

- **Start with just 2-3 crons** — morning digest, nightly review, and git backup are the highest value
- **Adjust schedules to your timezone** — cron times should match your actual routine
- **Monitor for errors** — check `openclaw cron list` weekly for any failed jobs
- **After OpenClaw updates** — verify crons still work (config formats can change between versions)
- **Model overrides** — if you specify a model for a cron, use bare names (e.g., `claude-sonnet-4-20250514`) without provider prefix
