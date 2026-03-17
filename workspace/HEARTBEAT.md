# HEARTBEAT.md

## Time-Aware Routing

Heartbeat behavior changes based on current time:

- **Morning (6-9 AM)**: Digest mode — calendar, threads, priorities
- **30 min before calendar events**: Auto-research mode
- **Evening (6-9 PM)**: Thread cleanup + follow-up drafting
- **Late night (12-6 AM)**: Maintenance + builds mode
- **Other times**: Standard proactive analysis

## Tasks

### 1. System Health + Cron Status
- Check `openclaw cron list` for any job with `status=error`
- If ANY cron is in error state: alert immediately with job name + how long it's been failing
- Check for available OpenClaw updates: `npm outdated -g openclaw`

### 2. Open Thread Tracker
- Read `pending-threads.json`
- Surface any threads with status "open" older than 48 hours
- Suggest follow-up action for each stale thread
- During conversations: when the user asks someone something or is waiting on a response, ADD it to pending-threads.json immediately

### 3. Calendar Awareness
- Check upcoming calendar events in the next 4 hours
- For any meeting with an unknown participant/company: trigger research
- Pre-research without delivery is wasted — set a trigger to push findings before the meeting

### 4. Auto-Skill Detection
- During normal work: if you notice the same multi-step task 3+ times, create a skill for it
- On heartbeat: review last 24h of work patterns. If a new skill candidate emerges, create it and mention it briefly.

### 4b. Calendar Nudge for Stale Threads
- Run `scripts/calendar-nudge.sh` to find pending threads 24h+ old needing owner input
- For each candidate: create a 5-min calendar event
  - Title: "Agent needs input: [thread subject]"
  - Time: next available slot during working hours
  - Description: thread context + what's needed to unblock
- After creating event, mark `calendarNudge: true` on the thread in pending-threads.json
- Max 2 nudges per heartbeat (don't spam the calendar)
- Skip threads in deferred/resolved/waiting-response status

### 5. Fact Extraction
- Review recent conversations for durable facts about entities (people, companies, projects)
- Write new facts to `life/areas/[type]/[name]/items.json`
- Skip casual chat and already-known info

### 6. Morning Digest (morning window only)
Compile and send:
- Open threads summary (from pending-threads.json)
- Calendar events for today and tomorrow
- Weather forecast
- Any overnight system alerts
- Uncompleted action items from last review

---

## Behavioral Rules

- **STOP defaulting to HEARTBEAT_OK.** Actually analyze. Only say HEARTBEAT_OK if every check returns nothing actionable.
- Only report items that are truly new or changed.
- Keep alerts concise — flag + suggested action, not essays.
- **Evening cleanup must produce at least ONE artifact.** A draft, a research file, a status update — something tangible.
- **Quiet time ≠ do-nothing time.** When the user is offline, that's the best time for internal work: thread cleanup, draft follow-ups, pre-research.
