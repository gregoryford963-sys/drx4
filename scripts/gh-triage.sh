#!/bin/bash
# gh-triage.sh — Fetch unread GH notifications, classify, mark read.
#
# Strategy:
# - Always fetch all unread (per_page=50, no since-filter — stale threads count).
# - Print each with thread_id so the agent can decide which ones to dive into.
# - Mark-read is NOT automatic; agent decides per-thread via:
#     GH_TOKEN=... gh api -X PATCH /notifications/threads/<ID>
# - For bulk mark-read of known-safe categories (author on own PR, ci_activity pass,
#   etc.), the agent invokes this script with --mark-safe to auto-PATCH them.
#
# Usage:
#   scripts/gh-triage.sh                # list all unread with classifications
#   scripts/gh-triage.sh --mark-safe    # list + auto-mark-read known-safe categories
#   scripts/gh-triage.sh --mark-all     # list + auto-mark-read EVERYTHING (only after manual review)

set -e

TOKEN=$(grep GITHUB_TOKEN /home/mars/drx4/.env | cut -d= -f2)
MODE="${1:-list}"

# Fetch unread notifications
GH_TOKEN="$TOKEN" gh api "/notifications?all=false&per_page=100" > /tmp/gh-triage-notifs.json

COUNT=$(python3 -c "import json; print(len(json.load(open('/tmp/gh-triage-notifs.json'))))")
echo "=== UNREAD GH NOTIFICATIONS: $COUNT ==="

if [ "$COUNT" -eq 0 ]; then exit 0; fi

# Classify each — prints: <safe|review> <thread_id> <reason> <repo> <title>
python3 <<'PYEOF'
import json
with open('/tmp/gh-triage-notifs.json') as f: d = json.load(f)
# Safe-to-mark categories: author on my own PRs, successful ci_activity
# Review-needed: mention with new comments, comment, failed ci_activity, state_change
for n in d:
    reason = n['reason']
    repo = n['repository']['full_name']
    title = n['subject']['title']
    tid = n['id']
    # Default classification
    if reason == 'author':
        klass = 'safe'
    elif reason == 'ci_activity':
        # Can't tell pass/fail from notification alone; mark review
        klass = 'review'
    elif reason == 'mention':
        klass = 'review'
    elif reason == 'comment':
        klass = 'review'
    elif reason == 'subscribed':
        klass = 'safe'
    elif reason == 'state_change':
        klass = 'safe'
    else:
        klass = 'review'
    print(f"{klass}\t{tid}\t{reason}\t{repo}\t{title[:80]}")
PYEOF

if [ "$MODE" = "--mark-safe" ] || [ "$MODE" = "--mark-all" ]; then
  echo ""
  echo "=== MARKING READ ==="
  ok=0
  while IFS=$'\t' read -r klass tid reason repo title; do
    if [ "$MODE" = "--mark-all" ] || [ "$klass" = "safe" ]; then
      r=$(GH_TOKEN="$TOKEN" gh api -X PATCH "/notifications/threads/$tid" --silent 2>&1)
      if [ -z "$r" ]; then ok=$((ok+1)); fi
    fi
  done < <(python3 <<'PYEOF2'
import json
with open('/tmp/gh-triage-notifs.json') as f: d = json.load(f)
for n in d:
    reason = n['reason']
    tid = n['id']
    if reason in ('author','subscribed','state_change'):
        klass='safe'
    else:
        klass='review'
    print(f"{klass}\t{tid}\t{reason}\tr\tt")
PYEOF2
)
  echo "marked read: $ok"
  NEW=$(GH_TOKEN="$TOKEN" gh api "/notifications?all=false&per_page=100" --jq '. | length')
  echo "remaining unread: $NEW"
fi
