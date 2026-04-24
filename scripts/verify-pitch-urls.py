#!/usr/bin/env python3
"""
verify-pitch-urls.py — enforce Rule 12 (URL citation against canonical source).

Scans markdown for github.com URLs (and aibtc.news / aibtc.com URLs) and curls
each one. Exits non-zero if any URL returns a non-2xx status.

Use on:
- draft pitches before fire (any file in daemon/drafts/)
- public-comment drafts before posting (pass --stdin)

Also flags suspicious product-as-org patterns (github.com/X/X) — but does not
fail on them if the URL resolves, since some real repos use that naming
(cocoa007/cocoa007, sigle/sigle, bitrouter/bitrouter).

Usage:
    python3 scripts/verify-pitch-urls.py <file-or-dir>...
    cat /tmp/comment.md | python3 scripts/verify-pitch-urls.py --stdin

Exit codes:
    0 - all URLs resolve 200
    1 - one or more URLs returned non-2xx
    2 - no URLs found (warning only, exits 0)
"""
import sys
import re
import subprocess
from pathlib import Path

URL_PATTERN = re.compile(r'https://(?:github\.com|aibtc\.news|aibtc\.com|raw\.githubusercontent\.com)/[^\s\)\]<>"]+')
PRODUCT_AS_ORG_KNOWN_GOOD = {
    "cocoa007/cocoa007",
    "sigle/sigle",
    "bitrouter/bitrouter",
}


def check_url(url: str) -> tuple[int, str]:
    url = url.rstrip(".,;:")
    try:
        result = subprocess.run(
            ["curl", "-sI", "-o", "/dev/null", "-w", "%{http_code}", "-L", "--max-time", "10", url],
            capture_output=True, text=True, timeout=15,
        )
        code = int(result.stdout.strip() or "0")
        return code, url
    except (subprocess.TimeoutExpired, ValueError):
        return 0, url


def scan_text(text: str, source: str) -> tuple[int, int]:
    urls = set(URL_PATTERN.findall(text))
    if not urls:
        return 0, 0
    failed = 0
    suspicious = 0
    print(f"\n== {source} ({len(urls)} url(s)) ==")
    for url in sorted(urls):
        code, normalized = check_url(url)
        status = "OK" if 200 <= code < 400 else "FAIL"
        marker = " [PRODUCT-AS-ORG]" if re.search(r'github\.com/([^/]+)/\1(?:[/#?]|$)', url) and not any(k in url for k in PRODUCT_AS_ORG_KNOWN_GOOD) else ""
        print(f"  [{status} {code}] {normalized}{marker}")
        if code < 200 or code >= 400:
            failed += 1
        if marker:
            suspicious += 1
    return failed, suspicious


def main(argv: list[str]) -> int:
    if "--stdin" in argv:
        text = sys.stdin.read()
        failed, _ = scan_text(text, "stdin")
        return 1 if failed else 0

    paths = [Path(a) for a in argv[1:] if not a.startswith("-")]
    if not paths:
        print("usage: verify-pitch-urls.py <file-or-dir>... | --stdin")
        return 2

    total_failed = 0
    total_files = 0
    for p in paths:
        if p.is_dir():
            files = list(p.rglob("*.md"))
        elif p.is_file():
            files = [p]
        else:
            print(f"skip (not found): {p}")
            continue
        for f in files:
            total_files += 1
            failed, _ = scan_text(f.read_text(), str(f))
            total_failed += failed

    print(f"\n== {total_files} file(s) · {total_failed} url(s) failed ==")
    return 1 if total_failed else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
