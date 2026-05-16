---
name: icp-setup
description: Conversational ICP intake for LinkedIn outbound. Interviews the user about their business and target persona, then creates a LinkedNav AI setup with the right ICP configuration. Outputs client-profile.yaml and a configured AI setup in LinkedNav. Use at campaign start or when targeting a new persona. Triggers on "set up ICP", "define my target", "who should I reach out to", "create AI setup".
---

# LinkedNav ICP Setup

Translates "I sell X to Y" into a working LinkedNav AI setup with targeting rules, personalization prompts, and a saved `client-profile.yaml`.

## Why this exists

LinkedIn outreach fails the same way cold email fails: wrong people, wrong message. Before building any list or writing any message, you need to know exactly who you're targeting and why they should care. This skill forces that precision.

LinkedNav's AI setup also uses your ICP to auto-generate personalized connection requests and messages at scale. The better your ICP, the better the AI output.

## Inputs

Either:
- **Website URL** of the business
- **Plain description** ("I sell X to Y")

## Outputs

- `profiles/<business-slug>/client-profile.yaml` — local targeting reference
- A created/updated AI setup in LinkedNav (`mcp__claude_ai_LinkedNav__create_ai_setup`)
- ICP auto-generated in LinkedNav (`mcp__claude_ai_LinkedNav__generate_ai_setup_icp`)

## Steps

When the skill starts, tell the user:
"I'm going to interview you to define your ideal customer profile. This creates a client-profile.yaml and sets up LinkedNav's AI personalization. Takes about 10 minutes."

### Step 1: Ask for the website URL first

Tell the user: "**Step 1 of 6 — Your business** — Let me read your website to understand what you sell before we start the interview."

> "What's the website of the business you're running LinkedIn outbound for?"

If URL provided: fetch and read the homepage, About page, and any "Customers" or "Case Studies" pages. Summarize what you learned:

> "Based on your website, here's what I understand:
>
> **<Company>** sells <product/service> to <target customer>. Core value prop: <summary>. Social proof: <logos, metrics>. Pricing signal: <self-serve / enterprise / unclear>.
>
> **Proposed LinkedIn ICP:** <titles> at <industry> companies with <headcount range>.
>
> Does that look right? Any corrections before the interview?"

If no website: ask for a two-sentence description.

When done, tell the user: "Got it. Now let's nail down who you're targeting."

### Step 2: ICP interview

Tell the user: "**Step 2 of 6 — ICP interview** — I'll ask you 10 questions one at a time. Be specific — vague answers produce vague targeting."

Ask these questions one at a time. Pre-fill proposed answers from the website where possible.

1. **What do you sell in one sentence?**
2. **Name your single best customer.** (If they hesitate: "Who's the most recent customer you closed that you'd want 100 more of?")
3. **What LinkedIn job title buys this?** Push back if they say "CEO" for companies >50 employees — it's almost never true at that scale.
4. **Seniority level?** (C-suite / VP / Director / Manager / Individual Contributor)
5. **Company headcount range?** (Give specific numbers — not "SMB". E.g. 20-200.)
6. **Industries — in or out?** Mark each as IN or OUT. No fuzzy "maybe."
7. **Geography?** Countries only, or specific cities/regions?
8. **Any triggers?** (Recently raised money, posted about a specific topic, connected to a competitor, etc.)
9. **What are you asking them to do?** (Book a call, reply with interest, watch a demo, etc.)
10. **Why would they say yes?** One sentence proof point or case study.

When done, tell the user: "Good. Now let's separate the must-haves from the nice-to-haves."

### Step 3: Split hard vs soft filters

Tell the user: "**Step 3 of 6 — Hard vs soft filters** — This decides what disqualifies a lead entirely versus what just makes them more interesting to prioritize."

For each criterion, ask: **"If you find someone who matches everything except this, do you reach out anyway?"**

- YES → soft preference (log it, use for personalization)
- NO → hard filter (must match before outreach)

LinkedIn-specific guidance:
- Job title: usually HARD
- Industry: usually HARD if targeting a vertical
- Headcount: usually SOFT at the edges
- Trigger (fundraise, post, etc): ALMOST ALWAYS SOFT — it's a personalization signal, not a filter

When done, tell the user: "Got it. Writing your ICP profile now."

### Step 4: Write client-profile.yaml

Tell the user: "**Step 4 of 6 — Saving profile** — Writing your client-profile.yaml with everything we just covered."

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
  seniority: [C-Suite, VP, Director]  # LinkedIn seniority levels
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
  personas_to_prioritize:
    - <e.g. "Directors over VPs at <50 headcount">

legal:
  banned_words: []
  regulated_industry: false

created_at: <YYYY-MM-DD>
```

Save to `profiles/<business-slug>/client-profile.yaml`.

When done, tell the user: "Profile saved. → Next: creating your AI setup in LinkedNav."

### Step 5: Create AI setup in LinkedNav

Tell the user: "**Step 5 of 6 — LinkedNav AI setup** — Creating the AI configuration that will personalize your messages at scale."

Call `mcp__claude_ai_LinkedNav__create_ai_setup` with:
- Name: `<business-slug>-icp`
- Description: the one-liner from the profile
- ICP summary from the interview

Then call `mcp__claude_ai_LinkedNav__generate_ai_setup_icp` to auto-generate the full ICP configuration in LinkedNav. Show the user the generated ICP and ask for approval.

If they want changes: call `mcp__claude_ai_LinkedNav__update_ai_setup` with corrections.

When done, tell the user: "AI setup created. → Next: activating it so LinkedNav uses it for this campaign."

### Step 6: Activate the AI setup

Tell the user: "**Step 6 of 6 — Activating** — Making this ICP the active setup in LinkedNav."

Call `mcp__claude_ai_LinkedNav__select_ai_setup` to make this the active setup.

Confirm:
```
AI setup "<name>" is now active in LinkedNav.

Profile saved to: profiles/<slug>/client-profile.yaml
LinkedNav AI setup ID: <id>

Ready to build your list.
```

When done, tell the user: "Done. ICP is live. → Next: build your list with /social-listening (warmest leads) or /list-builder (CSV import)."

## Common gotchas

- **"Our ICP is anyone who needs X"** — push for a named-customer example. "Anyone" is not a target.
- **Titles: always include synonyms.** "VP of Marketing" without "Head of Marketing", "CMO", "Chief Marketing Officer" misses 50% of matches.
- **LinkedIn seniority ≠ title.** A "Head of X" at a 15-person startup may be IC-level. Clarify.
- **Geography: LinkedIn defaults to current location, not company HQ.** Clarify which matters for this campaign.

## What to do next

ICP is defined and AI setup is live in LinkedNav.

**Next:** Build your list.
- `/social-listening` — find people engaging with competitors (warmest leads)
- `/list-builder` — import a CSV or build from search

**Or:** Write messages first if you already have a list.
- `/message-copywriting` — connection request + message sequences

## Related skills

- `/kickoff` — calls this skill as part of onboarding
- `/account-setup` — must run before this skill
- `/social-listening` — next step for warm list building
- `/list-builder` — next step for cold list import
- `/message-copywriting` — uses the ICP profile for copy guidance
