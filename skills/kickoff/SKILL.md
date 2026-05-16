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

1. Get your API key: https://www.linkednav.com/app/api-keys
2. Follow the MCP setup guide: https://www.linkednav.com/app/integrations/mcp

In Claude Code Settings → MCP Servers, add:
{
  "linkedNav": {
    "type": "http",
    "url": "https://mcp.linkednav.com",
    "headers": { "Authorization": "Bearer YOUR_API_KEY" }
  }
}

Restart Claude Code, then run /kickoff again.
Or run /account-setup for step-by-step help.
```

Stop. Do not proceed until the MCP connection is confirmed working.

---

When the skill starts (MCP confirmed), tell the user:
"We're going to define your target ICP and pick a list-building approach. This takes about 10-15 minutes. Let's start."

### Step 1 (asked FIRST): Business context

Tell the user: "**Step 1 of 3 — Your business** — What's the website of the business you're running LinkedIn outbound for? (or give me a two-sentence description)"

Ask only this one question. After getting the answer, move straight to Step 2 — do NOT ask the user about their LinkedNav setup status.

When done, tell the user: "Got it. Let me check if you already have an ICP profile set up."

### Step 2: Load or create the ICP profile

Tell the user: "**Step 2 of 3 — Target persona**"

First, call `mcp__claude_ai_LinkedNav__get_ai_setups` to check if any AI setups exist in LinkedNav. Also check for `profiles/<business-slug>/client-profile.yaml`.

- **Both exist** → load the profile silently. Tell the user: "Found your existing ICP profile. Let me pull it up." Ask: "Use this profile or start fresh?"
- **Only local YAML exists** → load it silently, proceed.
- **Nothing exists** → tell the user: "No ICP profile found — let's build one. I'll ask you ~10 questions about who you're targeting." Then invoke `/icp-setup`.

Do not ask the user to tell you whether they've set up an ICP. Check it yourself.

When done, tell the user: "ICP is ready. → Next: picking your list-building approach."

### Step 3: Interactive next-skill menu

Tell the user: "**Step 3 of 3 — List-building approach** — Based on your ICP, here's my recommendation for how to find leads."

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

Tell the user: "**Almost done — Campaign plan** — Saving your campaign checklist so you have a single reference for the full workflow."

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
