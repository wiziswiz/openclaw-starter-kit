#!/bin/bash
# calendar-nudge.sh — Check pending-threads.json for stale threads needing wiz input
# Outputs JSON array of threads that need calendar nudges (24h+ open, no nudge yet)
# Called by heartbeat flow; calendar creation handled by Clawd via calendar_create tool

THREADS_FILE="$HOME/clawd/pending-threads.json"

if [ ! -f "$THREADS_FILE" ]; then
  echo "[]"
  exit 0
fi

python3 -c "
import json, sys
from datetime import datetime, timedelta, timezone

now = datetime.now(timezone.utc)
cutoff = now - timedelta(hours=24)

threads = json.load(open('$THREADS_FILE'))
nudge_candidates = []

for t in threads:
    # Only open/waiting threads
    if t.get('status') not in ('open', 'waiting-response'):
        continue
    # Skip if already nudged
    if t.get('calendarNudge'):
        continue
    # Check age
    opened = t.get('opened', '')
    if not opened:
        continue
    try:
        opened_dt = datetime.fromisoformat(opened).replace(tzinfo=timezone.utc)
    except:
        continue
    if opened_dt < cutoff:
        nudge_candidates.append({
            'id': t['id'],
            'subject': t.get('subject', ''),
            'contact': t.get('contact', ''),
            'opened': opened,
            'days_open': (now - opened_dt).days
        })

print(json.dumps(nudge_candidates, indent=2))
"
