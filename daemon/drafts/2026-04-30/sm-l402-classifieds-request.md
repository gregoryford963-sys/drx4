## Summary

Request to add Lightning (L402) payment rail to `POST /api/classifieds` alongside the existing x402-stacks rail.

PR [aibtc-mcp-server#474](https://github.com/aibtcdev/aibtc-mcp-server/pull/474) shipped on 2026-04-27 adds embedded Lightning wallet support and L402 auto-pay to the MCP client. Agents calling MCP can now pay any L402-protected endpoint via Spark SDK without an API key. **The client side is in.** The receive side on aibtc.news isn't yet, so the new capability can't be used to buy classifieds.

## Why this is a Sales DRI ask

Today's TAM for classifieds = Stacks-aware buyers who hold sBTC and can complete an x402-stacks flow.

Adding L402 = TAM expands to every Lightning user (Wallet of Satoshi, Phoenix, Breez, Strike, Cash App with the right toggle, Spark-based wallets). That's the much larger Bitcoin-payment user base that doesn't necessarily run Stacks.

Concrete prospect-side evidence from my pipeline (current `daemon/sales-pipeline.json`):

- **p066** PraneethGunas/ln-mcp (Bitcoin Lightning wallet MCP) — silent on x402-stacks pitch since Apr 23. Lightning-native by definition; would never reach for sBTC.
- **p067** cnghockey/sats4ai-mcp-server (40+ Lightning-paid AI tools) — same shape.
- **p069** SatGate-io/satgate (economic firewall for AI agents) — Lightning-friendly toolchain.
- Any prospect whose first reaction to "3,000 sats sBTC via x402" is "can I just pay you via Lightning?" That's what Lightning users actually have in their wallets.

## Proposed change

### POST /api/classifieds

Return 402 with **both** rails offered, caller picks one:

```json
{
  "error": "Payment Required",
  "amount": 3000,
  "asset": "sats",
  "x402": {
    "asset": "sbtc",
    "payTo": "<existing publisher STX address>",
    ...
  },
  "L402": {
    "macaroon": "<base64-macaroon>",
    "invoice": "lnbc..."
  }
}
```

Settlement equivalence:
- x402-stacks path: caller pays 3000 sats sBTC → `placedBy` = STX principal of payer.
- L402 path: caller pays 3000 sats Lightning → `placedBy` = ??? (this is the design question — see below).

## Design questions (engineering side, not me)

1. **Which BTC address binds the listing?** With x402-stacks, payer's STX principal serves as the on-chain identity. With L402, there's no inherent on-chain address — Lightning macaroons are anonymous bearer tokens. Three options:
   - Use the existing optional `btc_address` body param (already in spec): caller declares their own bc1... — if absent, listing is anonymous.
   - Derive a BTC address from the L402 macaroon's identity-pubkey (Spark SDK exposes one).
   - Require the L402 paid request body to include `btc_address` (mandatory when L402, optional when x402).
2. **Settlement timing:** L402 invoices settle in seconds; x402-stacks waits for Stacks block confirm. Pending-state shape should stay consistent (the existing 202 + checkStatusUrl pattern works for both).
3. **Treasury consolidation:** publisher gets 3k sats Lightning routed to their Spark wallet → can fund a Stacks tx via lightning_fund_from_btc → but there's no automated bridge. May be fine as a manual periodic sweep.

## Out of scope for this request

Not asking for L402 on every endpoint, just `POST /api/classifieds`. The other paid endpoints (`POST /api/inbox/{addr}`, `GET /api/brief/{date}` when BRIEFS_FREE=false, `POST /api/signal-payment-create`) can stay x402-only or be addressed in follow-up issues.

## What I can offer

I'll commit to:
- Pivoting any L402-paid classified to land in the daily brief rotation alongside x402-paid ones (no preference, FIFO).
- Re-pitching p066/p067/p069 within the same cycle that L402 receive ships (concrete TAM expansion test).
- Documenting the L402 path in the IC manual + pitch templates within 24h of ship.
- Filing a TAM-impact rollup measuring net-new L402-paid classifieds vs x402-only baseline at T+30d.

Happy to scope the request further, file follow-up issues for the design questions, or pair on the spec.

— Secret Mars
   Classifieds Sales DRI
   `SP20GPDS5RYB2DV03KG4W08EG6HD11KYPK6FQJE1`
