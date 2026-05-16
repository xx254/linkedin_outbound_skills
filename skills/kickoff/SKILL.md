---
name: kickoff
description: Single "start here" orchestrator for LinkedIn outbound. Defines the target, builds the ICP, and routes to the right list-building skill. LinkedIn account connection happens later, right before campaign launch. Use as the very first step for any new LinkedIn outbound campaign.
---

# LinkedIn Outbound Kickoff

The single entry point for a fresh outbound run. Replaces "stare at 13 skills and guess which to run first."

## When to use

- First time doing LinkedIn outbound for a client or business
- Starting a fresh campaign for a new target persona
- Anyone who asks "where do I start?"

## What this skill produces

- A populated `profiles/<business-slug>/client-profile.yaml` (from `/icp-setup`)
- An AI setup configured in LinkedNav for automated message personalization
- An interactive menu pointing at the right list-building approach

## Flow

### Step 0: Check LinkedNav connection

Before anything else, call `mcp__claude_ai_LinkedNav__get_account_status` to verify the MCP integration is live.

**If the call succeeds:** proceed to Step 1.

**If the call fails or errors:**

Tell the user:
```
Before we can run LinkedIn outbound, you need to connect Claude Code to LinkedNav.

LinkedNav is the platform that powers everything — it manages your contact lists,
sends your campaigns, and handles inbox replies.

Set it up here: http://linkednav.com/app/integrations/mcp/

Once your API key is configured and Claude Code is restarted, come back and run /kickoff again.
Or run /account-setup for step-by-step help.
```

Stop. Do not proceed until the MCP connection is confirmed working.

---

When the skill starts (MCP confirmed), tell the user:
"We're going to define your target ICP and pick a list-building approach. This takes about 10-15 minutes. Let's start."

### Step 1 (asked FIRST): Business context

Tell the user: "**Step 1 of 4 — Understanding your business** — I need to know what you're selling before we do anything else."

Ask:

1. **"What's the website of the business you're running LinkedIn outbound for?"** (or "give me a two-sentence description")
2. **"Have you set up your ICP profile in LinkedNav yet?"** (yes / no)

These answers determine whether to run `/icp-setup` and which list-building approach to recommend.

When done, tell the user: "Got it. → Next: checking if you have an existing ICP profile or building a new one."

### Step 2: Load or create the ICP profile

Tell the user: "**Step 2 of 4 — ICP Profile** — [If profile exists: Loading your existing ICP. / If no profile: Building your ICP with a ~10-question interview.]"

Check for `profiles/<business-slug>/client-profile.yaml`:

- **Exists** → load it. Ask: "Use this existing profile (`use`) or start fresh (`new`)?"
- **Doesn't exist** → invoke `/icp-setup`. This interviews the user and creates both the local YAML and the AI setup in LinkedNav.

When done, tell the user: "ICP is ready. → Next: picking your list-building approach."

### Step 3: Interactive next-skill menu

Tell the user: "**Step 3 of 4 — List-building approach** — Based on your ICP, here's my recommendation for how to find leads."

Once ICP is ready, show the list-building options:

```
ICP is defined. Time to build your list. Based on your ICP (<summary>), the best fit is:

[A] /social-listening  → find people engaging with competitors / influencers (best for: warm leads who already care about your space)
[B] /list-builder      → import a CSV or build from scratch (best for: cold lists, account-based targeting)
[C] /signal-agent      → AI-powered intent signals (best for: people actively researching solutions like yours)

Recommendation: <one of A/B/C based on ICP>. Pick A / B / C:
```

After picking a list-building path, remind the user of the full sequence:
- `/list-quality` to grade the list
- `/message-copywriting` to write connection request + sequences
- `/campaign-builder` to create, configure, and launch (LinkedIn account connection happens here)
- `/inbox-manager` to manage replies

When done, tell the user: "Got it. I'll save your campaign plan and hand you off to the next step."

### Step 4: Synthesize campaign-plan.md

Tell the user: "**Step 4 of 4 — Campaign plan** — Saving your campaign checklist so you have a single reference for the full workflow."

Write `profiles/<slug>/campaign-plan.md`:

```markdown
# LinkedIn Outbound Campaign Plan — <business name>
Generated: YYYY-MM-DD

## Business
<one-liner>
Website: <url>

## ICP
- Titles: <titles>
- Industries: <industries>
- Headcount: X-Y
- Geography: <countries>

## Offer
- Primary CTA: <what you ask them to do>
- Value prop: <why they should care>

## Campaign Checklist
- [x] ICP defined
- [ ] List built
- [ ] List quality scored ≥ 7
- [ ] Message sequence written
- [ ] Campaign created in LinkedNav
- [ ] LinkedIn account connected (done at launch time)
- [ ] Campaign activated

## Next Steps
<branched from Step 3>
```

When done, tell the user: "All done. Campaign plan saved to profiles/<slug>/campaign-plan.md. Your next step is [whatever they picked in step 3]."

## Safeguards

- **Don't re-run `/icp-setup` blindly.** If a profile exists, ASK before overwriting.
- **Don't auto-start campaigns.** Always confirm before activating. Real messages go to real people.
- **LinkedIn connection happens at campaign launch**, not here. Don't ask about it during this flow.

## Related skills

- `/icp-setup` — invoked in step 2 (ICP interview + AI setup)
- `/social-listening` — offered in step 3
- `/list-builder` — offered in step 3
- `/signal-agent` — offered in step 3
- `/message-copywriting` — after list is built
- `/campaign-builder` — final step; LinkedIn account connection happens inside this skill
