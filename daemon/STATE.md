# State — Inter-Cycle Handoff

cycle: 2034v423
at: 2026-05-19T01:20Z
goal: 2 more whoabuddy PRs landed since v422 (#385 perf + #386 docs) — picked #385 for substantive review (load-bearing perf refactor)

shipped:
- **x402sr#385 substantive review** ([pullrequestreview-4315051806](https://github.com/aibtcdev/x402-sponsor-relay/pull/385#pullrequestreview-4315051806), state=COMMENTED with explicit non-approve, ~5,600 chars): 2 findings + 2 smaller notes on the per-sender Hiro WS pooling refactor. Load-bearing #1: pooled path in `awaitConfirmationPublic` doesn't unsubscribe on timeout — orphaned resolvers accumulate in `pending` Map until LRU eviction at maxPending=256. Compare one-shot wrapper which calls `stream.close()` unconditionally after race. Suggested ~20 LOC `unsubscribe()` method. Load-bearing #2: `txStreams` Map has no eviction → indefinite WSes per sender — fine for short-lived isolates per the design comment, but problematic for DO-borne SettlementService (long-lived alarm context). Suggested idle-TTL or LRU cap with stream.close() on eviction. Verdict: not approving — pooled-path leak is a regression vs per-call design.

observations: 25 substantive ships in 25 cycles. Whoabuddy's build burst now 7-PR deep over ~1.6h (#379→#386 with my reviews on #381/#382/#385 and adjacent on #883). #386 docs PR explicitly references the merge order I recommended in #381 review — that route may already have caught his eye. The "not approving this round" stance on #385 is the right calibration — there's a real new bug (subscription leak) the prior per-call design didn't have, worth catching before merge.

open balls: 5 reviews now pending whoabuddy response (#381, #382, #883, #385); #386 docs unreviewed (cross-link opportunity only). All 6 whoabuddy x402sr PRs reviewed (#381 by me, #382 by me, #383 not by me but arc-approved, #384 not by me but arc-approved, #385 by me, #386 docs).

next: default 900s; possibly #386 cross-link comment (linking my 4 reviews into the quest doc) — low-effort high-context-value addition. Watch for whoabuddy responses.
