# Philosophy

These principles emerged from months of daily iteration with an AI agent. They're the difference between a chatbot and a genuine productivity multiplier.

---

## 1. Manual Memory Beats Auto-Capture

Automated memory logging produces noise. Deliberate, manual writes to memory files produce signal.

When your agent writes a fact to `items.json` because it recognized something important in conversation — that's valuable. When a system auto-logs every utterance — that's a haystack with no needles.

**The practice:** Write to memory immediately when decisions are made, patterns emerge, or important facts surface. Don't batch. Don't wait for a "flush." Write now.

## 2. Search Before Speaking

The single most trust-destroying behavior an agent can exhibit: asking "do you want me to look into X?" when X is already in the workspace.

**The rule:** Before saying "I don't know," asking a question, or proposing to investigate — `grep -ri` the workspace, memory files, and project directories. If it exists, say so. If it doesn't, then ask.

This rule is non-negotiable. Violating it is the #1 way to lose a user's trust.

## 3. Corrections Go to SOUL.md

You will correct your agent's behavior. The question is whether those corrections stick.

**The mechanism:**
- `SOUL.md` is loaded every session → corrections here persist forever
- `PATTERNS.md` is loaded sometimes → corrections here persist maybe
- Conversation memory is ephemeral → corrections here persist until context window rolls

The math is simple: corrections that matter go to SOUL.md ACTIVE RULES. Everything else goes to PATTERNS.md.

If ACTIVE RULES has 8+ items, replace the least-recently-violated rule. A short list of enforced rules beats a long list of ignored ones.

## 4. Evening Cleanup Produces Artifacts

"Nothing needs attention" is almost never true. During quiet periods — evenings, weekends, user-offline hours — your agent should produce something tangible:

- A draft follow-up message
- A research file for tomorrow's meeting
- An updated thread status
- A pattern added to PATTERNS.md

Reading `pending-threads.json` and reporting "all clear" is not cleanup. It's avoidance.

**The standard:** Every 4-hour quiet stretch should produce at least one artifact.

## 5. Benchmark Before Implementing

When you ask your agent to evaluate a change, it should evaluate — not skip ahead to implementation. Eagerness to "get things done" does not override explicit instructions.

**The practice:** Run the evaluation. Present findings. Get approval. Then implement. In that order.

## 6. Three Strikes and You're Done

Any action item that appears in 3 consecutive reviews without completion must be either:
- **Done immediately** during the review itself, or
- **Permanently dropped** with explicit justification

There is no option C. Deferring indefinitely is how review systems become performative theater.

## 7. Tool Failure Recovery (Try 3 Before Crying)

"API returned an error" is not a response. It's giving up on attempt 1.

Before reporting a failure, try:
1. Alternative endpoint or method
2. Completely different approach
3. Manual workaround from available data

Only after all three fail: report what was tried, what failed, and why.

## 8. The Correction Loop Is Everything

The quality of your agent is determined by this loop:

```
User corrects behavior
  → Agent adds correction to SOUL.md
    → SOUL.md is loaded every session
      → Behavior is permanently fixed
        → User trusts agent more
          → User delegates more
            → Agent learns more patterns
              → Agent becomes more valuable
```

Break this loop at any point and quality degrades. The loop IS the product.

## 9. Research Without Delivery Is Waste

If your agent researches a topic but never delivers the findings at the right moment, the research was worthless. Internal preparation is not completion.

**The practice:** When research is done, set a delivery trigger. "When meeting X starts, push this brief." Don't rely on remembering — write the trigger to a memory file.

## 10. Security Is Not Optional

Third-party skills are untrusted code. Period. Every script gets read. Every dependency gets checked. Every external URL gets verified.

The security audit checklist in AGENTS.md exists because the threat is real: supply chain attacks, prompt injection in external content, credential harvesting disguised as "helpful tools."

Audit on install. Re-audit on update. Diff before accepting changes.

---

## The Meta-Lesson

The best agent setup isn't the most feature-rich one. It's the one where:

- Corrections actually stick (SOUL.md)
- Memory is deliberate, not automatic (three-layer system)  
- Quiet time is productive time (artifacts, not HEARTBEAT_OK)
- Failures are recovered from, not reported (try 3 approaches)
- Security is enforced, not assumed (audit everything)

Start with these principles. Add complexity only when you hit a real wall. The lean version is almost always the right version.
