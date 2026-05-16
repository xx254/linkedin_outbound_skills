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
| Just moved jobs | Person started a new role recently | New decision-makers in audit window, want to prove themselves |
| Just posted | Person recently posted on LinkedIn | Active, engaged, receptive to outreach |
| Growing team | Company is actively hiring / expanding headcount | Orgs investing in a function = budget and urgency |
| New boss | Company hired new senior leadership | Leadership change = vendor reviews, new priorities |
| Budget in hand | Company recently raised funding or shows budget signals | Urgency to spend, mandate to build |

Note: competitor and influencer engagement signals are handled by `/social-listening`, not this skill.

## Steps

> Tell the user: "I'm going to set up LinkedNav's signal agent — it finds people who are showing buying intent right now (new job, new boss, growing team, fresh funding). These leads outperform cold lists 2-3x."

### Step 0: Identify which ICP these leads belong to

Call `mcp__claude_ai_LinkedNav__get_ai_setups` to check existing setups.

**If 0 setups exist (first time user):**
Tell the user:
```
No ICP profile found. How do you want to proceed?

[A] Give me your landing page or service description → I'll walk you through
    a full ICP setup in LinkedNav (/icp-setup). Takes ~10 min, gives better
    AI personalization on your campaigns.

[B] Tell me who you're targeting in one sentence → I'll start finding leads
    right now. You can set up the full ICP later.

Pick A or B:
```
- If A: invoke `/icp-setup`, then continue with the slug from that setup.
- If B: ask "Who are you targeting?" and generate a slug from their answer (e.g., `vp-marketing-saas-us`). Use this as the list prefix.

**If exactly 1 setup exists:**
Auto-select it silently. Tell the user: "Using your ICP: **<setup name>**." Then continue.

**If 2+ setups exist:**
This is required to prevent leads from different ICPs getting mixed. Show the list:
```
You have multiple ICP setups:
- <name 1> (active)
- <name 2>
...

Which setup are these signal leads for? Or is this a new ICP? (If new → run /icp-setup first)
```
Use the selected setup's slug as the list prefix. Do not proceed until the user picks one.

### Step 1: Check existing signal agents

> Tell the user: "**Step 1 of 6 — Current setup.** Checking what signal agents are already configured."

Call `mcp__claude_ai_LinkedNav__get_signal_agent_settings` to see what's already configured.

Show current setup:
```
Signal agents:
- Job change alerts: <enabled/disabled>
- Auto-add to campaign: <campaign name or none>
- Last run: <date>
- Leads found (last 30 days): <N>
```

> When done, tell the user: "→ Choosing which signal type to run first."

### Step 2: Configure signal type

> Tell the user: "**Step 2 of 6 — Signal type.** Here are the 5 available signals. Pick one or more to monitor — I'll recommend based on your ICP."

Show all 5 options with all selected by default. Present them for confirmation:

```
I've selected all 5 signals by default — more signals = more leads surfaced.
Deselect any you don't want.

[x] A. Just moved jobs
      Catches people who recently started a new role.
      Why it works: new decision-makers audit existing vendors in the first 90 days.
      Best connection note: "Congrats on the new role at <company>..."

[x] B. Just posted on LinkedIn
      Catches people who recently published content.
      Why it works: active posters are more likely to accept connections and reply.
      Best connection note: "Saw your post on [topic]..."

[x] C. Growing team
      Catches companies actively hiring / expanding headcount.
      Why it works: hiring = budget allocated, urgency to solve problems.
      Best connection note: "Saw <company> is growing the [function] team..."

[x] D. New boss
      Catches companies that recently hired new senior leadership.
      Why it works: new leadership = vendor reviews, new priorities, fresh mandate.
      Best connection note: "Saw <company> brought on a new [title]..."

[x] E. Budget in hand
      Catches companies with recent fundraise or budget signals.
      Why it works: fresh capital = urgency to deploy it, decisions move fast.
      Best connection note: "Congrats on the [round] — scaling [function] is usually top of mind..."

All 5 selected. Reply "confirm" to use all, or tell me which to remove (e.g. "remove B and D").
```

After confirmation, summarize:
```
Monitoring: <selected signals>
Targeting: <titles from ICP> at <industries> companies
```

> When done, tell the user: "Signal configured. → Setting the run schedule."

### Step 3: Set auto-run

> Tell the user: "**Step 3 of 6 — Schedule.** Setting how often the agent runs. Daily is recommended."

Call `mcp__claude_ai_LinkedNav__set_signal_agent_auto_run` to schedule the agent:
- Daily (recommended)
- Weekly
- Manual only

> When done, tell the user: "Schedule set. → Deciding whether to auto-add leads to a campaign."

### Step 4: Set auto-add (optional)

> Tell the user: "**Step 4 of 6 — Auto-add (optional).** Warning: only enable this after you've reviewed at least 1 week of leads manually."

Call `mcp__claude_ai_LinkedNav__set_signal_agent_auto_add` to automatically add signal leads to a campaign.

⚠️ **Warning:** Only enable auto-add if you've already reviewed the quality of signal leads manually for at least 1 week. Auto-add without review can flood a campaign with off-ICP leads.

Ask:
> "Do you want new signal leads added to a campaign automatically, or would you prefer to review them first?"

If review-first: set to manual add. Show leads via Step 6 each week.
If auto-add: confirm the target campaign, then enable.

> When done, tell the user: "→ Running the agent now to get your first batch of leads."

### Step 5: Run the agent now

> Tell the user: "**Step 5 of 6 — Running.** Scanning LinkedIn for intent signals now. This takes a minute."

Call `mcp__claude_ai_LinkedNav__run_intent_agent` to trigger an immediate run.

Monitor the task: call `mcp__claude_ai_LinkedNav__get_agent_run_status` until complete.

```
Signal agent running...
- Scanned: <N> profiles
- Signals detected: <N>
- Matched ICP: <N>
- Added to review queue: <N>
```

> When done, tell the user: "[N leads found.] → Let's review them."

### Step 6: Review signal leads

> Tell the user: "**Step 6 of 6 — Reviewing leads.** Here are the people who triggered a signal this week. For each one: add to list, skip, or add to a different list."

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

Before showing leads, automatically create (or reuse) the list `<ai-setup-slug>-signal-agent-<YYYY-MM>` for this batch. Tell the user:
```
I'll add approved leads to: <ai-setup-slug>-signal-agent-<date>
(Creating this list now if it doesn't exist yet.)
```

For each lead, offer: Add to this list / Skip / Add to a different list.

Do not add signal leads to a list belonging to a different AI setup.

> When done, tell the user: "[N leads added.] → Next: /list-quality to score the list, then /message-copywriting to write signal-specific connection notes."

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
