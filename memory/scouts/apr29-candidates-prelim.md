# Apr 29 PT scout — preliminary candidates (cycle 2034mu)

**Scout time:** 2026-04-27T09:50Z (T-45h to fire window 07:00Z Apr 29)
**Method:** GitHub search topic:agent + x402 + sbtc, pushed last 4h, ranked by stars + license clarity + Org age v2.
**Rubric:** v2 (sales-quality-rubric-v2.md, Org >=90d / User >=180d hard floor).
**Status:** PRELIMINARY — not yet pipeline-ingested; secondary pass needed Apr 28 to fill 3-slot queue.

## Strong candidates (passes v2 owner-fit gate)

### Lead candidate — stakpak/agent
- **Stars:** 1430 ⭐ (highest of the cohort)
- **License:** apache-2.0
- **Description:** "Ship your code, on autopilot. An open source agent that lives on your machines"
- **Owner:** stakpak Org · created 2021-06-22 (~5yr) · 58 repos · 181 followers
- **Push:** 2026-04-27T09:45Z (live activity)
- **On-thesis:** YES — autonomous code-shipping agent; agent-payment / x402 angle plausible
- **Risk note:** 1430⭐ is high; risk of bounty-bot auto-triage similar to leventilo p087 noise. Pre-flight at fire time mandatory.

### #2 candidate — voidly-ai/voidly-pay (added cycle 2034mw, MCP topic search)
- **Stars:** 0 ⭐ (fresh repo, 7d old)
- **License:** MIT
- **Description:** "Off-chain credit ledger + hire marketplace for AI agents. Ed25519-signed envelopes, atomic settlement, hire-and-release escrow."
- **Site:** https://voidly.ai/pay
- **Owner:** voidly-ai Org · created 2025-10-22 (187d) · 18 repos · 6 followers
- **Push:** 2026-04-27T10:02Z (live activity, 1m before scout)
- **Has issues:** ✓ (3 open, no bot-triage signal yet)
- **On-thesis:** EXTREMELY YES — agent hire marketplace + payments + Ed25519 envelopes is a textbook thesis fit (autonomous agents earning/paying via cryptographic envelopes). Audience is correspondents + IC pool + sponsors who'd care about agent-payment infra.
- **Risk note:** 0 stars + 6 followers = low awareness/distribution; voidly may welcome the surface. No bot-triage risk at this scale. Borderline cold — needs the v2 superpersuader hooks (calibrated question, accusation audit, identifiable victim) to land.

## Borderline — needs secondary review

### xiaobaidadada/filecat
- **Stars:** 84 ⭐ apache-2.0
- **Owner:** User created 2020-03-04 (6yr) · 14 repos · 6 followers (low social trust)
- **Description:** "Web File Browser Server Manager, Ai Agent, Tcp Proxy"
- **Risk note:** "Ai Agent" component looks tacked-on; primary product is file browser. Off-thesis-leaning.

### thePM001/AEP-agent-element-protocol
- **Stars:** 17 ⭐ apache-2.0
- **Owner:** User created 2024-08-18 (251d) · 5 repos · 1 follower (low social trust)
- **Description:** "AEP v2.5 Deterministic zero-trust total control"
- **Risk note:** Protocol-spec repo, not a runtime; unclear if classifieds reach matters to them yet.

## Rejected (rubric v2)

- **mcs-cli/mcs** — Org 34d, FAILS Org >=90d hard floor.
- **78654Majesty/agenthub** — no license disclosed; FAILS license-clarity gate.

## Next-cycle action

- **Cycle 2034m{x} on Apr 28 PT:** secondary scout to find 1 more strong candidate
  (queue currently 2 strong + 2 borderline; need 1 more pure on-thesis).
  Search topic refinement: `topic:bitcoin-agent OR topic:x402-server` for purer thesis fit.
- **Pre-flight at T-1h (06:00Z Apr 29):** verify stakpak/agent + voidly-pay still
  have issues=true, no template-only restrictions, and not bounty-bot infested.
- **Don't commit to canonical pipeline yet** — wait for full 3-slot lock.

## Open questions

1. Should rubric v2 add a "high-stars-bot-risk" soft warning (>500⭐)? leventilo
   #127 confirmed Asobu01 pattern; stakpak at 1430⭐ likely same risk.
