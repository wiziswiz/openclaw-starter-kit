---
name: x-research
description: >
  Natural language X/Twitter research via bird CLI for searching, analyzing profiles, 
  threads, and sorting by engagement with time filtering.
  
  Use when:
  - User asks "search x for", "what's happening on twitter", "check twitter for"
  - Need real-time social sentiment about topics, projects, or events
  - User wants to see what specific accounts are tweeting about
  - Research crypto discourse, tech discussions, or breaking news on X
  - Need to follow conversation threads or analyze engagement patterns
  - User mentions "bird cli" or wants non-API X research

  Don't use when:
  - Need to post tweets, like, retweet, or manage X accounts (read-only skill)
  - User wants comprehensive web search beyond X/Twitter
  - Looking for historical data beyond what bird CLI can access
  - Need academic sources or formal documentation
  - Rate limits are hit or bird authentication fails
  
  Inputs: Natural language queries, usernames, tweet URLs, time filters
  Outputs: Engagement-sorted tweets with metadata, threads, user profiles
  Success: Relevant, high-engagement tweets answering the research question

metadata: {"openclaw":{"emoji":"🔍","requires":{"bins":["bird"]}}}
---

# x-research 🔍

X/Twitter research skill. Ask natural language questions about what's happening on X and get sourced, engagement-sorted results.

## How it works

Translate natural language queries into `bird` CLI commands. Always use the `~/bin/bird-auth` wrapper (has auth tokens baked in).

## Query Translation Rules

When the user asks about Twitter/X, translate their intent:

### Search
```bash
# Basic search
~/bin/bird-auth search "query" -n 20 --json

# From a specific user
~/bin/bird-auth search "from:username query" -n 20 --json

# Exclude retweets (cleaner results)
~/bin/bird-auth search "query -is:retweet" -n 20 --json

# Multiple terms
~/bin/bird-auth search "(term1 OR term2) -is:retweet" -n 20 --json

# Minimum engagement (filter post-hoc from JSON)
~/bin/bird-auth search "query" -n 50 --json | jq '[.[] | select(.likeCount > 10)]'
```

### Time Filtering
bird search uses Twitter's search operators for time:
```bash
# Last 24 hours: use "since:" operator with yesterday's date
~/bin/bird-auth search "query since:2026-02-07" -n 20 --json

# Last hour: use "since:" with specific datetime
~/bin/bird-auth search "query since:2026-02-08_12:00:00_UTC" -n 20 --json

# Date range
~/bin/bird-auth search "query since:2026-02-01 until:2026-02-08" -n 20 --json
```

### Profile / User Tweets
```bash
~/bin/bird-auth user-tweets @username -n 20 --json
```

### Read a Specific Tweet
```bash
~/bin/bird-auth read <url-or-id> --json
```

### Full Thread
```bash
~/bin/bird-auth thread <url-or-id> --json
```

### Replies to a Tweet
```bash
~/bin/bird-auth replies <url-or-id> -n 20 --json
```

### Trending / News
```bash
~/bin/bird-auth news -n 10 --json
~/bin/bird-auth news --ai-only  # AI-curated only
```

### Lists
```bash
~/bin/bird-auth lists --json
~/bin/bird-auth list-timeline <list-id> -n 20 --json
```

## Post-Processing

After getting JSON results, always:

1. **Sort by engagement** — sort by `likeCount` descending unless user asks otherwise
2. **Filter noise** — remove tweets with 0 likes unless specifically requested
3. **Format for Telegram** — use markdown with clickable links:
   ```
   1. [@username](https://x.com/username/status/ID) — 🔥 1.2K likes
   > Tweet text here (truncated to ~200 chars)
   ```
4. **Include metadata** — show total results found, time range, query used
5. **Link everything** — every @mention and tweet should be a clickable URL

## Research Loop (for complex queries)

For questions like "what's CT saying about X?" or "summarize the discourse on Y":

1. **Decompose** — break into 2-3 search queries (different angles/keywords)
2. **Search** — run each query with `bird search`
3. **Deduplicate** — remove duplicate tweet IDs
4. **Sort** — by engagement (likes)
5. **Synthesize** — summarize the key narratives, link to top tweets
6. **Source** — every claim must link to a tweet

## Example Outputs

**User:** "what are people saying about ETH staking?"
```
🔍 X Research: "ETH staking" (last 7 days, sorted by engagement)

1. [@elonmusk](https://x.com/elonmusk/status/123) — 🔥 2.1K likes
   > $ETH staking yields looking solid after the merge, good entry point...

2. [@VitalikButerin](https://x.com/VitalikButerin/status/456) — 🔥 890 likes
   > Project ecosystem growing, strong fundamentals...

📊 Found 47 results | Top 10 shown | Query: "ETH staking -is:retweet"
```

## Important Notes

- **Read-only** — never post, like, retweet, or follow via this skill
- **Rate limits** — bird uses cookie auth, so respect Twitter's rate limits. Max ~50 results per query.
- **Cookie auth** — if bird fails with auth errors, cookies may need refresh (check ~/bin/bird-auth)
- **No API cost** — this uses cookie auth, not the paid X API
