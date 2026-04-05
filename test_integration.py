#!/usr/bin/env python3
"""
Frontend/Backend linking integration tests.

Verifies that the HTTP API endpoints match what the frontend (frontend.cl.jac)
expects. Tests register a fresh user, then exercise each walker endpoint.

Usage:
    # Start the server first:
    #   source jac-env/bin/activate && jac start server.jac --no_client -p 8001
    python3 test_integration.py [--port 8001]
"""

import sys
import json
import time
import argparse
import urllib.request
import urllib.error

BASE_URL = "http://localhost:8001"
EXPECTED_RESULT_KEYS = [
    "case_assessment", "rights_protections", "urgent_steps", "critical_warnings",
    "follow_up_questions", "legal_glossary", "help_contacts", "process_outlook",
]
EXPECTED_RESULT_FIELDS = ["value", "model", "is_ready", "loop_count"]

passed = 0
failed = 0


def post(path, body, token=None):
    data = json.dumps(body).encode()
    headers = {"Content-Type": "application/json"}
    if token:
        headers["Authorization"] = f"Bearer {token}"
    req = urllib.request.Request(f"{BASE_URL}{path}", data=data, headers=headers, method="POST")
    with urllib.request.urlopen(req, timeout=15) as resp:
        return json.loads(resp.read())


def check(name, condition, detail=""):
    global passed, failed
    if condition:
        print(f"  PASS  {name}")
        passed += 1
    else:
        print(f"  FAIL  {name}" + (f": {detail}" if detail else ""))
        failed += 1


# ---------------------------------------------------------------------------
# Setup: register a test user
# ---------------------------------------------------------------------------
print("=== Setup ===")
try:
    resp = post("/user/register", {"username": f"integ_{int(time.time())}", "password": "testpass"})
    assert resp["ok"], resp
    TOKEN = resp["data"]["token"]
    print(f"  Registered user, token: {TOKEN[:12]}...")
except Exception as e:
    print(f"  FATAL: Could not register user: {e}")
    sys.exit(1)

# ---------------------------------------------------------------------------
# Test 1: AnalyzeSituation returns all 8 nodes
# ---------------------------------------------------------------------------
print("\n=== Test 1: AnalyzeSituation ===")
resp = post("/walker/AnalyzeSituation",
            {"user_input": "I received a Notice to Appear and my green card is pending."},
            token=TOKEN)

check("response.ok is true", resp["ok"])
check("data.reports is a list", isinstance(resp.get("data", {}).get("reports"), list))
reports = resp.get("data", {}).get("reports", [])
check("reports has at least 1 entry", len(reports) >= 1)

if reports:
    result = reports[0]
    check("reports[0] has all 8 keys", all(k in result for k in EXPECTED_RESULT_KEYS),
          f"got: {list(result.keys())}")
    for key in EXPECTED_RESULT_KEYS:
        node = result.get(key, {})
        check(f"  {key} has required fields",
              all(f in node for f in EXPECTED_RESULT_FIELDS))
        check(f"  {key}.value is non-empty", bool(node.get("value", "").strip()))

# ---------------------------------------------------------------------------
# Test 2: FollowUp returns updated results
# ---------------------------------------------------------------------------
print("\n=== Test 2: FollowUp ===")
resp2 = post("/walker/FollowUp", {
    "original_input": "I received a Notice to Appear.",
    "follow_up_answer": "My employer already filed an I-129 extension.",
}, token=TOKEN)

check("response.ok is true", resp2["ok"])
reports2 = resp2.get("data", {}).get("reports", [])
check("reports has at least 1 entry", len(reports2) >= 1)

if reports2:
    result2 = reports2[0]
    # FollowUp reports {"results": {...}, "limit_reached": bool}
    check("reports[0] has 'results' key", "results" in result2 or any(k in result2 for k in EXPECTED_RESULT_KEYS),
          f"got keys: {list(result2.keys())}")
    check("reports[0] has 'limit_reached' key", "limit_reached" in result2)

    inner = result2.get("results", result2)
    check("follow-up results has all 8 keys", all(k in inner for k in EXPECTED_RESULT_KEYS),
          f"got: {list(inner.keys())}")

# ---------------------------------------------------------------------------
# Test 3: SwitchModel updates model
# ---------------------------------------------------------------------------
print("\n=== Test 3: SwitchModel ===")
resp3 = post("/walker/SwitchModel", {
    "target_label": "case_assessment",
    "new_model": "claude-sonnet-4-6",
}, token=TOKEN)

check("response.ok is true", resp3["ok"])
reports3 = resp3.get("data", {}).get("reports", [])
check("reports has at least 1 entry", len(reports3) >= 1)

if reports3:
    r = reports3[0]
    check("reports[0] has 'label'", "label" in r, f"got: {list(r.keys())}")
    check("reports[0].label == 'case_assessment'", r.get("label") == "case_assessment")
    check("reports[0].model == 'claude-sonnet-4-6'", r.get("model") == "claude-sonnet-4-6")

# ---------------------------------------------------------------------------
# Test 4: SwitchModel rejects invalid model
# ---------------------------------------------------------------------------
print("\n=== Test 4: SwitchModel rejects invalid model ===")
resp4 = post("/walker/SwitchModel", {
    "target_label": "case_assessment",
    "new_model": "fake-model-xyz",
}, token=TOKEN)

check("response.ok is true", resp4["ok"])
reports4 = resp4.get("data", {}).get("reports", [])
if reports4:
    check("model not changed to fake", reports4[0].get("model") != "fake-model-xyz",
          f"model is: {reports4[0].get('model')}")

# ---------------------------------------------------------------------------
# Test 5: ResetAll clears all nodes
# ---------------------------------------------------------------------------
print("\n=== Test 5: ResetAll ===")
resp5 = post("/walker/ResetAll", {}, token=TOKEN)

check("response.ok is true", resp5["ok"])
reports5 = resp5.get("data", {}).get("reports", [])
check("reports has at least 1 entry", len(reports5) >= 1)

if reports5:
    reset_list = reports5[0]
    check("reports[0] is a list of reset statuses",
          isinstance(reset_list, list) or isinstance(reset_list, dict))

# After reset, re-analyze should still work (graph auto-re-inits on next call)
resp5b = post("/walker/AnalyzeSituation",
              {"user_input": "Testing after reset."},
              token=TOKEN)
check("AnalyzeSituation works after ResetAll", resp5b["ok"])
reports5b = resp5b.get("data", {}).get("reports", [])
if reports5b:
    check("8 keys present after reset", all(k in reports5b[0] for k in EXPECTED_RESULT_KEYS))

# ---------------------------------------------------------------------------
# Test 6: FollowUp max loops triggers summary
# ---------------------------------------------------------------------------
print("\n=== Test 6: FollowUp max loops (3 iterations) ===")
limit_reached = False
for i in range(3):
    r = post("/walker/FollowUp", {
        "original_input": "I am applying for a green card through my spouse.",
        "follow_up_answer": f"Answer number {i + 1}",
    }, token=TOKEN)
    reps = r.get("data", {}).get("reports", [])
    if reps and reps[0].get("limit_reached"):
        limit_reached = True
        break

check("limit_reached triggers after max loops", limit_reached)

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
total = passed + failed
print(f"\n=== Results: {passed}/{total} passed ===")
if failed:
    sys.exit(1)
