# Cron Guide

Crons turn your agent from reactive (waits for you) to proactive (works while you sleep).

## What Are OpenClaw Crons?

Cron jobs are scheduled tasks that your agent runs automatically. They're how your agent:
- Sends you a morning briefing before you ask
- Backs up its memory every night
- Watches for broken configurations
- Prepares research before your meetings

## Getting Started

### List existing crons
```bash
openclaw cron list
```

### Add a cron
```bash
openclaw cron add \
  --name "job-name" \
  --schedule "30 7 * * *" \
  --task "Description of what the agent should do"
```

### Cron schedule syntax
```
┌───────────── minute (0-59)
│ ┌───────────── hour (0-24)
│ │ ┌───────────── day of month (1-31)
│ │ │ ┌───────────── month (1-12)
│ │ │ │ ┌───────────── day of week (0-7, 0=Sun)
│ │ │ │ │
* * * * *
```

Common patterns:
- `30 7 * * *` — 7:30 AM daily
- `0 */6 * * *` — every 6 hours
- `*/15 * * * *` — every 15 minutes
- `0 20 * * 0` — Sunday at 8 PM
- `0 1 * * 1-5` — 1 AM weekdays only

## Recommended Starter Crons

Start with these three — they provide the most value for the least complexity:

### 1. Morning Digest (high value)
Your daily briefing. Calendar, weather, open threads, action items.
```bash
openclaw cron add --name "morning-digest" --schedule "30 7 * * *" \
  --task "Run morning-digest skill. Send formatted digest with weather, calendar, threads, and action items."
```

### 2. Nightly Self-Review (high value)
Audit what was accomplished today. Produces a review file.
```bash
openclaw cron add --name "nightly-self-review" --schedule "0 1 * * *" \
  --task "Review today's work. Write structured review to reviews/YYYY-MM-DD.md with completed and incomplete items."
```

### 3. Git Backup (essential)
Protect your agent's memory with automatic git commits.
```bash
openclaw cron add --name "git-backup" --schedule "0 2 * * *" \
  --task "Auto-commit workspace changes: git add -A && git commit -m 'Auto-backup' && git push"
```

See `examples/example-cron-setup.md` for the full set of recommended crons.

## Managing Crons

```bash
# Check recent runs
openclaw cron runs --name morning-digest

# Manually trigger a job
openclaw cron run --name morning-digest

# Remove a cron
openclaw cron remove --name config-watchdog
```

## Troubleshooting

### Cron is in error state
1. Check `openclaw cron runs --name <job>` for error details
2. Common cause: model name format. Use bare names (`claude-sonnet-4-20250514`) not provider-prefixed (`anthropic/claude-sonnet-4-20250514`)
3. Try manually running: `openclaw cron run --name <job>`

### Crons broke after update
1. Run `openclaw cron list` — check all jobs
2. Read the changelog for breaking changes
3. Run `post-update-health-check` skill
4. Test one low-stakes cron before trusting the rest

### Cron runs but produces nothing
1. Check the task description — is it specific enough?
2. Verify the skills it references are installed
3. Check gateway logs for errors

## Key Lessons

- **Start small** — 2-3 crons is plenty. Add more as you find gaps.
- **Monitor for errors** — check `openclaw cron list` weekly
- **After updates, verify** — config formats can change between OpenClaw versions
- **Model names are bare** — no provider prefix in cron model overrides
- **Test before batch** — test changes on one cron before updating all of them
