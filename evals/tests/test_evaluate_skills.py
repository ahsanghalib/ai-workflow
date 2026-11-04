import importlib.util
import json
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch


SCRIPT = Path(__file__).resolve().parents[1] / "scripts" / "evaluate-skills.py"
SPEC = importlib.util.spec_from_file_location("evaluate_skills", SCRIPT)
evaluate_skills = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(evaluate_skills)


class PromptConstructionTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.root = Path(self.tmp.name)
        (self.root / "evals" / "cases" / "skills" / "linkedin-workspace" / "files").mkdir(parents=True)
        (self.root / "skills" / "linkedin-workspace" / "references").mkdir(parents=True)
        (self.root / "skills" / "linkedin-workspace" / "SKILL.md").write_text(
            "---\nname: linkedin-workspace\n---\nCANDIDATE_ONLY_SKILL_RULE\n"
        )
        (self.root / "skills" / "linkedin-workspace" / "references" / "state-rules.md").write_text(
            "CANDIDATE_ONLY_STATE_RULE\n"
        )
        (self.root / "skills" / "linkedin-workspace" / "references" / "google-sheet-schema.md").write_text(
            "CANDIDATE_ONLY_SCHEMA_RULE\n"
        )
        (self.root / "evals" / "cases" / "skills" / "linkedin-workspace" / "files" / "fixture.txt").write_text(
            "SYNTHETIC_FIXTURE\n"
        )
        self.case = {
            "id": "case-1",
            "prompt": "Use linkedin-workspace for evals/files/fixture.txt and propose a local state.",
            "files": ["files/fixture.txt"],
            "expected_output": "GRADER_ONLY_EXPECTED_OUTPUT",
            "assertions": ["GRADER_ONLY_ASSERTION"],
            "expected_new_content_hash": "GRADER_ONLY_HASH",
        }

    def tearDown(self):
        self.tmp.cleanup()

    def test_baseline_excludes_skill_schema_state_and_grader_data(self):
        built = evaluate_skills.build_prompt(self.root, "linkedin-workspace", self.case, "baseline")
        prompt = built["prompt"]
        for forbidden in (
            "CANDIDATE_ONLY_SKILL_RULE",
            "CANDIDATE_ONLY_STATE_RULE",
            "CANDIDATE_ONLY_SCHEMA_RULE",
            "GRADER_ONLY_EXPECTED_OUTPUT",
            "GRADER_ONLY_ASSERTION",
            "GRADER_ONLY_HASH",
        ):
            self.assertNotIn(forbidden, prompt)
        self.assertIn("SYNTHETIC_FIXTURE", prompt)
        self.assertNotIn("Use linkedin-workspace", prompt)
        self.assertEqual(built["neutral_task"], "evals/files/fixture.txt and propose a local state.")

    def test_candidate_adds_entrypoint_and_relevant_references_only(self):
        built = evaluate_skills.build_prompt(self.root, "linkedin-workspace", self.case, "candidate")
        prompt = built["prompt"]
        self.assertIn("CANDIDATE_ONLY_SKILL_RULE", prompt)
        self.assertIn("CANDIDATE_ONLY_STATE_RULE", prompt)
        self.assertIn("CANDIDATE_ONLY_SCHEMA_RULE", prompt)
        self.assertNotIn("GRADER_ONLY", prompt)
        self.assertEqual(built["neutral_task"], "evals/files/fixture.txt and propose a local state.")

    def test_explicit_baseline_prompt_is_shared_across_modes(self):
        self.case["baseline_prompt"] = "Review this synthetic local state and propose a patch."
        base = evaluate_skills.build_prompt(self.root, "linkedin-workspace", self.case, "baseline")
        candidate = evaluate_skills.build_prompt(self.root, "linkedin-workspace", self.case, "candidate")
        self.assertEqual(base["neutral_task"], candidate["neutral_task"])
        self.assertIn("Review this synthetic local state", base["prompt"])
        self.assertNotIn("CANDIDATE_ONLY", base["prompt"])

    def test_rejects_invalid_case_paths_and_modes(self):
        self.case["files"] = ["../../outside.txt"]
        with self.assertRaises(ValueError):
            evaluate_skills.build_prompt(self.root, "linkedin-workspace", self.case, "baseline")
        self.case["files"] = ["files/fixture.txt"]
        with self.assertRaises(ValueError):
            evaluate_skills.build_prompt(self.root, "linkedin-workspace", self.case, "other")

    def test_rejects_symlinked_source_outside_repository(self):
        outside = self.root.parent / (self.root.name + "-outside.txt")
        outside.write_text("outside")
        linked = self.root / "evals" / "cases" / "skills" / "linkedin-workspace" / "files" / "linked.txt"
        linked.symlink_to(outside)
        self.case["files"] = ["files/linked.txt"]
        with self.assertRaises(ValueError):
            evaluate_skills.build_prompt(self.root, "linkedin-workspace", self.case, "baseline")
        outside.unlink()

    def test_records_hashes_for_exact_included_sources(self):
        built = evaluate_skills.build_prompt(self.root, "linkedin-workspace", self.case, "candidate")
        paths = {item["path"] for item in built["sources"]}
        self.assertEqual(paths, {
            "evals/cases/skills/linkedin-workspace/files/fixture.txt",
            "skills/linkedin-workspace/SKILL.md",
            "skills/linkedin-workspace/references/state-rules.md",
            "skills/linkedin-workspace/references/google-sheet-schema.md",
        })
        self.assertTrue(all(len(item["sha256"]) == 64 for item in built["sources"]))


class RunnerTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.root = Path(self.tmp.name)
        (self.root / "evals" / "cases" / "skills" / "linkedin-workspace" / "files").mkdir(parents=True)
        (self.root / "skills" / "linkedin-workspace" / "references").mkdir(parents=True)
        (self.root / "skills" / "linkedin-workspace" / "SKILL.md").write_text("---\nname: linkedin-workspace\n---\nRule")
        (self.root / "skills" / "linkedin-workspace" / "references" / "state-rules.md").write_text("State")
        (self.root / "skills" / "linkedin-workspace" / "references" / "google-sheet-schema.md").write_text("Schema")
        (self.root / "evals" / "cases" / "skills" / "linkedin-workspace" / "files" / "fixture.txt").write_text("fixture")
        self.case = {"id": "case-1", "prompt": "Review evals/files/fixture.txt.", "files": ["files/fixture.txt"]}

    def tearDown(self):
        self.tmp.cleanup()

    def test_runs_prompt_on_stdin_with_isolation_flags_and_identical_config(self):
        calls = []

        def fake_run(argv, **kwargs):
            calls.append((argv, kwargs))
            if argv == ["codex", "--version"]:
                return evaluate_skills.subprocess.CompletedProcess(argv, 0, "codex 1.2.3\n", "")
            return evaluate_skills.subprocess.CompletedProcess(argv, 0, '{"type":"turn.completed"}\n', "")

        with patch.object(evaluate_skills.subprocess, "run", side_effect=fake_run):
            run_dir = self.root / "results" / "run-1"
            run_dir.mkdir(parents=True)
            records = [
                evaluate_skills.run_case(self.root, run_dir, "run-1", "linkedin-workspace", self.case, mode, "gpt-test", "codex 1.2.3")
                for mode in ("baseline", "candidate")
            ]
        self.assertEqual(len(calls), 2)
        for argv, kwargs in calls:
            self.assertIn("--ephemeral", argv)
            self.assertIn("--ignore-user-config", argv)
            self.assertIn("--sandbox", argv)
            self.assertIn("read-only", argv)
            self.assertIn("--skip-git-repo-check", argv)
            self.assertIn("--json", argv)
            self.assertIn("-", argv)
            self.assertNotIn(kwargs["input"], argv)
            expected_record = records[0] if "baseline" in str(kwargs["cwd"]) else records[1]
            self.assertEqual(kwargs["input"], (run_dir / expected_record["prompt_snapshot"]).read_text())
            self.assertTrue(str(kwargs["cwd"]).startswith(str(run_dir)))
            self.assertEqual(kwargs["timeout"], 90)
        config_args = [[call[0][i + 1] for i, arg in enumerate(call[0][:-1]) if arg == "-c"] for call in calls]
        self.assertEqual(config_args[0], config_args[1])
        self.assertEqual(records[0]["model"], "gpt-test")
        self.assertEqual(records[0]["reasoning_effort"], "medium")
        self.assertEqual(records[0]["cli_version"], "codex 1.2.3")

    def test_tool_invocation_invalidates_run_even_when_exit_is_zero(self):
        run_dir = self.root / "results" / "run-2"
        run_dir.mkdir(parents=True)

        def fake_run(argv, **kwargs):
            if argv == ["codex", "--version"]:
                return evaluate_skills.subprocess.CompletedProcess(argv, 0, "codex 1.2.3", "")
            return evaluate_skills.subprocess.CompletedProcess(
                argv, 0, '{"type":"item.completed","item":{"type":"command_execution","command":"touch x"}}\n', ""
            )

        with patch.object(evaluate_skills.subprocess, "run", side_effect=fake_run):
            record = evaluate_skills.run_case(self.root, run_dir, "run-2", "linkedin-workspace", self.case, "baseline", "gpt-test", "codex 1.2.3")
        self.assertTrue(record["observed_tool_invocation"])
        self.assertFalse(record["valid_for_grading"])

    def test_each_case_mode_has_distinct_prompt_snapshot_and_workspace(self):
        run_dir = self.root / "results" / "run-3"
        run_dir.mkdir(parents=True)
        with patch.object(evaluate_skills.subprocess, "run") as mocked:
            mocked.side_effect = [
                evaluate_skills.subprocess.CompletedProcess([], 0, "codex 1", ""),
                evaluate_skills.subprocess.CompletedProcess([], 0, '{"type":"turn.completed"}\n', ""),
                evaluate_skills.subprocess.CompletedProcess([], 0, '{"type":"turn.completed"}\n', ""),
            ]
            baseline = evaluate_skills.run_case(self.root, run_dir, "run-3", "linkedin-workspace", self.case, "baseline", "gpt-test", "codex 1")
            candidate = evaluate_skills.run_case(self.root, run_dir, "run-3", "linkedin-workspace", self.case, "candidate", "gpt-test", "codex 1")
        self.assertNotEqual(baseline["prompt_sha256"], candidate["prompt_sha256"])
        self.assertNotEqual(baseline["workspace"], candidate["workspace"])
        self.assertTrue((run_dir / baseline["prompt_snapshot"]).exists())
        self.assertTrue((run_dir / candidate["prompt_snapshot"]).exists())

    def test_rejects_existing_run_directory(self):
        existing = self.root / "results" / "run-4"
        existing.mkdir(parents=True)
        with self.assertRaises(FileExistsError):
            evaluate_skills.create_run_directory(self.root / "results", "run-4")

    def test_rejects_unsafe_case_id_before_creating_workspace(self):
        run_dir = self.root / "results" / "run-5"
        run_dir.mkdir(parents=True)
        case = dict(self.case, id="../escape")
        with self.assertRaises(ValueError):
            evaluate_skills.run_case(self.root, run_dir, "run-5", "linkedin-workspace", case, "baseline", "gpt-test")
        self.assertFalse((self.root / "escape").exists())

    def test_zero_exit_without_completed_message_is_not_valid_for_grading(self):
        run_dir = self.root / "results" / "run-6"
        run_dir.mkdir(parents=True)

        def fake_run(argv, **kwargs):
            return evaluate_skills.subprocess.CompletedProcess(argv, 0, "", "")

        with patch.object(evaluate_skills.subprocess, "run", side_effect=fake_run):
            record = evaluate_skills.run_case(
                self.root, run_dir, "run-6", "linkedin-workspace", self.case,
                "baseline", "gpt-test", "codex 1.2.3",
            )
        self.assertFalse(record["valid_for_grading"])


if __name__ == "__main__":
    unittest.main()
