---
name: account-setup
description: Sets up a LinkedNav account and connects Claude Code to LinkedNav via MCP. Creates the account, generates the API key, and verifies the integration is live. LinkedIn profile connection happens later, at campaign launch time. Triggers on "set up LinkedNav", "get API key", "account setup", "connect MCP".
---

# LinkedNav Account Setup

Gets your LinkedNav account created and Claude Code wired up to it via MCP. LinkedIn profile connection is a separate step that happens when you're ready to launch a campaign.

## What this skill produces

- A verified LinkedNav account
- MCP integration working (Claude can call LinkedNav tools)
- API key saved to local environment
- Billing plan confirmed

## Steps

When the skill starts, tell the user:
"I'll get your LinkedNav account connected to Claude Code. This takes about 5 minutes."

### Step 1: Check if user has a LinkedNav account

Tell the user: "**Step 1 of 4 — LinkedNav account** — Checking if you have a LinkedNav account before we do anything else."

Ask:
> "Do you already have a LinkedNav account?"

**If NO:**
```
Sign up at: https://www.linkednav.com
Use a business email. After you've created your account, come back here.

[Press Enter when ready]
```

**If YES:** proceed to Step 2.

When done, tell the user: "Account confirmed. → Next: testing if Claude Code can talk to LinkedNav."

### Step 2: Check MCP integration

Tell the user: "**Step 2 of 4 — MCP connection** — Testing if Claude Code can talk to LinkedNav."

Call `mcp__claude_ai_LinkedNav__get_dashboard_summary` to verify the MCP connection is live.

If it returns data → connection is live, skip to Step 4.

If it errors:
```
The LinkedNav MCP integration isn't connected. Two ways to fix it:

Option A — OAuth (easier):
1. Run /mcp in Claude Code
2. Select "claude.ai LinkedNav" from the list
3. Complete authentication in your browser
4. Come back here

Option B — API key:
1. Get your API key: https://www.linkednav.com/app/api-keys
2. In Claude Code, open Settings → MCP Servers and add:

   {
     "linkedNav": {
       "type": "http",
       "url": "https://mcp.linkednav.com",
       "headers": { "Authorization": "Bearer YOUR_API_KEY" }
     }
   }

3. Restart Claude Code and come back here

Full guide: https://www.linkednav.com/app/integrations/mcp
```

When done, tell the user: "MCP connection verified. → Next: setting up your API key so Claude Code can call LinkedNav."

### Step 3: Get the API key

Tell the user: "**Step 3 of 4 — API key** — Setting up the API key so Claude Code can authenticate with LinkedNav."

Guide the user to their LinkedNav API key:

```
1. Go to https://www.linkednav.com/app/api-keys
2. Copy your API key
3. In Claude Code, open Settings → MCP Servers and add:

{
  "linkedNav": {
    "type": "http",
    "url": "https://mcp.linkednav.com",
    "headers": { "Authorization": "Bearer YOUR_API_KEY" }
  }
}

4. Restart Claude Code

Full guide: https://www.linkednav.com/app/integrations/mcp
```

Confirm the key is working by calling `mcp__claude_ai_LinkedNav__get_account_status`.

When done, tell the user: "API key is working. → Next: confirming your plan supports campaigns."

### Step 4: Check billing

Tell the user: "**Step 4 of 4 — Billing** — Confirming your plan supports campaigns and checking your send limits."

Call `mcp__claude_ai_LinkedNav__get_billing_summary` and confirm they're on a plan that supports campaigns. Warn if they're on a free/trial plan that limits daily sends.

Confirm:
```
LinkedNav account: active
MCP integration: connected
Plan: <plan name> — supports up to <N> campaigns / <N> messages/day
```

When done, tell the user: "All set. LinkedNav is connected and your plan supports campaigns. → Next step: run /kickoff to define your ICP and pick a list-building approach."

## What to do next

Account is set up and Claude Code is connected to LinkedNav.

**Start the full flow:** → `/kickoff` to define your ICP and pick a list-building approach.

**Or jump straight to list building:**
- `/social-listening` — find competitor engagers
- `/list-builder` — import a CSV

**Note:** LinkedIn profile connection happens inside `/campaign-builder` when you're ready to launch. No need to do it here.

## Related skills

- `/kickoff` — start here after account setup
- `/icp-setup` — next step to define your target persona
- `/campaign-builder` — LinkedIn profile connection happens inside this skill at launch time
