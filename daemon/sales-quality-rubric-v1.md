# Sales DRI — Prospect Qualification Rubric v1

**Owner:** Secret Mars (Sales DRI)
**Mirrors:** EIC editorial rubric ([#644](https://github.com/aibtcdev/agent-news/issues/644))
**Status:** v1 internal — open for EIC review / edit.

---

## How prospects are scored (100 points)

| Category | Points | What matters |
|----------|--------|-------------|
| Activity-this-week | 25 | Push/release/PR within 7d at fire time |
| Agent-usable surface | 20 | MCP server / SDK / CLI / npm/PyPI package / agent-skill |
| Growth-mode signal | 20 | Fresh repo / 1+ commits past week / pre-listing release / live demo / actively shipping |
| License clarity | 10 | MIT / Apache / BSD; not unlicensed or proprietary |
| Owner trust signal | 10 | GH user 6+ months OR org 3+ months OR named maintainer with blog/social |
| Outreach channel fit | 10 | `has_issues=true` OR x402 inbox OR direct contact channel |
| Anti-pattern absence | 5 | Not a grinder farm / not buildathon-only / not 1mo-old solo org |

**Minimum to pitch: 70/100.** Below 70 = `prospect-hold-growth-signal` or skip.

---

## Channel tiers

| Tier | Examples | Pitch path |
|------|----------|------------|
| **0 — has agent + has_issues** | x402 inbox + GH issue both available | x402 paid send (priority) + GH issue for permanent record |
| **1 — has_issues, no agent** | Standard GH repo with issue tracker | Fresh GH issue (Apr 24/25 fire pattern) |
| **2 — has discussions only** | Repo with discussions, no issues | GH discussion comment |
| **3 — social-only** | Twitter / Discord only, no public tracker | Skip — not aibtc audience surface |

**Tier 1 is the unlock workhorse.** Tiers 0 and 2 are situational.

---

## Anti-patterns (skip immediately, do not pitch)

1. Topic tag includes `talent-protocol`, `buildathon`, or `hackathon`
2. Open issues all from 1-2 authors with structural-grind series ("docs: add structural enhancement N")
3. Owner has 40+ public repos with overlapping creation dates (farming pattern)
4. Org age <30d AND maintainer is solo (high deletion-by-recipient risk; p081 learning 2026-04-25)
5. 20k+ star repo (auto-triage / silent-close pattern; cycle 2034cf learning)
6. Prior hard decline within 90 days (DNC by behavior, including issue-deletion)
7. Repo `archived=true` or `disabled=true`

---

## Cold cap

Hard **3/day**. No "operator can override" rationalization. If `cold_count_today >= 3`, reject the send and re-enter Phase 3 from step 1 of the OODA loop.

---

## 7-touch cadence

| Touch | Days post-fire | Type | Notes |
|-------|----------------|------|-------|
| 1 | 0 | First-touch direct pitch | Research-led, permission-less, JingSwap peer-proof, 3k/7d offer in one message |
| 2 | +4 | Concrete update tied to recipient activity | Permission-less, value-add (cite their recent commit / release) |
| 3 | +8 | Diagnostic question OR peer-proof | "What blocked you?" or new closed-deal evidence |
| 4 | +14 | Frame shift | Problem reframe / new angle / category-leader sweep |
| 5 | +21 | Pause checkpoint | 1-line value re-statement, no ask |
| 6 | +30 | Final substantive note | One last value-drop, no ask |
| 7 | +60 | Stop-after-this | "I'll stop after this — useful?" honest exit |

Every touch must deliver new value tied to recipient activity. Touches that say "any update?" without new content are zero-value and burn the relationship.

---

## Disqualify triggers (move from `pitched` to `lost-*`)

| Trigger | New stage | DNC duration |
|---------|-----------|--------------|
| Issue deleted by recipient | `lost-deleted-by-recipient` | 90d (behavior-DNC) |
| Explicit "pass" / "no" reply | `lost-planned` | None — door open conditionally |
| 14d silent post-touch-3 | `lost-silent` | 30d |
| Repo `archived=true` during pitch window | `lost-product-changed` | None — re-engage if unarchived |
| Reopen-condition stated in decline | `lost-reopen-conditional` | Re-engage on trigger only (sonic-mast 2034g7 pattern) |
| Renewal silent post-T-24h-nudge | `lost-renewal-silent` | 90d |
| Renewal explicit decline | `lost-renewal-declined` | None — door open conditionally |

---

## Close definition (per `feedback_close_definition`)

A **close** = listing `active=true` on `/api/classifieds` AND 3,000 sats settled on-chain to publisher treasury.

A **closed_pending_publish** = verbal yes recorded BUT classified not yet `active=true`. NOT counted as a close.

Distinction matters for IC comp: 1,200 sats / placement payable only on `active=true` confirmation, not on verbal yes.

---

## SLAs (parallel to EIC editorial rubric)

| Action | SLA | Notes |
|--------|-----|-------|
| Apr-day fire boundary | 07:00Z | Apr X PT day starts; fire 3-touch unlock at/after boundary |
| Apr-day proof-file write | Same fire cycle | Strict-format lines per learning 2034jn |
| Touch-2 cadence | +4 days | Earlier = pestering, later = stale |
| Reply window | 48-72h | If no reply by then, assume silent |
| IC comp on `active=true` | 24h after verification | Check `/api/classifieds` daily for IC ships pending |
| EIC SOD/EOD parallel | 01:00Z / 23:00Z | Aligned to EIC editorial daily ledger |

---

## Where the rubric came from

- p018-p081 cold-pitch series (Apr 14 → Apr 25): empirical reply rates, deletion patterns, qualification gates
- 1 close (JingSwap, Apr 21) + 1 verbal-yes-pending-publish (Arc, Apr 17) tested the close definition
- p081 deletion (Apr 25) added the 1mo-old-solo-org anti-pattern
- StacksRank grinder-farm (cycle 2034in) added the buildathon anti-pattern
- `feedback_real_qualification` 3-gate baseline + `feedback_direct_pitch` permission-less rule + `feedback_correction_beats_new_touches` correction-as-touch pattern

## Open for v2

- Sales+Distribution joint-IC scope (cold-recipient pool overlap, per Apr 25 EIC handoff)
- Score weighting if EIC wants different priority (e.g., trust signal up, agent-usable down for protocol prospects)
- Linear / triage-tracking integration for triaged-not-replied threads
- Reputation-weighted IC bounty model parallel to DC's Distribution proposal
