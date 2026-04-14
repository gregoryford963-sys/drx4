#!/usr/bin/env bash
# Cycle-start briefing: prints goal + backlog + drift tells.
# Run at the top of every cycle so "what am I trying to do" is unambiguous.

set -euo pipefail
cd "$(dirname "$0")/.."

# Self-repair: if core.hooksPath drifted away from scripts/hooks, reset it.
# This is the first thing the briefing does so future cycles can't silently
# bypass the cruise-mode block.
current_hooks_path=$(git config --get core.hooksPath || echo "")
if [[ "$current_hooks_path" != "scripts/hooks" ]]; then
  echo "⚠  core.hooksPath drifted ($current_hooks_path) — resetting to scripts/hooks"
  git config core.hooksPath scripts/hooks
fi

echo "=== NORTH STAR ==="
cat daemon/NORTH_STAR.md
echo ""
echo "=== LAST CYCLE STATE ==="
cat daemon/STATE.md
echo ""
echo "=== DRIFT CHECK ==="

# Count consecutive state-only commits (cruise cycles that bypassed the hook)
recent=$(git log --format="%s%n%an%x00" -20 --name-only | tr '\n' ' ')
echo "Last 5 commits:"
git log --oneline -5
echo ""

# Count today's outputs (calendar day UTC)
today=$(date -u +%Y-%m-%d)
signals_today=$(grep -c "signals_today" daemon/health.json || echo 0)
prs_open=$(git log --since="${today}T00:00:00Z" --oneline 2>/dev/null | wc -l)

echo "Commits today (UTC): $(git log --since="${today}T00:00:00Z" --oneline 2>/dev/null | wc -l)"
echo ""
echo "CRM route count: $(jq '[.routes // [], .listings_p2p // [], .listings_prediction // []] | add | length' daemon/crm.json 2>/dev/null || echo '?')"
echo "CRM listings live: $(jq '.stats.listings_live' daemon/crm.json 2>/dev/null || echo '?')"
echo ""
echo "Open BFF PRs:"
gh search prs --author secret-mars --state open --json number,title,repository --jq '.[] | "  \(.repository.name)#\(.number) \(.title)"' 2>/dev/null | head -10
echo ""
echo "=== GH mentions you haven't acted on (drift tell — mentions are not 'stale re-triggers') ==="
gh api /notifications?all=false --jq '.[] | select(.reason == "mention" or .reason == "review_requested") | "  [\(.reason)] \(.repository.full_name)  \(.subject.title)"' 2>/dev/null | head -20
echo ""
echo "Unreviewed GH notifications total: $(gh api /notifications?all=false --jq 'length' 2>/dev/null || echo '?')"
echo ""
echo "=== Unreplied inbox messages (free-reply eligible) ==="
curl -s "https://aibtc.com/api/inbox/SP4DXVEC16FS6QR7RBKGWZYJKTXPC81W49W0ATJE?status=unread&limit=5" 2>/dev/null \
  | jq -r '.inbox.messages[] | "  \(.peerDisplayName): \(.content[:120])"' 2>/dev/null | head -10
