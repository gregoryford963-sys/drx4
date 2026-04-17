#!/usr/bin/env bash
# draft-pitch.sh — template-fill generator for a classifieds-sales first-touch.
#
# Complementary to eval-pitch.sh (LLM judge). This is deterministic structure
# enforcement: required fields, 500-char x402 limit, em-dash strip, direct-pitch
# frame (no permission-first). Pipe output to eval-pitch.sh before sending.
#
# Usage:
#   draft-pitch.sh \
#     --channel x402 \
#     --handle Rapha-btc \
#     --artifact "jing-swap-contract PR #42 merged 2026-04-12" \
#     --artifact-url "https://github.com/Rapha-btc/jing-swap-contract/pull/42" \
#     --fit "STX/sBTC swap desk for agents on a 5-min settlement cadence" \
#     --comparable "cocoa007 HODLMM Bin Analytics placed Apr 15, 3k sats" \
#     --handle-mine "Secret Mars"
#
# Output goes to stdout. Non-zero exit on validation failure.
#
# Exit codes:
#   0 = draft emitted + passed structural validation
#   1 = validation failure (missing required, over char limit, em-dash present)
#   2 = usage error
set -euo pipefail

CHANNEL=""
HANDLE=""
ARTIFACT=""
ARTIFACT_URL=""
FIT=""
COMPARABLE="cocoa007 HODLMM Bin Analytics placed Apr 15, still active on aibtc.news/api/classifieds"
HANDLE_MINE="Secret Mars"
OPEN_LOOP=""

die() { echo "ERROR: $*" >&2; exit "${2:-1}"; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --channel) CHANNEL="${2:-}"; shift 2 ;;
    --handle) HANDLE="${2:-}"; shift 2 ;;
    --artifact) ARTIFACT="${2:-}"; shift 2 ;;
    --artifact-url) ARTIFACT_URL="${2:-}"; shift 2 ;;
    --fit) FIT="${2:-}"; shift 2 ;;
    --comparable) COMPARABLE="${2:-}"; shift 2 ;;
    --handle-mine) HANDLE_MINE="${2:-}"; shift 2 ;;
    --open-loop) OPEN_LOOP="${2:-}"; shift 2 ;;
    -h|--help)
      sed -n '2,30p' "$0" | sed 's/^# \{0,1\}//'
      exit 0 ;;
    *) die "unknown flag: $1" 2 ;;
  esac
done

# --- Validate required ---------------------------------------------------------
[[ -z "$CHANNEL" ]] && die "--channel required (x402 | gh | nostr)"
[[ -z "$HANDLE" ]] && die "--handle required"
[[ -z "$ARTIFACT" ]] && die "--artifact required (one line on what they shipped)"
[[ -z "$ARTIFACT_URL" ]] && die "--artifact-url required"
[[ -z "$FIT" ]] && die "--fit required (one-line audience overlap reason)"

case "$CHANNEL" in
  x402|gh|nostr) ;;
  *) die "--channel must be x402|gh|nostr (got: $CHANNEL)" ;;
esac

# --- Verify artifact URL responds ---------------------------------------------
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 "$ARTIFACT_URL" || echo "000")
if [[ "$HTTP_STATUS" != "200" && "$HTTP_STATUS" != "301" && "$HTTP_STATUS" != "302" ]]; then
  echo "WARN: artifact-url $ARTIFACT_URL returned HTTP $HTTP_STATUS (continuing, but verify manually)" >&2
fi

# --- Em-dash strip (operator + prospect-facing prose must not contain em-dashes) ---
strip_dash() { printf '%s' "$1" | sed 's/—/./g; s/–/./g'; }

ARTIFACT=$(strip_dash "$ARTIFACT")
FIT=$(strip_dash "$FIT")
COMPARABLE=$(strip_dash "$COMPARABLE")
OPEN_LOOP=$(strip_dash "$OPEN_LOOP")

# --- Assemble pitch per channel -----------------------------------------------
case "$CHANNEL" in
  x402)
    # 500-char hard limit. Direct pitch, no permission-first.
    [[ -z "$OPEN_LOOP" ]] && OPEN_LOOP="Reply yes and I'll send the x402 payment link, or pass and I'll take you off the list."
    DRAFT=$(cat <<EOF
$HANDLE, saw $ARTIFACT ($ARTIFACT_URL). 3,000 sats for 7 days on aibtc.news classifieds, payment via x402, typically live within the hour. $FIT. Reference: $COMPARABLE. $OPEN_LOOP -$HANDLE_MINE
EOF
)
    ;;
  gh)
    # GitHub issue body. Longer allowed but still tight.
    [[ -z "$OPEN_LOOP" ]] && OPEN_LOOP="What would it take to test one 7-day slot on $HANDLE's current product?"
    DRAFT=$(cat <<EOF
## 3,000 sats / 7-day classified on aibtc.news for $HANDLE

Hi $HANDLE, saw $ARTIFACT ($ARTIFACT_URL). Clean work.

**The offer:** 3,000 sats buys a 7-day classified placement on aibtc.news. The daily brief is read by the agent correspondent network with on-chain click + contract-call tracking surfaced per placement. $FIT.

**Live comparable:** $COMPARABLE. Verifiable at https://aibtc.news/api/classifieds.

**Next step:** $OPEN_LOOP Happy to share the placement economic model (daily impressions, on-chain click-through, sample placements) if useful.

Reply here with yes + a payment address I can x402 the invoice to, or pass and I'll take $HANDLE off the list.

-$HANDLE_MINE
EOF
)
    ;;
  nostr)
    # Nostr DM. Similar to x402 but no char limit.
    [[ -z "$OPEN_LOOP" ]] && OPEN_LOOP="Reply yes and I'll send the x402 payment link, or pass and I'll take you off the list."
    DRAFT=$(cat <<EOF
$HANDLE, saw $ARTIFACT ($ARTIFACT_URL). 3,000 sats for a 7-day classified on aibtc.news, payment via x402, typically live within the hour. $FIT. Live comparable: $COMPARABLE. $OPEN_LOOP -$HANDLE_MINE
EOF
)
    ;;
esac

# --- Post-generation validation ----------------------------------------------
CHAR_COUNT=$(printf '%s' "$DRAFT" | wc -c)
if [[ "$CHANNEL" == "x402" && "$CHAR_COUNT" -gt 500 ]]; then
  echo "ERROR: x402 draft is $CHAR_COUNT chars, limit is 500. Tighten artifact/fit/comparable/open-loop." >&2
  exit 1
fi

# Retired permission-first phrases (any presence fails)
if printf '%s' "$DRAFT" | grep -qE -i 'mind if i share|would you be open|useful to talk|bad time|if this is not a fit|no pitch yet|no commitment|mind if we chat'; then
  echo "ERROR: draft contains retired permission-first framing. Rewrite without it." >&2
  exit 1
fi

# Em-dash final check (shouldn't be there after strip but verify)
if printf '%s' "$DRAFT" | grep -q '—\|–'; then
  echo "ERROR: draft still contains em-dash / en-dash after strip. Investigate sed replacement." >&2
  exit 1
fi

printf '%s\n' "$DRAFT"
printf '\n--- meta: channel=%s chars=%d ---\n' "$CHANNEL" "$CHAR_COUNT" >&2
