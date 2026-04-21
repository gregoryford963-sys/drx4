#!/usr/bin/env bash
# fire-draft.sh — ship a ready-to-fire classifieds pitch draft as a fresh
# GitHub issue on the target repo. Extracts the `## Body` section cleanly,
# runs lint-pitches.py first to reject hard-violation drafts, fires the
# gh issue create, prints the resulting issue URL.
#
# Usage:
#   scripts/fire-draft.sh <draft-file> <target-repo> "<issue-title>"
#
# Example:
#   scripts/fire-draft.sh daemon/drafts/p052-sbtc-07z-fire.md \
#     stacks-sbtc/sbtc \
#     "Classifieds placement on aibtc.news — context + ask"
#
# Env:
#   GITHUB_PAT_SECRET_MARS  (read from .env by default)
#   SSH key at /home/mars/drx4/.ssh/id_ed25519 (not used; we POST via gh)
set -euo pipefail

DRAFT="${1:?draft file required}"
REPO="${2:?target repo (owner/name) required}"
TITLE="${3:?issue title required}"

if [[ ! -f "$DRAFT" ]]; then
  echo "error: draft not found: $DRAFT" >&2
  exit 1
fi

# Lint gate — hard violations block the fire even if pre-commit already passed
if [[ -x /home/mars/drx4/scripts/lint-pitches.py ]]; then
  if ! python3 /home/mars/drx4/scripts/lint-pitches.py "$DRAFT" > /dev/null 2>&1; then
    echo "✗ LINT BLOCK — $DRAFT has hard violations" >&2
    python3 /home/mars/drx4/scripts/lint-pitches.py "$DRAFT" | grep '^HARD' >&2
    echo ""
    echo "Refusing to fire. Fix the draft first." >&2
    exit 1
  fi
fi

# Body extraction — everything between `## Body` and the next `---`
BODY="$(awk '/^## Body$/{f=1;next}/^---$/{if(f){f=0;exit}}f' "$DRAFT")"

if [[ -z "$BODY" ]]; then
  echo "error: could not extract ## Body section from $DRAFT" >&2
  exit 1
fi

# Pull token if not already set
if [[ -z "${GITHUB_PAT_SECRET_MARS:-}" ]]; then
  export GITHUB_PAT_SECRET_MARS="$(grep '^GITHUB_PAT_SECRET_MARS=' /home/mars/drx4/.env | cut -d= -f2-)"
fi
export GH_TOKEN="$GITHUB_PAT_SECRET_MARS"

echo "firing $DRAFT → $REPO..."
URL="$(gh issue create --repo "$REPO" --title "$TITLE" --body "$BODY")"
echo "✓ $URL"
echo ""
echo "Next steps:"
echo "  1. Append proof URL to daemon/sales-proofs/\$(date -u +%Y-%m-%d).md"
echo "  2. Update sales-pipeline.json prospect touches[] + advance stage"
echo "  3. Commit + push"
