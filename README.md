# LinkedIn Outbound Skills

Claude Code skills for LinkedIn outbound, powered by [LinkedNav](https://www.linkednav.com).

**What is LinkedNav?** LinkedNav is a LinkedIn outbound platform that manages your contact lists, sends connection requests and message sequences, handles inbox replies with AI drafts, and tracks campaign performance — all through your real LinkedIn account. These skills connect Claude Code to LinkedNav via MCP, so you can run your entire outbound workflow through conversation.

13 skills covering the full workflow — from ICP definition through campaign launch, inbox management, and analytics.

**New here?** Run `/kickoff` — it walks you through the whole setup in one guided flow.

---

## Getting started

### 1. Prerequisites

- [Claude Code](https://claude.com/claude-code) installed
- A [LinkedNav](https://www.linkednav.com) account (free trial available)
- LinkedNav MCP configured in Claude Code (see below)

### 2. Clone and install

```bash
git clone https://github.com/xx254/linkedin_outbound_skills ~/linkedin-outbound-skills
cd ~/linkedin-outbound-skills
bash install.sh
```

This copies the skills to `~/.claude/skills/` where Claude Code can find them. Then restart Claude Code.

### 3. Configure the LinkedNav MCP

**Option A — OAuth (easier, recommended):**

Run `/mcp` in Claude Code, select **"claude.ai LinkedNav"** from the list, and complete the authentication in your browser. No API key needed.

**Option B — API key:**

In Claude Code, open **Settings → MCP Servers** and add:

```json
{
  "linkedNav": {
    "type": "http",
    "url": "https://mcp.linkednav.com",
    "headers": {
      "Authorization": "Bearer YOUR_API_KEY"
    }
  }
}
```

Get your API key from: **https://www.linkednav.com/app/api-keys**

Full setup guide: **https://www.linkednav.com/app/integrations/mcp**

### 4. Run the kickoff

```
/kickoff
```

That's it. The kickoff walks you through ICP setup and routes you to the right list-building skill based on your situation.

---

## The full workflow

```
/kickoff                  ← start here
       ↓
/icp-setup                ← define who you're targeting
       ↓
  [build your list — pick one]
  /social-listening       ← warm leads from competitor/influencer engagers
  /list-builder           ← import CSV or build from scratch
  /signal-agent           ← AI intent signals (job changes, funding, etc.)
       ↓
/list-quality             ← grade the list before sending (score 1-10)
       ↓
/lead-enrichment          ← add emails/phones for multi-channel (optional)
       ↓
/message-copywriting      ← write connection request + message sequence
       ↓
/campaign-builder         ← create + connect LinkedIn + launch (starts paused)
       ↓
/inbox-manager            ← daily reply management
       ↓
/analytics                ← weekly performance review
```

---

## All skills

| Skill | Purpose |
|-------|---------|
| `/kickoff` | Start here. Orchestrates ICP setup and routes to list building. |
| `/account-setup` | Set up LinkedNav account + MCP API key. |
| `/icp-setup` | ICP interview → `client-profile.yaml` + LinkedNav AI setup. |
| `/social-listening` | Find warm leads from competitor/influencer post engagers. |
| `/list-builder` | Import CSV or build contact lists from scratch. |
| `/list-quality` | Grade a list before sending. 6-dimension score (1-10). |
| `/lead-enrichment` | Add emails and phone numbers to LinkedIn contacts. |
| `/message-copywriting` | Write connection note + follow-up message sequence. |
| `/campaign-builder` | Create, configure, connect LinkedIn account, and activate campaigns. |
| `/inbox-manager` | Review replies, approve AI drafts, send manual responses. |
| `/signal-agent` | Configure intent signals (job changes, hiring, funding). |
| `/analytics` | Campaign performance review and optimization recommendations. |
| `linkedNav-api` | *(internal reference — not user-invocable)* |

---

## LinkedIn safety limits

| Limit | Safe range |
|-------|-----------|
| Connection requests / week | 50–80 (new accounts: 20–30) |
| Messages / day | 10–20 |
| Profile views / day | 80–100 |
| Active campaigns per account | 1–3 |

All campaign defaults stay within safe ranges. Exceeding limits risks account restriction.

---

## Directory layout

```
linkedin-outbound-skills/
  README.md
  skills/
    kickoff/SKILL.md
    icp-setup/SKILL.md
    list-builder/SKILL.md
    list-quality/SKILL.md
    message-copywriting/SKILL.md
    campaign-builder/SKILL.md
    inbox-manager/SKILL.md
    analytics/SKILL.md
    social-listening/SKILL.md
    signal-agent/SKILL.md
    lead-enrichment/SKILL.md
    account-setup/SKILL.md
    linkedNav-api/SKILL.md
  profiles/                   ← YOUR data (gitignored)
    <business-slug>/
      client-profile.yaml     ← produced by /icp-setup
      campaign-plan.md        ← produced by /kickoff
```

---

## Contributing

PRs welcome. Keep the north star: a beginner should be able to clone this, run `/kickoff`, and have a live campaign within an hour.

## License

MIT
