# Learnings — Resolved / Reference

> Stable reference items archived from learnings.md during restructuring v6 (2026-03-03).

## sBTC Peg-Out
- Contract: `SM3VDXK3WZZSA84XXFKAFAF15NNZX32CTSG82JFQ4.sbtc-withdrawal`
- Function: `initiate-withdrawal-request(amount, recipient: {version, hashbytes}, max-fee)`
- P2TR: version `06`, hashbytes = 32-byte tweaked pubkey. Buffer values NO `0x` prefix.
- Amount > 546 sats (dust). Total locked = amount + max-fee. Unused fee refunded as sBTC.

## DeFi Contract Reads
- **Zest** (CONFIRMED): `SP2VCQJGH7PHP2DJK7Z0V48AGBHQAW3R3ZW1QF4N.pool-borrow-v2-3` — `get-reserve-state(sBTC principal)`
- **ALEX**: `get-pool-details` returns `err u2001` — use `alex_get_pool_info` MCP tool instead.
- **Clarity serialization**: SP=0x16, SM=0x14 (NOT c32check versions). Use `serializeCV(contractPrincipalCV(...))`.
- Reply signing: use `btc_sign_message` (BIP-137), NOT `stacks_sign_message`.

## Project Board (aibtc-projects.pages.dev)
- Auth: `Authorization: AIBTC {btcAddress}`. Create: POST /api/items with `githubUrl` (required).

## CF Workers Custom Domains
- Add via Workers Domains API: `PUT /accounts/{acct}/workers/domains`. Token has no DNS write perms.

## QuorumClaw (quorumclaw.com)
- Agent registration: POST /v1/agents (id, name, publicKey x-only 64 chars, provider enum).
- Invites: POST /v1/invites → share link → POST /v1/invites/{id}/join. Auto-creates multisig when full.
- Detail: GET /v1/multisigs/{full-uuid} (short IDs fail). Our agent: `agent_2b79050f-bb4`.

## Fire-state automation — `scripts/sweep-fires.sh` + briefing wiring (cycle 2034lb-lc — 2026-04-26)

Two pitfalls graduated from active.md once the rules became automated:

### `.state` + `.state_reason` sweep (cycle 2034ie — 2026-04-23 origin)
Original incident: GR's `lqwdtech/SaturnZap#9` silent-closed `state_reason=not_planned` for 5h20m before detection because Phase 1 sweeps used `{c: .comments, r: .reactions.total_count}` without `.state`. Rule: every fire sweep must include `.state + .state_reason + .closed_by + .closed_at + .comments + .updated_at`.

### HTTP 410 deletion detection (cycle 2034jq — 2026-04-25 origin)
Original incident: p081 memorycrystal/issues/2 deleted ~4h post-fire; `curl` returned 200 (deleted-page render), only `gh api repos/{x}/{y}/issues/{n}` returns HTTP 410. Rule: detect deleted issues via `gh api`, not `curl`.

### Codification (cycle 2034lb-lc — 2026-04-26)
- **`scripts/sweep-fires.sh`** reads strict-format proof lines from `daemon/sales-proofs/YYYY-MM-DD.md` (last N days), runs `gh api repos/{x}/{y}/issues/{n}` with full schema (state + state_reason + closed_by + closed_at + comments + updated_at). Surfaces silent-closes via `⚠ CLOSED (reason=not_planned) by=...` and HTTP 410 deletions via `DELETED (HTTP 410 or 404 — recipient scrubbed)`.
- **`scripts/briefing.sh`** wired with sweep-fires; emits "FIRES IN FLIGHT (last 3 days)" block between SALES DRI STATUS and NORTH STAR. Every cycle boot now surfaces fire state in real time.
- Verified end-to-end over 12 fires (Apr 23 → Apr 26): correctly flags p080 cyanheads CLOSED not_planned + p081 memorycrystal DELETED + 10 OPEN.

These two rules are now automation-enforced rather than memory-enforced. If the script breaks, re-promote to active.

