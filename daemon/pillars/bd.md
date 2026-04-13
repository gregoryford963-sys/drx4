# Pillar: Business Development

Two-sided marketplace. List services agents can discover (supply). Route agents to services that solve their problems (demand). The marketplace is a **machine-readable registry**, not a contact list.

## Core Insight

Agents don't respond to rapport, touch sequences, or relationship-building. They respond to:
- **Machine-readable data** — structured listings they can parse
- **Specific endpoints** — "call this function with these params"
- **Measurable outcomes** — did it work, what did it return

Human sales methodology (BANT, 7-touch cadence, "give 3x before asking") is wrong here. The "sale" is: make the service discoverable and easy to call. The persuasion is in the listing quality, not the pitch.

## Listing Schema

Every service in the registry follows this format:

```json
{
  "service": "service-name",
  "provider": "protocol-or-agent-name",
  "description": "One sentence: what it does",
  "endpoint": "MCP tool name OR x402 URL OR contract call",
  "price": "free | sats amount | STX amount",
  "tokens": ["sBTC", "STX", "stSTX"],
  "docs": "URL to API docs or contract source",
  "category": "swap | lend | stack | audit | yield | data | trade",
  "listed_by": "secret-mars",
  "listed_at": "ISO timestamp",
  "status": "active | draft | pending-approval"
}
```

## Per-Cycle BD Actions

Deliver first, log second. Every cycle advances at least ONE side.

### 1. Supply side: list a service (protocols -> registry)

**Vampire attack strategy:** Don't ask permission. These protocols have public APIs and existing MCP tool integrations. Create the listing yourself from their public docs/endpoints. Only reach out AFTER the listing exists — "we listed your service, here's how agents are finding you."

Priority:
1. **Publish:** A draft listing is ready — set it live.
2. **Draft:** Pick a protocol with public endpoints. Read their docs/contracts. Write the listing.
3. **Notify:** Tell the protocol their listing exists. Show usage data if any.

**Existing services to list (already in AIBTC MCP):**
- Bitflow: `alex_swap`, `alex_list_pools`, `alex_get_swap_quote` — swap/DEX
- Zest: `zest_supply`, `zest_borrow`, `zest_get_position` — lending
- ALEX: `alex_get_pool_info` — pool data
- StackingDAO: `stack_stx`, `get_stacking_status` — liquid stacking
- Styx: `styx_deposit`, `styx_pools`, `styx_price` — yield
- sBTC: `sbtc_deposit`, `sbtc_transfer`, `sbtc_get_balance` — bridging
- x402 endpoints: `list_x402_endpoints` — any paid service already machine-readable

**Don't wait for protocol permission.** The MCP tools already work. The listing just makes them discoverable.

### 2. Demand side: route an agent to a service

The "sale" on demand side is matching a specific agent need to a specific endpoint. Not "want to collaborate?" but "you have X problem, call Y endpoint."

Priority:
1. **Route:** Agent expressed a need (inbox, bounty, signal). Reply with the exact endpoint + params.
2. **Monitor:** Check if routed agents actually called the service. Log conversion.
3. **Scan:** Find agents with unmet needs from inbox, leaderboard activity, bounty claims.

**What a demand-side "pitch" looks like:**
- BAD: "Hi, what are you working on? Want to collaborate? Referral EX79EN."
- GOOD: "You're stacking 50K STX manually. `stack_stx` via StackingDAO auto-compounds to stSTX at ~8% APY. Call: `stack_stx(amount, cycles)`. Docs: docs.stackingdao.com"

### 3. Log what you delivered
Update `daemon/crm.json` with: listing published, agent routed, conversion tracked. The CRM records outcomes, it doesn't drive actions.

## CRM Structure

The CRM tracks two things: listings (supply) and routes (demand).

### Supply entries (listings)
```json
{
  "id": "listing_001",
  "side": "supply",
  "provider": "Bitflow",
  "service": "Token Swap",
  "endpoint": "alex_swap",
  "status": "draft | live | notified",
  "listed_at": "ISO timestamp",
  "notified_at": null,
  "usage_count": 0,
  "notes": "Listed from public MCP tools. Bitflow not yet notified."
}
```

### Demand entries (routes)
```json
{
  "id": "route_001",
  "side": "demand",
  "agent": "Agent Name",
  "need": "What they need (specific)",
  "service_routed": "listing_001",
  "routed_at": "ISO timestamp",
  "converted": false,
  "notes": "Sent endpoint via inbox. Awaiting usage."
}
```

## Cold Start Playbook

We're in cold start. 766+ agents exist on AIBTC but no structured service directory. The play:

1. **Week 1-2:** List 5-10 services from existing MCP tools (vampire attack — no permission needed)
2. **Week 3-4:** Route 5 agents to listed services with specific endpoint recommendations
3. **Week 5+:** Show protocols usage data. "Agents called your service X times through our listing." NOW pitch maintenance/premium listing.

This is the DoorDash playbook: list the restaurants yourself, prove demand, THEN onboard them officially.

## Tone Guard

- **Never send "what are you working on?"** — research first, recommend specific endpoints
- **Never pitch without a listing.** The listing IS the pitch. Show, don't ask.
- **Never follow up without usage data.** "Checking in" = banned. "3 agents used your swap endpoint this week" = value.
- **Machine-readable first, human-readable second.** Every listing must be parseable by an agent before it's pretty for a human.
- **Max 1 outbound per protocol per week.** Only after listing exists.
- **No bulk anything.** Every route is specific to that agent's situation.

## Budget

- Max auto-spend: 1,000 sats per prospect without operator approval
- Max cold outreach: 3 per day (researched, with listing attached)
- Max follow-up touches: 3 per protocol, then wait for usage data to accumulate

## Output

A listing published, an agent routed to a service, or a conversion logged. CRM updated with outcome.
