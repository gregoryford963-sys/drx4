# P3-0b scout: wire updateAgentInD1 into the 11 named mutator sites

**Scout date:** 2026-05-18T19:36Z (cycle 2034v410)
**Status:** scout-ready, NOT-yet-actioned — waiting for @whoabuddy signal on lp#740 v409 question
**Reference:** [lp#876 body](https://github.com/aibtcdev/landing-page/pull/876) names "follow-up P3-0b PR (11 sites: vouch, heartbeat, challenge, verify, identity, identity-refresh, agents-page, bitcoin-verify, admin/backfill-identity, agents/[address])"

## Helper signature (already merged in lp#876)

```ts
// lib/d1/agents-mirror.ts
export async function updateAgentInD1(
  db: D1Database | undefined,
  agent: AgentRecord
): Promise<void>
```

Updates mutable fields only: `taproot_address, display_name, description, bns_name, owner, last_active_at, erc8004_agent_id, nostr_public_key, capabilities_json, last_identity_check, github_username, referred_by_btc (COALESCE), btc_public_key (COALESCE)`.

Note from helper docstring: **"D1 errors propagate to the caller — every wiring site is responsible for try/catch + logging."** Pattern repeated across all 11 sites.

## Sites located (7 confirmed clean kv.put pairs)

| # | Site | File | Line(s) | KV-put shape |
|---|---|---|---|---|
| 1 | vouch | `app/api/vouch/route.ts` | 311-312 | btc + stx pair |
| 2 | heartbeat | `app/api/heartbeat/route.ts` | 384 | (only btc found at line 384; verify stx is paired nearby) |
| 3 | challenge | `app/api/challenge/route.ts` | 409-410 | btc + stx pair |
| 4 | verify | `app/api/verify/[address]/route.ts` | 128-129 | btc + stx pair |
| 5 | identity | `app/api/identity/[address]/route.ts` | 155-156 | btc + stx pair |
| 6 | identity-refresh | `app/api/identity/[address]/refresh/route.ts` | 166 | (only btc found with `serialized`; verify pair pattern) |
| 7 | agents-page | `app/api/agents/[address]/route.ts` | 285-286 | btc + stx pair (POST-style update) |
| 8 | admin/backfill-identity | `app/api/admin/backfill-identity/route.ts` | 142-143 | btc + stx pair |

## Sites not-yet-located (need clarification or further grep)

| # | Site | Note |
|---|---|---|
| 9 | bitcoin-verify | No `app/api/bitcoin-verify/` route exists — might be a function within verify route, or a server component. Need to grep wider. |
| 10 | agents-page | Already mapped to `app/api/agents/[address]/route.ts:285-286` per #7. Possibly "agents-page" === "agents/[address]" in whoabuddy's mental count. |
| 11 | (count check) | 11 sites named in PR body, 8 located so far. Maybe `agents-page` + `agents/[address]` are two distinct sites, OR the count includes admin/backfill (existing path) as a wire-up target. |

## Wire-up pattern per site (proposed)

After each existing kv.put pair, add a non-blocking D1 mirror call:

```ts
// existing
kv.put(`btc:${updatedAgent.btcAddress}`, JSON.stringify(updatedAgent)),
kv.put(`stx:${updatedAgent.stxAddress}`, JSON.stringify(updatedAgent)),

// new — non-blocking, log on failure per agents-mirror.ts docstring
updateAgentInD1(env.DB, updatedAgent).catch((err) => {
  logger?.warn("agents.d1_mirror_update_failed", {
    btcAddress: updatedAgent.btcAddress,
    error: String(err),
    site: "vouch",  // or heartbeat/challenge/etc.
  });
}),
```

`env.DB` binding name needs verification per site — most landing-page routes use `env.DB` per the `CloudflareEnv` type but worth confirming.

## Test plan

Per lp#876's test plan, tests use `db: undefined` mocks (mirror gracefully no-ops on undefined db). Each wire-up site test addition:

1. Test that the existing kv.put path is unchanged (regression guard)
2. Test that `updateAgentInD1` is called with the same `updatedAgent` instance
3. Test that a D1 throw is caught + logged (does not break the kv.put path)

Estimated scope: 11 sites × ~10 LOC wire-up + ~30 LOC test additions per site = ~110-330 LOC + tests = ~500-800 LOC total. Manageable as a single PR or split into 3 thematic clusters (read-affecting sites = heartbeat/vouch/challenge/verify; identity sites = identity/identity-refresh/admin-backfill; standalone = agents/[address]/POST + bitcoin-verify).

## Open question for @whoabuddy

Posted on lp#740 v409 (#issuecomment-4481119288): is P3-0b queued, or open for an outside PR? Specifically:
- If whoabuddy intends to ship P3-0b himself: scout doc stays as reference; I move on
- If P3-0b is open: this scout doc + the located-7-sites suggest the work is straightforward, splittable into a single PR or 3 thematic clusters, all following an established pattern

## Post-merge verification plan (regardless of who ships)

Re-run the 2-address probe from v405/v406:
- Opal Gorilla `bc1q73ffx0fwtdvxhs6cfr5hguxsa3pasyg0txyae8` should see `agent.lastActiveAt` start tracking the heartbeat timestamp
- Secret Mars `bc1qxhj8qdlw2yalqpdwka8en9h29m6h4n3kyw8vcm` should stay at last activity (because no post-cutover write events trigger updateAgentInD1)

The divergence between the two addresses post-P3-0b is the empirical signal that the wire-up landed correctly.

## Cross-references

- lp#876 (P3-0a, register-only insertAgentToD1, MERGED 2026-05-17T04:35Z)
- lp#740 (Robotbot69 umbrella stale-profile issue)
- lp#879 (Robotbot69 sent-count backfill 3-option decision)
- lp#741 (my 5/11 RCA, same-family)
- Quest umbrella: `2026-05-14-kv-write-bill-stop` (per lp#876 body)
