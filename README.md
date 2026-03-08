<p align="center">
  <img src="https://raw.githubusercontent.com/nicepkg/nice-img/master/robot-emoji.png" width="120" alt="🤖" />
</p>

<h1 align="center">OpenClaw Starter Kit</h1>

<p align="center">
  <strong>Turn your AI assistant from a stateless chatbot into a proactive, memory-rich agent that learns your patterns, tracks your work, and gets better every day.</strong>
</p>

<p align="center">
  <a href="#-5-minute-quickstart">Quickstart</a> •
  <a href="#-whats-in-the-box">What's Inside</a> •
  <a href="#-the-memory-system">Memory</a> •
  <a href="#-skills-library">Skills</a> •
  <a href="#-proactive-crons">Crons</a> •
  <a href="#-philosophy">Philosophy</a>
</p>

---

> *This kit distills months of real-world iteration into a ready-to-use workspace. It's opinionated — because the defaults matter more than the options.*

## 🧠 The Problem

Out of the box, AI agents are **goldfish**. Every conversation starts from scratch. They don't remember your preferences, can't track your open threads, won't check on things proactively, and repeat the same mistakes you've already corrected.

This starter kit fixes that with:

- **Three-layer memory** — facts, daily events, and learned patterns that persist across sessions
- **Self-correcting behavior** — corrections you make are permanently stored and loaded every session
- **Proactive analysis** — your agent checks things on its own (system health, stale threads, upcoming meetings)
- **15 pre-built skills** — from GitHub repo analysis to morning digests to Twitter research
- **8 cron job templates** — scheduled tasks that make your agent feel alive

---

## ⚡ 5-Minute Quickstart

```bash
# 1. Clone this repo
git clone https://github.com/wiziswiz/openclaw-starter-kit.git
cd openclaw-starter-kit

# 2. Run the bootstrap script
chmod +x setup.sh
./setup.sh

# 3. Fill in your identity
#    The script will tell you which files to edit

# 4. Start (or restart) OpenClaw
openclaw gateway restart
```

**That's it.** Your agent now has a memory system, proactive heartbeats, thread tracking, and security-audited skill installation.

---

## 📦 What's in the Box

```
openclaw-starter-kit/
│
├── 🏠 workspace/                    ← Your agent's brain
│   ├── AGENTS.md                    # Core rules: memory, search discipline, security
│   ├── SOUL.md                      # Persona + ACTIVE RULES (self-correcting behavior)
│   ├── IDENTITY.md                  # Agent name, personality, vibe
│   ├── USER.md                      # Your name, timezone, preferences
│   ├── HEARTBEAT.md                 # What to check proactively
│   ├── PATTERNS.md                  # Tacit knowledge (grows over time)
│   ├── TOOLS.md                     # Notes about your local tools
│   ├── pending-threads.json         # Open loop tracker
│   ├── memory/                      # Daily event logs
│   └── life/areas/                  # Knowledge graph
│       ├── people/                  #   → Person entities
│       ├── companies/               #   → Company entities
│       └── projects/                #   → Project entities
│
├── 🛠️ skills/                       ← 15 pre-built skills
│   ├── repo-analyzer/               # GitHub repo trust scoring & due diligence
│   ├── spawn-agent/                 # Sub-agent orchestration
│   ├── fact-extraction/             # Memory fact extraction & management
│   ├── morning-digest/              # Daily morning briefing
│   ├── company-research/            # Structured BD research briefs
│   ├── x-research/                  # Twitter/X research & search
│   ├── google/                      # Gmail, Calendar, Drive integration
│   ├── healthcheck/                 # System security hardening
│   ├── post-update-health-check/    # Post-update regression verification
│   ├── baseline-ui/                 # UI quality baseline enforcement
│   ├── fixing-accessibility/        # WCAG accessibility fixes
│   ├── fixing-metadata/             # SEO & Open Graph metadata
│   ├── fixing-motion-performance/   # Animation performance optimization
│   ├── vercel-react-best-practices/ # 57 React/Next.js performance rules
│   └── web-design-guidelines/       # Web interface compliance review
│
├── ⏰ crons/                        ← 8 scheduled job templates
│   └── starter-crons.json           # Morning digest, nightly review, etc.
│
├── 📚 docs/                         ← Guides
│   ├── MEMORY-SYSTEM.md             # How the 3-layer memory works
│   ├── SKILLS-GUIDE.md              # Creating and using skills
│   ├── CRON-GUIDE.md                # Setting up proactive crons
│   └── PHILOSOPHY.md                # The 10 principles behind great agents
│
└── 💡 examples/                     ← Reference configs
    ├── example-patterns.md          # Common tacit knowledge patterns
    ├── example-heartbeat.md         # Heartbeat variants (dev/founder/researcher)
    └── example-cron-setup.md        # Step-by-step cron setup commands
```

---

## 🧠 The Memory System

Most AI agents forget everything between sessions. This kit gives your agent **three layers of persistent memory**:

```
┌─────────────────────────────────────────────────────┐
│                  LAYER 1: Knowledge Graph            │
│                                                      │
│   life/areas/people/alice/summary.md                │
│   life/areas/companies/acme/items.json              │
│   life/areas/projects/my-app/summary.md             │
│                                                      │
│   → Entity-based facts with typed lifecycle          │
│   → "Who is Alice?" → instant structured answer      │
└─────────────────────────────────────────────────────┘
                         │
┌─────────────────────────────────────────────────────┐
│               LAYER 2: Daily Notes                   │
│                                                      │
│   memory/2026-03-07.md                              │
│   memory/2026-03-06.md                              │
│   memory/2026-03-05.md                              │
│                                                      │
│   → What happened today (raw event log)              │
│   → Written continuously, not batched                │
│   → "What did we do last Tuesday?" → date search     │
└─────────────────────────────────────────────────────┘
                         │
┌─────────────────────────────────────────────────────┐
│            LAYER 3: Tacit Knowledge                  │
│                                                      │
│   PATTERNS.md                                        │
│                                                      │
│   → Patterns about how YOU work                      │
│   → "User works late, don't suggest breaks"          │
│   → "Test config on 1 system before batch rollout"   │
│   → Grows organically from corrections               │
└─────────────────────────────────────────────────────┘
```

**Key insight:** Manual memory writes > auto-capture. Deliberate saves are higher quality than automated logging. The agent decides what's worth remembering, not a parser.

→ Full details in [`docs/MEMORY-SYSTEM.md`](docs/MEMORY-SYSTEM.md)

---

## 🔄 The Self-Correction Loop

This is the **single most impactful pattern** in the kit:

```
You correct your agent
        │
        ▼
Agent adds correction to SOUL.md ACTIVE RULES
        │
        ▼
SOUL.md is loaded EVERY session
        │
        ▼
Correction persists forever ✨
        │
        ▼
PATTERNS.md captures the "why" for deeper understanding
```

**Example:** You tell your agent "don't use markdown tables on Telegram, they render as garbage." The agent:
1. Immediately adds to SOUL.md: `NO TABLES ON TELEGRAM — bullets only`
2. Adds to PATTERNS.md: the reasoning and context
3. Never makes that mistake again

> The difference between a good agent and a great one is how it handles corrections.

---

## 🛠️ Skills Library

Skills are specialized instruction files that teach your agent how to handle specific tasks. Install by copying to `~/.openclaw/skills/`.

### Research & Analysis
| Skill | What it does |
|-------|-------------|
| `repo-analyzer` | Trust-score any GitHub repo (security, code quality, contributor patterns) |
| `company-research` | Structured research briefs for outreach or due diligence |
| `x-research` | Search Twitter/X for real-time perspectives and expert opinions |

### Productivity
| Skill | What it does |
|-------|-------------|
| `morning-digest` | Daily briefing: calendar, threads, weather, action items |
| `spawn-agent` | Deploy sub-agents for parallel or long-running tasks |
| `fact-extraction` | Extract and organize facts from conversations into memory |
| `google` | Gmail search/send, Calendar events, Drive file access |

### System & Security
| Skill | What it does |
|-------|-------------|
| `healthcheck` | Security hardening audit (firewall, SSH, updates, exposure) |
| `post-update-health-check` | Verify nothing broke after an OpenClaw update |

### Development Quality (6 skills)
| Skill | What it does |
|-------|-------------|
| `baseline-ui` | Enforce consistent, accessible UI patterns |
| `fixing-accessibility` | WCAG-compliant keyboard, screen reader, focus fixes |
| `fixing-metadata` | SEO tags, Open Graph, canonical URLs, structured data |
| `fixing-motion-performance` | Fix janky animations and rendering bottlenecks |
| `vercel-react-best-practices` | 57 prioritized React/Next.js performance rules from Vercel |
| `web-design-guidelines` | Web Interface Guidelines compliance review |

---

## ⏰ Proactive Crons

Cron jobs are what make your agent feel **alive** — it does things without being asked.

The kit includes 8 starter cron templates (`crons/starter-crons.json`):

| Cron | Schedule | What it does |
|------|----------|-------------|
| 🌅 **Morning Digest** | 7:30 AM daily | Calendar, threads, weather, action items |
| 🔍 **Nightly Self-Review** | 1:00 AM daily | Grade today's performance, find improvement areas |
| 🛡️ **Config Watchdog** | Every 15 min | Detect silent config changes or drift |
| 💾 **Git Backup** | 3:00 AM daily | Auto-commit and push workspace changes |
| 📞 **Meeting Prep** | Every 30 min (business hours) | Research upcoming call participants |
| 🧠 **Weekly Synthesis** | Sunday 10 AM | Consolidate the week's facts and patterns |
| 📋 **Thread Cleanup** | 7:00 PM daily | Surface stale open threads needing follow-up |
| 📝 **Fact Extraction** | 9:00 PM daily | Extract durable facts from today's conversations |

→ Step-by-step setup in [`examples/example-cron-setup.md`](examples/example-cron-setup.md)

---

## 🏗️ Workspace Files Explained

### `AGENTS.md` — The Rulebook
Your agent's operating manual. Contains:
- **Search Before Speaking** — never claim ignorance without grepping first
- **Three-Layer Memory System** — how to store and retrieve information
- **Continuous Memory Writes** — write immediately, don't wait for batch flushes
- **Security Audit Protocol** — mandatory review before installing any new skill
- **Tool Failure Recovery** — try 3 approaches before reporting failure
- **Correction Protocol** — how to handle behavior corrections

### `SOUL.md` — Persona + Active Rules
Two sections:
1. **Persona** — your agent's personality (confident, concise, playful, whatever you want)
2. **Active Rules** — the 5-10 most important behavior corrections, loaded every session

### `HEARTBEAT.md` — Proactive Checklist
What your agent checks on heartbeat polls:
- System health (OpenClaw updates, cron errors)
- Open threads older than 48 hours
- Upcoming calendar events needing research
- Patterns suggesting new skills to create

See [`examples/example-heartbeat.md`](examples/example-heartbeat.md) for variants tailored to developers, founders, and researchers.

### `PATTERNS.md` — Living Knowledge
Starts empty. Grows as your agent learns:
- Debugging patterns ("always check HTTP method before calling")
- Deployment lessons ("test on 1 system before batch rollout")
- Your preferences ("user works late, don't suggest breaks")
- Tool quirks ("this API returns 429 after 3 calls, back off")

See [`examples/example-patterns.md`](examples/example-patterns.md) for common starter patterns.

---

## 🧭 Philosophy

Ten principles that separate great agent setups from mediocre ones:

1. **Manual memory beats auto-capture.** Quality > quantity.
2. **Search before speaking.** `grep` costs 1 tool call. Guessing costs 3+.
3. **Corrections go to SOUL.md.** It's the only file loaded every session.
4. **Evening cleanup produces artifacts.** Quiet time = drafts, research, thread updates.
5. **Benchmark before implementing.** Evaluate first, build second.
6. **Isolate before fixing.** Confirm which system is broken before changing anything.
7. **Test on one before rolling out.** One cron, one config, one system.
8. **Deliver, don't prepare.** Internal prep ≠ completion. User-facing delivery = done.
9. **Write immediately.** Don't wait for batch flushes. Facts decay in RAM.
10. **Build skills from repetition.** 3+ times = create a skill.

→ Full breakdown with examples in [`docs/PHILOSOPHY.md`](docs/PHILOSOPHY.md)

---

## 🚀 Getting Started

After running `setup.sh`:

1. **Edit `~/clawd/IDENTITY.md`** — Give your agent a name and personality
2. **Edit `~/clawd/USER.md`** — Tell your agent who you are
3. **Edit `~/clawd/SOUL.md`** — Customize the persona (or keep the default)
4. **Start talking** — Your agent will begin building memory from day one
5. **Correct freely** — Every correction makes it permanently smarter
6. **Set up crons** — See `examples/example-cron-setup.md` for the essentials

### Optional Power-Ups

- **Install skills** → Copy from `skills/` to `~/.openclaw/skills/`
- **Enable Google integration** → Follow `skills/google/SKILL.md` setup
- **Add Obsidian sync** → Dual-write to an Obsidian vault for graph visualization
- **Create custom skills** → See `docs/SKILLS-GUIDE.md`

---

## 🤝 Contributing

Found a pattern that makes your agent better? A skill that's universally useful? Open a PR.

The best contributions are **battle-tested patterns** — things you've run for weeks and proven work.

---

## 📝 License

MIT — use it, fork it, make it yours.

---

<p align="center">
  <em>Built from months of real-world iteration. Every pattern earned, not invented.</em>
</p>
