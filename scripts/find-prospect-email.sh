#!/usr/bin/env bash
# find-prospect-email.sh — extract org-domain emails from a prospect's legal/security pages.
# Usage: scripts/find-prospect-email.sh <domain>
#
# Pattern (cycle 2034pu, 2026-04-30): when a prospect's GH commits only expose personal
# noreply addresses (off-policy per IC mandate org-domain rule), most modern crypto sites
# are JS-rendered SPAs that hide emails on the homepage. Privacy / terms / security.txt
# pages are usually pre-rendered and ALWAYS list a contact email (GDPR mandate / RFC 9116).
#
# Filters out: noreply, github bots, image URLs ending in .png/.svg, generic example.com.
set -uo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <domain>"
  echo "Example: $0 hermetica.fi"
  exit 1
fi

DOMAIN="$1"
DOMAIN_NO_PROTO="${DOMAIN#https://}"
DOMAIN_NO_PROTO="${DOMAIN_NO_PROTO#http://}"
DOMAIN_NO_PROTO="${DOMAIN_NO_PROTO%/}"

PATHS=("/privacy" "/terms" "/privacy-policy" "/terms-of-service" "/.well-known/security.txt" "/contact" "/about")

found=0
for path in "${PATHS[@]}"; do
  for proto in "https://" "https://www."; do
    url="${proto}${DOMAIN_NO_PROTO}${path}"
    emails=$(curl -sL --max-time 5 "$url" 2>/dev/null | \
      grep -oE '[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' 2>/dev/null | \
      grep -vE 'noreply|bot|users\.no|@example|\.png|\.svg|\.jpg|@[0-9]x|@github\.com$|^_@|^[a-z]@[a-z]+\.[a-z]+$' 2>/dev/null | \
      sort -u | head -3 || true)
    if [[ -n "$emails" ]]; then
      echo "$url"
      echo "$emails" | sed 's/^/  /'
      found=1
    fi
  done
done

if [[ $found -eq 0 ]]; then
  echo "No org-domain emails found at standard legal paths for $DOMAIN."
  echo "Try: GitHub commits, twitter bio, dev.to, LinkedIn (manual)."
  exit 1
fi
