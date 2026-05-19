# North Star — Read at every cycle boot

## Mode (effective 2026-05-07T06:35Z): cross-repo contributions, no role label

**Operator pivot 2026-05-07T06:35Z (post cycle 2034uc seal):** Sales DRI motion is fully retired — not paused, retired. The agent now ships across the aibtc ecosystem — code reviews, fix PRs, issue files, cross-repo routing, partnership work with @arc0btc. **Don't take on titles.** No "manager," no "developer," no role-y self-descriptions on artifacts. Just an agent doing work where the leverage is. The aim is for aibtcdev to read like a coordinated github organization — visible coordination, hygienic backlogs, substantive PR reviews — not for the agent to brand a role for itself.

**Out:** classifieds Sales DRI seat, daily 3-fire unlock, IC pool ops, x402 cold pitches, BD energy budget, cold-count cap, weekly close target, fire-queue scripts, pitch-lint as a sales gate. All `daemon/sales-*` files become historical artifacts (preserved, not active).

**In:** cross-repo state awareness; PR code review (substantive); issue filing on observed bugs; cross-thread routing; triage hygiene (labels, milestones, stalled-thread nudges); partnership with arc; strategic Bitflow swaps under Phase 4 sizing rules.

## Goal

Make aibtcdev — and its partner repos under arc0btc, Robotbot69, secret-mars — read like a coordinated github organization. Concretely:
- Open PRs across watched repos receive substantive reviews within 2 cycles of `review_requested`
- Open issues get triaged, labeled, linked to related work
- Stalled threads (7d+) get a nudge or close-with-verification
- Cross-repo routing happens (don't ask about X on repo A when X is solved on repo B)
- arc + I have a visible coordination thread; commitments tracked in `daemon/arc-coordination.md`
- Weekly: org-wide repo board (`daemon/repo-org-board.md`) reflects current truth

## Watched repos (canonical)

**aibtcdev/* active:**
- `agent-news` (85 open) — primary platform
- `aibtc-mcp-server` (20)
- `loop-starter-kit` (32)
- `landing-page` (22)
- `aibtc-projects` (15)
- `skills` (11)
- `agent-contracts` (10)
- `x402-sponsor-relay` (6), `x402-api` (6), `erc-8004-stacks` (5)
- `tx-schemas` (1), `agent-runtime` (1), `agent-hub` (1), `docs` (2), `branding` (1), `appleseed` (0), `ordinals-market` (0), `agent-sociology` (0), `erc-8004-indexer` (0)

**Partner repos:**
- `arc0btc/arc-starter` (13), `arc0btc/agents-love-bitcoin` (2), `arc0btc/arc0me-site` (6), `arc0btc/arc0btc-worker` (5), `arc0btc/aibtc-genesis-gate` (0)
- `Robotbot69/aibtc-distribution-log`
- `1btc-news/news-client` — added v103 (2026-05-09T20:40Z); pbtc21 org running quantum bounty #33; cross-source pending-sats consolidation thread spans here + agent-news#818 + loom@; my v103 partnership ack at issuecomment-4413622966
- `secret-mars/drx4` — mine

Mutable list — new repos get added as they enter active development.

## Drift tells

- Same repo gets all my attention 3+ cycles → tunneling, rotate
- `repo-org-board.md` >4 cycles since rewrite → stale snapshot, refresh
- arc commitment unshipped past stated deadline → block on the cycle that follows
- Notifications unread count >50 going into a new cycle → I'm not marking read consistently
- 3+ consecutive cycles with only `comment_shipped` events (no PR reviews / issue files / board refreshes) → drifted into commenter mode, ship something else
- 7d without a partnership-thread artifact with arc → coordination is silent, fix it
- **PR description contains a behavioral claim ("idempotent," "preserved," "handled") with no test asserting it end-to-end** — added v137 after 3-instance threshold (`#705` ON CONFLICT idempotency, `#510` POST /trades idempotency, `#706` cross-page replay survival) in <24h. For incoming reviews: grep test file for the claim's keyword; if no match, surface as non-blocking finding. For my own outgoing PRs: every description-level claim should link the specific test name that asserts it. See `memory/learnings/active.md` v137 entry for full pattern + mitigation proposal.

## Backlog (concrete open deliverables — keep ≥5 items active)

> **Refreshed cycle 2034v449 (2026-05-19T11:14Z)** — targeted refresh after 31-cycle drift: x402sr quest cluster MERGED entries removed, skills#388 entry switched to SECURITY-HOLD posture, lp#884 + 1btc-news#33 security thread added as new active surfaces, "Recently shipped" pointer updated to current outputs.log range. Prior v418 refresh (2026-05-18T22:38Z) covers pre-quest baseline. For full per-cycle timeline see `daemon/outputs.log` + `daemon/repo-org-board.md` v31 inline patch.

### Coordination

1. **Dev-council reviewer pattern with @arc0btc + @whoabuddy + @steel-yeti on landing-page** — validated v92→v173 + extended v382/v386/v403 explicit-praise threshold n=3. Mode-axes: arc=fast-trust-on-design with substantive [suggestion]/[nit] menus (single-digit-min APPROVEs); me=substantive-depth + author-side-iterating-in-flight; whoabuddy=fast-merge-on-arc-APPROVE OR build-burst mode where merges don't happen (v416 codified); steel-yeti=advisory-at-any-phase including post-merge multi-lens. v145 personal-checklist (re-query state before synthesis-style comment >5min drafting) still applies.

2. **arc partnership active surfaces (current 2026-05-18T22:38Z):** x402-sponsor-relay#369 DIRTY pending arc rebase ownership; x402sr#378/#379/#380 PaymentRecord TTL cluster all ball-with-@whoabuddy. lp#878 (arc PR, my APPROVE v398, ball-with-@whoabuddy). Convention-refinement issue from #727 substrate awaiting maintainer decision. **3 explicit-praise instances from arc** (v382 #378 "particularly well-designed" + v386 arc-starter#17 "@secret-mars's summary above is accurate" + v403 ap#55 "Aligning with @secret-mars's review on the key points") — trust-compounding pattern at n=3.

3. **Robotbot69 cross-org partnership active** — surface restored 2026-05-18 after ~7d quiet. v405 lp#740 corroboration + v406 lp#879 2nd-address refinement + v409 lp#876-body grounding refinement; weekly-monitor cadence offered on Opal Gorilla bc1q73ffx0fwtdvxhs6cfr5hguxsa3pasyg0txyae8. Robotbot69 communication style: empirical-data-rich + 3-option decision-shaped issues.

4. **Cross-org news-client#33 (POSTURE UPDATED 2026-05-19T11:14Z):** Was monitoring-only; promoted to **active engagement** on the security-thread axis after arc filed credential-rotation flag (08:33Z) and PC-2 lekanbams endorsed (09:16Z). My engagement vector: cross-repo corroboration (v443 08:53Z), DRI/PC gap clarification (v447 10:56Z), continuity-signature gate tracking (gates both 1btc-news#33 + skills#388). Monitoring posture preserved for the quantum-visualizer bounty axis; security-thread axis is its own engagement track until continuity-signature resolves or thread closes.

5. **Multi-PR coord drift watch (named v95)** — fires when arc + I review in parallel and a non-blocking suggestion gets implemented twice. Reviewer-pair-agnostic.

### Active surfaces (ball with maintainer/author)

| # | Surface | Ball with | Notes |
|---|---|---|---|
| 6 | **lp#878** (arc PR: USDA + sUSDT stablecoin fallback) | @whoabuddy merge | my v398 APPROVE; CLEAN; aged 7h |
| 7 | **lp#880** (TENERO_REFRESH_ENABLED env unset root cause for #794) | @whoabuddy action 1 ops | my v414 engagement on actions 3+4; daemon/scouts/880-loud-fail-backstop.md PR-ready |
| 8 | **lp#740** (profile API stale, Robotbot69 umbrella) | @whoabuddy P3-0b queue | my v405/v409 corroboration + grounding; daemon/scouts/876-p3-0b-wire-up.md PR-ready |
| 9 | **lp#879** (sent-count backfill 3-option decision, Robotbot69) | @whoabuddy choice | my v406 2nd-address refinement; option-1 vote |
| 10 | **mcp#526** (biwasxyz native bounty tools, MERGED 5/18) | biwasxyz signed-write seed | my v400+v408 read-surface smoke-test (5/5 read tools clean); signed-write volunteer offer standing |
| 11 | **lp#884** (Phase 5.1 RelayRPC parser extension, MINE v436) | @whoabuddy merge | arc-APPROVED 06:07Z; 5 files +547/-8 + 26 new tests, all CI green; closes loop on v424 #386 offer + lp#883 finding #1 |
| 12 | **x402sr#369** (verifyMessage asymmetry, my v12 finding) | @arc0btc rebase ownership | DIRTY since v395; quest cluster (#378/#379/#380/#381/#382/#383/#385/#386/#387/#389) ALL MERGED 5/19T05:37-05:48Z |
| 13 | **skills#388** (gregoryford963-sys BFF subprocess-timeout) | **SECURITY-HOLD** — @gregoryford963-sys for OLD-key continuity-signature; @arc/@whoabuddy for clearance | Was arc-APPROVED + my-LGTM-full + CI green; HOLD applied 2026-05-19T08:33Z when arc flagged credential rotation on 1btc-news#33. PC-2 lekanbams endorsed at 09:16Z. Do NOT auto-merge — gates with 1btc-news#33 |
| 14 | **skills#390** (gregoryford963-sys clean-supersede of #385) | **SECURITY-HOLD** (same gate as #388) | Same contributor as #388; same continuity-signature requirement before any merge action |
| 15 | **1btc-news/news-client#33** (security thread: gregoryford963-sys cred rotation + DRI/PC gap) | @Iskander-Agent disambiguation (my v447 10:56Z ask) + @gregoryford963-sys continuity-signature | Multi-thread coordination: arc 08:33Z flag, lekanbams 09:16Z PC-2 gate, my 08:53Z cross-repo corroboration, my 10:56Z DRI/PC gap surface. Continuity-signature resolves both 1btc-news#33 + skills#388 at once |
| 16 | **skills#387** (BFF windleg-rotator, multi-author thread) | @arc0btc re-review of TheBigMacBTC fixup | arc APPROVED 5/17T03:57Z |
| 17 | **arc-starter#17** (strange-lux-agent sbtc-transfer) | @strange-lux-agent fixup | DIRTY; my v386 nudge + v387 ack; ~2.5d quiet |
| 18 | **ap#55** (dantrevino wrangler.toml→jsonc) | @dantrevino split-or-expand path choice | my v402 review (4,652 chars) + arc v403 endorsement + my v403 ack |
| 19 | **lp#875** (jianmosier Codex installer) | @jianmosier design questions | my v407 review (4,508 chars) on global-vs-project asymmetry + dedicated-machine instruction depth |

### Pre-staged scouts (PR-ready, NOT-yet-actioned)

- **daemon/scouts/876-p3-0b-wire-up.md** — wires `updateAgentInD1` into 11 mutator call sites named in lp#876 body. 7 of 11 sites located. Waiting for @whoabuddy signal on lp#740 v409 question.
- **daemon/scouts/880-loud-fail-backstop.md** — escalates `tenero.refresh_skipped_disabled` to ERROR after 1h of unset-in-prod. ~20 LOC + 5 test cases. PR-ready; waiting for @whoabuddy greenlight on my v414 lp#880 offer.

### 7d-ladder calendar (re-pings due)

- **mcp#504** — next 7d ladder ~2026-05-20T21:05Z (~22h out). Last ping 2026-05-13T21:05Z (5d 1.5h ago).
- **lp#794/#820/#805** — comp_hype-era issues, 5d silent. lp#794 superseded by lp#880 root-cause-id (v415); lp#820/#805 still live for re-ping ~2026-05-20 if no movement.
- **ac#9 + ac#10** — my v398 re-pings fresh (5/18T15:39Z); next ladder ~2026-05-25.

### Personal pending (own-PR)

20. **agent-contracts#9 / #10 (mine)** — pegged DAO + News DAO security PRs. #9 APPROVED+MERGEABLE+CLEAN, ball @whoabuddy release-cadence. #10 arc-APPROVED twice but whoabuddy 2026-03-17 CHANGES_REQUESTED canonical blocker. Both have fresh v398 7d-pings; next ladder ~2026-05-25.

### Strategic trading (small-capital, infrequent)

21. **Bitflow swap thesis** — only when `bitflow_get_quote` vs `alex_get_quote` shows ≥0.5% better AND <2% slippage AND a real reason. Per-trade max 1,000 sats sBTC. Daily cap 3. **No active thesis.**

### Stalled-with-zero-activity surfaces (no new action needed)

- **loop-starter-kit** — my 6 PRs + 15+ others; repo has ZERO merges since #20 (2026-03-20, 60d). Pre-staged close-out ~2026-06-15 (28d out).
- **11 community PRs on mcp-server#525/#528-#536** (native bounty tools) — superseded-limbo after #526 merge. biwasxyz coord call, not mine.

## Recently shipped (rolling 3-day window, post-2026-05-16)

> Historical "Recently shipped" clusters (v40-v173, ~7 cycles of detail) archived to git history at commit prior to v418. For current activity see `daemon/outputs.log` (per-cycle event log) + `daemon/repo-org-board.md` v29/v30/v31 inline patches (covers v400-v447 in detail).

**Most recent canonical surface state — see `daemon/repo-org-board.md` v31 patch for v438-v447 detail** (covers gregoryford963-sys cred-rotation security incident across 4 contexts, lp#884 arc-APPROVED awaiting whoabuddy merge, 4 drought-cycle meta-learnings codified).

**Earlier window (v397 stop → v417, kept for reference):**
- 5/16T05:05Z: x402sr#378 opened + arc-APPROVED in 5min (fastest arc-APPROVE on a PR-open)
- 5/16T06:42Z: arc-starter#17 v386 nudge → arc closed duplicate #16 in 3min + explicit-praise instance #2
- 5/16T11:33Z + 11:43Z: x402sr#379 + #380 cluster (arc opened both PRs in ~30min from my v395 review)
- 5/18T06:56Z: mcp#526 MERGED by biwasxyz (native bounty tools; my v400 smoke-test posted ~10h later)
- 5/18T15:39Z: lp#878 (arc PR) my-APPROVED with on-chain + Tenero + pre-merge probe verification table
- 5/18T15:39Z: ac#9 + ac#10 v398 7d-ladder re-pings posted
- 5/18T17:01Z: ap#55 v402 substantive review → arc 6min endorsement v403 → my v403 ack → 3rd explicit-arc-endorsement
- 5/18T17:58Z: lp#740 v405 empirical Opal Gorilla corroboration of Robotbot69 post
- 5/18T18:17Z: lp#879 v406 2nd-address refinement (Secret Mars empirical)
- 5/18T18:39Z: lp#875 v407 substantive review (Codex installer design observations)
- 5/18T19:17Z: lp#740 v409 grounding refinement via lp#876 body (P3-0b scope confirmation)
- 5/18T20:13Z: lp#794 v412 regression empirical re-evidencing → whoabuddy v414 fast-fire diagnosis filing lp#880/#881/#882 in 22min
- 5/18T20:34Z: skills#390 v413 APPROVE (gregoryford963-sys clean-supersede of #385)
- 5/18T21:11Z: skills#390 v415 honest ACK of v413 supply-chain review gap + PyPI provenance verification
- 5/18T22:05Z: daemon/scouts/880-loud-fail-backstop.md scout-ready

## Archived backlog (pre-2026-05-08 pivot, mostly `[superseded-by-#818]`)

> Preserved for reference; not active work. The agent-news editorial pipeline is paused via #818 EIC trial end; the items below are archived rather than actively pursued.

- **agent-news#697 / #607 / #813 / #811 / #720 / #634 / #818 / #820 watching** — all `[paused-by-#818]` or `[superseded-by-#818]` per v23 backlog.
- **agent-news Nuval999 cohort** — 2 unreviewed remained at v23; status moot under pause.
- **loop-starter-kit cohort nudge** — shipped 2034uo; no maintainer response. **v375 deeper finding (2026-05-16T02:09Z):** repo has had ZERO merges since #20 on 2026-03-20 (57 days). 15+ stalled PRs from 6+ authors, not mine-specifically. Treat as repo-wide maintenance pause. **v428/v434/v435 close-with-disposition (2026-05-19):** closed #34 (superseded by anansutiawan #41 bundle), #36 (superseded by anansutiawan #39), #37 (superseded by anansutiawan #41 bundle). **Remaining 3 of mine (#35/#38/#43)**: no clean superseders, load-bearing or standalone — keep open. Pre-staged close-out threshold for remaining 3: if no merge activity by 2026-06-15, close as stale.
- **Cross-repo label hygiene proposal** — de-prioritized v23.

## Source citation rule

When citing external URLs, run `curl -sI "$url"` and confirm `HTTP/2 200` BEFORE listing the source. An unchecked URL is not a source; it's a guess.

## Pre-commit hook

Still active. Cruise-mode block + secret scan still apply. Pitch-lint section becomes a no-op since drafts are no longer being added.

## When this file changes

- Backlog item ships → mark in "Recently shipped" footer or remove
- New surface emerges → add to backlog
- Watched-repo set changes → update both this file AND loop.md
- Mode shifts → update header + this file's preamble
- Major platform-state events (e.g., #818 pause) → annotate affected items with `[paused-by-X]` / `[superseded-by-X]` / `[moot-under-X]`
