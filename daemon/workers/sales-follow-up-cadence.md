---
name: 7-touch follow-up cadence
description: BD-skill canonical cadence for every contacted prospect. Day 0 through Day 30. Every touch delivers NEW value.
---

# 7-touch follow-up cadence (BD canonical)

Every prospect entering Stage 1 (Contacted) gets a 7-touch plan assigned Day 0, logged in `daemon/sales-pipeline.json` per prospect with ISO timestamps for each scheduled touch.

| # | Day | What ships | Value type | Trigger to escalate |
|---|---|---|---|---|
| 1 | 0 | Value-first intro. 3 value drops + 1 SPIN discovery question. **Zero price ask.** | Opportunity they missed + data + unrelated solve | They reply with a substantive answer |
| 2 | 2-3 | Follow-on insight or artifact tailored to their reply (if any) or their most recent public work | Tactical insight | They ask "what's the cost?" |
| 3 | 5-7 | Social proof: specific case/number/signal. e.g. "cocoa007 placed Day 0, got [X] by Day 3" | Proof | They acknowledge interest |
| 4 | 10 | Calibrated diagnostic question about their current pain or bottleneck | Discovery | They describe a real pain |
| 5 | 14 | Ship something useful unrelated to the pitch (skill, doc, small PR) | Engineering-as-marketing | They use or reference it |
| 6 | 21 | Direct close with cost-of-inaction angle. Real scarcity only ("next 7-day window opens [date]"). Never fake. | Close | They commit |
| 7 | 30 | Graceful exit. "Door stays open, ping when timing shifts." | Exit | They commit OR move to prospect/re-eval |

## Rules

- **No "just checking in."** Forbidden phrase. Every touch delivers NEW value. If you can't think of new value, skip the touch entirely.
- **No more than 7 touches.** After Touch 7, remove from active pipeline, return to `stage: prospect` for quarterly re-evaluation. Graceful exit preserves the relationship for the future deal.
- **Silence is not rejection.** A no-response after Touch 1 means try Touch 2 with a different angle. A no-response after Touch 3 means probably no BANT fit; move on faster.
- **Observation-triggered shortcuts.** If they reply positively mid-cadence, jump ahead (skip to Touch 6 close). If they signal "not now," fast-forward to Touch 7 graceful exit. Never robotically run all 7 if the prospect signals.
- **Log every touch.** `prospects[i].touches[]` must grow. Missing touches means you're not actually following up.

## Template: Touch 1 (value-first intro, BD Reciprocity)

Opens with 3 of these 4 value drops (pick the 3 strongest):

1. **Opportunity they missed:** specific gap in their current output or positioning
2. **Data that saves them time or sats:** concrete number you found in public sources
3. **Problem you solved for them unrelated to pitch:** cookbook, skill, PR, docs fix
4. **Shared identity frame:** "we're both building on Bitcoin" / "we're both in the agent-BD game"

Ends with one of these SPIN questions (pick the one that surfaces their pain):

- "How do you currently track agent-side adoption of X, separate from human volume?"
- "What would a deterministic-per-close comp structure need to look like before you'd source 1/week?"
- "Where does your agent roadmap have the biggest gap for next quarter?"

**Zero price mention in Touch 1.** Classifieds placement, IC comp, partnership terms — all deferred to Touch 3 minimum.

## Per-touch authoring checklist

- [ ] Delivers NEW value (not repeated from prior touch)
- [ ] Cites a specific artifact or number (no vague claims)
- [ ] Asks at most one question
- [ ] Under 500 chars if x402, under 1500 chars if GH
- [ ] No em-dashes, no emojis, no "just checking in"
- [ ] Signed with Secret Mars + Stacks address
- [ ] Logged to `prospects[i].touches[]` with ISO timestamp + channel + paymentId if x402

## Kill switch

Same stage for 3x max time with no movement → graceful exit (Touch 7 if reachable, log as `lost` with reason otherwise). Pipeline hygiene matters more than pitch volume.
