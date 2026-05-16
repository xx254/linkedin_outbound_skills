---
name: analytics
description: Reviews LinkedNav campaign performance and account health. Pulls dashboard summary, per-campaign metrics, and connection/reply rates. Flags underperforming campaigns and recommends fixes. Use after the first 3 days of a campaign, then weekly. Triggers on "how's the campaign doing", "check performance", "analytics", "reply rate", "acceptance rate".
---

# LinkedNav Analytics

Reviews what's working, what's not, and what to change next week.

## When to use

- After first 3 days of a campaign (early signal check)
- Weekly review of all active campaigns
- Before any major copy or targeting change
- When acceptance rates drop unexpectedly

## Steps

### Step 1: Dashboard overview

Call `mcp__claude_ai_LinkedNav__get_dashboard_summary`:

```
=== LinkedNav Dashboard ===
Date: <today>

Overall:
- Total connections sent: <N>
- Accepted: <N> (<rate>%)
- Messages sent: <N>
- Replies received: <N> (<rate>%)
- Positive replies: <N> (<rate>% of replies)
```

### Step 2: Per-campaign breakdown

Call `mcp__claude_ai_LinkedNav__get_campaigns_summary` and `mcp__claude_ai_LinkedNav__get_performance_analytics`.

Present as a table:

```
Campaign Performance:

| Campaign | Status | Sent | Accept% | Replies | Reply% | Positive% |
|----------|--------|------|---------|---------|--------|-----------|
| <name>   | Active | 120  | 28%     | 18      | 15%    | 8%        |
| <name>   | Active | 45   | 12%     | 2       | 4%     | 2%        |
```

Flag underperformers:
- Acceptance rate < 15%: 🔴 connection note problem
- Reply rate < 3%: 🟠 message 1 or 2 problem
- Both low: 🔴 targeting problem (wrong ICP or list)

### Step 3: Scheduled sends review

Call `mcp__claude_ai_LinkedNav__get_scheduled_sends` to see what's queued for the next 48 hours.

Flag if any campaign has no sends scheduled (could mean it's paused or list is exhausted).

### Step 4: Diagnosis and recommendations

Based on the metrics, recommend the next action:

**Acceptance rate < 15%:**
```
Diagnosis: Connection note isn't compelling enough for this audience.
Fix options:
A) Rewrite the connection note → /message-copywriting
B) Check if list source matches ICP (social listening lists typically accept 25-40%; cold CSV lists 15-25%)
C) Check account health — if profile is incomplete or account is new, that suppresses accepts
```

**Reply rate < 3% (with >15% acceptance):**
```
Diagnosis: Message 1 isn't earning a reply.
Fix options:
A) Rewrite message 1 — try a different angle → /message-copywriting
B) Test a question-first approach vs value-first
C) Check if message 2 is running (if message 1 never sent, no reply is expected)
```

**Both acceptance AND reply rate are normal but no pipeline:**
```
Diagnosis: Targeting is right, copy is working, but the offer or timing doesn't resonate.
Fix options:
A) Revisit the CTA — is it too big an ask? (call vs "reply with yes")
B) Test a different proof point or value prop
C) Add a lead magnet or resource offer in message 2
```

**Acceptance > 30% but reply < 2%:**
```
Diagnosis: People are accepting to be polite, not because they're interested. 
Connection note may be too generic ("fellow [industry] operator here").
Fix: Make the connection note more specific to the offer.
```

### Step 5: List health

Check if the list is running low:
- If < 20% of list remains unsent: warn and plan the next list build
- If list is exhausted: campaign will stall — start `/list-builder` or `/social-listening`

### Step 6: Account health check

Call `mcp__claude_ai_LinkedNav__get_account_status`:
- Any new warnings?
- Approaching weekly limits?
- Authentication issues?

If account is flagged or throttled: pause all campaigns until resolved.

## Benchmark targets

| Metric | Weak | OK | Good | Great |
|--------|------|----|------|-------|
| Connection acceptance rate | <10% | 10-20% | 20-30% | >30% |
| Reply rate (of accepted) | <3% | 3-8% | 8-15% | >15% |
| Positive reply rate (of all) | <1% | 1-3% | 3-6% | >6% |
| Messages to booked call | — | 100:1 | 50:1 | 25:1 |

Social listening lists typically outperform cold CSV lists by 1.5-2x on acceptance.

## What to do next

**If performance is good (A/B grade):** keep running. Scale the list → `/list-builder` or `/social-listening`.

**If connection note is the problem:** rewrite → `/message-copywriting` (Step 2 only).

**If messages are the problem:** rewrite sequence → `/message-copywriting`.

**If targeting is the problem:** review ICP → `/icp-setup`, then rebuild list → `/social-listening` or `/list-builder`.

**If inbox is filling up with positive replies:** → `/inbox-manager` immediately.

## Related skills

- `/inbox-manager` — manage the replies this skill surfaces
- `/message-copywriting` — rewrite if metrics are low
- `/campaign-builder` — adjust campaign settings
- `/icp-setup` — revisit ICP if targeting seems off
- `/signal-agent` — add intent signals to find warmer leads
