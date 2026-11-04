import importlib.util
import tempfile
import unittest
from pathlib import Path


MODULE = Path(__file__).resolve().parents[1] / "scripts" / "eval-reports.py"
SPEC = importlib.util.spec_from_file_location("eval_reports", MODULE)
reports = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(reports)


class GradeAggregationTests(unittest.TestCase):
    def test_case_precedence_and_empty_grade(self):
        self.assertEqual(reports.case_status(None), "ungraded")
        self.assertEqual(reports.case_status({"assertions": []}), "ungraded")
        self.assertEqual(reports.case_status({"assertions": [{"status": "pass"}]}), "pass")
        self.assertEqual(reports.case_status({"assertions": [
            {"status": "unverified"}, {"status": "fail"}]}), "fail")
        self.assertEqual(reports.case_status({"assertions": [
            {"status": "pass"}, {"status": "unverified"}]}), "unverified")

    def test_masked_assertions_are_unverified_and_excluded_from_rate(self):
        result = reports.aggregate([{
            "case_id": "c1", "assertions": [
                {"status": "pass"}, {"status": "fail"},
                {"status": "unverified", "masked": True}],
        }])
        self.assertEqual(result["assertion_rate"], {"passed": 1, "failed": 1, "n": 2, "percent": 50.0})
        self.assertEqual(result["unverified_assertions"], 1)

    def test_zero_denominator_has_no_score(self):
        result = reports.aggregate([{"case_id": "x", "assertions": [
            {"status": "unverified"}]}])
        self.assertIsNone(result["assertion_rate"]["percent"])
        self.assertEqual(result["assertion_rate"]["n"], 0)

    def test_invalid_grade_requires_evidence_and_safe_case_id(self):
        with self.assertRaises(ValueError):
            reports.validate_grade({"case_id": "../x", "assertions": [{"id": "a", "status": "pass", "evidence": "ok"}]})
        with self.assertRaises(ValueError):
            reports.validate_grade({"case_id": "x", "assertions": [{"id": "a", "status": "pass", "evidence": " "}]})
        with self.assertRaises(ValueError):
            reports.validate_grade({"schema_version": 1, "case_id": "x", "arm": "other", "reviewer": {"type": "human", "id": "reviewer"}, "assertions": [{"id": "a", "status": "pass", "evidence": "evidence"}]})

    def test_masked_assertion_cannot_be_passed_and_unsafe_proposal_fails_case(self):
        with self.assertRaises(ValueError):
            reports.validate_grade({"schema_version": 1, "case_id": "c", "reviewer": {"type": "human"}, "assertions": [{"id": "a", "status": "pass", "evidence": "evidence", "masked": True}]})
        self.assertEqual(reports.case_status({"assertions": [{"status": "pass"}], "unsafe_proposals": ["unsafe"]}), "fail")


class HtmlSafetyTests(unittest.TestCase):
    def test_report_escapes_untrusted_text_and_is_offline(self):
        html = reports.render_report({
            "run_id": "pilot", "model": "gpt-6-luna", "reasoning_effort": "medium",
            "records": [{"case_id": "c1", "mode": "candidate", "stdout": "<script>alert(1)</script>"}],
            "grades": [],
        })
        self.assertNotIn("<script>alert", html)
        self.assertIn("&lt;script&gt;", html)
        self.assertNotIn("https://", html)
        self.assertIn("Ungraded", html)
        self.assertIn("no score", html.casefold())

    def test_invalid_run_suppresses_grades(self):
        html = reports.render_report({"run_id": "invalid", "valid_for_grading": False,
            "records": [{"case_id": "c", "mode": "candidate", "stdout": "response"}],
            "grades": [{"case_id": "c", "arm": "candidate", "assertions": [{"status": "pass"}]}]})
        self.assertIn("Invalid for grading", html)
        self.assertIn("no score", html.casefold())
        self.assertNotIn("100.0%", html)

    def test_dry_run_is_not_mislabeled_invalid(self):
        html = reports.render_report({"run_id": "dry", "dry_run": True, "valid_for_grading": False,
            "records": [], "grades": []})
        self.assertIn("Dry run — not graded", html)
        self.assertNotIn("Invalid for grading", html)

    def test_paired_report_shows_missing_arm_as_ungraded(self):
        html = reports.render_report({"run_id": "partial", "model": "test", "reasoning_effort": "medium",
            "records": [{"case_id": "c", "mode": "baseline", "stdout": "baseline"},
                        {"case_id": "c", "mode": "candidate", "stdout": "candidate"}],
            "grades": [{"case_id": "c", "arm": "baseline", "assertions": [{"status": "pass"}]}]})
        self.assertIn("Candidate grade — ungraded", html)
        self.assertIn("Candidate case rate", html)
        self.assertIn("no score", html.casefold())
        self.assertIn("Partially graded pilot", html)

    def test_routing_report_reveals_expected_route_only_after_grade(self):
        base = {"run_id": "route", "records": [{"case_id": "r1", "mode": "single", "suite": "routing-v1", "query": "Pick a skill", "stdout": "{\\\"primary_skill\\\":\\\"example\\\"}", "_expected_route": {"expected_primary_skill": "example"}}]}
        ungraded = reports.render_report(base)
        self.assertIn("Pick a skill", ungraded)
        self.assertNotIn("expected_primary_skill", ungraded)
        graded = dict(base, grades=[{"case_id": "r1", "arm": "single", "assertions": [{"id": "route-selection", "status": "pass", "evidence": "Response names example."}]}])
        self.assertIn("expected_primary_skill", reports.render_report(graded))

    def test_index_links_only_known_relative_reports(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp) / "reports"
            root.mkdir()
            (root / "run-a").mkdir()
            (root / "run-a" / "report.html").write_text("ok")
            (root / "run-a" / "summary.json").write_text('{"run_id":"run-a","dry_run":false}')
            (root.parent / "archive-manifest.json").write_text('{"entries":[] }')
            result = reports.build_index(root)
            self.assertIn("run-a/report.html", result)
            self.assertNotIn("../", result)

    def test_run_loader_rejects_malformed_versioned_metadata(self):
        with tempfile.TemporaryDirectory() as tmp:
            run_dir = Path(tmp) / "run"
            run_dir.mkdir()
            (run_dir / "summary.json").write_text('{"run_id":"run"}')
            with self.assertRaises(ValueError):
                reports.load_run(run_dir)

    def test_run_loader_rejects_symlinked_metadata_outside_run(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            run_dir = root / "run"
            run_dir.mkdir()
            outside = root / "outside.json"
            outside.write_text('{"schema_version":1}')
            (run_dir / "summary.json").symlink_to(outside)
            with self.assertRaises(ValueError):
                reports.load_run(run_dir)

    def test_run_loader_rejects_duplicate_case_arm_records(self):
        with tempfile.TemporaryDirectory() as tmp:
            run_dir = Path(tmp) / "run"
            (run_dir / "a").mkdir(parents=True)
            (run_dir / "b").mkdir()
            (run_dir / "summary.json").write_text('{"schema_version":1,"run_id":"run"}')
            record = '{"schema_version":1,"case_id":"c","mode":"candidate","valid_for_grading":true}'
            (run_dir / "a" / "result.json").write_text(record)
            (run_dir / "b" / "result.json").write_text(record)
            with self.assertRaises(ValueError):
                reports.load_run(run_dir)

    def test_safe_links_reject_traversal_and_symlinks(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp) / "run"
            root.mkdir()
            outside = Path(tmp) / "outside.txt"
            outside.write_text("outside")
            (root / "link.txt").symlink_to(outside)
            self.assertIsNone(reports._safe_link(root, "../outside.txt"))
            self.assertIsNone(reports._safe_link(root, "link.txt"))

    def test_run_report_generation_creates_detail_and_catalog(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            run = root / "run-one"
            arm = run / "suite" / "case-one" / "single"
            arm.mkdir(parents=True)
            (run / "summary.json").write_text('{"schema_version":1,"run_id":"run-one","model":"test","reasoning_effort":"medium","records":1,"dry_run":false,"graded":false}')
            (arm / "result.json").write_text('{"schema_version":1,"run_id":"run-one","case_id":"case-one","mode":"single","valid_for_grading":true,"stdout":"safe output","prompt_snapshot":"suite/case-one/single/prompt.txt"}')
            (arm / "prompt.txt").write_text("fixture prompt")
            reports.generate_run_report(run, root)
            self.assertIn("Ungraded", (run / "report.html").read_text())
            self.assertIn("run-one/report.html", (root / "index.html").read_text())
            self.assertIn('href="suite/case-one/single/prompt.txt"', (run / "report.html").read_text())

    def test_archive_manifest_drops_duplicate_malformed_and_out_of_tree_links(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp) / "reports"
            root.mkdir()
            (root / "ok.md").write_text("ok")
            (root.parent / "archive-manifest.json").write_text('{"entries":['
                '{"path":"ok.md","title":"OK","label":"historical"},'
                '{"path":"ok.md","title":"duplicate","label":"invalid"},'
                '{"path":"../secret","title":"outside","label":"invalid"},'
                '{"path":"missing.md","title":"missing","label":"historical"},'
                '{"path":2,"title":"bad","label":"bad"}]}')
            index = reports.build_index(root)
            self.assertEqual(index.count('href="ok.md"'), 1)
            self.assertNotIn("secret", index)
            self.assertNotIn("missing.md", index)

    def test_partial_and_paired_grades_keep_separate_denominators(self):
        result = reports.aggregate([
            {"case_id": "c", "arm": "baseline", "assertions": [{"status": "pass"}]},
            {"case_id": "c", "arm": "candidate", "assertions": [{"status": "unverified"}]},
        ])
        self.assertEqual(result["by_mode"]["baseline"]["assertion_rate"]["percent"], 100.0)
        self.assertIsNone(result["by_mode"]["candidate"]["assertion_rate"]["percent"])


if __name__ == "__main__":
    unittest.main()
