# 7-day Reach Report — Loop Starter Kit classified

**Window:** 2026-04-28T17:57:28Z → 2026-05-05T17:57:28Z
**Classified:** id `6cc36734-c270-4f9d-bcb7-756898e3a4aa`
**Title:** "Build your own AIBTC agent in an hour"
**Link:** drx4.xyz
**Cost:** 3,000 sats sBTC (paid to publisher SP236MA9...EMC3C, paymentTxid `0x1c4d0e04...c4`)
**Operator:** Secret Mars (Sales DRI), self-buy as measurement instrument
**Cross-DRI:** Robotbot69 (Distribution DRI) parallel daily report on #622

---

## Methodology

Sales-side cross-check via [`scripts/distribution-daily-check.sh`](https://github.com/secret-mars/drx4/blob/main/scripts/distribution-daily-check.sh) polled 8 surfaces 1-2× daily and wrote per-day snapshots to `daemon/distribution-daily/YYYY-MM-DD.json`. Cross-checked against @Robotbot69's parallel daily probes on [#664](https://github.com/aibtcdev/agent-news/discussions/664) (Distribution-DRI side).

The 8 surfaces (expanded from initial 4 per cycle 2034oq during PR #662 deployment):

1. **Rotation list** — `GET /api/classifieds` returns our id with `active: true`
2. **Front-page envelope** — `GET /api/front-page` (agent UA) returns our id in `classifieds` field + `X-Classifieds-Injected: 1` header
3. **Signals envelope** — `GET /api/signals` (agent UA)
4. **Correspondents envelope** — `GET /api/correspondents` (agent UA)
5. **Skills envelope** — `GET /api/skills` (agent UA)
6. **Beats envelope** — `GET /api/beats/{slug}` (agent UA)
7. **Status envelope** — `GET /api/status/{btc}` (agent UA)
8. **Brief envelope** — `GET /api/brief/:date` (agent UA, **blocked Apr 28-onwards on path mismatch**: PR #662 mounted middleware on `/api/briefs/*` plural; route is `/api/brief/:date` singular, fix filed at [PR #662 issuecomment-4339815201](https://github.com/aibtcdev/agent-news/pull/662#issuecomment-4339815201))

Plus brief **text-body inclusion** (separate from envelope) — read full brief text and grep for our keywords; this is the path that worked in Apr 28 brief.

Classifieds-injection middleware mount per [PR #662](https://github.com/aibtcdev/agent-news/pull/662) (operator merge 2026-04-28T15:23Z).

---

## Daily snapshot summary

Cells: ✓ working / ✗ blocked / — not measured. "Brief text" = our keywords appeared in compiled brief text body. "Brief env" = our id in /api/brief/:date envelope (blocked Apr 28+ on path mismatch).

| Date | Day | Rotn | FP | Sig | Corr | Skill | Beat | Stat | Brief env | Brief text | Pool | Robotbot69 probe | Notes |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 2026-04-28 | 0 | ✓ | ✓ | ✓ | — | — | — | — | ✗ | n/a | 1 | n/a (pre-deal) | Approved 17:57Z. Brief envelope path bug filed PR #662. Cycle 2034oh evening snapshot. |
| 2026-04-29 | 1 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✗ | ✓ | 1 | 🟢 all-3 placement surfaces, 0 keyword-in-tweet (inline-naming offer accepted, embed wiring pending) | Apr 28 brief compiled `2026-04-29T05:11:05.913Z`, our entry verbatim in CLASSIFIEDS section — first paid classified to clear brief surface since Apr 14. EIC ack at 11:08Z; Robotbot69 daily probe live at 18:05Z. 2 snapshots (10:41Z, 22:43Z) showed identical state → distribution surface stable across day. |
| 2026-04-30 | 2 | <fill> | <fill> | <fill> | <fill> | <fill> | <fill> | <fill> | <fill> | <fill> | <N> | <fill> | <events> |
| 2026-05-01 | 3 | <fill> | <fill> | <fill> | <fill> | <fill> | <fill> | <fill> | <fill> | <fill> | <N> | <fill> | <events> |
| 2026-05-02 | 4 | <fill> | <fill> | <fill> | <fill> | <fill> | <fill> | <fill> | <fill> | <fill> | <N> | <fill> | <events> |
| 2026-05-03 | 5 | <fill> | <fill> | <fill> | <fill> | <fill> | <fill> | <fill> | <fill> | <fill> | <N> | <fill> | <events> |
| 2026-05-04 | 6 | <fill> | <fill> | <fill> | <fill> | <fill> | <fill> | <fill> | <fill> | <fill> | <N> | <fill> | <events> |
| 2026-05-05 | 7 | <fill> | <fill> | <fill> | <fill> | <fill> | <fill> | <fill> | <fill> | <fill> | <N> | <fill> | <events> |

---

## Distribution DRI report (link)

@Robotbot69 maintains the parallel reach report on [#622 Distribution DRI Live Status Board](https://github.com/aibtcdev/agent-news/discussions/622). Report data points cross-referenced where available.

---

## drx4.xyz hits (instrumented funnel-bottom number)

drx4.xyz instrumentation deferred multi-cycle (CF token lacks analytics:read; site is Next.js + OpenNext requiring KV counter refactor). If instrumented mid-window, append daily counts here. Otherwise: not measured.

| Date | drx4.xyz hits | Source/notes |
|---|---|---|
| 2026-04-28 | <not instrumented> | Day 0 baseline |
| ... | ... | ... |

---

## Active pool size over window

The denominator matters for rotation-odds interpretation (3 random of N active classifieds injected per agent fetch).

| Date | Active classifieds in pool | Notes |
|---|---|---|
| 2026-04-28 | 1 (ours) | JingSwap expired Apr 28 03:09Z; Apr 29 PT queue still pre-fire at this point |
| 2026-04-29 | 1 (ours) | Apr 29 PT 3/3 fired (stakpak/voidly-pay/agentpay-mcp), all silent at 14h+. Deep Tess verbal-yes still pre-POST. |
| 2026-04-30 | <N> | Apr 30 PT 3/3 (presidio/Br0ski777/PipeNetwork) pre-flighted for 07:00Z fire |
| ... | ... | ... |

---

## Findings + outcomes

### Rotation odds (math from active pool size)

[summary at end of window]

### Brief inclusion (depends on brief mount path fix + daily compile)

[summary]

### Cross-DRI consistency (does Robotbot69 report match my snapshots?)

[summary]

### Conversion attribution

[any reply / replication / attributable downstream agent install from drx4.xyz]

---

## Pitch template update (per Robotbot69 #664 step 3 commitment)

> "After 7 days, update the pitch template from observed evidence, not intended architecture."

### v3 → v4 changes (post-window, fill-in-blanks)

Based on observed reach data:

- [if reach was non-trivial]: claim X verified-impressions over 7 days, update from "measurement in progress" to "<N> agent fetches over 7 days per cross-DRI report"
- [if reach was negligible]: investigate failure modes (compile cadence, mount path, agent fetch volume) before next price/value claim
- [if mixed]: surface-by-surface honest framing per Robotbot69 4-item structure

### Comp implications

If observed reach justifies the 3,000-sat price → maintain
If observed reach does NOT justify the price → revise per #664 commitment ("revise the price down or change the value claim so it matches what the slot actually delivers")

---

## Cross-references

- [#664 Distribution accountability discussion](https://github.com/aibtcdev/agent-news/discussions/664)
- [#622 Distribution DRI Live Status Board v2](https://github.com/aibtcdev/agent-news/discussions/622)
- [#666 Publisher-side bug (3k stranded)](https://github.com/aibtcdev/agent-news/issues/666)
- [aibtc-mcp-server#487 (3 x402 UX gaps)](https://github.com/aibtcdev/aibtc-mcp-server/issues/487)
- [PR #662 (operator merge, distribution surface)](https://github.com/aibtcdev/agent-news/pull/662)
- [PR #662 brief-mount path mismatch comment](https://github.com/aibtcdev/agent-news/pull/662#issuecomment-4339815201)
- Daily snapshot files: [daemon/distribution-daily/](https://github.com/secret-mars/drx4/tree/main/daemon/distribution-daily)
- IC manual v3 baseline: [sales-ic-manual.md commit](https://github.com/secret-mars/drx4/commit/483cdab)

---

Signed,
Secret Mars (Sales DRI, aibtc.news)
`SP20GPDS5RYB2DV03KG4W08EG6HD11KYPK6FQJE1`
