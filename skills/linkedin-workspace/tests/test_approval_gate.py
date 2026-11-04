import hashlib
import json
import subprocess
import sys
import unittest
from pathlib import Path


SCRIPT = Path(__file__).parents[1] / "scripts" / "check-approval.py"


def valid_input():
    body = "Approved synthetic post."
    digest = hashlib.sha256(body.encode("utf-8")).hexdigest()
    return {
        "content": {
            "Content ID": "LI-0001", "Revision": 2, "Content Hash": digest,
            "Final Post Text": body, "Approval": "approved",
            "Visual Status": "not_needed", "Visual Type": "none",
        },
        "visual_assets": [],
        "approval": {
            "Content ID": "LI-0001", "Revision": 2,
            "Content Hash": digest, "approved": True,
        },
    }


def run_gate(data):
    return subprocess.run(
        [sys.executable, str(SCRIPT)], input=json.dumps(data), text=True,
        capture_output=True, check=False,
    )


class ApprovalGateTests(unittest.TestCase):
    def test_accepts_exact_approved_content_without_visual(self):
        result = run_gate(valid_input())
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(result.stdout)["decision"], "allowed")

    def test_denies_non_string_visual_type_with_structured_result(self):
        for invalid in [[], {}]:
            with self.subTest(value=invalid):
                data = valid_input()
                data["content"].update({"Visual Status": "ready", "Visual Type": invalid})
                result = run_gate(data)
                self.assertEqual(result.returncode, 1)
                self.assertEqual(json.loads(result.stdout)["decision"], "denied")
                self.assertEqual(result.stderr, "")

    def test_denies_stale_body_hash(self):
        data = valid_input()
        data["content"]["Final Post Text"] += " Edited"
        result = run_gate(data)
        self.assertEqual(result.returncode, 1)
        self.assertEqual(json.loads(result.stdout)["decision"], "denied")

    def test_denies_mismatched_revision_and_boolean_revision(self):
        data = valid_input()
        data["approval"]["Revision"] = 1
        self.assertEqual(run_gate(data).returncode, 1)
        data = valid_input()
        data["content"]["Revision"] = True
        self.assertEqual(run_gate(data).returncode, 1)

    def test_requires_matching_verified_visual(self):
        data = valid_input()
        data["content"].update({"Visual Status": "ready", "Visual Type": "document"})
        result = run_gate(data)
        self.assertEqual(result.returncode, 1)
        digest = data["content"]["Content Hash"]
        data["visual_assets"] = [{
            "Content ID": "LI-0001", "Type": "document", "Source Hash": digest,
            "QA Status": "verified", "Approved": "yes",
        }]
        self.assertEqual(run_gate(data).returncode, 0)

    def test_denies_malformed_json_and_missing_approval(self):
        bad = subprocess.run([sys.executable, str(SCRIPT)], input="{", text=True,
                             capture_output=True, check=False)
        self.assertEqual(bad.returncode, 1)
        data = valid_input()
        data.pop("approval")
        self.assertEqual(run_gate(data).returncode, 1)


if __name__ == "__main__":
    unittest.main()
