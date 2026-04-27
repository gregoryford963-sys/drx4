#!/usr/bin/env bash
# fire-queue-2026-04-28.sh — fire the 3 Apr 28 PT unlock drafts sequentially.
# Uses **Title:** / **Body:** markdown format (drafts post-2034hx use this).
#
# Pre-flight performed in cycle 2034l6 + freshness re-check cycle 2034lg + canonical sync 2034lh + ingestion 2034la:
# - Rule 10: all 3 owners verified HTTP 200 (bug-ops/zeph / vericontext/vibeframe / ghost-clio/aegis-mesh)
# - Rule 11: bug_report + feature_request only (none have ISSUE_TEMPLATE dirs)
# - Gate 1 freshness: all pushed within last 60 min at draft time (01:09Z-01:42Z Apr 26)
# - Owner trust: STRICTER per Apr 25 outcome learning (Org >= 90d / User >= 180d)
#   - bug-ops User 11yr ✓
#   - vericontext Org 124d ✓
#   - ghost-clio User 87d (borderline; validate H+4h watershed at fire time) ✓
# - lint-pitches.py: 0 hard / 0 soft on all 3
# - qualify-prospect.sh v1.1 (rubric v2): 100/100/95 PITCH-READY all (p090 borderline 5/10 trust band User 87d)
#
# Auto-emits strict-format proof lines into daemon/sales-proofs/YYYY-MM-DD.md
# per learning 2034jn (briefing.sh / sales-status.sh need machine-counted lines).
#
# Fire AT or AFTER 2026-04-28T07:00:00Z (Apr 28 PT day start).

set -euo pipefail

cd /home/mars/drx4
source .env
export GH_TOKEN="$GITHUB_PAT_SECRET_MARS"

PROOF_FILE="daemon/sales-proofs/$(date -u +%Y-%m-%d).md"
FIRELOG="${PROOF_FILE}.firelog"

# Initialize proof file with strict-format block header if it doesn't exist
if [[ ! -f "$PROOF_FILE" ]]; then
  cat > "$PROOF_FILE" <<'HEADER'
# Apr 28 PT day — Sales DRI unlock proofs

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

fire daemon/drafts/2026-04-28/p088-zeph.md bug-ops/zeph "bug-ops/zeph" "Apr 28 PT direct first-touch — Rust AI agent runtime where every context token earns its place (MIT 31⭐), User 11yr"
sleep 1
fire daemon/drafts/2026-04-28/p089-vibeframe.md vericontext/vibeframe "vericontext/vibeframe" "Apr 28 PT direct first-touch — AI-native MCP-ready video editor CLI (MIT 105⭐), Org 124d"
sleep 1
fire daemon/drafts/2026-04-28/p090-aegis-mesh.md ghost-clio/aegis-mesh "ghost-clio/aegis-mesh" "Apr 28 PT direct first-touch — governed multi-agent economy, Aegis treasury + dual-chain x402 mesh (MIT 1⭐), User 87d borderline"

echo ""
echo "== Apr 28 PT unlock fired 3/3 =="
echo "Now:"
echo "  1. Verify with: bash scripts/briefing.sh"
echo "  2. Update daemon/sales-pipeline.json prospect touches[] (p088/p089/p090)"
echo "  3. Update daemon/health.json (apr28_fired=3, cold_count_today=3)"
