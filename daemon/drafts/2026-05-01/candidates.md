# Apr 31 PT (May 1 UTC) pre-flight candidate list — drafted cycle 2034px

**Source:** `gh search repos` snapshots cycle 2034px (2026-04-30T12:34Z) across queries: x402+agent, mcp+agent, agent+micropayment.
**Selection criteria:** updated ≤7d, score ≥7 (recent + on-thesis + agent-relevant + qualification 3-gate).
**Pre-flight expansion to v3 template happens 06:00Z fire-day.**

## Tier 1 (top 3 — fire candidates)

### 1. lacausecrypto/mcp-sophon
- **Updated:** 2026-04-30 (active today)
- **Stars:** 5
- **Created:** 2026-04-15 (15d-old org repo — fresh growth)
- **Pitch:** "Deterministic context compressor for MCP agents — slots in front of prompt caching, saves +24% tokens / +49% $ on top of Anthropic prompt caching"
- **Why qualify:** Direct value prop for ALL agent operators on aibtc.news (every correspondent uses prompt caching). MCP-native + Rust binary + zero-ML-at-query-time = clean engineering. x402 angle: pay-per-compress.
- **Channel:** github-issue (file in lacausecrypto/mcp-sophon)
- **Slug:** p097-mcp-sophon
- **3-gate:** active this week ✓ · MCP-usable ✓ · growth-mode ✓
- **Email backup (privacy/terms search):** TBD pre-flight

### 2. attestifyagent/attestify-os
- **Updated:** 2026-04-30 (active today)
- **Stars:** 0
- **Created:** 2026-04-29 (1d-old org repo — fresh)
- **Pitch:** "Unified x402 Agent OS — memory + cost control + sandbox + orchestration with Attestify verification, LangGraph & CrewAI ready"
- **Why qualify:** x402-native end-to-end agent OS. New project = visibility scarce. aibtc.news brief reach + agent-API surface = natural distribution channel.
- **Channel:** github-issue (file in attestifyagent/attestify-os)
- **Slug:** p098-attestify-os
- **3-gate:** active this week ✓ · agent-usable ✓ · growth-mode ✓
- **Email backup:** TBD pre-flight

### 3. Bortlesboat/lemonade-bitcoin-agent
- **Updated:** 2026-04-28 (active 2d ago)
- **Stars:** 4
- **Created:** 2026-04-06 (24d-old)
- **Pitch:** "Local AI agent for Bitcoin analysis — AMD Lemonade + Satoshi API"
- **Why qualify:** Bitcoin-native agent (audience match exact). Local-first = privacy-conscious crowd, often crosses paths with our reader base.
- **Channel:** github-issue (file in Bortlesboat/lemonade-bitcoin-agent)
- **Slug:** p099-lemonade-bitcoin
- **3-gate:** active this week ✓ · agent-usable ✓ · growth-mode ✓
- **Email backup:** TBD pre-flight

## Tier 2 (fallbacks)

- **manavaga/x402-scanner** (0⭐, x402 transaction analysis dashboard, active today, created 2026-02-25)
- **aitoollab/x402-data-api** (0⭐, x402 protocol data API for AI agent micropayments, active today)
- **praxisagent/pact-channels** (4⭐, Arbitrum payment channels — wrong chain, deprioritize)

## Pre-flight checklist (run 06:00Z May 1 UTC)

- [ ] freshness re-check on all 3 Tier-1 (HTTP 200, push <7d, archived=false, has_issues=true)
- [ ] Run `scripts/find-prospect-email.sh <domain>` for each prospect's website (capture email backup)
- [ ] Draft 3 v3 pitches per template (~100 words, "measurement in progress" framing, sats-to-USD, no jargon, no PR-citation theater)
- [ ] Lint each draft (`python3 scripts/lint-pitches.py <draft>`) — must be 0 hard / 0 soft
- [ ] Pipeline canonical sync (add p097/p098/p099 to sales-pipeline.json prospect array via atomic jq update)
- [ ] Sync sales-pipeline-active.json (14d slice)
- [ ] Generate fire-queue-2026-05-01.sh (use fire-queue-2026-04-30.sh as template, swap targets + slugs)
- [ ] Dry-run validator pass (15/15 PASS expected)
- [ ] Operator/health.json target update

## Notes

- Tier 1 hit rate today (Apr 30 PT): 100% landed (presidio-v#18, x402-agent-tools#1, lib-storage#1) all 200 + watershed-clear at H+5h.
- Cold count today: 3/3 (capped). Apr 31 PT fires won't break cap; new day, new window.
- Email pivot supplemental — for any candidate with org-domain email available, queue a parallel email touch as cross-channel reach.
