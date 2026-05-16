---
name: inbox-manager
description: Manages the LinkedNav unibox — reviews unread threads, approves or edits AI-generated replies, sends manual responses, and marks threads as read. Use daily to stay on top of active campaigns. Triggers on "check inbox", "manage replies", "approve messages", "unibox", "who replied".
---

# LinkedNav Inbox Manager

Your daily command for managing active campaign conversations — reviewing who replied, approving AI-drafted responses, and sending your own replies.

## Why this exists

LinkedNav can auto-generate replies using your AI setup. But those replies go to real people and represent your brand. This skill surfaces every pending AI reply for your approval before it sends, and helps you handle the conversations that need a human touch.

A campaign that sends great connection requests but ignores replies will close 0 deals. Inbox management is where outbound becomes pipeline.

## Steps

### Step 1: Check unread count

Call `mcp__claude_ai_LinkedNav__get_unibox_unread_count` first:
```
Unread messages: <N>
Pending AI replies to approve: <N>
```

If 0 unread and 0 pending: "Inbox is clear. Nothing to review."

### Step 2: Sync unibox

Call `mcp__claude_ai_LinkedNav__sync_unibox` to pull latest messages from LinkedIn. This ensures you're seeing real-time data.

### Step 3: Review unread threads

Call `mcp__claude_ai_LinkedNav__get_unibox` and display a summary of unread threads:

```
Unread conversations:

1. Jane Doe (Acme Corp, VP Marketing)
   "Thanks for connecting! Happy to chat — what do you do?"
   [POSITIVE] — worth a detailed reply

2. John Smith (Beta Inc, Head of Growth)
   "Not the right time, maybe later"
   [NEUTRAL/SOFT NO] — log and follow up in 3 months

3. Sarah Lee (Gamma, CMO)
   "Who is this? How did you get my info?"
   [NEGATIVE] — needs careful handling

4. Mike Chen (Delta, Director of Marketing)
   "Yes, definitely interested. Can you send more info?"
   [HOT] — respond immediately
```

Categorize each reply as: HOT / POSITIVE / NEUTRAL / SOFT NO / HARD NO / OUT OF OFFICE.

### Step 4: Handle HOT and POSITIVE replies first

For HOT replies (expressed interest, asking for next step):

Draft a reply that:
1. Thanks them briefly (1 sentence max)
2. Gives them the next step clearly (book a call link, send a resource, answer their question)
3. Stays short — no walls of text

Template:
```
<First name>, glad this resonated.

[Direct answer to their question or next step].

[CTA: "Here's my calendar: [link]" or "Happy to send [resource] — just confirm your email?"]
```

For POSITIVE replies (engaged but no clear ask):

Ask one clarifying question to qualify them. Don't pitch until you understand their situation.

### Step 5: Review and approve pending AI replies

Call `mcp__claude_ai_LinkedNav__get_pending_replies` to see AI-drafted replies waiting for approval.

For each pending reply, show:
```
Thread: <name> at <company>
Their message: "<text>"
AI-drafted reply: "<text>"

[A] Approve and send
[B] Edit before sending
[C] Deny (don't send, I'll handle manually)
[D] Regenerate (try a different AI draft)
```

To approve: `mcp__claude_ai_LinkedNav__approve_pending_reply`
To edit: show the draft, let the user edit, then approve
To deny: `mcp__claude_ai_LinkedNav__deny_pending_reply`
To regenerate: `mcp__claude_ai_LinkedNav__regenerate_pending_reply`

**Never auto-approve pending replies without showing them to the user first.**

### Step 6: Handle pending comments

Call `mcp__claude_ai_LinkedNav__get_pending_comments` for any pending AI comments on posts.

Same flow: approve, edit, or deny each.

Call `mcp__claude_ai_LinkedNav__get_pending_comments_count` to show total volume.

### Step 7: Send manual replies

For threads where you want to write a custom reply:

Call `mcp__claude_ai_LinkedNav__send_unibox_reply` with your message text and thread ID.

Use this for:
- HOT leads (don't let AI handle these)
- NEGATIVE / defensive replies (requires careful human tone)
- Complex questions that need specific answers

### Step 8: Mark threads as read

After reviewing a thread: call `mcp__claude_ai_LinkedNav__mark_unibox_thread_read`.

Do this in bulk at the end of your inbox session.

### Step 9: Update pending reply text (if editing)

If you want to update a pending AI reply before approving: call `mcp__claude_ai_LinkedNav__update_pending_reply` with the edited text.

## Reply strategy by category

| Category | Response strategy |
|----------|------------------|
| HOT (wants next step) | Reply within 1 hour if possible. Give clear next step. Don't pitch features. |
| POSITIVE (curious) | Ask one qualifying question. Keep it conversational. |
| NEUTRAL | Acknowledge, leave door open: "Makes sense — feel free to reach out when timing changes." |
| SOFT NO ("not now") | "Totally understand — I'll check back in Q3." Then move them to a nurture tag. |
| HARD NO ("remove me") | Remove them from the campaign immediately. `mcp__claude_ai_LinkedNav__remove_leads_from_campaign` |
| OOO | Wait for them to return. Schedule a follow-up in 2 weeks. |
| Confused ("who are you?") | Brief, friendly clarification of who you are and why you reached out. Don't over-explain. |

## Daily rhythm

Recommended: check inbox once in the morning, once end of day.

```
Morning: sync → review HOT/POSITIVE → approve AI replies → send manual HOT replies
Evening: check for new replies → mark read → approve any new pending AI replies
```

## What to do next

**Inbox is clear and replies are handled.**

**Weekly:** → `/analytics` to review acceptance rate, reply rate, and campaign performance.

**If acceptance rate is low (<15%):** connection note may need a rewrite → `/message-copywriting`

**If reply rate is low (<3%):** message 1 or 2 may need rework → `/message-copywriting`

## Related skills

- `/campaign-builder` — creates the campaign this skill manages replies for
- `/analytics` — review full campaign performance
- `/message-copywriting` — rewrite sequences if reply rates are low
- `/signal-agent` — set up intent signals to find warmer leads
