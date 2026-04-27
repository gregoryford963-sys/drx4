#!/usr/bin/env bash
# fire-queue-2026-04-29.sh — fire the 3 Apr 29 PT unlock drafts sequentially.
# Uses **Title:** / **Body:** markdown format (drafts post-2034hx use this).
#
# Pre-flight performed in cycles 2034mu-2034n7 (3-slot lock) + 2034n8 (drafts) + 2034na (canonical ingest):
# - Rule 10: all 3 owners verified HTTP 200 at scout time (stakpak / voidly-ai / up2itnow0822)
# - Rule 11: bug_report + feature_request only (none have ISSUE_TEMPLATE dirs as of scout)
# - Gate 1 freshness: all pushed within last hours at draft time (12:14Z-15:21Z Apr 27)
# - Owner trust: STRICTER per Apr 25 outcome learning (Org >= 90d / User >= 180d)
#   - stakpak Org 4yr 11mo ✓ (1430⭐ HIGH-BOT-RISK — pre-flight bot-detect mandatory at T-1h)
#   - voidly-ai Org 187d ✓ (0⭐ MIT, fresh repo 7d old, has_issues=true)
#   - up2itnow0822 User 289d ✓ (4⭐ MIT, repo 67d old, has_issues=true 2 open)
# - lint-pitches.py: 0 hard / 0 soft on all 3 (cycle 2034n8)
#
# Auto-emits strict-format proof lines into daemon/sales-proofs/YYYY-MM-DD.md
# per learning 2034jn (briefing.sh / sales-status.sh need machine-counted lines).
#
# Fire AT or AFTER 2026-04-29T07:00:00Z (Apr 29 PT day start).

set -euo pipefail

cd /home/mars/drx4
source .env
export GH_TOKEN="$GITHUB_PAT_SECRET_MARS"

PROOF_FILE="daemon/sales-proofs/$(date -u +%Y-%m-%d).md"
FIRELOG="${PROOF_FILE}.firelog"

# Initialize proof file with strict-format block header if it doesn't exist
if [[ ! -f "$PROOF_FILE" ]]; then
  cat > "$PROOF_FILE" <<'HEADER'
# Apr 29 PT day — Sales DRI unlock proofs

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

fire daemon/drafts/2026-04-29/p091-stakpak.md stakpak/agent "stakpak/agent" "Apr 29 PT direct first-touch — open-source agent that ships code on autopilot, MCP-aware release pipeline (apache-2.0 1430⭐), Org 5yr (HIGH-BOT-RISK pre-flight cleared)"
sleep 1
fire daemon/drafts/2026-04-29/p092-voidly-pay.md voidly-ai/voidly-pay "voidly-ai/voidly-pay" "Apr 29 PT direct first-touch — agent-hire marketplace + Ed25519-signed envelopes, atomic settlement (MIT 0⭐), Org 187d"
sleep 1
fire daemon/drafts/2026-04-29/p093-agentpay-mcp.md up2itnow0822/agentpay-mcp "up2itnow0822/agentpay-mcp" "Apr 29 PT direct first-touch — non-custodial x402 MCP payment layer, open-source alternative to Vercel x402-mcp (MIT 4⭐), User 289d"

echo ""
echo "== Apr 29 PT unlock fired 3/3 =="
echo "Now:"
echo "  1. Verify with: bash scripts/briefing.sh"
echo "  2. Update daemon/sales-pipeline.json prospect touches[] (p091/p092/p093)"
echo "  3. Update daemon/health.json (apr29_fired=3, cold_count_today=3)"
