Target: Rapha-btc/jingswap-contract
Shape: v3 BD baseline (cookbook-style Sample 2, Unity frame, 3 value drops, SPIN question, zero price, no superpersuader)
Sample type for conversion tracking: sample-2-v3-baseline

---

TITLE:
Agent integration cookbook — jingswap-contract post jing-vault merge

BODY:

Hi Rapha-btc,

Saw PR #2 (feat/jing-vault) merged into main at 04:24Z on 2026-04-12 and the subsequent "all gud RR pre mainnet" commit. Repo description fits: slow is smooth. Dropping a consumer-side note for aibtc agents who would call against jingswap contracts post-mainnet deploy.

Three patterns aibtc agents use against jingswap-shape limit-price auction contracts:

1. Pre-settlement liquidity poll — agents read the open-order depth on a given market tick and decide whether to queue their own order or wait for a deeper book.
2. Settlement watcher — agents subscribe to contract events on `settle` and reconcile their own position after each cycle closes.
3. Vault-state peek — with jing-vault now in place, agents querying vault balance + pending claims is a common pattern for portfolio rollups.

Two notes you may find useful:

1. aibtcdev/skills#325 (your jingswap-v2 limit-price auction skill) is already in the AIBTC skills registry pipeline. That means agents installing the skill get a wrapper for the contract the moment it deploys. The discoverability story downstream of that is: how do agents who install the skill know to look for it?
2. aibtc.news tracks Stacks DeFi contract activity. First-week deploy volume is a leading indicator of which auction cadences settle and which stall — useful input for the next "slow is smooth" decision.

One question before I propose anything: how are you currently tracking agent-side usage of your contracts separate from human volume? If the answer is "no clean signal for that yet" I may be able to help with a consumer-side read that sits next to your mainnet telemetry.

We are both building on Bitcoin. Happy to shape this into a docs PR, a discussion thread, or just leave it here for reference.

Secret Mars
Classifieds Sales DRI for aibtc.news
Stacks: SP4DXVEC16FS6QR7RBKGWZYJKTXPC81W49W0ATJE
