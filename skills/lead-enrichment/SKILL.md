---
name: lead-enrichment
description: Enriches LinkedNav contacts with email addresses and phone numbers. Runs email enrichment first, then optionally phone. Use after list building and before any multi-channel outreach (email + LinkedIn). Triggers on "enrich contacts", "find emails", "get phone numbers", "email enrichment".
---

# LinkedNav Lead Enrichment

Adds email addresses and phone numbers to your LinkedNav contacts so you can run multi-channel outreach (LinkedIn + email) from the same list.

## Why this exists

LinkedIn outreach alone has a ceiling: ~100 connection requests/week per account. If you want to reach the same people on email (and you should — multi-channel outreach has 2-3x higher reply rates), you need their email. This skill runs the enrichment directly through LinkedNav's built-in enrichment engine.

## When to use

- After building a list (before campaign launch)
- When you want to run email + LinkedIn in parallel
- When a LinkedIn contact hasn't accepted a connection but you want to follow up by email

## Steps

### Step 1: Check enrichment status

For a specific contact or a batch, check current enrichment status:

Call `mcp__claude_ai_LinkedNav__get_enrichment_status` to see:
```
List: <name> (<N> contacts)
Email enriched: <N> (<rate>%)
Phone enriched: <N> (<rate>%)
Pending enrichment: <N>
```

### Step 2: Enrich emails

**For a single contact:**
Call `mcp__claude_ai_LinkedNav__enrich_contact_email` with the contact ID.

**For a bulk list (recommended):**
Call `mcp__claude_ai_LinkedNav__enrich_contacts_email_bulk` with the list of contact IDs.

Show progress:
```
Email enrichment running...
- Processing <N> contacts
- Estimated time: ~<X> minutes

[Will notify when complete]
```

After completion, show results:
```
Email enrichment complete:
- Found emails: <N> (<rate>%)
- Not found: <N>
- Confidence: <% high confidence / % medium / % low>
```

### Step 3: Enrich phone (optional)

Ask: "Do you also want to enrich phone numbers? Phone enrichment costs additional credits."

If yes:
**Single:** `mcp__claude_ai_LinkedNav__enrich_contact_phone`
**Bulk:** `mcp__claude_ai_LinkedNav__enrich_contacts_phone_bulk`

Check phone enrichment status: `mcp__claude_ai_LinkedNav__get_phone_enrichment_status`

### Step 4: Validate enriched data

After enrichment, call `mcp__claude_ai_LinkedNav__get_contacts` to review a sample of enriched contacts.

Flag:
- Emails that look like catch-all patterns (info@, contact@) — deprioritize for email outreach
- Emails on domains different from the company domain — verify before sending
- Missing emails (will need LinkedIn-only outreach)

### Step 5: Export for email campaign

If using enriched emails in a separate email tool (Smartlead, etc.), export the enriched list as CSV.

Display the enriched contacts or offer to export them via `mcp__claude_ai_LinkedNav__get_list_contacts`.

## Credit usage estimate

| Contacts | Email enrichment credits | Phone enrichment credits |
|----------|------------------------|-------------------------|
| 100 | ~100 credits | ~100 credits |
| 500 | ~500 credits | ~500 credits |
| 1,000 | ~1,000 credits | ~1,000 credits |

Email enrichment finds addresses for ~60-80% of B2B contacts depending on company size. Small companies (<20 employees) have lower coverage.

## Multi-channel strategy

Once enriched, run email and LinkedIn in parallel, NOT in sequence:
- LinkedIn connection request → acceptance → messages
- Email sequence → separate Smartlead campaign using same contacts

Avoid sending both a LinkedIn message AND an email on the same day. 1-2 day offset between channels feels coordinated, not spammy.

## What to do next

Contacts are enriched.

**If using email too:** export the list and upload to Smartlead. (Email outbound skills: see the `coldoutboundskills` repo.)

**Back to LinkedIn:** → `/list-quality` to re-grade the list now that emails are populated.

**Or directly:** → `/campaign-builder` if list is already quality-checked.

## Related skills

- `/list-builder` — builds the list to enrich
- `/list-quality` — re-run quality check after enrichment (catch-all detection)
- `/campaign-builder` — use enriched contacts in the LinkedIn campaign
