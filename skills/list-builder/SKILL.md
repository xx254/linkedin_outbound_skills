---
name: list-builder
description: Builds and manages LinkedIn contact lists in LinkedNav. Imports contacts from CSV, creates lists, adds leads in bulk, and links lists to campaigns. Use when you have a CSV of LinkedIn profiles or company names, or when you need to organize existing contacts into a named list. Triggers on "build a list", "import contacts", "add leads", "create a list".
---

# LinkedNav List Builder

Takes a CSV of LinkedIn profiles (or company names) and turns them into a named, campaign-ready LinkedNav contact list.

## Why this exists

LinkedNav campaigns run on lists. Before you can send connection requests or messages, your leads need to be in a LinkedNav list. This skill handles the import and organization, so you can go from CSV → campaign in one pass.

## Inputs

- A CSV file with at minimum: `linkedin_url` OR `first_name` + `last_name` + `company_name`
- Optional: `email`, `phone`, `job_title`, `company_domain`

## Outputs

- A named list in LinkedNav with all imported contacts
- (Optional) List linked to a campaign

## Steps

When the skill starts, tell the user:
"I'll import your contacts into a named LinkedNav list. Have your CSV ready — it needs at minimum a linkedin_url column, or first_name + last_name + company_name."

### Step 0: Identify which ICP this list belongs to

Call `mcp__claude_ai_LinkedNav__get_ai_setups` to check existing setups.

**If 0 setups exist (first time user):**
Tell the user:
```
No ICP profile found. How do you want to proceed?

[A] Give me your landing page or service description → I'll walk you through
    a full ICP setup in LinkedNav (/icp-setup). Takes ~10 min, gives better
    AI personalization on your campaigns.

[B] Tell me who you're targeting in one sentence → I'll start building your
    list right now. You can set up the full ICP later.

Pick A or B:
```
- If A: invoke `/icp-setup`, then continue with the slug from that setup.
- If B: ask "Who are you targeting?" and generate a slug from their answer (e.g., `vp-marketing-saas-us`). Use this as the list prefix.

**If exactly 1 setup exists:**
Auto-select it silently. Tell the user: "Using your ICP: **<setup name>**." Then continue — no need to ask.

**If 2+ setups exist:**
This is required to prevent leads from different ICPs getting mixed. Show the list:
```
You have multiple ICP setups:
- <name 1> (active)
- <name 2>
...

Which setup is this list for? Or is this for a new ICP? (If new → run /icp-setup first)
```
Use the selected setup's slug as the list prefix. Do not proceed until the user picks one.

### Step 1: Check existing lists

Tell the user: "**Step 1 of 5 — Existing lists** — Checking what lists you already have so we don't create duplicates."

Call `mcp__claude_ai_LinkedNav__get_lists` to show existing lists:
```
Existing lists:
- <name> (<N> contacts, created <date>)
- ...
```

Ask: "Add to an existing list or create a new one?"

When done, tell the user: "Got it. [Creating a new list / Adding to your existing list] → Next: setting up the list."

### Step 2: Create a new list (if needed)

Tell the user: "**Step 2 of 5 — Creating list** — Setting up a named list for this campaign."

Suggest a name using the active AI setup slug as prefix: `<ai-setup-slug>-csv-<YYYY-MM-DD>`
Example: if active setup is `elevenlabs-icp` → suggest `elevenlabs-icp-csv-2026-05-16`.

The user may adjust the middle part but the AI setup slug prefix is required. Do not create a list without it.

Call `mcp__claude_ai_LinkedNav__create_list` with the name.

When done, tell the user: "List created. → Next: importing your contacts."

### Step 3: Import contacts

Tell the user: "**Step 3 of 5 — Importing contacts** — Adding your contacts to the list now."

Ask the user to provide the CSV path or paste LinkedIn URLs directly.

For each contact, call `mcp__claude_ai_LinkedNav__create_lead` with:
- `linkedin_url` (preferred)
- `first_name`, `last_name`, `company_name` (fallback)
- Any other available fields

For bulk imports (>20 contacts): use `mcp__claude_ai_LinkedNav__create_leads_bulk` to send all at once.

Show progress:
```
Importing... 
✓ 50/200 contacts added
✓ 100/200 contacts added
✓ Done — 198 contacts added (2 skipped: missing LinkedIn URL)
```

Skipped contacts: list them with the reason. Don't silently drop them.

When done, tell the user: "Import done — [N] contacts added. Let me show you a sample."

### Step 4: Review list contents

Tell the user: "**Step 4 of 5 — Review** — Showing a sample of imported contacts so you can spot any issues before we go further."

Call `mcp__claude_ai_LinkedNav__get_list_contacts` on the new list and show a sample of 10 contacts:
```
Sample from "<list name>":
- John Smith, VP Marketing @ Acme Corp
- Sarah Lee, Head of Growth @ Startup XYZ
...
```

When done, tell the user: "List looks good. → Next: grade the list with /list-quality before sending to catch duplicates and off-ICP contacts."

### Step 5: (Optional) Link to campaign

Tell the user: "**Step 5 of 5 — Link to campaign (optional)** — Do you want to link this list to an existing campaign now, or do it later in /campaign-builder?"

Ask: "Do you want to link this list to an existing campaign?"

If yes: call `mcp__claude_ai_LinkedNav__link_list_to_campaign`.

If no: the list stays available for later. They can link it in `/campaign-builder`.

When done, tell the user: "All done. Your list is ready. → Run /list-quality to grade it before sending."

### Step 6: Move or merge (if cleanup needed)

If the user has stale contacts to remove: use `mcp__claude_ai_LinkedNav__bulk_delete_contacts` or `mcp__claude_ai_LinkedNav__bulk_move_contacts` to reorganize.

## CSV format reference

Minimum required:
```csv
linkedin_url,first_name,last_name,job_title,company_name,company_domain
https://linkedin.com/in/janedoe,Jane,Doe,VP Marketing,Acme,acme.com
```

`linkedin_url` is the most reliable identifier. First+last+company is a fallback.

## List naming conventions

All lists must be prefixed with the active AI setup slug to keep leads from different ICPs separated:

```
<ai-setup-slug>-<source>-<YYYY-MM-DD>
```

Examples (AI setup: `elevenlabs-icp`):
- `elevenlabs-icp-csv-2026-05-16` — CSV import
- `elevenlabs-icp-social-listening-2026-05` — competitor engagers
- `elevenlabs-icp-signal-agent-2026-05` — intent signals
- `elevenlabs-icp-inbound-q2` — inbound leads

Bad names: `list1`, `test`, `may leads`, or any name without the AI setup prefix.

## What to do next

List is built.

**Next:** Grade it → `/list-quality` (catches duplicates, off-ICP titles, bad profiles before you send)

**Then:** Write messages → `/message-copywriting`

**Then:** Create campaign → `/campaign-builder`

## Related skills

- `/icp-setup` — produces `client-profile.yaml` used for ICP checks
- `/social-listening` — alternative list-building path (warm engagers)
- `/list-quality` — run after building to grade the list
- `/lead-enrichment` — enrich imported contacts with email/phone
- `/campaign-builder` — link the list to a campaign and launch
