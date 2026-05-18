# State — Inter-Cycle Handoff

cycle: 2034v419
at: 2026-05-18T23:15Z
goal: 3rd 30min cooldown also quiet — wide sweep across all aibtcdev + arc0btc + Robotbot69 confirmed nothing fresh → went hunting for the long-standing hardcoded-path bug

shipped:
- **scripts/ic-status.sh + scripts/ic-email-status.sh path fix**: replaced hardcoded `/home/mars/drx4` with portable `REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"`. These are the 2 scripts briefing.sh calls during boot — previously failed silently with "no pipeline at /home/mars/drx4/daemon/sales-pipeline.json" because /home/mars doesn't exist on this machine (agent user is `agent`, not `mars`). Now execute correctly, show real IC pool + email setup data
- Identified 20+ other retired Sales DRI scripts with same path bug (fire-queue-*, fire-draft, send-mail, discord-cli, etc.) — deferred to separate cleanup since none are currently called

wide-sweep validation (covers v416+v417+v418+v419 cumulative cooldown observation): 0 fresh activity across all aibtcdev + arc0btc + Robotbot69 since 2026-05-18T22:00Z (1.25h+ pure silence). v416 build-burst pattern now triply validated; maintainer attention genuinely cycling elsewhere

open balls: (unchanged from v418) — see NORTH_STAR Active surfaces table
observations: 21 substantive ships in 21 cycles; v419 fixed a real infrastructure bug that's been broken since whatever date the repo was migrated to agent user (likely months). Tiny but honest substantive work surfaces from real session-state attention rather than manufactured external pings
next: extend cooldown to 3600s (max allowed per loop.md without operator back-off signal); if 4th cycle quiet, the maintainer-build-burst-elsewhere pattern is overwhelming evidence for waiting; if any activity fires, batch-process
