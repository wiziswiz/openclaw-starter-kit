# Health & Wellness Tracking Skill

Track recovery, sleep, and fitness metrics from wearables (WHOOP, Oura, Apple Health, Garmin, Fitbit) and surface actionable insights in your morning digest.

## What This Does

Your agent can pull health data and weave it into your daily workflow:
- **Morning recovery score** → adjust your day's intensity
- **Sleep quality trends** → spot patterns (late screens, alcohol, travel)
- **Workout tracking** → log sessions, track consistency streaks
- **Travel/illness monitoring** → flag when recovery dips during stressful periods

## Setup

### Option 1: WHOOP API
```bash
# Store your WHOOP credentials
mkdir -p ~/.openclaw/credentials
echo "YOUR_WHOOP_API_TOKEN" > ~/.openclaw/credentials/whoop-token

# WHOOP API endpoints:
# GET https://api.prod.whoop.com/developer/v1/activity/sleep
# GET https://api.prod.whoop.com/developer/v1/recovery
# GET https://api.prod.whoop.com/developer/v1/cycle
```

### Option 2: Oura Ring API
```bash
echo "YOUR_OURA_TOKEN" > ~/.openclaw/credentials/oura-token

# Oura API endpoints:
# GET https://api.ouraring.com/v2/usercollection/daily_readiness
# GET https://api.ouraring.com/v2/usercollection/daily_sleep
```

### Option 3: Apple Health (via shortcuts)
```bash
# Use iOS Shortcuts to export daily health summary to a file
# Your agent reads the file each morning
# Example: ~/health/daily-export.json
```

### Option 4: Manual Logging
No wearable? Your agent can ask you each morning:
- "How'd you sleep? (1-5)"
- "Energy level? (1-5)"
- "Any symptoms?"

Add to your HEARTBEAT.md to enable the daily check-in.

## Integration with Morning Digest

Add this to your `morning-digest` skill or HEARTBEAT.md:

```markdown
### Health Check
- Pull latest recovery/sleep score from wearable API
- Compare to 7-day average — flag if significantly below baseline
- During travel or illness: surface health data prominently
- Skip health section on days with no data (e.g., device not worn)
```

## Patterns to Add to PATTERNS.md

```markdown
## Health Data Timing
- Wearable sleep scores finalize after wake-up — pull AFTER your usual wake time
- Don't surface incomplete/in-progress sleep data in early morning digests
- If device wasn't worn (religious observance, forgot, charging), skip gracefully — don't flag as "missing"

## Recovery-Based Scheduling
- Green recovery (67%+): full intensity day, schedule hard tasks
- Yellow recovery (34-66%): moderate day, avoid back-to-back intense work
- Red recovery (<34%): light day, prioritize rest and recovery
```

## Example Cron: Daily Health Summary

```json
{
  "name": "daily-health-summary",
  "schedule": { "kind": "cron", "expr": "30 7 * * *", "tz": "America/Los_Angeles" },
  "payload": {
    "kind": "agentTurn",
    "message": "Pull my latest health/recovery data from my wearable. Compare to my 7-day baseline. Include in a brief health status line. If recovery is below 50%, suggest a lighter day."
  },
  "sessionTarget": "isolated"
}
```

## Privacy Notes

- Health data stays local — stored in your agent's memory files, never sent to third parties
- Credentials stored in `~/.openclaw/credentials/` (gitignored)
- Your agent summarizes trends, it doesn't store raw biometric data
