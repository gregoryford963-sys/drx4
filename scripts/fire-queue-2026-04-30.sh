#!/usr/bin/env bash
# Apr 30 PT fire queue — 3 v3 pitches (presidio / Br0ski / PipeNetwork)
# Pre-flighted cycle 2034p0; lint 0/0; canonical pipeline updated 91→94 (then 94→97 cycle 2034p1 backfill).
# Writes BOTH (a) sales-proofs/YYYY-MM-DD.md strict-format lines (briefing.sh machine-count source)
# AND (b) atomic pipeline updates with structural validation (closes p085-p087 data-gap pattern).
set -euo pipefail

REPO_DIR="/home/mars/drx4"
DRAFTS="$REPO_DIR/daemon/drafts/2026-04-30"
GIT_SSH_COMMAND="ssh -i $REPO_DIR/.ssh/id_ed25519 -o IdentitiesOnly=yes"
export GIT_SSH_COMMAND

cd "$REPO_DIR"
source .env
export GH_TOKEN="$GITHUB_PAT_SECRET_MARS"

PROOF_FILE="daemon/sales-proofs/$(date -u +%Y-%m-%d).md"
if [[ ! -f "$PROOF_FILE" ]]; then
  cat > "$PROOF_FILE" <<'HEADER'
# Apr 30 PT day — Sales DRI unlock proofs

## Strict-format machine-readable proofs

HEADER
fi

# Capture starting length so we can validate +1 per fire (pipeline grows touches[], not prospects[])
EXPECTED_LEN=$(jq '.prospects | length' "$REPO_DIR/daemon/sales-pipeline.json")
EXPECTED_KEYS=$(jq 'keys | length' "$REPO_DIR/daemon/sales-pipeline.json")

fire_one() {
  local prospect_id="$1" target_repo="$2" draft_file="$3" proof_summary="$4"
  local title body
  title=$(grep '^\*\*Title:' "$draft_file" | sed 's/\*\*Title:\*\* //')
  body=$(awk '/^\*\*Body:\*\*/{flag=1;sub(/^\*\*Body:\*\* /,"",$0); print; next} flag{print}' "$draft_file")

  if [[ -z "$title" || -z "$body" ]]; then
    echo "error: could not extract title/body from $draft_file" >&2
    return 1
  fi

  echo "=== $prospect_id → $target_repo ==="
  echo "Title: $title"
  echo "Body length: $(echo "$body" | wc -c) chars"

  local issue_url
  issue_url=$(gh issue create -R "$target_repo" --title "$title" --body "$body" 2>&1 | tail -1)
  echo "Result: $issue_url"

  local now
  now=$(date -u +%FT%TZ)

  # Strict-format proof line for sales-status.sh / briefing.sh
  echo "- ${now} | ${target_repo} | github_issue | outbound | ${issue_url} | ${proof_summary}" >> "$PROOF_FILE"

  # Atomic pipeline update with structural validation
  jq --arg id "$prospect_id" --arg now "$now" --arg url "$issue_url" '
    .prospects |= map(
      if .id == $id then
        . + {
          stage: "pitched",
          first_touch_at: $now,
          last_touch_at: $now,
          touches: (.touches + [{
            timestamp: $now,
            channel: "github-issue",
            direction: "outbound",
            url: $url,
            summary: "Apr 30 PT v3 pitch fire (cycle 2034p0 pre-flight). 3k sats / 7d, measurement in progress."
          }])
        } |
        .contact.issue_url = $url
      else . end
    )
  ' "$REPO_DIR/daemon/sales-pipeline.json" > /tmp/pipeline-fire.json

  local post_len post_keys
  post_len=$(jq '.prospects | length' /tmp/pipeline-fire.json 2>/dev/null || echo "0")
  post_keys=$(jq 'keys | length' /tmp/pipeline-fire.json 2>/dev/null || echo "0")

  if jq empty /tmp/pipeline-fire.json 2>/dev/null \
     && [ "$post_len" = "$EXPECTED_LEN" ] \
     && [ "$post_keys" = "$EXPECTED_KEYS" ]; then
    mv /tmp/pipeline-fire.json "$REPO_DIR/daemon/sales-pipeline.json"
    echo "Pipeline updated for $prospect_id (len=$post_len keys=$post_keys)"
  else
    echo "Pipeline update FAILED for $prospect_id (expected len=$EXPECTED_LEN keys=$EXPECTED_KEYS, got len=$post_len keys=$post_keys) — manual recovery needed"
    rm -f /tmp/pipeline-fire.json
    exit 1
  fi
  echo ""
}

fire_one "p094" "presidio-v/presidio-hardened-x402" "$DRAFTS/p094-presidio.md" \
  "Apr 30 PT direct first-touch — x402 security middleware (PII/spending/replay), 3⭐, has #17 cite hook"
sleep 1
fire_one "p095" "Br0ski777/x402-agent-tools" "$DRAFTS/p095-x402-agent-tools.md" \
  "Apr 30 PT direct first-touch — 103 production-ready agent tools w/ x402 micropayments, 5⭐ MIT, v1.1.1 catalog"
sleep 1
fire_one "p096" "PipeNetwork/lib-storage" "$DRAFTS/p096-pipenetwork.md" \
  "Apr 30 PT direct first-touch — storage SDKs (TS/Py/Rust) + x402 agent payments, PipeNetwork org infra"

echo ""
echo "=== Apr 30 PT fire complete (proofs + pipeline atomic) ==="
echo "Verify with: bash scripts/briefing.sh"
