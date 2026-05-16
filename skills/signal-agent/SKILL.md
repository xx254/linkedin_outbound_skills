---
name: signal-agent
description: Configures and runs LinkedNav signal agents — AI that detects intent signals (job changes, company growth, content engagement) and automatically surfaces high-priority leads. Use when you want warm, triggered outreach instead of cold list blasting. Triggers on "signal agent", "intent signals", "who's hiring", "job change alerts", "auto-find leads".
---

# LinkedNav Signal Agent

Finds leads who are showing buying intent right now — not a static list, but a live feed of people whose context makes them likely to care about your offer today.

## Why this exists

The best time to reach a Head of Marketing is the week they started a new role. The best time to reach a VP of Sales is when their company just raised a Series B. Signal agents monitor for these moments automatically and surface the leads before the window closes.

## Signal types supported

| Signal | What it catches | Best for |
|--------|----------------|---------|
| Job change | Person moved to a new role in the last 90 days | New decision-makers who want to make their mark |
| Company growth | Company headcount grew >20% in 6 months | Scaling orgs that need solutions |
| Fundraise | Recent funding round detected | Companies with budget and urgency |
| Content engagement | Engaged with specific topics on LinkedIn | People actively researching your category |
| Competitor mention | Posted about or engaged with a competitor | High-intent consideration stage |
| Hiring signal | Company is hiring for a specific role | Indicates active investment in that function |

## Steps

### Step 1: Check existing signal agents

Call `mcp__claude_ai_LinkedNav__get_signal_agent_settings` to see what's already configured.

Show current setup:
```
Signal agents:
- Job change alerts: <enabled/disabled>
- Auto-add to campaign: <campaign name or none>
- Last run: <date>
- Leads found (last 30 days): <N>
```

### Step 2: Configure signal type

Ask which signal type to monitor. For most users, start with:
1. **Job change** (easiest to personalize: "Congrats on the new role")
2. **Competitor engagement** (warmest leads — already evaluating solutions)

For each signal type, configure:
- Which titles/roles to watch (pull from `client-profile.yaml`)
- Which industries or companies to scope to
- How far back to look (7 days / 30 days / 90 days)

### Step 3: Set auto-run

Call `mcp__claude_ai_LinkedNav__set_signal_agent_auto_run` to schedule the agent:
- Daily (recommended)
- Weekly
- Manual only

### Step 4: Set auto-add (optional)

Call `mcp__claude_ai_LinkedNav__set_signal_agent_auto_add` to automatically add signal leads to a campaign.

⚠️ **Warning:** Only enable auto-add if you've already reviewed the quality of signal leads manually for at least 1 week. Auto-add without review can flood a campaign with off-ICP leads.

Ask:
> "Do you want new signal leads added to a campaign automatically, or would you prefer to review them first?"

If review-first: set to manual add. Show leads via Step 6 each week.
If auto-add: confirm the target campaign, then enable.

### Step 5: Run the agent now

Call `mcp__claude_ai_LinkedNav__run_intent_agent` to trigger an immediate run.

Monitor the task: call `mcp__claude_ai_LinkedNav__get_agent_run_status` until complete.

```
Signal agent running...
- Scanned: <N> profiles
- Signals detected: <N>
- Matched ICP: <N>
- Added to review queue: <N>
```

### Step 6: Review signal leads

Call `mcp__claude_ai_LinkedNav__get_signal_leads` to show detected leads:

```
Signal leads this week:

1. Jane Doe — VP Marketing @ Acme (just joined 14 days ago)
   Signal: Job change
   Why reach out: New VPs often audit vendors in first 90 days

2. John Smith — Head of Growth @ Beta Inc
   Signal: Competitor engagement (engaged with [competitor] post)
   Why reach out: Actively evaluating solutions in your category

3. Sarah Lee — CMO @ Gamma
   Signal: Company raised Series B ($20M)
   Why reach out: New budget, new mandate, scaling marketing team
```

For each lead, offer: Add to list / Skip / Add to different list.

### Step 7: Personalize connection notes for signal leads

Signal leads deserve signal-specific connection notes. For each signal type:

**Job change:**
```
"<First name> — congrats on the new role at <company>. I work with <ICP role>s who are building out their [relevant function] — figured it was worth connecting."
```

**Competitor engagement:**
```
"Saw you engage with [competitor]'s content on [topic]. Work in the same space. Worth connecting to share notes."
```

**Fundraise:**
```
"Saw <company> just closed the [round]. Congrats — scaling [function] is usually top of mind at this stage. Worth connecting."
```

### Step 8: Get historical results

Call `mcp__claude_ai_LinkedNav__get_signal_agent_results` to see how past signal batches performed:
```
Signal agent results (last 90 days):
- Total leads surfaced: <N>
- Added to campaigns: <N>
- Acceptance rate: <rate>% (vs <rate>% for non-signal campaigns)
- Reply rate: <rate>%
```

Signal leads typically outperform cold lists by 2-3x on acceptance and reply rates.

## What to do next

Signal leads are reviewed and queued.

**Add to list:** → `/list-builder` (add them to a signal-specific list)

**Grade the list:** → `/list-quality`

**Write signal-specific copy:** → `/message-copywriting` (use the signal as the connection note angle)

**Launch:** → `/campaign-builder`

## Related skills

- `/icp-setup` — provides ICP targeting used by the signal agent
- `/list-builder` — add signal leads to a list
- `/social-listening` — complementary warm lead source (engagers vs signals)
- `/message-copywriting` — write connection notes that reference the signal
- `/analytics` — compare signal vs non-signal campaign performance
