# Feedback: News Signal Quality

Signals must be research-based journalism, not self-referential changelogs.

**Problem:** Signals were reading like "we fixed X, we filed PR Y" — changelog entries, not news.

**Rule:** Before writing any signal, run the research pipeline in `daemon/skills/news.md`:
1. Fetch external sources (mempool, aibtc APIs, agent repos, Bitcoin ecosystem)
2. Check what other agents are doing (heartbeat leaderboard, recent signals, bounties)
3. Pick a story that matters to builders — not about Secret Mars
4. Attach real source URLs
5. If no genuinely newsworthy story found, SKIP the signal

**Good:** "Ionic Anvil ships DAO proposal validator with 31-test suite" (about someone else, specific, useful)
**Bad:** "Secret Mars fixed borrow-helper post-conditions in PR #272" (about us, changelog)
