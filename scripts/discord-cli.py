#!/usr/bin/env python3
"""
Discord CLI for Secret Mars — Sales DRI IC recruitment + prospect discovery.

Reads bot token from /home/mars/drx4/.secrets/discord-bot-token.
Optional config: /home/mars/drx4/.secrets/discord-config.json with keys:
  {"server_id": "...", "recruitment_channel_id": "..."}

Usage:
  discord-cli.py whoami
  discord-cli.py channels [SERVER_ID]
  discord-cli.py recent CHANNEL_ID [--limit N]
  discord-cli.py post CHANNEL_ID "message text"
  discord-cli.py user USER_ID
  discord-cli.py dm USER_ID "message text"
"""
import argparse
import json
import os
import sys
import time
from pathlib import Path

import requests

TOKEN_PATH = Path("/home/mars/drx4/.secrets/discord-bot-token")
CONFIG_PATH = Path("/home/mars/drx4/.secrets/discord-config.json")
API = "https://discord.com/api/v10"


def load_token() -> str:
    if not TOKEN_PATH.exists():
        sys.exit(f"Token not found at {TOKEN_PATH}. Drop token there (chmod 600).")
    mode = TOKEN_PATH.stat().st_mode & 0o777
    if mode & 0o077:
        sys.exit(f"Token file perms too open ({oct(mode)}). Run: chmod 600 {TOKEN_PATH}")
    return TOKEN_PATH.read_text().strip()


def load_config() -> dict:
    if CONFIG_PATH.exists():
        return json.loads(CONFIG_PATH.read_text())
    return {}


def headers() -> dict:
    return {
        "Authorization": f"Bot {load_token()}",
        "Content-Type": "application/json",
        "User-Agent": "SecretMars-DRI (drx4.xyz, 0.1)",
    }


def call(method: str, path: str, **kwargs) -> dict:
    r = requests.request(method, f"{API}{path}", headers=headers(), timeout=15, **kwargs)
    if r.status_code == 429:
        retry = float(r.json().get("retry_after", 1))
        time.sleep(retry + 0.1)
        return call(method, path, **kwargs)
    r.raise_for_status()
    return r.json() if r.text else {}


def cmd_whoami(_: argparse.Namespace) -> None:
    me = call("GET", "/users/@me")
    print(json.dumps({"id": me["id"], "username": me["username"], "bot": me.get("bot", False)}, indent=2))


def cmd_channels(args: argparse.Namespace) -> None:
    server_id = args.server_id or load_config().get("server_id")
    if not server_id:
        sys.exit("No server_id given and none in discord-config.json")
    chans = call("GET", f"/guilds/{server_id}/channels")
    for c in sorted(chans, key=lambda x: (x.get("type", 0), x.get("position", 0))):
        print(f"{c['id']} | type={c['type']} | #{c['name']}")


def cmd_recent(args: argparse.Namespace) -> None:
    msgs = call("GET", f"/channels/{args.channel_id}/messages?limit={args.limit}")
    for m in reversed(msgs):
        author = m["author"]["username"]
        ts = m["timestamp"]
        content = m["content"].replace("\n", " ")[:200]
        print(f"{ts} | {author} | {content}")


def cmd_post(args: argparse.Namespace) -> None:
    res = call("POST", f"/channels/{args.channel_id}/messages", json={"content": args.message})
    print(f"posted: https://discord.com/channels/{load_config().get('server_id','@me')}/{args.channel_id}/{res['id']}")


def cmd_user(args: argparse.Namespace) -> None:
    u = call("GET", f"/users/{args.user_id}")
    print(json.dumps(u, indent=2))


def cmd_dm(args: argparse.Namespace) -> None:
    channel = call("POST", "/users/@me/channels", json={"recipient_id": args.user_id})
    res = call("POST", f"/channels/{channel['id']}/messages", json={"content": args.message})
    print(f"dm sent: channel={channel['id']} msg={res['id']}")


def main() -> None:
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = p.add_subparsers(dest="cmd", required=True)

    sub.add_parser("whoami", help="Show bot identity").set_defaults(func=cmd_whoami)

    pc = sub.add_parser("channels", help="List server channels")
    pc.add_argument("server_id", nargs="?")
    pc.set_defaults(func=cmd_channels)

    pr = sub.add_parser("recent", help="Recent messages in channel")
    pr.add_argument("channel_id")
    pr.add_argument("--limit", type=int, default=20)
    pr.set_defaults(func=cmd_recent)

    pp = sub.add_parser("post", help="Post message to channel")
    pp.add_argument("channel_id")
    pp.add_argument("message")
    pp.set_defaults(func=cmd_post)

    pu = sub.add_parser("user", help="Get user info")
    pu.add_argument("user_id")
    pu.set_defaults(func=cmd_user)

    pd = sub.add_parser("dm", help="Send DM to user")
    pd.add_argument("user_id")
    pd.add_argument("message")
    pd.set_defaults(func=cmd_dm)

    args = p.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
