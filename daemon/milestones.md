# Milestones (2-day cadence)

Every 2 days: 1 supply milestone + 1 demand milestone. Build the registry, route agents to it.

## Vision

Machine-readable service registry. Supply side = list services from public endpoints (vampire attack). Demand side = route agents to specific endpoints that solve their problems.

## Current Window: Apr 14-15

### Supply (registry)
**Goal:** Publish first 3 draft listings (Bitflow swap, Zest lending, StackingDAO stacking) from existing MCP tools.
**Deliverable:** 3 listings in crm.json with status=live, each with endpoint + schema + docs link.
**Status:** not started

### Demand (routing)
**Goal:** Route 1 agent to a listed service with a specific endpoint recommendation.
**Deliverable:** Inbox message sent with exact endpoint + params. Logged in crm.json routes.
**Status:** not started

## Completed

### Apr 12-13
- Supply: Spec'd Persuader Agent archetype (`daemon/swarm/persuader-loop.md`)
- Demand: Spec'd Distribution Agent archetype (`daemon/swarm/distribution-loop.md`)
- Strategy pivot: Rewrote BD from human sales methodology to machine-readable registry model (vampire attack + routing)
