#!/usr/bin/env bash
# migrate-to-followup-loop.sh — v2 (includes IC threads)
# One-time migration. Idempotent — safe to re-run.

set -euo pipefail
cd "$(dirname "$0")/.."

echo "=== 1. Backfill outbox-archive.json ==="
python3 - <<'PY'
import json, pathlib
p = pathlib.Path("daemon/outbox-archive.json")
d = json.loads(p.read_text())
changed = 0
for entry in d.get("archived", []):
    if "reply_checked_at" not in entry:
        entry["reply_checked_at"] = None
        entry["reply_content"] = None
        entry["reply_at"] = None
        changed += 1
p.write_text(json.dumps(d, indent=2))
print(f"  backfilled {changed} entries")
PY

echo "=== 2. Split sales-pipeline.json ==="
python3 - <<'PY'
import json, pathlib
from datetime import datetime, timedelta, timezone
src = pathlib.Path("daemon/sales-pipeline.json")
data = json.loads(src.read_text())
now = datetime.now(timezone.utc)
cutoff = now - timedelta(days=14)

def is_active(p):
    last = p.get("last_touch_at") or p.get("first_touch_at")
    if not last:
        return True
    try:
        t = datetime.fromisoformat(last.replace("Z","+00:00"))
        return t >= cutoff
    except Exception:
        return True

prospects = data.get("prospects", [])
keep_stages = {"qualified","closed_pending_publish","posted","support-case"}
active = [p for p in prospects if is_active(p) or p.get("stage") in keep_stages]
archive = [p for p in prospects if p not in active]

active_data = dict(data)
active_data["prospects"] = active
active_data["note"] = "14d-active slice; full archive in sales-pipeline-archive.json"

archive_data = {
    "version": data.get("version"),
    "note": "Prospects with no touches in last 14 days",
    "prospects": archive,
}

pathlib.Path("daemon/sales-pipeline-active.json").write_text(json.dumps(active_data, indent=2))
pathlib.Path("daemon/sales-pipeline-archive.json").write_text(json.dumps(archive_data, indent=2))
print(f"  active: {len(active)} prospects")
print(f"  archived: {len(archive)} prospects")
PY

echo "=== 3. Create watchlist.json (with IC threads) ==="
python3 - <<'PY'
import json, pathlib
out = pathlib.Path("daemon/watchlist.json")

# Don't overwrite if exists, but DO add missing sections
if out.exists():
    wl = json.loads(out.read_text())
    print("  watchlist.json exists — merging missing sections")
else:
    # Seed open_sends from outbox-archive
    oa = json.loads(pathlib.Path("daemon/outbox-archive.json").read_text())
    open_sends = []
    for e in oa.get("archived", []):
        if e.get("reply_content") is None:
            open_sends.append({
                "message_id": e["message_id"],
                "recipient_stx": e.get("recipient_stx"),
                "recipient_btc": e.get("recipient_btc"),
                "sent_at": e["sent_at"],
                "last_checked_at": None,
            })
    wl = {
        "version": "1.1",
        "note": "Open loops requiring active polling. Phase 1 updates each cycle.",
        "open_sends": open_sends,
        "open_github": [],
        "open_commitments": [],
        "archived": []
    }
    print(f"  seeded {len(open_sends)} open sends")

# Add ic_threads if missing
if "ic_threads" not in wl:
    wl["ic_threads"] = [
        {"url": "repos/aibtcdev/agent-news/issues/475", "last_checked_at": "1970-01-01T00:00:00Z", "purpose": "ic_recruitment"},
        {"url": "repos/aibtcdev/agent-news/issues/477", "last_checked_at": "1970-01-01T00:00:00Z", "purpose": "live_status_board"}
    ]
    print("  added ic_threads (#475 recruitment + #477 status board)")

# Add ic_conversations if missing
if "ic_conversations" not in wl:
    wl["ic_conversations"] = []
    print("  added empty ic_conversations array")

out.write_text(json.dumps(wl, indent=2))
PY

echo "=== 4. Create ic-activity.log if missing ==="
if [[ ! -f daemon/ic-activity.log ]]; then
    echo "# IC Activity Log — append-only record of IC events from Phase 1c/1e" > daemon/ic-activity.log
    echo "# Format: ISO8601 | author | event_type | prospect_id_or_null | url_or_detail" >> daemon/ic-activity.log
    echo "  created daemon/ic-activity.log"
else
    echo "  ic-activity.log exists"
fi

echo "=== 5. Verification ==="
ls -la daemon/watchlist.json daemon/sales-pipeline-active.json daemon/sales-pipeline-archive.json daemon/ic-activity.log 2>/dev/null
echo ""
echo "Done. Next steps:"
echo "  1. cp loop.md .claude/loop.md"
echo "  2. Edit daemon/STATE.md — add this_week_close_target: p017"
echo "  3. Edit daemon/NORTH_STAR.md — add week-target directive block"
echo "  4. git add -A && git commit -m 'migrate: follow-up-first loop + IC monitoring'"
echo "  5. Run a cycle manually and check daemon/ic-activity.log grew"
