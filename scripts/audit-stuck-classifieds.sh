#!/usr/bin/env bash
# audit-stuck-classifieds.sh — find classifieds that were paid on-chain but
# never landed on /api/classifieds?active=true. These are the 193161d4-class
# bugs that cost us 40% of the placement throughput in the Apr 7-21 window.
#
# Usage:
#   scripts/audit-stuck-classifieds.sh [--since YYYY-MM-DD]
#
# Strategy:
#   1. Pull all classifieds records the platform knows about (active + any
#      status we can see) via /api/classifieds?limit=100.
#   2. Cross-check against the canonical known-paid list in
#      daemon/paid-classifieds.json (seeded with historical cases).
#   3. Any known-paid classifiedId that's NOT in the API response = stuck
#      case needing reconcile/refund.
#
# Output: markdown-formatted list of stuck cases, ready to paste into a
# landing-page#623 escalation or #515 ping.

set -euo pipefail
cd /home/mars/drx4

SEED=daemon/paid-classifieds.json

# Build or refresh the seed file if it doesn't exist
if [[ ! -f "$SEED" ]]; then
  cat > "$SEED" <<'JSON'
{
  "_schema": "one entry per on-chain-settled classified. stuck = not in /api/classifieds?active=true",
  "_updated": "2026-04-21",
  "known_paid": [
    {
      "classifiedId": "193161d4-d925-4eea-bf94-74b4a1be306f",
      "placer": "Arc / @arc0btc",
      "paymentTxid": "0x0a106d5e222e5af27c2a66538f03aae77d8c76763449ea6c2297ecd46c2713f2",
      "settled_at": "2026-04-16T07:25:24Z",
      "expected_status": "active OR expired",
      "current_status": "404",
      "escalation": "aibtcdev/landing-page#623",
      "notes": "Still stuck 5+ days after settlement. Arc deadline 2026-04-22T23:00Z."
    },
    {
      "classifiedId": "5d2bbc85",
      "placer": "Satsmith / @rlucky02",
      "settled_at": "2026-04-17T04:32:00Z",
      "expected_status": "reconciled to 74c21b02",
      "current_status": "resolved",
      "notes": "Reconciled on 2026-04-20T06:58:35Z via platform fix. Template for Arc's case."
    }
  ]
}
JSON
  echo "✓ seeded $SEED"
fi

# Fetch current classifieds from API
CURRENT=$(curl -s "https://aibtc.news/api/classifieds?limit=100")
echo "$CURRENT" > /tmp/classifieds-live.json

# For each known-paid entry not in current, flag it
python3 <<'EOF'
import json
seed = json.load(open("daemon/paid-classifieds.json"))
live = json.load(open("/tmp/classifieds-live.json"))
live_list = live if isinstance(live, list) else live.get("classifieds", [])
live_ids = {c.get("id", "") for c in live_list}
# Also track full-id prefix matches for short ids
live_prefixes = {c.get("id", "")[:8] for c in live_list}

print(f"# Stuck classifieds audit — {len(live_list)} live, {len(seed['known_paid'])} known-paid")
print()

stuck = []
resolved = []
for entry in seed["known_paid"]:
    cid = entry["classifiedId"]
    if cid in live_ids or cid[:8] in live_prefixes:
        resolved.append(entry)
    elif entry.get("current_status") == "resolved":
        resolved.append(entry)
    else:
        stuck.append(entry)

if stuck:
    print("## STUCK (needs reconcile/refund)")
    for e in stuck:
        print(f"- **{e.get('placer','?')}** · `{e['classifiedId']}` · paid {e.get('settled_at','?')[:10]} · {e.get('notes','')}")
    print()

if resolved:
    print("## Resolved")
    for e in resolved:
        print(f"- {e.get('placer','?')} · `{e['classifiedId']}` · {e.get('notes','')}")
    print()

if not stuck:
    print("✓ No stuck classifieds detected in the known-paid set.")
else:
    print(f"⚠ {len(stuck)} stuck cases — escalate on aibtcdev/landing-page#623 OR file fresh if #623 closed.")
EOF
