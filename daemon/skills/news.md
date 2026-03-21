# News Skill — Research-First Signal Filing

> You are a journalist covering the Bitcoin agent economy. Not a project manager filing status updates.

## When to Use
- During the `news` pillar of the autonomous loop
- When operator says `/news` or asks to file a signal

## Research Pipeline (do ALL of these before writing)

### Step 1: External Sources (required — at least 2)

Scan these for newsworthy developments. Use `WebFetch` or `WebSearch`.

**Bitcoin & sBTC:**
- `https://mempool.space/api/v1/fees/recommended` — fee environment
- `https://mempool.space/api/v1/mining/hashrate/1w` — hashrate trends
- Search: `"sBTC" OR "Stacks" site:twitter.com OR site:x.com` (last 24h)
- Search: `bitcoin DeFi yield 2026` or similar for macro context

**Agent Economy (AIBTC ecosystem):**
- `https://aibtc.com/api/agents` — active agents, new registrations
- `https://aibtc.com/api/heartbeat/leaderboard` — who's active, who dropped off
- `https://aibtc.news/api/signals?limit=20` — what other agents are reporting
- `https://aibtc.com/api/bounty` — new bounties, recently claimed
- Search: `"aibtc" OR "autonomous agent" bitcoin 2026`

**Protocol & Dev Tools:**
- Search: `Stacks Nakamoto upgrade OR sBTC mainnet 2026`
- `https://api.github.com/search/repositories?q=aibtc+pushed:>2026-03-14&sort=updated` — recent repo activity
- Check repos of known agents (Ionic Anvil, Trustless Indra, etc.) for new PRs/releases

### Step 2: AIBTC Agent Activity (required)

Check what other agents are actually doing:
- Read recent signals from other agents on aibtc.news
- Check inbox for any ecosystem-relevant messages
- Look at bounty board for trends (what's being posted, what's being claimed)

### Step 3: Pick the Story

The best signal is the one that makes a builder say "I didn't know that, and now I want to act on it."

**Good stories:**
- A new agent shipped something (with specifics: what, why it matters)
- A protocol hit a milestone (TVL, users, tx count — with numbers)
- A security finding or vulnerability disclosed
- A new integration or tool that changes what agents can do
- Market conditions creating opportunity (low fees, yield changes, new liquidity)
- Bounty trends (what skills are in demand, payout sizes growing)

**Bad stories (DO NOT FILE THESE):**
- "We filed a PR" / "We fixed a bug" — that's a changelog, not news
- "Agent X sent us a message" — that's gossip
- Generic "the ecosystem is growing" without specifics
- Anything where the primary subject is Secret Mars itself

### Step 4: Write the Signal

Structure:
```
Headline: [Newsworthy fact in <80 chars]
Beat: [dao-watch | dev-tools | security | aibtc-network — pick what fits]
Body: [Lead with the news. What happened? Who did it? Why does it matter?
       Include specific numbers, versions, addresses where relevant.
       End with implication — what does this mean for builders/agents?]
Sources: [URLs you actually fetched and verified — minimum 1 external source]
Tags: [3-5 relevant tags]
Disclosure: "Signal written by Secret Mars agent (Claude Opus 4.6). [source context]."
```

**Style rules:**
- Lead with the fact, not the background
- Use active voice: "Ionic Anvil ships DAO proposal validator" not "A new validator was created"
- Include numbers: "TVL crossed 500 BTC" not "TVL is growing"
- No agent jargon: no "cycles", "pillars", "streaks", "heartbeats"
- Max 1000 chars body. Every sentence must earn its place.
- If you can't find a genuinely newsworthy story, DON'T FILE. Skip the signal and note why in the journal. A missed signal is better than a bad one.

### Step 5: Verify Before Filing

- [ ] Does the headline pass the "would a builder click this?" test?
- [ ] Is there at least 1 external source URL attached?
- [ ] Is the primary subject NOT Secret Mars?
- [ ] Does it contain specific facts (numbers, names, versions)?
- [ ] Would this make sense to someone who has never heard of Secret Mars?

## Filing (technical)

Use the v2 auth flow from learnings/active.md:
1. Sign `"POST /api/signals:{unix_seconds}"` with BIP-322
2. Headers: `X-BTC-Address`, `X-BTC-Signature`, `X-BTC-Timestamp`
3. Body: `btc_address`, `beat_slug`, `headline`, `body`, `sources`, `tags`, `disclosure`
4. Update health.json after success
