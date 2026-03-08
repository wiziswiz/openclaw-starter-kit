#!/bin/bash
# xr — Quick X/Twitter research CLI
# Usage: xr "query" [options]
# Options:
#   -n COUNT    Number of results (default: 15)
#   -s SORT     Sort by: likes|retweets|recent (default: likes)
#   -t TIME     Time filter: 1h|3h|12h|1d|7d (default: 7d)
#   -m MIN      Minimum likes to show (default: 0)
#   --from USER Search from specific user
#   --profile   Get user's recent tweets instead of search
#   --thread ID Show full thread
#   --raw       Output raw JSON

BIRD="$HOME/bin/bird-auth"
COUNT=15
SORT="likes"
TIME=""
MIN_LIKES=0
FROM=""
PROFILE=""
THREAD=""
RAW=false
QUERY=""

# Parse args
while [[ $# -gt 0 ]]; do
    case $1 in
        -n) COUNT="$2"; shift 2;;
        -s) SORT="$2"; shift 2;;
        -t) TIME="$2"; shift 2;;
        -m) MIN_LIKES="$2"; shift 2;;
        --from) FROM="$2"; shift 2;;
        --profile) PROFILE="$2"; shift 2;;
        --thread) THREAD="$2"; shift 2;;
        --raw) RAW=true; shift;;
        *) QUERY="$1"; shift;;
    esac
done

# Handle thread mode
if [ -n "$THREAD" ]; then
    $BIRD thread "$THREAD" --json 2>/dev/null
    exit $?
fi

# Handle profile mode
if [ -n "$PROFILE" ]; then
    RESULTS=$($BIRD user-tweets "@$PROFILE" -n "$COUNT" --json 2>/dev/null)
    if [ "$RAW" = true ]; then
        echo "$RESULTS"
        exit 0
    fi
    echo "$RESULTS" | jq -r --arg min "$MIN_LIKES" '
        [.[] | select(.likeCount >= ($min | tonumber))]
        | sort_by(-.likeCount)
        | to_entries[]
        | "\(.key + 1). @\(.value.author.username) — ❤️ \(.value.likeCount) | 🔁 \(.value.retweetCount)\n   \(.value.text | gsub("\n"; " ") | .[0:200])\n   🔗 https://x.com/\(.value.author.username)/status/\(.value.id)\n"'
    exit 0
fi

# Build search query
if [ -z "$QUERY" ]; then
    echo "Usage: xr \"query\" [-n count] [-s likes|retweets|recent] [-t 1h|3h|12h|1d|7d] [-m min_likes]"
    echo "       xr --profile username [-n count]"
    echo "       xr --thread tweet_url_or_id"
    exit 1
fi

SEARCH_QUERY="$QUERY -is:retweet"

# Add from: filter
if [ -n "$FROM" ]; then
    SEARCH_QUERY="from:$FROM $QUERY"
fi

# Add time filter
if [ -n "$TIME" ]; then
    case $TIME in
        1h)  SINCE=$(date -u -v-1H '+%Y-%m-%d_%H:%M:%S_UTC' 2>/dev/null || date -u -d '1 hour ago' '+%Y-%m-%d_%H:%M:%S_UTC');;
        3h)  SINCE=$(date -u -v-3H '+%Y-%m-%d_%H:%M:%S_UTC' 2>/dev/null || date -u -d '3 hours ago' '+%Y-%m-%d_%H:%M:%S_UTC');;
        12h) SINCE=$(date -u -v-12H '+%Y-%m-%d_%H:%M:%S_UTC' 2>/dev/null || date -u -d '12 hours ago' '+%Y-%m-%d_%H:%M:%S_UTC');;
        1d)  SINCE=$(date -u -v-1d '+%Y-%m-%d' 2>/dev/null || date -u -d '1 day ago' '+%Y-%m-%d');;
        7d)  SINCE=$(date -u -v-7d '+%Y-%m-%d' 2>/dev/null || date -u -d '7 days ago' '+%Y-%m-%d');;
        *)   SINCE="$TIME";;
    esac
    SEARCH_QUERY="$SEARCH_QUERY since:$SINCE"
fi

# Fetch more than needed so we can filter/sort
FETCH_COUNT=$((COUNT * 3))
if [ $FETCH_COUNT -gt 50 ]; then FETCH_COUNT=50; fi

RESULTS=$($BIRD search "$SEARCH_QUERY" -n "$FETCH_COUNT" --json 2>/dev/null)

if [ "$RAW" = true ]; then
    echo "$RESULTS"
    exit 0
fi

# Sort and format
SORT_FIELD=".likeCount"
case $SORT in
    retweets) SORT_FIELD=".retweetCount";;
    recent)   SORT_FIELD=".createdAt";;
    *)        SORT_FIELD=".likeCount";;
esac

TOTAL=$(echo "$RESULTS" | jq 'length' 2>/dev/null)

echo ""
echo "🔍 X Research: \"$QUERY\" | Sort: $SORT | Results: ${TOTAL:-0}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "$RESULTS" | jq -r --arg min "$MIN_LIKES" --arg count "$COUNT" --arg sf "$SORT_FIELD" '
    [.[] | select(.likeCount >= ($min | tonumber))]
    | sort_by(-(.likeCount // 0))
    | .[0:($count | tonumber)]
    | to_entries[]
    | "\(.key + 1). @\(.value.author.username // "unknown") — ❤️ \(.value.likeCount // 0) | 🔁 \(.value.retweetCount // 0) | 💬 \(.value.replyCount // 0)\n   \(.value.text | gsub("\n"; " ") | .[0:200])\n   🔗 https://x.com/\(.value.author.username // "unknown")/status/\(.value.id)\n"'
