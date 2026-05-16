---
name: icp-setup
description: Sets up a LinkedNav AI setup and ICP profile from a website or description. Auto-generates the full ICP using LinkedNav's AI — user confirms or adjusts, no lengthy interview. Outputs client-profile.yaml and an active AI setup in LinkedNav. Triggers on "set up ICP", "define my target", "who should I reach out to", "create AI setup".
---

# LinkedNav ICP Setup

Reads your website, auto-generates your ICP using LinkedNav's AI, and asks you to confirm. No 10-question interview — just review and adjust what's wrong.

## Inputs

Either:
- **Website URL** of the business
- **Plain description** ("I sell X to Y")

## Outputs

- `profiles/<business-slug>/client-profile.yaml` — local targeting reference
- An active AI setup in LinkedNav with full ICP configuration

## Steps

When the skill starts, tell the user:
"I'll generate your ICP automatically from your website. This takes about 2 minutes — you just confirm what looks right."

### Step 1: Get the website

Tell the user: "**Step 1 of 4 — Your business** — What's the website of the business you're running LinkedIn outbound for?"

If URL provided: fetch and read the homepage, About page, and any "Customers" or "Case Studies" pages.

If no website: ask for a 2-3 sentence description of what they sell and who buys it.

When done, tell the user: "Got it. Generating your ICP now — this takes a few seconds."

### Step 2: Auto-generate the ICP

Tell the user: "**Step 2 of 4 — Generating ICP** — LinkedNav's AI is building your targeting profile from the website."

Call `mcp__claude_ai_LinkedNav__create_ai_setup` with:
- Name: `<business-slug>-icp`
- Description: one-liner inferred from the website

Then immediately call `mcp__claude_ai_LinkedNav__generate_ai_setup_icp` to auto-generate the full ICP.

Present everything at once:

```
Here's your auto-generated ICP. Review each field — confirm if it looks right,
or tell me what to change.

Business: <company name>
One-liner: <what they sell>

Target persona:
  Job titles:      <title 1>, <title 2>, <title 3>
  Seniority:       <C-suite / VP / Director / Manager>
  Industries:      <industry 1>, <industry 2>
  Headcount:       <min>–<max> employees
  Geography:       <countries>

Offer:
  CTA:             <what you're asking them to do>
  Value prop:      <why they should care>
  Proof point:     <case study or metric>

Triggers (soft signals):
  <trigger 1>, <trigger 2>

Does this look right? Reply:
  - "Looks good" to confirm and continue
  - Tell me specifically what's wrong (e.g. "headcount should be 50-500" or "add Germany to geography")
```

When done, tell the user: "ICP confirmed. Saving your profile now."

### Step 3: Apply corrections (if any)

If the user wants changes, update the specific fields they mentioned.

Call `mcp__claude_ai_LinkedNav__update_ai_setup` with the corrections.

Re-show only the changed fields and ask: "Anything else to adjust, or good to go?"

Do not re-ask all fields — only show what changed.

When done, tell the user: "All corrections applied. → Saving and activating."

### Step 4: Save yaml and activate

Tell the user: "**Step 4 of 4 — Saving and activating.**"

Write `profiles/<business-slug>/client-profile.yaml` from the confirmed ICP:

```yaml
business:
  name: <business name>
  website: <url>
  one_liner: <what they sell>
  tone: <casual|formal|peer-to-peer>

offer:
  primary_cta: <what you ask leads to do>
  value_prop: <why they should care, one sentence>
  proof_point: <case study or metric>

icp_hard_filters:
  job_titles:
    - <exact title>
    - <synonym>
  seniority: [C-Suite, VP, Director]
  industries_in:
    - <LinkedIn industry name>
  industries_out:
    - <LinkedIn industry name>
  headcount_min: <int>
  headcount_max: <int>
  countries:
    - <country name>
  excluded_companies: []

icp_soft_preferences:
  triggers:
    - recent_fundraise
    - posted_about: <topic>
    - connected_to_competitor
  personas_to_prioritize: []

legal:
  banned_words: []
  regulated_industry: false

created_at: <YYYY-MM-DD>
```

Call `mcp__claude_ai_LinkedNav__select_ai_setup` to activate.

Confirm:
```
ICP is live.

Profile saved to: profiles/<slug>/client-profile.yaml
LinkedNav AI setup: <name> (active)
AI setup slug: <slug>  ← prefix for all lists in this campaign
```

**Return flow:** If invoked from another skill (`/list-builder`, `/social-listening`, `/signal-agent`):
```
ICP setup complete. → Returning to list building.
```
Hand back with the AI setup slug so the calling skill continues automatically.

If invoked standalone:
```
→ Next: build your list. Pick one:

[A] /social-listening  — find people who recently liked, commented on, or shared
                         posts from your competitors' company pages or key influencers
                         in your space. Best for: warm leads already aware of the problem.

[B] /signal-agent      — AI monitors for real-time buying intent:
                         • Just moved jobs (new role → 90-day audit window)
                         • Just posted on LinkedIn (active and engaged right now)
                         • Company growing team (hiring = budget and urgency)
                         • New senior leadership (new boss = vendor reviews)
                         • Budget in hand (recent fundraise or budget signals)
                         Best for: reaching the right person at exactly the right moment.

[C] /list-builder      — import a CSV of LinkedIn profiles, or build a list manually.
                         Best for: account-based targeting, inbound leads, existing databases.

Which approach fits your situation?
```

## Common gotchas

- **Generated titles too broad:** Push for specificity — "Marketing" as a title misses most of your ICP. Ask: "What's the exact title of your last 3 customers?"
- **Titles: always include synonyms.** "VP of Marketing" without "Head of Marketing" / "CMO" misses 50% of matches.
- **Geography: LinkedIn defaults to current location, not company HQ.** If this matters, clarify which the user wants.

## Related skills

- `/kickoff` — calls this skill as part of onboarding
- `/social-listening` — next step for warm list building
- `/list-builder` — next step for cold list import
- `/message-copywriting` — uses the ICP profile for copy guidance
