---
name: list-quality
description: Pre-campaign quality scorecard for any LinkedNav contact list. Grades duplicate rate, title relevance, profile completeness, ICP fit, and LinkedIn URL validity. Outputs a letter grade (A-F) and top issues to fix BEFORE you send. Run after list building, before campaign creation.
---

# LinkedNav List Quality Scorecard

A list of 500 LinkedIn profiles is not the same as a good list of 500 LinkedIn profiles. This skill grades your list before you connect with anyone.

## Why this exists

LinkedIn campaigns are not free to undo. Each connection request you send is visible on your profile (and theirs). Sending to the wrong people doesn't just waste credits — it pollutes your acceptance rate, which LinkedIn uses to throttle future requests. Catching list issues here saves your account health.

## Inputs

- A LinkedNav list ID (from `/list-builder` or `/social-listening`)
- Optional: `client-profile.yaml` (from `/icp-setup`) for ICP fit scoring

## Output

A markdown scorecard with:
- **Overall score** (1-10)
- **6 dimension scores** (each 1-10)
- **Top issues to fix**
- **Pre-send checklist**

## The 6 dimensions

### 1. LinkedIn URL validity (critical)

- **What:** % of contacts with a valid `linkedin_url` (not null, not `[object Object]`, not a company page URL)
- **Rule:** 100% must have valid personal LinkedIn URLs. Company URLs will fail silently.
- **Score:** 10 if all valid, 1 if <80% valid

### 2. Duplicate profiles

- **What:** % of duplicate LinkedIn URLs in the list
- **Rule:** <1% acceptable. Same person appearing twice wastes a connection slot and looks spammy if they get two requests.
- **Score:** 10 at 0% duplicates, drops linearly

### 3. Title relevance

- **What:** % of titles matching your ICP's job title list (from `client-profile.yaml`)
- **Rule:** ≥80% match. If 30% of your "VP Marketing" list is actually "Marketing Coordinator", you have ICP drift.
- **Score:** 10 if ≥80% match, 5 if 40-80%, 1 if <40%

### 4. Bad-title detection

- **What:** % of titles matching known off-ICP patterns
- **Bad patterns:** `intern`, `student`, `assistant`, `coordinator`, `part-time`, `retired`, `freelance`, `job seeker`, non-English titles when targeting US/English-speaking markets
- **Score:** 10 if <2%, drops sharply after

### 5. Profile completeness

- **What:** % of contacts with both first + last name AND a non-empty company name
- **Rule:** 95%+ acceptable. Missing names break personalization variables.
- **Score:** 10 if 95%+, drops linearly

### 6. ICP fit (optional — requires client-profile.yaml)

- **What:** % of contacts matching your declared industry + headcount filters
- **Rule:** ≥80% match
- **Score:** 10 if ≥80%, drops linearly

## Score mapping

Weighted average (URL validity weighted 2x):

| Score | Action |
|-------|--------|
| 9-10 | Launch it |
| 7-8 | Minor fixes, then launch |
| 5-6 | Fix top issues first |
| 3-4 | Serious cleanup needed |
| 1-2 | Rebuild the list |

## Steps

> Tell the user: "I'm going to score your list across 6 dimensions before you send a single connection request. This catches bad data that would waste your weekly connection quota."

### Step 1: Load the list

> Tell the user: "**Step 1 of 4 — Loading list.** Pulling your contacts from LinkedNav."

Ask which LinkedNav list to score. If they don't know the list ID, call `mcp__claude_ai_LinkedNav__get_lists` to show options.

Call `mcp__claude_ai_LinkedNav__get_list_contacts` to pull all contacts.

> When done, tell the user: "[N] contacts loaded. Running quality checks now."

### Step 2: Run each dimension

> Tell the user: "**Step 2 of 4 — Scoring.** Checking LinkedIn URL validity, duplicates, title relevance, bad titles, profile completeness, and ICP fit."

Score each dimension programmatically from the contact data. For ICP fit, load `client-profile.yaml` if available.

> When done, tell the user: "Scoring done. Here's your scorecard."

### Step 3: Present the scorecard

```
=== LinkedNav List Quality Scorecard ===

List: <name> (<N> contacts)
Overall score: <score>/10

Dimensions:
1. LinkedIn URL validity:  <score>/10  (<N> valid of <total>)
2. Duplicate profiles:     <score>/10  (<N> duplicates)
3. Title relevance:        <score>/10  (<N>% match ICP titles)
4. Bad-title detection:    <score>/10  (<N> off-ICP titles)
5. Profile completeness:   <score>/10  (<N>% have full name + company)
6. ICP fit:                <score>/10  (<N>% match filters) [or: N/A — no ICP file]

Top issues to fix:
1. [Issue] — [fix]
2. [Issue] — [fix]
...

Pre-send checklist:
[ ] Remove duplicate profiles
[ ] Filter off-ICP titles
[ ] Fix or remove contacts with invalid LinkedIn URLs
[ ] Confirm list is <100 new contacts/week (LinkedIn limit)
[ ] Run /lead-enrichment if email addresses needed
```

> After showing the scorecard, tell the user: "→ If score ≥ 7: you're good to go → /message-copywriting. If score < 7: let's fix the top issues first."

### Step 4: Fix issues (if grade < B)

> Tell the user: "**Step 4 of 4 — Fixing issues.** [Removing duplicates / filtering off-ICP titles / handling invalid URLs]. I'll show you each change before making it."

For duplicate cleanup: call `mcp__claude_ai_LinkedNav__bulk_delete_contacts` on duplicates.

For off-ICP title filtering: show the list of flagged contacts, confirm which to remove, then delete.

For missing LinkedIn URLs: these contacts cannot be reached via LinkedIn outbound. Offer to move them to a separate list for email outreach instead.

Re-run the scorecard after fixes until score ≥ 7.

> When done, tell the user: "Fixes applied. Re-running the score to confirm. → When score ≥ 7: next step is /message-copywriting."

## LinkedIn-specific limits

Even an A-grade list needs to respect LinkedIn's weekly limits:

| Account type | Safe connection requests/week |
|-------------|------------------------------|
| New account (<3 months) | 20-30 |
| Established account | 50-80 |
| Premium/Sales Navigator | 80-100 |

Warn if the list is larger than what can be safely sent in 4 weeks. Suggest splitting into weekly batches.

## What to do next

**If score ≥ 7:** → `/message-copywriting` to write connection request + sequences.

**If score < 5:** fix the top 3 issues, re-run this skill. Don't launch a low-quality list — poor acceptance rates damage your account standing.

## Related skills

- `/list-builder` — builds the list this skill scores
- `/social-listening` — alternative list source
- `/icp-setup` — produces `client-profile.yaml` used for ICP fit scoring
- `/lead-enrichment` — enrich contacts with email/phone if needed
- `/message-copywriting` — next step after list passes quality check
