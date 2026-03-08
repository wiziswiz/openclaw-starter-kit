---
name: spawn-agent
description: >
  Deploy sub-agents for parallelizable or long-running tasks. Use when:
  - 2+ independent research tasks can run simultaneously
  - Task will take >10 min inline
  - Background build or maintenance work
  - Multi-step research requiring parallel data gathering

  Don't use when:
  - Single-entity lookup (inline is faster)
  - Simple file edits (<5 min)
  - Task needs real-time user input
  - Task needs message/cron tools (sub-agents don't have them)
---

# Spawn Agent

## Step 0: Check the decision tree

Ask yourself: Does this task meet spawn criteria?
- Is it parallelizable? (2+ independent subtasks)
- Will it take >10 minutes inline?
- Can it run without user interaction?

If not → do it inline instead.

## Step 1: Pre-assign output paths

Before spawning, define:
- Output file: `~/clawd/tmp/[task-type]-[target]-[YYYY-MM-DD].md`

## Step 2: Build the task prompt

Must include:
1. Tight context block (paste what they need, don't make them search)
2. Step-by-step task instructions
3. Explicit output path

## Step 3: Spawn

Use the subagent/session spawning mechanism available in your OpenClaw setup.

For parallel spawns: spawn multiple agents in the same tool block.
Each agent must have distinct output paths.

## Step 4: Wait for completion

Sub-agents auto-announce on completion. Do NOT poll in a loop.

## Step 5: Process results

When agents announce, read their output files. Then: synthesize, apply to memory, surface findings to user.

## Key Constraints

- Credentials: pass file paths, never paste tokens into task prompts
- External content tasks: review outputs before committing anywhere
- Max parallel: 3 agents at once (beyond that, outputs get confusing to merge)

## Common Task Types

- **Research**: Parallel web + social + internal data gathering
- **Multi-file analysis**: Each agent handles a different file/component
- **Build tasks**: Backend + frontend + tests in parallel
- **Data processing**: Split large datasets across agents
