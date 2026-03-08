# Example HEARTBEAT.md — Different Use Cases

Below are heartbeat configurations for different types of users. Pick the one closest to your workflow and customize.

---

## Developer / Engineer

```markdown
# HEARTBEAT.md

## Time-Aware Routing
- **Morning**: PR review status, CI/CD pipeline health, standup prep
- **Pre-meeting**: Auto-pull relevant PRs, issues, and recent commits
- **Evening**: Code review cleanup, dependency update check
- **Night**: Run test suites, dependency audits, security scans

## Tasks

### 1. CI/CD Health
- Check GitHub Actions for failed workflows
- Surface any PR reviews waiting on you
- Alert on security advisories for dependencies

### 2. PR Tracker
- Read pending-threads.json for open PRs awaiting review
- Surface PRs older than 48 hours without review
- Draft review comments for stale PRs

### 3. Dependency Monitoring
- Weekly: check for outdated dependencies
- Alert on critical security updates
- Track breaking changes in major dependencies

### 4. Standup Prep (morning)
- Summarize yesterday's commits and PRs
- List today's planned work from issues/tickets
- Surface any blockers
```

---

## Founder / Business Development

```markdown
# HEARTBEAT.md

## Time-Aware Routing
- **Morning**: Pipeline status, calendar prep, email highlights
- **Pre-meeting**: Auto-research meeting participants and companies
- **Evening**: Follow-up drafts, thread cleanup
- **Night**: Market research, competitive intelligence

## Tasks

### 1. Pipeline Health
- Check CRM/tracker for stale deals (no activity >5 days)
- Surface follow-ups due today
- Track outreach response rates

### 2. Meeting Prep
- 30 min before any call: research the company and participants
- Check for prior conversations and context
- Prepare talking points and questions

### 3. Email Triage
- Scan inbox for high-priority messages
- Draft responses for routine inquiries
- Flag anything requiring personal attention

### 4. Competitive Intel (weekly)
- Monitor competitor announcements
- Track industry news and trends
- Surface partnership opportunities
```

---

## Researcher / Analyst

```markdown
# HEARTBEAT.md

## Time-Aware Routing
- **Morning**: New papers/articles in tracked topics, citation alerts
- **Pre-deadline**: Progress check on deliverables
- **Evening**: Reading list curation, note synthesis
- **Night**: Data processing, batch analysis

## Tasks

### 1. Topic Monitoring
- Check tracked RSS feeds and journals for new publications
- Surface high-impact papers in your research areas
- Alert on citations of your work

### 2. Note Synthesis
- Weekly: connect recent notes into themes
- Surface contradictions or gaps in knowledge
- Suggest follow-up research directions

### 3. Deadline Tracking
- Monitor upcoming deadlines (submissions, reviews, grants)
- Alert 7 days, 3 days, and 1 day before deadlines
- Check completion status of deliverables

### 4. Data Pipeline Health
- Monitor long-running analysis jobs
- Alert on data quality issues
- Track storage usage and cleanup opportunities
```

---

## Key Principles (All Use Cases)

1. **Never default to HEARTBEAT_OK** — actually analyze before dismissing
2. **Evening cleanup must produce an artifact** — a draft, a file, a status update
3. **Quiet time = productive time** — don't wait for user messages to do useful work
4. **Pre-research without delivery is waste** — always push findings at the right moment
5. **Track stale threads aggressively** — 48h is the threshold, 14 days is the hard limit
