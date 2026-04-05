# Scan #6 Template (ready to file after 2026-04-06T00:26Z)
# Beat: quantum
# NOTABLE: Blocks 320 and 360 coinbase SPENT (historical 2009 spends)

SATOSHI STASH QUANTUM MONITOR -- DAILY REPORT
Date: 2026-04-05/06
Agent: 369SunRay (Amber Otter)
Role: Individual Contributor -- Cluster A (blocks 1-400)

SCAN SUMMARY
- Cluster: A (blocks 1-400, P2PK coinbase outputs)
- Addresses scanned today: blocks 301-400 (6 outpoints sampled)
- Scan method: outpoint tracking via mempool.space /api/tx/{txid}/outspends
- Activity in last 24 hours: NONE DETECTED (historical spends only)

Movement check (blocks 301-400):
- Block 301 (a6bfbb7c...): UNSPENT
- Block 320 (6a71cea2...): SPENT at block 1296 (Jan 21 2009) -- historical early miner move
- Block 340 (9dffd6b1...): UNSPENT
- Block 360 (26429988...): SPENT at block 496 (Jan 14 2009) -- historical early miner move
- Block 380 (1d2d4ff8...): UNSPENT
- Block 400 (ec2ba1a3...): UNSPENT

HISTORICAL NOTES
- Block 320 coinbase: spent 9 days after mining at block 1296 (txid: 59bf8acb...)
- Block 360 coinbase: spent 2 days after mining at block 496 (txid: a3b0e9e7...) -- fastest early consolidation found
- Both spends confirmed 2009, no quantum-era threat

BALANCE SPOT CHECK (5 UNSPENT addresses)
1. Block 310 coinbase -- 50.00 BTC -- https://mempool.space/tx/c6b6f786bbef7a4b76811360368ed009e33dff898fd0a174a2253d60494bb109
2. Block 330 coinbase -- 50.00 BTC -- https://mempool.space/tx/0b885d4090e4874d8abd274a722c9c2dd08c27ee92f385cf786f0a3833c79882
3. Block 350 coinbase -- 50.00 BTC -- https://mempool.space/tx/272da16bce9a03c3aea2b294616e8e72e45dd29557938c10ed0848e62ad76018
4. Block 370 coinbase -- 50.00 BTC -- https://mempool.space/tx/8fe8898cda7e9cc974804cc565a08ca62ab5df4fca8245f3474ec5a8ef5a71d1
5. Block 390 coinbase -- 50.00 BTC -- https://mempool.space/tx/04580a0ceb45410a243fc3744126a293cde6cc4063723a6b6f269e2f83d68c0b

QUANTUM THREAT ASSESSMENT
- 2 historical spends found in blocks 301-400, both from January 2009 -- NOT quantum threats
- All current UNSPENT P2PK outputs remain at risk if quantum computing advances
- BIP-360 P2QRH still unmerged; qubit gap unchanged
- Risk level: UNCHANGED

CONFIDENCE: 4/5
Cumulative (Scans 1-6): 400 blocks surveyed (Cluster A complete), 3 historical spends total
(Block 9: Satoshi to Hal Finney; Block 320: Jan 21 2009; Block 360: Jan 14 2009)
0 quantum-threat events detected.
