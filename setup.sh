#!/bin/bash
# OpenClaw Starter Kit — Bootstrap Script
# Creates your agent workspace with the three-layer memory system,
# proactive heartbeat, and production-tested skills.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORKSPACE="${HOME}/clawd"
SKILLS_DIR="${HOME}/.openclaw/skills"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'
BOLD='\033[1m'

echo ""
echo -e "${BLUE}${BOLD}🐾 OpenClaw Starter Kit${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check if workspace already exists
if [ -d "$WORKSPACE" ]; then
    echo -e "${YELLOW}⚠️  Workspace already exists at ${WORKSPACE}${NC}"
    echo -e "   This script won't overwrite existing files."
    read -p "   Continue and only add missing files? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 0
    fi
fi

# ─── Step 1: Create workspace structure ───────────────────────────
echo -e "${GREEN}📁 Creating workspace structure...${NC}"

mkdir -p "$WORKSPACE"/{memory,life/areas/{people,companies,projects},reviews,tmp}

# Copy workspace files (skip if they already exist)
for file in AGENTS.md SOUL.md IDENTITY.md USER.md HEARTBEAT.md TOOLS.md PATTERNS.md pending-threads.json; do
    if [ ! -f "$WORKSPACE/$file" ]; then
        cp "$SCRIPT_DIR/workspace/$file" "$WORKSPACE/$file"
        echo -e "   ✅ Created ${file}"
    else
        echo -e "   ⏭️  Skipped ${file} (already exists)"
    fi
done

# Create memory .gitkeep
touch "$WORKSPACE/memory/.gitkeep"

echo ""

# ─── Step 2: Initialize git repo ─────────────────────────────────
if [ ! -d "$WORKSPACE/.git" ]; then
    echo -e "${GREEN}📦 Initializing git repository...${NC}"
    cd "$WORKSPACE"
    git init -q
    git add AGENTS.md
    git commit -q -m "Initialize agent workspace"
    echo -e "   ✅ Git repo initialized"
    echo -e "   ${YELLOW}💡 Tip: Add a remote to back up your agent's memory${NC}"
    echo -e "   ${YELLOW}   git remote add origin <your-private-repo-url>${NC}"
else
    echo -e "   ⏭️  Git repo already exists"
fi

echo ""

# ─── Step 3: Install skills ──────────────────────────────────────
echo -e "${GREEN}🧠 Skills available for installation:${NC}"
echo ""

SKILLS=(
    "repo-analyzer:GitHub repo trust scoring and due diligence"
    "spawn-agent:Deploy sub-agents for parallel tasks"
    "fact-extraction:Extract durable facts into knowledge graph"
    "morning-digest:Daily morning briefing"
    "post-update-health-check:Post-update regression check"
    "company-research:Structured company research briefs"
)

for skill_entry in "${SKILLS[@]}"; do
    IFS=':' read -r skill_name skill_desc <<< "$skill_entry"
    
    if [ -d "$SKILLS_DIR/$skill_name" ]; then
        echo -e "   ⏭️  ${BOLD}${skill_name}${NC} — already installed"
        continue
    fi
    
    echo -e "   📋 ${BOLD}${skill_name}${NC} — ${skill_desc}"
    read -p "      Install? (y/N) " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        mkdir -p "$SKILLS_DIR/$skill_name"
        cp -r "$SCRIPT_DIR/skills/$skill_name/"* "$SKILLS_DIR/$skill_name/"
        echo -e "      ${GREEN}✅ Installed${NC}"
    fi
done

echo ""

# ─── Step 4: Offer cron setup ────────────────────────────────────
echo -e "${GREEN}⏰ Cron jobs help your agent work proactively.${NC}"
echo -e "   See ${BOLD}examples/example-cron-setup.md${NC} for setup commands."
echo ""
echo -e "   Recommended starter crons:"
echo -e "   • ${BOLD}morning-digest${NC} — daily briefing at 7:30 AM"
echo -e "   • ${BOLD}nightly-self-review${NC} — daily review at 1:00 AM"
echo -e "   • ${BOLD}git-backup${NC} — auto-commit at 2:00 AM"
echo ""
echo -e "   ${YELLOW}💡 Run the commands in examples/example-cron-setup.md to set these up${NC}"
echo ""

# ─── Done ─────────────────────────────────────────────────────────
echo -e "${BLUE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}${BOLD}✅ Setup complete!${NC}"
echo ""
echo -e "Next steps:"
echo -e "  1. ${BOLD}Edit ~/clawd/IDENTITY.md${NC} — give your agent a name and personality"
echo -e "  2. ${BOLD}Edit ~/clawd/USER.md${NC} — tell your agent who you are"
echo -e "  3. ${BOLD}Edit ~/clawd/SOUL.md${NC} — customize persona and add active rules"
echo -e "  4. ${BOLD}Start OpenClaw${NC}: openclaw gateway start"
echo -e "  5. ${BOLD}Read docs/PHILOSOPHY.md${NC} — understand the principles"
echo ""
echo -e "${BLUE}Happy building! 🐾${NC}"
