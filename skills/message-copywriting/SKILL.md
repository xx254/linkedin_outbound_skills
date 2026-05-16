---
name: message-copywriting
description: Writes LinkedIn connection requests and message sequences through a stepwise confirmation process. Produces a complete 3-step sequence: connection note, first message after accept, follow-up. LinkedIn-specific rules: 300-char connection note, no "I wanted to reach out", no pitch in the first message. Triggers on "write LinkedIn messages", "write connection request", "message sequence", "LinkedIn copy".
---

# LinkedNav Message Copywriting

Writes the connection request and message sequence your campaign sends. Works stepwise: confirm direction → connection note → message 1 → message 2 → final copy.

## Why this exists

LinkedIn copy fails differently than cold email. The biggest mistake: pitching in the connection request, or pitching in message 1 before they've replied. LinkedIn is not email. The sequence is: connect → earn trust → offer value → then pitch. This skill enforces that order.

## Inputs

- `client-profile.yaml` (from `/icp-setup`) — ICP + offer
- Your campaign angle (or the skill will help you find one)

## Outputs

- Connection request note (≤300 characters)
- Message 1 after acceptance (sent after they accept)
- Message 2 follow-up (if no reply to message 1)
- (Optional) Message 3 final break-up message
- Saved to `profiles/<slug>/campaigns/<campaign-slug>/linkedin-sequence.md`

## LinkedIn copy rules (hardcoded — never break these)

1. **Connection note ≤300 characters.** Hard limit. LinkedIn enforces this.
2. **No pitch in the connection note.** If they feel sold to, they won't accept.
3. **No pitch in message 1.** Message 1 earns trust or offers value. The ask comes in message 2.
4. **Never start with "I hope this message finds you well."** Delete on sight.
5. **Never reference "I wanted to reach out."** Just reach out.
6. **Personalization must be specific.** "I saw your company" is not specific. "I saw you commented on [post topic]" is specific.
7. **One CTA per message.** Don't ask for a call AND a reply AND a referral in the same message.
8. **Message length:** connection note ≤300 chars; messages 1-2: 50-100 words; message 3: ≤60 words.

---

> Tell the user: "I'll write your connection request and message sequence step by step, confirming each piece before moving on. LinkedIn copy fails when it pitches too early — I'll make sure the sequence earns trust before asking for anything."

## Step 1: Confirm campaign angle

> Tell the user: "**Step 1 of 6 — Campaign direction.** Reading your ICP profile and confirming the targeting before I write a word."

Read `client-profile.yaml`. Present a summary:

```
Campaign Direction:
- Target: <titles> at <industry>, <headcount range>
- Offer: <CTA>
- Value prop: <one sentence>
- Proof point: <case study or metric>
- Trigger: <what makes this person relevant now>

Does this look right? Confirm or correct before I write.
```

> When done, tell the user: "Direction confirmed. Writing your connection note now."

### Three connection note angles

**Angle A: Shared context / community**
Connect around something they already care about — competitor post, conference, shared group, mutual connection.
- "Saw you commented on [person]'s post about [topic] — had a related thought and figured I'd connect."
- "Fellow [industry] operator here — connecting to stay in the loop."

**Angle B: Specific observation**
Say something specific you noticed about their company or role.
- "Noticed [company] just launched [thing] — impressive. Connecting to follow what you build."
- "Your post on [topic] was the clearest take I've read on [problem]. Connected."

**Angle C: Direct + brief**
For warm lists where context is obvious, just be honest and short.
- "I help [ICP role] at [company size] companies [core value prop]. Thought it worth connecting."

---

## Step 2: Write the connection note

> Tell the user: "**Step 2 of 6 — Connection note (≤300 chars).** I'll give you 3 options — one for each angle. Pick one or ask for more."

Present 3 options (one per angle above). For each:
- Full text
- Character count
- Why this angle fits the list source (social listening → Angle A; cold list → Angle B or C)

Recommend one. Ask: "Which works? Or want more options?"

**Examples:**

Angle A (social listening list):
```
"Saw you engage with [competitor]'s content on [topic] — it's a space I work in closely. Connecting to share ideas."
— 118 chars ✓
```

Angle B (cold list, specific):
```
"Noticed [company] is scaling the [department] team. I work with [ICP role]s at similar-stage companies on [problem]. Worth connecting."
— 136 chars ✓
```

> When done, tell the user: "Connection note locked. → Next: message 1 (sent after they accept)."

---

## Step 3: Write message 1 (after acceptance)

> Tell the user: "**Step 3 of 6 — Message 1.** This goes out after acceptance. Goal: start a conversation, not close a deal. No pitch yet."

Message 1 goal: **start a conversation, not close a deal**. Offer something — an insight, a resource, a question — without asking for anything big.

### Three message 1 strategies

**Strategy A: Value-first (share something useful)**
```
<First name>, thanks for connecting.

I was just writing up [short insight relevant to their role/company]. Happy to share it if useful — [specific reason it applies to them].

No agenda, just figured it might be worth 5 minutes.
```

**Strategy B: Question (earn a reply)**
```
<First name>, quick question for you —

[Role-specific question that shows you understand their world. Binary answer preferred: yes/no, or "still the case?"]

Asking because it comes up a lot with [their ICP type] I talk to.
```

**Strategy C: Observation (show research)**
```
<First name> — noticed [company] recently [did X / hired for Y / launched Z].

Out of curiosity: is [relevant challenge] on your radar because of that?

Happy to share what we've seen from [similar companies].
```

Present all three with recommendation. Get approval before continuing.

> When done, tell the user: "Message 1 approved. → Next: message 2 (follow-up if no reply)."

---

## Step 4: Write message 2 (follow-up)

> Tell the user: "**Step 4 of 6 — Message 2.** Re-engage with a fresh angle. Never 'following up on my last message'."

Message 2 goal: **re-engage with a different angle**. Don't repeat message 1. Rotate value prop.

Rules:
- Never open with "Following up on my last message"
- Never say "I know you're busy"
- Lead with a new hook or insight

```
<First name> — [new hook: different angle, stat, or observation].

[One sentence on what you do / what's changed].

Worth a quick chat?
```

> When done, tell the user: "Message 2 done. → Want a message 3 break-up message? (Optional but recommended.)"

---

## Step 5: Write message 3 (optional break-up)

> Tell the user: "**Step 5 of 6 — Message 3 (optional break-up).** Short, low-pressure, final touch."

Short, low-pressure, final message. 1-2 sentences max.

```
<First name> — last message from me.

If [topic] is ever on your radar, happy to reconnect then. [Company] is doing [relevant thing] and it tends to matter when [trigger].
```

Or redirect:
```
<First name>, if [relevant role] would be a better fit for this conversation, happy to reach out to them instead. Let me know.
```

> When done, tell the user: "Sequence complete. Saving now."

---

## Step 6: Output final sequence

> Tell the user: "**Step 6 of 6 — Saving sequence.** Writing to linkedin-sequence.md and running the QA checklist."

```markdown
## LinkedIn Sequence — <campaign name>

### Connection Request Note (<N> chars)
<note text>

---

### Message 1 (after acceptance, Day 1-2)
Subject: N/A (LinkedIn messages have no subject)

<message text>

---

### Message 2 (Day 7-10 after Message 1, if no reply)
<message text>

---

### Message 3 (Day 14, optional break-up)
<message text>

---

### Variables Used
| Variable | Source |
|----------|--------|
| {{first_name}} | Contact first name |
| {{company_name}} | Contact's company |
| {{ai_trigger}} | LinkedNav AI: reason for reaching out |
| {{ai_role_context}} | LinkedNav AI: their role context |
```

Save to `profiles/<slug>/campaigns/<campaign-slug>/linkedin-sequence.md`.

> When done, tell the user: "Sequence saved. → Next: /campaign-builder to create the campaign and launch."

---

## QA Checklist

Run before finalizing:

| Check | Pass? |
|-------|-------|
| Connection note ≤ 300 chars | ☐ |
| No pitch in connection note | ☐ |
| Message 1 does NOT ask for a call/meeting | ☐ |
| No "hope this finds you well" or "I wanted to reach out" | ☐ |
| Each message works standalone (not "following up on...") | ☐ |
| CTA is low-effort (binary question or soft offer) | ☐ |
| No generic AI first lines ("I see your company does...") | ☐ |
| Message 1-2 word count 50-100 | ☐ |

---

## What to do next

Sequence is written and saved.

**Next:** → `/campaign-builder` to create the campaign, load the sequence, link the list, and launch.

## Related skills

- `/icp-setup` — provides `client-profile.yaml` with ICP + offer
- `/list-quality` — run before writing to know who you're talking to
- `/campaign-builder` — uses this sequence to create the campaign
- `/inbox-manager` — manage replies after campaign launches
