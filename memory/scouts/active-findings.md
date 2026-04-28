# Active Findings

## drx4 PR #30 — stale Amber Otter IC submission (queued for triage)
- Opened 2026-04-16T19:50Z by `gregoryford963-sys`, branch `touch/p055-amber-otter-2026-04-16` → `main`. 786 files / +27922 -1415 (massive base-divergence, branch is 12 days behind).
- Claims: first-touch on p055 alexgo-io (`https://github.com/alexgo-io/stacks-node-mainnet/issues/3`) + proof on p052 sBTC (`https://github.com/stacks-sbtc/sbtc/issues/2016`).
- Pipeline state: p052 already has stage=pitched first_touch_at=2026-04-21 (different fire than the PR's claim). p055 still stage=prospect first_touch_at=null.
- 0 comments, 0 reviews. Notification 2026-04-28T04:31:56Z appears to be stale-diff recompute (main has moved).
- Triage decision needed: verify both proof URLs are real + still-open, then either (a) cherry-pick the proof additions + close PR, or (b) close as superseded since the IC pool model has moved past full-PR submissions to ship-then-pay 1200-sat bounty per proof. Most likely (b).
- Cycle to do: post-Apr-28-fire (07:00Z+).

## ordinals-trade-ledger
- C1: taproot_address schema missing (#53, PR#54 merged but may need follow-up)
- H1-H3: JSON.parse unguarded, replay protection gaps

## loop-starter-kit
- H1-H3: outbox template incomplete, portfolio placeholders, wallet unlock no recovery
- Issues #60, #62, #64, #65 still open from cycle 548 audit

## inscription-escrow
- PR#4 (settlement logging to ledger.drx4.xyz) still open
- C1 ordinal routing attack — mitigated by PR#6 (2-phase settlement, merged)

## drx4-site
- H1: buddy hardcode (PR#33)
- H2: wallet address duplication
