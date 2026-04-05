#!/usr/bin/env python3
"""
Interactive pipeline test.

Usage:
    # Start the server first:
    #   source jac-env/bin/activate && jac start server.jac --no_client -p 8001
    python3 test_interactive.py [--port 8001]
"""

import sys
import json
import time
import argparse
import urllib.request
import urllib.error

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------
parser = argparse.ArgumentParser()
parser.add_argument("--port", type=int, default=8001)
args = parser.parse_args()
BASE_URL = f"http://localhost:{args.port}"

NODE_ORDER = [
    "case_assessment",
    "rights_protections",
    "urgent_steps",
    "critical_warnings",
    "follow_up_questions",
    "legal_glossary",
    "help_contacts",
    "process_outlook",
]

# ---------------------------------------------------------------------------
# HTTP helper
# ---------------------------------------------------------------------------
def post(path, body, token=None):
    data = json.dumps(body).encode()
    headers = {"Content-Type": "application/json"}
    if token:
        headers["Authorization"] = f"Bearer {token}"
    req = urllib.request.Request(
        f"{BASE_URL}{path}", data=data, headers=headers, method="POST"
    )
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            return json.loads(resp.read())
    except urllib.error.HTTPError as e:
        body = e.read().decode()
        print(f"  HTTP {e.code} from {path}: {body[:300]}")
        sys.exit(1)
    except urllib.error.URLError as e:
        print(f"  Cannot reach server at {BASE_URL}: {e.reason}")
        print("  Make sure the server is running: jac start server.jac --no_client -p 8001")
        sys.exit(1)


# ---------------------------------------------------------------------------
# Display helpers
# ---------------------------------------------------------------------------
def print_divider(char="─", width=70):
    print(char * width)

def print_node_results(results: dict):
    for key in NODE_ORDER:
        node = results.get(key)
        if not node:
            continue
        print_divider()
        label = key.replace("_", " ").upper()
        loop = node.get("loop_count", "?")
        model = node.get("model", "?")
        print(f"  [{label}]  (loop {loop}, model: {model})")
        print_divider("·")
        value = node.get("value", "").strip()
        print(f"  {value}")
    print_divider()


# ---------------------------------------------------------------------------
# Register a fresh user
# ---------------------------------------------------------------------------
print()
print_divider("═")
print("  BONO PIPELINE INTERACTIVE TEST")
print_divider("═")
print()

resp = post("/user/register", {
    "username": f"test_{int(time.time())}",
    "password": "testpass"
})
if not resp.get("ok"):
    print(f"Registration failed: {resp}")
    sys.exit(1)

TOKEN = resp["data"]["token"]
print(f"  Registered test user (token: {TOKEN[:12]}...)")
print()

# ---------------------------------------------------------------------------
# Get the initial string from the user
# ---------------------------------------------------------------------------
print("Enter the situation string to run through the pipeline:")
print("  (e.g. 'I received a Notice to Appear and my green card is pending.')")
print()
try:
    user_input = input("  > ").strip()
except (EOFError, KeyboardInterrupt):
    print()
    sys.exit(0)

if not user_input:
    print("No input provided, exiting.")
    sys.exit(0)

# ---------------------------------------------------------------------------
# Step 1: AnalyzeSituation
# ---------------------------------------------------------------------------
print()
print_divider("═")
print("  STEP 1 — AnalyzeSituation")
print_divider("═")
print()

resp = post("/walker/AnalyzeSituation", {"user_input": user_input}, token=TOKEN)
if not resp.get("ok"):
    print(f"AnalyzeSituation failed: {resp}")
    sys.exit(1)

reports = resp.get("data", {}).get("reports", [])
if not reports:
    print("No reports returned from AnalyzeSituation.")
    sys.exit(1)

results = reports[0]
print_node_results(results)

# ---------------------------------------------------------------------------
# Step 2: Follow-up loop
# ---------------------------------------------------------------------------
loop = 0
max_loops = 3
original_input = user_input

while loop < max_loops:
    print()
    print("Do you want to answer a follow-up question? [y/N]")
    try:
        choice = input("  > ").strip().lower()
    except (EOFError, KeyboardInterrupt):
        print()
        break

    if choice not in ("y", "yes"):
        break

    print()
    print("Enter your follow-up answer:")
    try:
        follow_up_answer = input("  > ").strip()
    except (EOFError, KeyboardInterrupt):
        print()
        break

    if not follow_up_answer:
        print("  (empty answer, skipping)")
        break

    loop += 1
    print()
    print_divider("═")
    print(f"  FOLLOW-UP ROUND {loop}")
    print_divider("═")
    print()

    resp = post("/walker/FollowUp", {
        "original_input": original_input,
        "follow_up_answer": follow_up_answer,
    }, token=TOKEN)

    if not resp.get("ok"):
        print(f"FollowUp failed: {resp}")
        break

    reports = resp.get("data", {}).get("reports", [])
    if not reports:
        print("No reports returned from FollowUp.")
        break

    payload = reports[0]

    # FollowUp can return either a summary (limit reached) or updated results
    if payload.get("limit_reached"):
        print("  Maximum follow-up rounds reached. Final summary:")
        print()
        print_divider("·")
        print(payload.get("summary", "(no summary)"))
        print_divider("·")
        break
    else:
        inner = payload.get("results", payload)
        print_node_results(inner)

print()
print_divider("═")
print("  Done.")
print_divider("═")
print()
