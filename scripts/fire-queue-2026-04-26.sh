#!/usr/bin/env bash
# fire-queue-2026-04-26.sh — fire the 3 Apr 26 PT unlock drafts sequentially.
# Uses **Title:** / **Body:** markdown format (drafts post-2034hx use this).
#
# Pre-flight performed in cycle 2034jm:
# - Rule 10: all 3 owners verified HTTP 200 (ashlrai / logi-cmd / carbonsteward)
# - Rule 11: bug_report + feature_request (no commercial-scope flag) — none of the 3 have ISSUE_TEMPLATE dirs
# - Gate 1 freshness: all pushed within last 30 min at draft time (08:38-08:41Z Apr 25)
# - lint-pitches.py: 0 hard / 0 soft on all 3
#
# Fire AT or AFTER 2026-04-26T07:00:00Z (Apr 26 PT day start).
#
# Cycle 2034jn upgrade: this script auto-emits strict-format proof lines into
# daemon/sales-proofs/YYYY-MM-DD.md so briefing.sh / sales-status.sh count them
# without a manual append step. (See memory/learnings/active.md for the
# briefing 0/3 false-negative rule.)

set -euo pipefail

cd /home/mars/drx4
source .env
export GH_TOKEN="$GITHUB_PAT_SECRET_MARS"

PROOF_FILE="daemon/sales-proofs/$(date -u +%Y-%m-%d).md"
FIRELOG="${PROOF_FILE}.firelog"

# Initialize proof file with strict-format block header if it doesn't exist
if [[ ! -f "$PROOF_FILE" ]]; then
  cat > "$PROOF_FILE" <<'HEADER'
# Apr 26 PT day — Sales DRI unlock proofs

## Strict-format machine-readable proofs

HEADER
fi

fire() {
  local draft="$1"
  local repo="$2"
  local prospect="$3"
  local summary="$4"
  local title
  local body

  title="$(awk '/^\*\*Title:\*\*/{sub(/^\*\*Title:\*\*[[:space:]]*/,""); print; exit}' "$draft")"
  body="$(awk 'f{print} /^\*\*Body:\*\*/{f=1}' "$draft")"

  if [[ -z "$title" || -z "$body" ]]; then
    echo "error: could not extract title/body from $draft" >&2
    return 1
  fi

  python3 scripts/lint-pitches.py "$draft" | grep -E '^(HARD|scanned)' || true

  echo "firing $draft → $repo..."
  local url
  url="$(gh issue create --repo "$repo" --title "$title" --body "$body")"
  local ts
  ts="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "✓ $url"
  echo "$url" >> "$FIRELOG"
  # Strict-format proof line for sales-status.sh machine-counting
  echo "- ${ts} | ${prospect} | github_issue | outbound | ${url} | ${summary}" >> "$PROOF_FILE"
}

fire daemon/drafts/2026-04-26/p082-phantom-secrets.md ashlrai/phantom-secrets "ashlrai/phantom-secrets" "Apr 26 PT direct first-touch — phantom token proxy + MCP server (MIT 6⭐), Mason Wyatt"
sleep 1
fire daemon/drafts/2026-04-26/p083-agent-guardrails.md logi-cmd/agent-guardrails "logi-cmd/agent-guardrails" "Apr 26 PT direct first-touch — merge gates for Claude Code/Cursor/Windsurf via MCP (MIT 5⭐), Pythius"
sleep 1
fire daemon/drafts/2026-04-26/p084-grid402.md carbonsteward/grid402 "carbonsteward/grid402" "Apr 26 PT direct first-touch — x402 USDC pay-per-call grid data on Base (MIT), Samuel Lee"

echo ""
echo "== Apr 26 PT unlock fired 3/3 =="
echo "Now:"
echo "  1. Verify with: bash scripts/briefing.sh"
echo "  2. Update daemon/sales-pipeline.json prospect touches[] (p082/p083/p084)"
echo "  3. Update daemon/health.json (apr26_fired=3, cold_count_today=3)"
