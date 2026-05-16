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

> Tell the user: "I'll pull your campaign performance and tell you exactly what's working, what's not, and what to change. Takes about 2 minutes."

### Step 1: Dashboard overview

> Tell the user: "**Step 1 of 6 — Overall stats.** Getting the big picture across all campaigns."

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

> When done, tell the user: "→ Now breaking down by campaign."

### Step 2: Per-campaign breakdown

> Tell the user: "**Step 2 of 6 — Campaign breakdown.** Showing acceptance rate and reply rate for each campaign. Flagging anything that's underperforming."

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

> When done, tell the user: "→ Checking your send queue."

### Step 3: Scheduled sends review

> Tell the user: "**Step 3 of 6 — Scheduled sends.** Making sure campaigns have sends queued for the next 48 hours."

Call `mcp__claude_ai_LinkedNav__get_scheduled_sends` to see what's queued for the next 48 hours.

Flag if any campaign has no sends scheduled (could mean it's paused or list is exhausted).

> When done, tell the user: "→ Diagnosing any issues I found."

### Step 4: Diagnosis and recommendations

> Tell the user: "**Step 4 of 6 — Diagnosis.** Based on the numbers, here's what's working and what needs to change — with specific fix options."

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

> When done, tell the user: "→ Checking list health."

### Step 5: List health

> Tell the user: "**Step 5 of 6 — List health.** Checking if any campaign is about to run out of contacts."

Check if the list is running low:
- If < 20% of list remains unsent: warn and plan the next list build
- If list is exhausted: campaign will stall — start `/list-builder` or `/social-listening`

> When done, tell the user: "→ Checking your LinkedIn account status."

### Step 6: Account health check

> Tell the user: "**Step 6 of 6 — Account health.** Making sure no LinkedIn warnings have appeared."

Call `mcp__claude_ai_LinkedNav__get_account_status`:
- Any new warnings?
- Approaching weekly limits?
- Authentication issues?

If account is flagged or throttled: pause all campaigns until resolved.

> When done, tell the user: "Review complete. [→ Next action based on diagnosis: /message-copywriting if copy issues / /list-builder or /social-listening if list running low / /inbox-manager if replies are piling up]"

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
