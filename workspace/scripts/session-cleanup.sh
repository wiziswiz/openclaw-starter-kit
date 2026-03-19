#!/bin/bash
# OpenClaw Session Cleanup
# Removes old cron/sub-agent session files that accumulate over time.
# Without this, sessions.json grows indefinitely and can slow down your agent
# or cause OOM crashes under heavy cron usage.
#
# Keeps: main session + any session modified within the last 48 hours.
# Safe to run anytime — it won't touch active sessions.

set -euo pipefail

SESSIONS_DIR="$HOME/.openclaw/agents/main/sessions"
SESSIONS_JSON="$SESSIONS_DIR/sessions.json"
MAX_AGE_MINUTES="${1:-2880}"  # Default: 48 hours (2880 min). Pass custom value as $1.

# Safety check
if [ ! -f "$SESSIONS_JSON" ]; then
    echo "ERROR: sessions.json not found at $SESSIONS_JSON"
    exit 1
fi

# Get main session ID (never delete this)
MAIN_ID=$(python3 -c "
import json
with open('$SESSIONS_JSON') as f:
    data = json.load(f)
print(data.get('agent:main:main', {}).get('sessionId', ''))
")

if [ -z "$MAIN_ID" ]; then
    echo "ERROR: Could not find main session ID"
    exit 1
fi

echo "Main session: $MAIN_ID (protected)"

# Count before
BEFORE=$(find "$SESSIONS_DIR" -name "*.jsonl" | wc -l | tr -d ' ')
SIZE_BEFORE=$(du -sh "$SESSIONS_DIR" | cut -f1)

# Delete old .jsonl files, except main session
DELETED=0
while IFS= read -r f; do
    [ -f "$f" ] || continue
    basename=$(basename "$f")
    [ "$basename" = "${MAIN_ID}.jsonl" ] && continue
    rm "$f"
    DELETED=$((DELETED + 1))
done < <(find "$SESSIONS_DIR" -name "*.jsonl" -mmin +"$MAX_AGE_MINUTES")

# Rebuild sessions.json — remove entries whose .jsonl files no longer exist
python3 -c "
import json, os

sessions_dir = '$SESSIONS_DIR'
with open('$SESSIONS_JSON') as f:
    data = json.load(f)

cleaned = {}
removed = 0
for key, val in data.items():
    if not isinstance(val, dict):
        cleaned[key] = val
        continue
    sid = val.get('sessionId', '')
    jsonl = os.path.join(sessions_dir, f'{sid}.jsonl') if sid else ''
    if not sid or os.path.exists(jsonl) or key == 'agent:main:main':
        cleaned[key] = val
    else:
        removed += 1

with open('$SESSIONS_JSON', 'w') as f:
    json.dump(cleaned, f)

print(f'Removed {removed} orphaned entries from sessions.json')
"

AFTER=$(find "$SESSIONS_DIR" -name "*.jsonl" | wc -l | tr -d ' ')
SIZE_AFTER=$(du -sh "$SESSIONS_DIR" | cut -f1)

echo "Files: $BEFORE → $AFTER (deleted $DELETED)"
echo "Size: $SIZE_BEFORE → $SIZE_AFTER"
