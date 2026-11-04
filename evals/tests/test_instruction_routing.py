import importlib.util
import json
import unittest
from pathlib import Path


SCRIPTS = Path(__file__).resolve().parents[1] / "scripts"


def module(name, filename):
    spec = importlib.util.spec_from_file_location(name, SCRIPTS / filename)
    result = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(result)
    return result


instruction = module("evaluate_instructions", "evaluate-instructions.py")
routing = module("evaluate_routing", "evaluate-routing.py")


class InstructionPromptTests(unittest.TestCase):
    def test_suite_has_six_cases_and_explicit_overlap_reviews(self):
        data = instruction.load_cases(Path(__file__).resolve().parents[2])
        self.assertGreaterEqual(len(data["cases"]), 6)
        self.assertTrue(all(case["overlap_review"] for case in data["cases"]))

    def test_candidate_is_baseline_plus_only_the_instruction_snapshot(self):
        case = {"prompt": "Synthetic task"}
        baseline = instruction.make_prompt(case, None)
        candidate = instruction.make_prompt(case, "UNIQUE_TARGET_POLICY")
        self.assertTrue(candidate.startswith(baseline + "\n\nRepository global instructions"))
        self.assertNotIn("UNIQUE_TARGET_POLICY", baseline)
        self.assertIn("UNIQUE_TARGET_POLICY", candidate)

    def test_isolation_audit_rejects_grader_criteria_leak(self):
        case = {"id": "x", "prompt": "task", "overlap_review": "review-only", "assertions": [{"id": "a", "criterion": "secret criterion"}]}
        baseline = instruction.make_prompt(case, None)
        candidate = instruction.make_prompt(case, "policy")
        instruction.audit_case_prompt(case, baseline, candidate, "policy")
        with self.assertRaises(ValueError):
            instruction.audit_case_prompt(case, baseline + " secret criterion", candidate, "policy")

    def test_event_audit_requires_completed_response_without_tools(self):
        output = '{"type":"turn.completed","item":{"type":"agent_message","text":"answer"}}\n'
        events, valid, failed = instruction.inspect_events(output)
        self.assertEqual(events, [])
        self.assertTrue(valid)
        self.assertFalse(failed)
        tool = '{"type":"item.completed","item":{"type":"command_execution","command":"touch x"}}\n'
        events, valid, failed = instruction.inspect_events(tool)
        self.assertTrue(events)
        self.assertFalse(valid)


class RoutingPromptTests(unittest.TestCase):
    def test_prompt_does_not_include_case_specific_expected_route(self):
        data = json.loads((Path(__file__).resolve().parents[1] / "cases/routing/evals.json").read_text())
        case = next(item for item in data["cases"] if "expected_behavior" in item)
        prompt = routing.build_prompt("A synthetic request", ["brainstorming", "spec-workflow"])
        self.assertNotIn(case["expected_behavior"], prompt)
        self.assertIn("A synthetic request", prompt)


if __name__ == "__main__":
    unittest.main()
