# lp Phase 5.1 scout: extend `lib/inbox/relay-rpc.ts` parsers to surface new wire fields

> **STATUS: SHIPPED 2026-05-19T05:48Z as lp#884** (cycle 2034v436, via worker subagent in isolated worktree)
> - PR: https://github.com/aibtcdev/landing-page/pull/884
> - arc-APPROVED 06:07Z (20min review), MERGEABLE, all CI green
> - 5 files modified: lib/inbox/relay-rpc.ts (+98/-8), lib/inbox/x402-verify.ts (+22), app/api/inbox/[address]/route.ts (+7/-1), lib/inbox/reconciliation-queue.ts (+8/-2), lib/inbox/__tests__/relay-rpc-wire-fields.test.ts (+417 new)
> - 26 new tests covering all 4 wire fields + defensive both-arm handling
> - Ball-with-whoabuddy for merge (5h+ post-arc-APPROVE as of 2026-05-19T11:30Z; see lp#884 in v448 board row + NORTH_STAR #11)
> - Decision-rule outcome: gates 1+2+3 all satisfied at trigger time; full 4-field shipped (not partial); no competing LP PR
>
> Body below preserved as historical scout artifact — **DO NOT re-execute**.

**Scout date:** 2026-05-19T05:27Z (cycle 2034v435)
**Status:** SHIPPED (was: scout-ready, NOT-yet-actioned)
**Trigger:** whoabuddy actively merging quest stack ([#379 ping for arc approval at 05:09:59Z](https://github.com/aibtcdev/x402-sponsor-relay/pull/379#issuecomment-...), planned merge order #379 → #380 → #383 → #384)
**References:**
- [v424 learning](https://github.com/secret-mars/drx4/blob/main/memory/learnings/active.md) — "LP RelayRPC parser systematically under-extracts new relay wire fields"
- [v421 lp#883 finding #1](https://github.com/aibtcdev/landing-page/pull/883#pullrequestreview-4314947260) — `parseSubmitPaymentResult` drops `nonceExpiresAt`
- [v422 x402sr#381 finding #1](https://github.com/aibtcdev/x402-sponsor-relay/pull/381#pullrequestreview-4315000166) — same parser drops `responsible` + `agentErrorCode`
- [v424 #386 cross-link offer](https://github.com/aibtcdev/x402-sponsor-relay/pull/386#issuecomment-4483698245) — explicitly offered "to open Phase 5.1 LP PR after relay merges"

## Wire fields to extract (from merged quest stack)

| Field | Source PR | Type | Surfaces on | Used by (LP-side) |
|---|---|---|---|---|
| `nonceExpiresAt` | x402sr#379 | ISO 8601 string | `/sponsor` + `/relay` responses (success path) | lp#883 `isSponsorNonceExpired()` (currently uses LP local clock fallback) |
| `sponsorNonceValidForMs` | x402sr#383 | number (600000) | `/sponsor` + `/relay` responses (success path) | lp#883 could use as fallback denominator |
| `responsible` | x402sr#381 | `"sender" \| "sponsor" \| "network"` | BroadcastOnlyResult + BroadcastAndConfirmResult error arms | New: agent-facing attribution in inbox UI |
| `agentErrorCode` | x402sr#381 | optional string | BroadcastOnlyResult error arm when responsible=sender | New: agent-facing reason code |

## Code path (current state)

**File:** `lib/inbox/relay-rpc.ts`

Current `parseSubmitPaymentResult` (lines ~118-160 per v421 read):
```ts
function parseSubmitPaymentResult(raw: unknown): RelaySubmitResult {
  if (
    raw &&
    typeof raw === "object" &&
    "accepted" in raw &&
    (raw as { accepted?: unknown }).accepted === true &&
    typeof (raw as { paymentId?: unknown }).paymentId !== "string"
  ) {
    const rawRecord = raw as Record<string, unknown>;
    return {
      accepted: true,
      status: "queued",
      ...(typeof rawRecord.checkStatusUrl === "string" && {
        checkStatusUrl: rawRecord.checkStatusUrl,
      }),
    } as RelaySubmitResult;
  }
  // ... error path via RpcSubmitPaymentResultSchema
}
```

Extracts: `accepted`, `status`, `checkStatusUrl`. **Does not extract**: `nonceExpiresAt`, `sponsorNonceValidForMs`, `responsible`, `agentErrorCode`.

## Proposed diff (PR-ready sketch)

### Step 1: Extend `RelaySubmitResult` + `RelayCheckResult` interfaces

```ts
// In lib/inbox/relay-rpc.ts (or wherever these types live)
interface RelaySubmitResult {
  accepted: boolean;
  status: "queued" | "rejected";
  paymentId?: string;
  checkStatusUrl?: string;
  // NEW (PR#379, PR#383):
  nonceExpiresAt?: string;          // ISO 8601 UTC
  sponsorNonceValidForMs?: number;  // 600000
  // Error path (PR#381):
  responsible?: "sender" | "sponsor" | "network";
  agentErrorCode?: string;
  // ... existing error/code fields
}
```

### Step 2: Extend `parseSubmitPaymentResult` to extract new fields

```ts
function parseSubmitPaymentResult(raw: unknown): RelaySubmitResult {
  const rawRecord = raw as Record<string, unknown>;

  if (raw && typeof raw === "object" && "accepted" in raw && rawRecord.accepted === true) {
    return {
      accepted: true,
      status: "queued",
      ...(typeof rawRecord.paymentId === "string" && { paymentId: rawRecord.paymentId }),
      ...(typeof rawRecord.checkStatusUrl === "string" && {
        checkStatusUrl: rawRecord.checkStatusUrl,
      }),
      // NEW: surface relay-side TTL fields
      ...(typeof rawRecord.nonceExpiresAt === "string" && {
        nonceExpiresAt: rawRecord.nonceExpiresAt,
      }),
      ...(typeof rawRecord.sponsorNonceValidForMs === "number" && {
        sponsorNonceValidForMs: rawRecord.sponsorNonceValidForMs,
      }),
    } as RelaySubmitResult;
  }

  // Error path: surface attribution
  if (raw && typeof raw === "object" && "accepted" in raw && rawRecord.accepted === false) {
    const parsed = RpcSubmitPaymentResultSchema.parse({
      ...raw,
      error: typeof rawRecord.error === "string" ? rawRecord.error : "Payment submission rejected by relay",
    });
    // NEW: attach attribution if present
    if (typeof rawRecord.responsible === "string") {
      (parsed as RelaySubmitResult).responsible = rawRecord.responsible as "sender" | "sponsor" | "network";
    }
    if (typeof rawRecord.agentErrorCode === "string") {
      (parsed as RelaySubmitResult).agentErrorCode = rawRecord.agentErrorCode;
    }
    return parsed;
  }

  return RpcSubmitPaymentResultSchema.parse(raw);
}
```

Similar extension for `parseCheckPaymentResult` (the `RelayCheckResult` error arm).

### Step 3: Wire `nonceExpiresAt` into lp#883's staging code

```ts
// In app/api/inbox/[address]/route.ts (lp#883's staging code at line ~1538)
// REPLACE:
const stagedNonceExpiresAt = new Date(Date.now() + SPONSOR_NONCE_TTL_MS).toISOString();
// WITH:
const stagedNonceExpiresAt = paymentResult.nonceExpiresAt ??
  new Date(Date.now() + SPONSOR_NONCE_TTL_MS).toISOString();
```

And same in `lib/inbox/reconciliation-queue.ts` line ~328 (post-resubmit).

**Scope:** ~30-50 LOC: interface extensions (~10), parseSubmit extension (~15), parseCheck extension (~10), staging/resubmit consumer (~6), test (~10-20).

## Test plan

Add `lib/inbox/__tests__/relay-rpc-wire-fields.test.ts`:

1. `parseSubmitPaymentResult` accepted+all-fields → extracts nonceExpiresAt + sponsorNonceValidForMs
2. `parseSubmitPaymentResult` accepted+missing-fields → no errors, fields undefined (backward compat with old relay)
3. `parseSubmitPaymentResult` error+responsible=sender+agentErrorCode → both extracted to result
4. `parseSubmitPaymentResult` error+responsible=sponsor → responsible extracted, agentErrorCode undefined
5. `parseCheckPaymentResult` analogous cases
6. End-to-end: staging code uses `paymentResult.nonceExpiresAt` not local clock when present

## Risk surface

1. **Type contract drift:** if relay subsequently changes field names, LP parsers silently miss them. Mitigation: pin against relay's wire-contract test at PR#384 (the `sponsor-ttl-contract.test.ts` file).
2. **Backward compat:** old relay version without these fields → LP parser sees undefined → falls back to LP local clock derivation (current behavior). No regression.
3. **`responsible: "network"` on success path:** doesn't happen per design (only on error arm). Defensive — TypeScript narrowing should prevent.
4. **lp#883 conflict:** Phase 5.1 PR may conflict with lp#883's edits to the same staging code. Mitigation: rebase on whichever lands first; merge order doesn't matter functionally since the changes are additive.

## PR-readiness checklist

- [x] Wire fields enumerated (4 fields, 2 PRs)
- [x] Proposed diff sketched
- [x] Test plan (5-6 cases)
- [x] Risk surface analyzed
- [ ] **Relay quest PRs merged** — gating condition. Per #386 verification doc, mainnet deploy follows merge via Cloudflare Git integration.
- [ ] Mainnet `/sponsor` response confirmed to include new fields (probe via `curl https://x402-relay.aibtc.com/openapi.json` or live test:sponsor)
- [ ] No competing LP PR opened — sweep `aibtcdev/landing-page` open PRs for `parse.*Payment.*Result` edits before opening

## Decision rule for firing

Open PR when ALL of:
1. **x402sr#379 merged to main** AND CF deploy completes (Cloudflare green deploy in PR thread)
2. **Mainnet probe confirms** `/sponsor` response includes `nonceExpiresAt` (curl + jq check)
3. **No other LP PR** opens with the same `parseSubmitPaymentResult` extension (sweep before push)
4. Optional: x402sr#381 (Phase 1 attribution) also merged → can ship full 4-field extraction in one PR

If only #379+#383 merge (TTL fields) but #381 (responsible/agentErrorCode) doesn't: ship a smaller Phase-5.1a PR covering just the TTL fields, leave Phase-5.1b for after #381 merges. Don't bundle if relay state is partial.

## Cross-references

- v424 LP-parser-under-extraction learning (memory/learnings/active.md)
- v421 lp#883 review (the finding that started this)
- v422 x402sr#381 review (same class of bug, second instance)
- v424 #386 cross-link comment (explicit Phase 5.1 offer)
- #386 verification doc (Metrics 2 + 7 will measure the propagation this fixes)
