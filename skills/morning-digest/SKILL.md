---
name: morning-digest
description: >
  Generate and send the daily morning digest with weather, calendar, open threads,
  and system status. Use when current time is in the morning window and no digest
  has been sent today.
  Don't use when digest already sent today or outside the morning window.
---

# Morning Digest

## When to Use
- Current time is in the morning window (e.g., 6-9 AM local time)
- No digest has been sent today
- User requests morning briefing

## Implementation

Compile and send the following sections:

### ☀️ Weather
- Local forecast (high/low, conditions)
- Use weather skill or wttr.in

### 📅 Calendar (next 2 days)
- Pull from Google Calendar (all accounts)
- Emphasize TODAY's events first
- Then tomorrow's events

### 📋 Open Threads
- Read `pending-threads.json`
- Surface threads older than 48 hours
- Suggest follow-up actions

### 🔍 Action Items from Last Review
- Read last night's self-review (if exists)
- Surface uncompleted items (⬜)
- These represent yesterday's carryover that needs fixing TODAY

### 🔧 System Status
- Channel status (any disconnects or errors)
- Cron job health
- Any system alerts worth flagging

### 📰 News & Updates (optional)
- Top headlines in areas of interest
- Keep brief — 3-5 items max

## Format
- Clean sections with emoji headers
- Concise bullets — not paragraphs
- Actionable items should be clearly marked

## Rules
1. **Every item must be actionable or informational** — no filler
2. **Hyperlinks on every external reference** — items without links are useless on mobile
3. **Keep it scannable** — the user should get the full picture in 30 seconds
4. **Don't repeat info the user already knows** — check if they were online recently

## Post-Send
Consider pinning the digest message if your channel supports it.
