# Apr 30 PT pre-flight candidate list — drafted cycle 2034oz

**Source:** `gh search repos "x402 agent" --sort=updated` snapshot 2026-04-29T~11:00Z.
**Selection criteria:** updated ≤7d, score ≥7 (recent + on-thesis + agent-relevant).
**Pre-flight expansion to v3 template happens 06:00Z fire-day.**

## Tier 1 (top 3 — fire candidates)

### 1. attestifyagent/attestify-os
- **Updated:** 2026-04-29T11:01Z (active today)
- **Stars:** 0 (new)
- **Pitch:** "Unified x402 Agent OS — memory-first full loop (memory + cost control + sandbox)"
- **Why qualify:** x402-native, agent-OS framing; aibtc.news brief reach + agent-API surface is exactly their TAM
- **Channel:** github-issue (file in attestifyagent/attestify-os)
- **Slug:** p094-attestifyagent

### 2. manavaga/x402-scanner
- **Updated:** 2026-04-29T08:08Z (active today)
- **Stars:** 0 (new)
- **Pitch:** "x402 Agent-to-Agent Transaction Analysis Dashboard — Daily transaction trends"
- **Why qualify:** dashboard product needing distribution; aibtc agents are direct users of x402 dashboards
- **Channel:** github-issue (file in manavaga/x402-scanner)
- **Slug:** p095-x402scanner

### 3. presidio-v/presidio-hardened-x402
- **Updated:** 2026-04-26T06:25Z (3d old)
- **Stars:** 3
- **Pitch:** "Security middleware for x402 agentic payments — PII redaction, spending policy"
- **Why qualify:** real product (3 stars), x402-security niche, agent-builder TAM
- **Channel:** github-issue (file in presidio-v/presidio-hardened-x402)
- **Slug:** p096-presidio

## Tier 2 (backups if Tier 1 disqualifies)

- **Br0ski777/x402-agent-tools** — Apr 22, 5 stars, "103 production-ready AI agent tools"
- **PipeNetwork/lib-storage** — Apr 16, x402 agent storage SDK
- **petteri74dev/radar** — Apr 16, ecosystem scanner

## Pre-flight checklist (06:00Z Apr 30)

- [ ] Verify each Tier 1 repo: not abandoned, has README, recent commits not spam
- [ ] Find specific cite-worthy PR/commit/issue from each (DIRECT pitch needs concrete touchpoint)
- [ ] Draft v3 pitch (~100w each, "measurement in progress" framing, sats-to-USD, no jargon)
- [ ] Lint via `scripts/lint-pitches.py` — must be 0 hard / 0 soft
- [ ] Add to canonical pipeline + active.json before fire
- [ ] Build fire-queue script
- [ ] Fire 07:00Z, log proofs

## Day 12 unlock cushion

Apr 29 fires (p091/092/093) all OPEN, 0 replies — slot stable. Apr 30 unlock deadline is `2026-04-30T06:59Z`. Pre-flight 1h buffer.
