---
name: social-listening
description: Finds warm LinkedIn leads by monitoring competitors and influencers. Tracks who's engaging with posts in your space, imports engagers as leads, and sets up auto-import. Best for: finding people already interested in your category before you pitch them. Triggers on "find leads", "competitor engagers", "who's engaging", "social listening", "track competitor".
---

# LinkedNav Social Listening

Finds people who are actively engaging with your competitors and key influencers on LinkedIn — these are warm leads who already care about your space.

## Why this exists

Cold LinkedIn outreach has a ~10-20% acceptance rate. Social listening outreach — reaching people who recently commented on or liked a competitor's post — can hit 30-50%+. They already know the problem exists. You're not educating; you're offering a choice.

This skill monitors the right posts, pulls the engagers, imports them as leads, and optionally auto-imports new engagers every 24 hours.

## Inputs

- At least one competitor LinkedIn URL or influencer LinkedIn URL
- Your `client-profile.yaml` (from `/icp-setup`) for ICP filtering

## Outputs

- Tracked competitors / influencers in LinkedNav
- Engager list imported into a LinkedNav contact list
- (Optional) Auto-import running on a schedule

## Steps

> Tell the user: "I'm going to find people who are already engaging with your competitors on LinkedIn — these are your warmest leads. We'll track the right accounts, pull engagers, and build your list."

### Step 1: Identify who to track

> Tell the user: "**Step 1 of 7 — Who to track.** I need your competitors' LinkedIn company pages and any key influencers in your space."

Ask:
> "Who are your 2-3 main competitors on LinkedIn? Paste their company page URLs."

Also ask:
> "Are there any thought leaders or influencers in your space who post content your ICP reads? Paste their profile URLs."

If they're unsure of competitor LinkedIn URLs, help them find them:
```
Search LinkedIn for: <competitor company name>
Look for the company page (building icon, not a personal profile).
Copy the URL: linkedin.com/company/<slug>
```

> When done, tell the user: "Got the URLs. → Setting up tracking now."

### Step 2: Track competitors

> Tell the user: "**Step 2 of 7 — Setting up tracking.** Adding these accounts to LinkedNav's monitoring system."

For each competitor URL:
```
mcp__claude_ai_LinkedNav__track_competitor
```

For each influencer URL:
```
mcp__claude_ai_LinkedNav__track_influencer
```

Confirm each was added successfully.

> When done, tell the user: "[N accounts tracked.] → Finding which posts have the most engagers."

### Step 3: Find qualifying posts

> Tell the user: "**Step 3 of 7 — Recent posts.** Here are the posts with the most engagement. Pick which ones to pull leads from."

Call `mcp__claude_ai_LinkedNav__get_social_listening_qualifying_posts` to see which recent posts have the most engagers.

Present a summary table:
```
Recent qualifying posts:

| Post | Author | Date | Engagers | Type |
|------|--------|------|----------|------|
| "<snippet>" | Competitor A | May 12 | 234 | Competitor |
| "<snippet>" | Influencer B | May 14 | 512 | Influencer |
...

Which posts do you want to pull engagers from? (All / pick by number)
```

> When done, tell the user: "Posts selected. → Pulling engager profiles."

### Step 4: Get engagers

> Tell the user: "**Step 4 of 7 — Engagers.** Pulling profiles of people who engaged with those posts and filtering against your ICP."

Call `mcp__claude_ai_LinkedNav__get_social_listening_engagers` for each selected post.

Filter against your ICP (from `client-profile.yaml`):
- Title match → keep
- Title clearly off-ICP → flag but don't auto-discard (ask the user)
- No title visible → keep (LinkedIn privacy settings)

Show a sample of 10-20 engagers for the user to review before bulk-importing.

> When done, tell the user: "[N ICP-matching engagers found.] → Check the stats summary, then we'll import."

### Step 5: Get stats

> Tell the user: "**Step 5 of 7 — Stats.** Here's the full picture of what's being tracked and how many leads are available."

Call `mcp__claude_ai_LinkedNav__get_social_listening_stats` to show overall pipeline:
```
Social listening stats:
- Competitors tracked: <N>
- Influencers tracked: <N>
- Total posts monitored: <N>
- Engagers found (last 30 days): <N>
- ICP-match estimate: ~<N> (based on title filter)
```

> When done, tell the user: "→ Ready to import. Which list should these go into?"

### Step 6: Import to a list

> Tell the user: "**Step 6 of 7 — Importing.** Adding engagers to your LinkedNav list."

Ask:
> "Import these <N> engagers to a new list or an existing one?"

If new list: call `mcp__claude_ai_LinkedNav__create_list` with name `social-listening-<date>`.

Then call `mcp__claude_ai_LinkedNav__add_leads_bulk_to_campaign` or add contacts to the list.

> When done, tell the user: "[N contacts imported.] → Want LinkedNav to auto-import new engagers every 24 hours?"

### Step 7: Set up auto-import (optional)

> Tell the user: "**Step 7 of 7 — Auto-import (optional).** Set this up once and new engagers will appear in your list daily without any manual work."

> "Do you want LinkedNav to automatically import new engagers every 24 hours?"

If yes:
```
mcp__claude_ai_LinkedNav__set_social_listening_auto_import
mcp__claude_ai_LinkedNav__trigger_social_listening_auto_import
```

This means every day, new people who engage with tracked posts get added to the list automatically.

Call `mcp__claude_ai_LinkedNav__get_social_listening_auto_import` to confirm it's active and show the import settings.

### Step 8: Check import task status

Call `mcp__claude_ai_LinkedNav__get_social_listening_auto_import_task` to confirm the first import ran and how many contacts were added.

> When done, tell the user: "All done. → Next: /list-quality to grade the list, then /message-copywriting."

## Quality note

Social listening leads are warm but not pre-verified for ICP fit. Always run `/list-quality` before adding to a campaign.

## LinkedIn safety limits

Engager lists can be large. Don't add more than 50-100 new leads per campaign per week. LinkedIn flags sudden spikes in connection requests.

## What to do next

Engagers are imported into a list.

**Next:** Grade the list → `/list-quality`

**Then:** Write messages → `/message-copywriting`

**Then:** Create campaign → `/campaign-builder`

## Related skills

- `/icp-setup` — required before running this skill (for ICP filtering)
- `/list-quality` — run after importing to grade the list
- `/list-builder` — alternative for cold list import
- `/message-copywriting` — write the connection request + sequences
- `/campaign-builder` — create and launch the campaign
