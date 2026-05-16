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

### Step 1: Check existing lists

Call `mcp__claude_ai_LinkedNav__get_lists` to show existing lists:
```
Existing lists:
- <name> (<N> contacts, created <date>)
- ...
```

Ask: "Add to an existing list or create a new one?"

### Step 2: Create a new list (if needed)

Ask for a name. Suggest: `<icp-slug>-<YYYY-MM-DD>` (e.g., `vp-marketing-us-2026-05-16`).

Call `mcp__claude_ai_LinkedNav__create_list` with the name.

### Step 3: Import contacts

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

### Step 4: Review list contents

Call `mcp__claude_ai_LinkedNav__get_list_contacts` on the new list and show a sample of 10 contacts:
```
Sample from "<list name>":
- John Smith, VP Marketing @ Acme Corp
- Sarah Lee, Head of Growth @ Startup XYZ
...
```

### Step 5: (Optional) Link to campaign

Ask: "Do you want to link this list to an existing campaign?"

If yes: call `mcp__claude_ai_LinkedNav__link_list_to_campaign`.

If no: the list stays available for later. They can link it in `/campaign-builder`.

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

Good names tell you exactly what's in the list:
- `vp-marketing-us-funded-2026-05` — VP Marketing, US, recently funded
- `social-listening-competitor-a-may26` — engagers from Competitor A
- `inbound-demo-requests-q2-2026` — inbound leads
- `account-list-top50-targets` — named account ABM

Bad names: `list1`, `test`, `may leads`

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
