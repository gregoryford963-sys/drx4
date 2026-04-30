#!/usr/bin/env bash
# ic-status.sh — IC pool status from pipeline data.
# Prints per-IC: prospects sourced, current stages, comp owed (closes only).
#
# Comp model (from daemon/workers/sales-ic-manual.md):
#   1,200 sats per active=true new placement
#     600 sats per active=true renewal
# Forward-paid only on close (stage = active=true classified).
set -euo pipefail

REPO_DIR="/home/mars/drx4"
PIPELINE="$REPO_DIR/daemon/sales-pipeline.json"

if [[ ! -f "$PIPELINE" ]]; then
  echo "no pipeline at $PIPELINE"
  exit 1
fi

# Get unique sourced_by values that look like IC handles
ics=$(jq -r '.prospects[] | select(.sourced_by? != null) | .sourced_by' "$PIPELINE" | sort -u)

if [[ -z "$ics" ]]; then
  echo "No IC-sourced prospects in pipeline."
  exit 0
fi

echo "=== IC Pool Status (from sales-pipeline.json) ==="
echo "Comp model: 1,200 sats/new placement · 600 sats/renewal · paid only on active=true close"
echo ""

while read -r ic; do
  count=$(jq --arg ic "$ic" '[.prospects[] | select(.sourced_by == $ic)] | length' "$PIPELINE")
  pitched=$(jq --arg ic "$ic" '[.prospects[] | select(.sourced_by == $ic) | select(.stage | startswith("pitched"))] | length' "$PIPELINE")
  closed=$(jq --arg ic "$ic" '[.prospects[] | select(.sourced_by == $ic) | select(.stage == "closed_pending_publish" or .stage == "closing")] | length' "$PIPELINE")
  lost=$(jq --arg ic "$ic" '[.prospects[] | select(.sourced_by == $ic) | select(.stage | startswith("lost"))] | length' "$PIPELINE")
  active_close=$(jq --arg ic "$ic" '[.prospects[] | select(.sourced_by == $ic) | select(.deal? != null and .deal.posted_at? != null)] | length' "$PIPELINE")

  comp_due=$((active_close * 1200))

  printf "%-35s · %d sourced (%d pitched / %d pending-close / %d lost) · %d active-close → %d sats comp due\n" \
    "$ic" "$count" "$pitched" "$closed" "$lost" "$active_close" "$comp_due"

  # Last-touched prospect for this IC
  last=$(jq -r --arg ic "$ic" '[.prospects[] | select(.sourced_by == $ic)] | sort_by(.last_touch_at // "1970") | .[-1] | "\(.id) \(.name) (\(.stage), last_touch=\(.last_touch_at // "never"))"' "$PIPELINE")
  printf "    last: %s\n" "$last"
done <<< "$ics"

echo ""
echo "=== Total comp owed across pool ==="
total=$(jq '[.prospects[] | select(.sourced_by? != null) | select(.deal? != null and .deal.posted_at? != null)] | length' "$PIPELINE")
echo "Active-close placements: $total · Comp owed: $((total * 1200)) sats"

echo ""
echo "Note: 'active-close' here = prospect has a deal.posted_at field set."
echo "Verify before paying: classified must be active=true on aibtc.news/api/classifieds at payout time."
