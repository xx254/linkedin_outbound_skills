---
name: linkedNav-api
description: Reference documentation for LinkedNav MCP tools. Not user-invocable — used internally by other skills. Contains tool names, parameters, and usage patterns for all LinkedNav MCP operations.
user_invocable: false
---

# LinkedNav API Reference

Internal reference for LinkedNav MCP tool usage. Not invoked directly by users.

## Account & Status

| Tool | Purpose |
|------|---------|
| `get_account_status` | LinkedIn connection status, health, warnings |
| `get_linkedin_accounts` | List connected LinkedIn accounts |
| `get_billing_summary` | Credits, plan, usage |
| `get_dashboard_summary` | High-level metrics across all campaigns |
| `get_integration_status` | Third-party integrations connected |

## Campaigns

| Tool | Purpose |
|------|---------|
| `create_campaign` | Create new campaign (always create as paused) |
| `get_campaign` | Get single campaign details |
| `get_campaigns` | List all campaigns |
| `get_campaigns_summary` | Aggregated stats across campaigns |
| `update_campaign` | Edit campaign settings (name, limits, schedule) |
| `pause_campaign` | Pause an active campaign |
| `activate_campaign` | Activate a paused campaign |
| `duplicate_campaign` | Clone a campaign for A/B testing |
| `delete_campaign` | Delete (only use if no contacts messaged) |
| `add_lead_to_campaign` | Add single lead |
| `add_leads_bulk_to_campaign` | Add multiple leads |
| `remove_leads_from_campaign` | Remove leads from a campaign |
| `get_scheduled_sends` | See what's queued to send |
| `update_scheduled_send_status` | Pause or cancel a scheduled send |

## Lists

| Tool | Purpose |
|------|---------|
| `create_list` | Create a new contact list |
| `get_lists` | List all contact lists |
| `update_list` | Rename or modify a list |
| `delete_list` | Delete a list |
| `get_list_contacts` | Get contacts in a list |
| `link_list_to_campaign` | Associate a list with a campaign |

## Contacts & Leads

| Tool | Purpose |
|------|---------|
| `create_contact` | Add a single contact |
| `create_lead` | Add a single lead (for campaigns) |
| `create_leads_bulk` | Add multiple leads at once |
| `get_contact` | Get a single contact |
| `get_contacts` | List all contacts |
| `get_contacts_summary` | Aggregated contact stats |
| `update_contact` | Edit contact fields |
| `delete_contact` | Remove a contact |
| `bulk_delete_contacts` | Remove multiple contacts |
| `bulk_move_contacts` | Move contacts between lists |

## Email & Phone Enrichment

| Tool | Purpose |
|------|---------|
| `enrich_contact_email` | Find email for one contact |
| `enrich_contact_phone` | Find phone for one contact |
| `enrich_contacts_email_bulk` | Find emails for many contacts |
| `enrich_contacts_phone_bulk` | Find phones for many contacts |
| `get_enrichment_status` | Status of email enrichment job |
| `get_phone_enrichment_status` | Status of phone enrichment job |

## Social Listening

| Tool | Purpose |
|------|---------|
| `track_competitor` | Add a competitor company to monitor |
| `track_influencer` | Add an influencer to monitor |
| `get_social_listening_posts` | All tracked posts |
| `get_social_listening_qualifying_posts` | Posts with enough engagers to mine |
| `get_social_listening_engagers` | People who engaged with a post |
| `get_social_listening_stats` | Overview: posts tracked, engagers found |
| `get_social_listening_auto_import` | Check auto-import settings |
| `set_social_listening_auto_import` | Configure auto-import |
| `trigger_social_listening_auto_import` | Force an immediate import |
| `get_social_listening_auto_import_task` | Task status for an import |

## AI Setup (ICP)

| Tool | Purpose |
|------|---------|
| `create_ai_setup` | Create a new ICP / AI setup |
| `get_ai_setup` | Get a specific AI setup |
| `get_ai_setups` | List all AI setups |
| `update_ai_setup` | Edit an AI setup |
| `delete_ai_setup` | Remove an AI setup |
| `select_ai_setup` | Set an AI setup as active |
| `generate_ai_setup_icp` | Auto-generate ICP from description |

## Prompts

| Tool | Purpose |
|------|---------|
| `create_prompt` | Create a custom message prompt |
| `get_prompt` | Get a specific prompt |
| `get_prompts` | List all prompts |
| `update_prompt` | Edit a prompt |

## Signal Agent

| Tool | Purpose |
|------|---------|
| `get_signal_agent_settings` | Current signal agent config |
| `get_signal_agent_results` | Historical results |
| `get_signal_leads` | Leads surfaced by signal agent |
| `run_intent_agent` | Trigger a signal agent run |
| `get_agent_run_status` | Status of a running agent task |
| `set_signal_agent_auto_run` | Schedule auto-run (daily/weekly) |
| `set_signal_agent_auto_add` | Auto-add signal leads to campaign |

## Unibox (Inbox)

| Tool | Purpose |
|------|---------|
| `get_unibox` | Get inbox threads |
| `get_unibox_unread_count` | Unread message count |
| `get_unibox_task_status` | Status of unibox sync task |
| `sync_unibox` | Pull latest messages from LinkedIn |
| `send_unibox_reply` | Send a reply in a thread |
| `mark_unibox_thread_read` | Mark a thread as read |
| `get_pending_replies` | AI-drafted replies waiting for approval |
| `get_pending_replies_count` | Count of pending replies |
| `approve_pending_reply` | Approve and send an AI reply |
| `deny_pending_reply` | Reject an AI reply |
| `regenerate_pending_reply` | Request a new AI draft |
| `update_pending_reply` | Edit an AI draft before approving |
| `retry_pending_reply` | Retry a failed reply send |
| `get_pending_comments` | AI-drafted comments on posts |
| `get_pending_comments_count` | Count of pending comments |
| `approve_pending_comment` | Approve and post an AI comment |
| `deny_pending_comment` | Reject an AI comment |
| `update_pending_comment` | Edit an AI comment draft |
| `retry_pending_comment` | Retry a failed comment |

## Tasks & Performance

| Tool | Purpose |
|------|---------|
| `get_tasks` | List background tasks |
| `cancel_task` | Cancel a running task |
| `retry_task` | Retry a failed task |
| `get_performance_analytics` | Campaign performance metrics |

## Connection Management

| Tool | Purpose |
|------|---------|
| `preview_withdraw_connections` | Preview which connections to withdraw |
| `withdraw_connections` | Withdraw pending connection requests |

## Rate limits & safety

- All write operations (create, activate, send) should be confirmed with the user before calling
- Campaign activation: always show full campaign summary before calling `activate_campaign`
- Bulk operations: show count + sample before executing on large sets
- `withdraw_connections`: call `preview_withdraw_connections` first, always confirm before withdrawing
- LinkedIn limits: ~100 connection requests/week; ~50-100 messages/day; respect these in campaign settings
