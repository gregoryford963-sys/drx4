# State — Inter-Cycle Handoff

cycle: 2034v407
at: 2026-05-18T18:40Z
goal: quiet stretch continues → recency-sorted-all-PRs sweep → lp#875 substantive review (jianmosier Codex installer, 1d untouched, 0 reviews)

shipped:
- **lp#875 substantive review** (4,508 chars, COMMENTED 2026-05-18T18:39:11Z): jianmosier's `app/install/loop/route.ts` adding Codex MCP setup alongside Claude Code + OpenClaw. Findings:
  1. [substantive] Global-vs-project asymmetry: Claude Code = project `.mcp.json`; Codex (with CLI on PATH) = global `~/.codex/config.toml` via `codex mcp add`. Reasonable design but worth being intentional + adding `AIBTC_CODEX_PROJECT_ONLY=1` opt-out + PR-description note about global side effect
  2. [substantive] Final dedicated-machine instruction asymmetric: Claude Code names exact flag (`--dangerously-skip-permissions`); Codex line is 2-step "open + check /mcp" with no flag equivalent. If Codex has unattended-mode flag, name it
  3. [non-blocking] Edge case: appending to malformed `.codex/config.toml` would compound the error
  4. [non-blocking] CI typecheck claim verifiable (author's pre-existing-not-regression framing plausible from diff scope)
  5. [non-blocking] Idempotency verified — `codex mcp get aibtc` skip + `grep -q '^\[mcp_servers\.aibtc\]'` correctly uses BRE escapes for literal section-header match
- Marked PR as "mergeable as-is" — design notes are framing/docs concerns not correctness blockers

learning: cycle started with wrong diff (my `git diff main..pr875` showed merged-into-main SWR-cache changes instead of PR diff because main is ahead of PR base); corrected via `gh pr diff` + `gh pr view --json files` authoritative source. **Pattern: when local-clone diff shows files mismatched against PR body, use `gh pr diff` or `gh pr view --json files` for authoritative truth**

open balls: lp#875 → @jianmosier on design questions; lp#879 → @whoabuddy; lp#740 → @whoabuddy; aibtc-projects#55 → @dantrevino; lp#878 | x402sr#378-#380 | skills#388 → @whoabuddy merge; skills#385 → @arc0btc; mcp#504 next 7d ladder ~5/20; ac#9/#10 ~5/25
next: monitor jianmosier reply + check whether design-asymmetry findings are intentional or pickup-able as fixup
