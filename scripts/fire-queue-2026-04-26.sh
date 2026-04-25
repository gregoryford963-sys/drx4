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

set -euo pipefail

cd /home/mars/drx4
source .env
export GH_TOKEN="$GITHUB_PAT_SECRET_MARS"

fire() {
  local draft="$1"
  local repo="$2"
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
  echo "✓ $url"
  echo "$url" >> "daemon/sales-proofs/$(date -u +%Y-%m-%d).md.firelog"
}

fire daemon/drafts/2026-04-26/p082-phantom-secrets.md ashlrai/phantom-secrets
sleep 1
fire daemon/drafts/2026-04-26/p083-agent-guardrails.md logi-cmd/agent-guardrails
sleep 1
fire daemon/drafts/2026-04-26/p084-grid402.md carbonsteward/grid402

echo ""
echo "== Apr 26 PT unlock fired 3/3 =="
echo "Now:"
echo "  1. Write daemon/sales-proofs/2026-04-26.md with the 3 fired URLs"
echo "  2. Update daemon/sales-pipeline.json prospect touches[]"
echo "  3. Update daemon/health.json (apr26_fired=3, cold_count_today=3)"
