# Post-Update Health Check Skill

Run after every OpenClaw update to catch regressions before they impact scheduled jobs.

## Trigger
- Immediately after any `gateway update.run` or `npm i -g openclaw` completes

## Steps

### 1. Verify Cron Jobs
```
cron list → for each job:
  - Check model field: does it use a bare model name? (no provider prefix)
  - Check last run status: any recent errors?
  - If model uses provider prefix format (e.g., "anthropic/X"), fix to bare name
```

### 2. Test One Cron
- Pick a LOW-STAKES cron (e.g., a data sync job, NOT self-review or morning digest)
- Trigger with `cron run`
- Wait for completion (check `cron runs`)
- Verify status: "ok"

### 3. Check Config Compatibility
```
gateway config.get → verify:
  - All model names still resolve
  - No deprecated config keys warned in gateway logs
  - Fallback model chain still valid
```

### 4. Verify Changelog for Breaking Changes
```
cat $(npm root -g)/openclaw/CHANGELOG.md | head -100
```
Look for: model renames, config format changes, deprecated features, cron behavior changes.

### 5. Report
Push a Telegram message: "✅ Post-update health check passed — [version]. Tested [cron name], all clear."
Or: "⚠️ Post-update issues found: [list]. Fixing now."

## Key Lessons
- Cron model overrides use BARE names (no provider prefix): `claude-opus-4-6` not `anthropic/claude-opus-4-6`
- `"default"` as model value does NOT work in crons — gets interpreted as `anthropic/default`
- Always test before batch-applying model changes
