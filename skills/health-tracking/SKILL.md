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

## Illness Early Warning

Your agent can cross-reference multiple biomarkers to detect illness **before you feel symptoms** — often 1-2 days early.

### How It Works

The illness detector compares your current metrics against a 14-day rolling baseline:

| Signal | Threshold | What it means |
|--------|-----------|---------------|
| RHR spike | >5bpm above baseline | Heart working harder (immune response) |
| HRV crash | >20% below baseline | Autonomic stress / inflammation |
| SpO2 dip | Below 95% | Possible respiratory issue |
| Respiratory rate | >0.5 breaths/min above avg | Body compensating |
| Multi-day decline | 2+ days of recovery drops | Sustained stress, not just a bad night |

**Risk levels:**
- **1 signal** → Low (subtle note: "keep an eye on it")
- **2 signals** → Moderate (alert: "you might be coming down with something")
- **3+ signals** → High (urgent: "cancel non-essential meetings, rest")
- **Consecutive days** compound the risk — 2 "low" days in a row → moderate

### Example Script

```bash
#!/bin/bash
# whoop-illness-check.sh — compare current metrics to 14-day baseline
# Outputs JSON: {"illness_risk": "none|low|moderate|high", "signals": N, "details": "..."}

# Fetch 14 days of recovery data from your wearable API
# Extract: RHR, HRV, SpO2, respiratory rate, recovery score

# Calculate baselines (exclude today)
# Compare current day vs baseline
# Count triggered signals
# Track consecutive elevated days in a state file

# Risk escalation:
#   1 signal = low
#   2 signals = moderate  
#   3+ signals = high
#   2+ consecutive "low" days = upgrade to moderate
#   3+ consecutive "moderate" days = upgrade to high
```

See a full reference implementation in the WHOOP section above. Adapt the API calls for your specific wearable (Oura, Garmin, Apple Health export, etc.).

### Illness Detection Cron

```json
{
  "name": "illness-early-warning",
  "schedule": { "kind": "cron", "expr": "45 7 * * 0-5", "tz": "America/Los_Angeles" },
  "payload": {
    "kind": "agentTurn",
    "message": "Run the illness detection script. Parse output JSON. If illness_risk is 'none', stay silent. If 'low', send a subtle note. If 'moderate', send a health watch alert with specific biomarker details. If 'high', send an urgent alert recommending rest and doctor visit."
  },
  "sessionTarget": "isolated"
}
```

> 💡 **Pair with the sleep score cron** — run illness check right after sleep data is scored, so you get one combined health briefing each morning.

> ⚠️ **Not a medical device.** This catches patterns, not diagnoses. Always consult a doctor for real symptoms.

## Privacy Notes

- Health data stays local — stored in your agent's memory files, never sent to third parties
- Credentials stored in `~/.openclaw/credentials/` (gitignored)
- Your agent summarizes trends, it doesn't store raw biometric data
