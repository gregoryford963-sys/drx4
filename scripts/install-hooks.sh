#!/usr/bin/env bash
# Install git hooks by pointing core.hooksPath at the tracked scripts/hooks dir.
# Run once per clone.

set -euo pipefail
cd "$(dirname "$0")/.."

chmod +x scripts/hooks/pre-commit scripts/hooks/commit-msg
git config core.hooksPath scripts/hooks

echo "✓ hooks installed"
echo "  core.hooksPath = scripts/hooks"
echo ""
echo "Active hooks:"
ls -1 scripts/hooks/ | sed 's/^/  /'
echo ""
echo "Bypass for crash recovery / stop cycles:"
echo "  ALLOW_STATE_ONLY=1 git commit ..."
