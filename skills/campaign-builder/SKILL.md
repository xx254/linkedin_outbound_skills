---
name: campaign-builder
description: Creates and launches a LinkedIn outbound campaign in LinkedNav. Takes a sequence (from /message-copywriting), links a list, configures daily limits, and activates. Always creates in PAUSED state first — you review before going live. Triggers on "create campaign", "launch campaign", "set up campaign", "start outreach".
---

# LinkedNav Campaign Builder

Creates a LinkedNav campaign, loads your message sequence, links your list, and launches — in that order. Always starts paused so you can review before going live.

## Why this exists

LinkedNav campaigns are the engine. Without a properly configured campaign, sequences don't send, daily limits aren't enforced, and LinkedIn accounts get flagged for unusual activity. This skill configures everything correctly the first time.

## Inputs

- `linkedin-sequence.md` (from `/message-copywriting`)
- A LinkedNav list ID (from `/list-builder` or `/social-listening`)
- Your `client-profile.yaml` for naming and context

## Outputs

- A named, configured campaign in LinkedNav (starts PAUSED)
- List linked to campaign
- Daily limits set
- Campaign activated (after your review)

## Steps

### Step 1: Check existing campaigns

Call `mcp__claude_ai_LinkedNav__get_campaigns` and show active campaigns:
```
Active campaigns:
- <name> (<status>, <N> leads, <accept rate>%)
- ...
```

Warn if there are already 3+ active campaigns on one LinkedIn account — LinkedIn flags high simultaneous outreach volume.

### Step 2: Name the campaign

Suggest: `<icp-slug>-<list-source>-<YYYY-MM-DD>`
Examples:
- `vp-marketing-social-listening-2026-05`
- `head-growth-csv-import-2026-05`
- `cmo-competitor-engagers-q2`

### Step 3: Create the campaign

Call `mcp__claude_ai_LinkedNav__create_campaign` with:
- Name
- Status: `paused` (always start paused)
- Connection note text (from sequence)
- Message sequence steps

Show the created campaign ID and confirm it was created successfully.

### Step 4: Link the list

Call `mcp__claude_ai_LinkedNav__link_list_to_campaign` with the campaign ID and list ID.

Confirm: "List `<list name>` (<N> contacts) linked to campaign `<campaign name>`."

### Step 5: Configure campaign settings

Call `mcp__claude_ai_LinkedNav__update_campaign` to set:

```yaml
daily_connection_requests: <N>   # Recommended: 10-20 for new accounts, 20-30 for established
daily_messages: <N>              # Recommended: 10-15
timezone: <user's timezone>
active_days: [Mon, Tue, Wed, Thu, Fri]
active_hours:
  start: "09:00"
  end: "18:00"
```

Show recommended settings based on account age:

| Account age | Connection requests/day | Messages/day |
|------------|------------------------|-------------|
| <3 months  | 5-10 | 5-10 |
| 3-12 months | 10-20 | 10-15 |
| 1+ year | 15-25 | 15-20 |
| Premium/Sales Nav | 20-30 | 20-25 |

Ask the user to confirm or adjust before saving.

### Step 6: Review campaign before launch

Call `mcp__claude_ai_LinkedNav__get_campaign` and display a full summary:

```
=== Campaign Review ===

Name: <name>
Status: PAUSED (safe to review)
List: <list name> (<N> contacts)
Daily limit: <N> connection requests, <N> messages

Connection Note (<chars> chars):
"<full text>"

Message 1 (after acceptance):
"<full text>"

Message 2 (day 7, if no reply):
"<full text>"

Message 3 (day 14, break-up):
"<full text>"

Estimated timeline:
- At <N>/day, full list contacted in ~<X> weeks
- Expected acceptance rate: 20-35% (typical for this ICP)
- Expected reply rate: 5-15% of accepted

Does everything look right? Reply YES to activate or tell me what to change.
```

**DO NOT activate without explicit "yes" from the user.** Real messages go to real people.

### Step 7: Connect LinkedIn account

Before activating, verify a LinkedIn account is connected to LinkedNav.

Call `mcp__claude_ai_LinkedNav__get_linkedin_accounts`.

**If one or more accounts appear:**
```
LinkedIn account connected:
- <name> (<email>) — <status>

Using this account for the campaign. Confirm? (yes / change)
```

If multiple accounts: ask which one to use.

**If no accounts connected:**
```
No LinkedIn account is connected yet. You need one to send connection requests.

Steps:
1. Open app.linkedNav.com → Settings → LinkedIn Accounts
2. Click "Add Account"
3. Log in with your LinkedIn credentials
4. Approve the 2FA prompt if asked

Come back when connected.

[Press Enter when ready]
```

After they return, call `mcp__claude_ai_LinkedNav__get_linkedin_accounts` again to confirm, then call `mcp__claude_ai_LinkedNav__get_account_status` to check for blocking warnings:

| Warning | What it means | Fix |
|---------|--------------|-----|
| `needs_reauth` | LinkedIn session expired | Re-login in LinkedNav Settings |
| `profile_incomplete` | Missing photo or headline | Complete LinkedIn profile first |
| `warming_required` | New account needs warm-up | Enable warm-up in Settings; wait 1-2 weeks |
| `connection_limit_reached` | Hit weekly cap (~100) | Wait until Monday; cap resets weekly |

Don't proceed to Step 8 if health shows a blocking warning.

### Step 8: Activate

Only after explicit confirmation AND LinkedIn account is connected and healthy:

Call `mcp__claude_ai_LinkedNav__activate_campaign`.

Confirm:
```
✓ Campaign "<name>" is now ACTIVE.

Sending will start within the next scheduled active window (<timezone>, M-F 9am-6pm).

Recommended: check /analytics after 3 days to see early acceptance rates.
```

## Safety rails

- **Never activate a campaign without explicit user approval in this conversation.**
- **Never exceed LinkedIn's weekly connection limit.** Enforce daily limits that stay under 100/week total across all active campaigns.
- **Warn on duplicate campaigns.** If a campaign with similar name or list already exists, ask before creating a new one.
- **Paused state is your friend.** If anything looks wrong mid-campaign: call `mcp__claude_ai_LinkedNav__pause_campaign`.

## Managing existing campaigns

To pause: `mcp__claude_ai_LinkedNav__pause_campaign`
To update settings: `mcp__claude_ai_LinkedNav__update_campaign`
To duplicate for A/B testing: `mcp__claude_ai_LinkedNav__duplicate_campaign`
To delete (only if no contacts have been messaged): `mcp__claude_ai_LinkedNav__delete_campaign`

## What to do next

Campaign is live.

**Day 1-3:** Let it run. Don't touch it.

**Day 3:** → `/analytics` to check early acceptance rates. If <15%, connection note may need a rewrite.

**Ongoing:** → `/inbox-manager` to handle replies, approve pending AI-generated responses.

**Week 2:** → `/analytics` for full performance review and optimization.

## Related skills

- `/message-copywriting` — writes the sequence this skill loads
- `/list-builder` or `/social-listening` — produce the list
- `/inbox-manager` — manage replies after launch
- `/analytics` — review performance after first week
