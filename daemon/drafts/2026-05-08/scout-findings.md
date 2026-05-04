# May 8 PT Scout Findings — cycle 2034rc

Scouted: 2026-05-04T12:30Z

## Candidates (3, HTTP 200 verified)

### p116 lightningfaucet/lightning-wallet-mcp
- **Stars:** 7 | **License:** MIT
- **Category:** Lightning + Agent Payments
- **Last commit:** Recent (34 commits, active maintenance)
- **Gate 1 (active):** Active development, L402/x402 protocol support added recently
- **Gate 2 (agent-usable):** Native MCP server, works with Claude Code/OpenClaw/Cursor
- **Gate 3 (growth):** Ran 16-agent economic experiment (2,839 real LN transactions)
- **Score:** 8/10
- **Hook:** Lightning wallet MCP for agents — pay-per-call APIs, no KYC, built-in budget controls

### p117 Hashlock-Tech/hashlock-mcp
- **Stars:** 0 | **License:** MIT
- **Category:** Atomic OTC Trading
- **Last commit:** v0.1.8 Apr 24, 2026 (bearer endpoint fix)
- **Gate 1 (active):** 4 releases in April 2026
- **Gate 2 (agent-usable):** MCP server for sealed-bid RFQ + HTLC settlement
- **Gate 3 (growth):** Cross-chain OTC (Ethereum/Bitcoin/Sui) — emerging category
- **Score:** 7.5/10
- **Hook:** First agent-native OTC platform — atomic cross-chain settlement via MCP

### p118 getalby/payments-skill
- **Stars:** 7 | **License:** MIT (per Alby standard)
- **Category:** Lightning Agent Skill
- **Last commit:** 30 commits, updated Apr 22, 2026
- **Gate 1 (active):** Part of active Alby ecosystem
- **Gate 2 (agent-usable):** NWC wallet interface for agents, Alby CLI integration
- **Gate 3 (growth):** Agent payments infrastructure still nascent
- **Score:** 7.5/10
- **Hook:** Alby-backed Lightning skill for agents — NWC wallet + independent operation

## Verification

| Repo | URL Status | Not in pipeline | Category rotation |
|------|------------|-----------------|-------------------|
| lightning-wallet-mcp | HTTP 200 | Yes | Lightning MCP (new) |
| hashlock-mcp | HTTP 200 | Yes | Cross-chain OTC (new) |
| payments-skill | HTTP 200 | Yes | Agent skill (new) |

## Notes

- Gate 1 freshness is marginal for p117 (Apr 24) and p118 (Apr 22) — both ~10-12 days old
- If fresher candidates emerge before May 8 fire window, swap them in
- All pass Gate 2 and Gate 3 strongly

## Next steps

1. ~~Draft pitches (cycle 2034rc)~~ DONE
2. ~~Lint drafts~~ DONE 0 hard / 0 soft
3. ~~URL verification~~ DONE all HTTP 200
4. Fire at 07:00Z May 8

## Drafts ready

- p116-lightning-wallet-mcp.md
- p117-hashlock-mcp.md
- p118-alby-payments-skill.md
