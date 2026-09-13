from __future__ import annotations

import concurrent.futures
import os
import shutil
import sqlite3
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

SKILL_ROOT = Path(__file__).parents[1]
SCRIPT = "scripts/memory-management.py"


class MemoryManagementCliTests(unittest.TestCase):
    def setUp(self) -> None:
        self.tempdir = tempfile.TemporaryDirectory(
            prefix=".test-memory-",
            dir=SKILL_ROOT,
        )
        self.project_root = Path(self.tempdir.name)

    def tearDown(self) -> None:
        self.tempdir.cleanup()

    def run_cli(self, *arguments: str) -> subprocess.CompletedProcess[str]:
        return self.run_cli_from(self.project_root, *arguments)

    def run_cli_from(
        self,
        project_root: Path,
        *arguments: str,
    ) -> subprocess.CompletedProcess[str]:
        return self.run_cli_from_skill(SKILL_ROOT, project_root, *arguments)

    def run_cli_from_skill(
        self,
        skill_root: Path,
        project_root: Path,
        *arguments: str,
    ) -> subprocess.CompletedProcess[str]:
        return subprocess.run(
            [
                sys.executable,
                SCRIPT,
                "--project-root",
                str(project_root),
                *arguments,
            ],
            cwd=skill_root,
            capture_output=True,
            text=True,
            check=False,
        )

    def add_concurrent_title(self, title: str) -> subprocess.CompletedProcess[str]:
        return self.run_cli("add", "--title", title, "--feature", "concurrency")

    def test_installed_skill_runs_in_shared_agents_layout(self) -> None:
        install_tempdir = tempfile.TemporaryDirectory(prefix=".test-memory-install-")
        try:
            install_root = Path(install_tempdir.name)
            installed_skill = install_root / ".agents/skills/agent-memory"
            installed_skill.mkdir(parents=True)
            for filename in ("SKILL.md", "AGENTS-SNIPPET.md"):
                shutil.copy2(SKILL_ROOT / filename, installed_skill / filename)
            for directory in ("scripts", "templates"):
                shutil.copytree(
                    SKILL_ROOT / directory,
                    installed_skill / directory,
                )

            skill_text = (installed_skill / "SKILL.md").read_text(encoding="utf-8")
            self.assertIn("\nname: agent-memory\n", skill_text)
            self.assertTrue((installed_skill / SCRIPT).is_file())

            project_root = install_root / "project"
            project_root.mkdir()
            help_result = subprocess.run(
                [sys.executable, SCRIPT, "--help"],
                cwd=installed_skill,
                capture_output=True,
                text=True,
                check=False,
            )
            self.assertEqual(help_result.returncode, 0, help_result.stderr)
            self.assertIn("verify", help_result.stdout)

            initialized = self.run_cli_from_skill(
                installed_skill,
                project_root,
                "init",
            )
            self.assertEqual(initialized.returncode, 0, initialized.stderr)
            added = self.run_cli_from_skill(
                installed_skill,
                project_root,
                "add",
                "--title",
                "Installed shared episode",
            )
            self.assertEqual(added.returncode, 0, added.stderr)

            database = project_root / ".ai/memory/memory.sqlite"
            self.assertTrue(database.is_file())
            con = sqlite3.connect(database)
            try:
                fts_table = con.execute(
                    "SELECT name FROM sqlite_master WHERE name = 'memories_fts'"
                ).fetchone()
            finally:
                con.close()
            self.assertIsNotNone(fts_table)

            searched = self.run_cli_from_skill(
                installed_skill,
                project_root,
                "search",
                "shared",
            )
            self.assertEqual(searched.returncode, 0, searched.stderr)
            self.assertIn("Installed shared episode", searched.stdout)
            fetched = self.run_cli_from_skill(
                installed_skill,
                project_root,
                "get",
                "1",
            )
            self.assertEqual(fetched.returncode, 0, fetched.stderr)
            self.assertIn("Installed shared episode", fetched.stdout)
            verified = self.run_cli_from_skill(
                installed_skill,
                project_root,
                "verify",
            )
            self.assertEqual(verified.returncode, 0, verified.stderr)
            self.assertIn("consistent", verified.stdout)
            reindexed = self.run_cli_from_skill(
                installed_skill,
                project_root,
                "reindex",
            )
            self.assertEqual(reindexed.returncode, 0, reindexed.stderr)
        finally:
            install_tempdir.cleanup()

    def test_reads_sync_episode_edits_automatically(self) -> None:
        added = self.run_cli("add", "--title", "Editable episode")
        self.assertEqual(added.returncode, 0, added.stderr)

        episode = next((self.project_root / ".ai/memory/episodes").glob("*.md"))
        episode.write_text(
            episode.read_text(encoding="utf-8") + "\nFresh finding: use the new path.\n",
            encoding="utf-8",
        )

        searched = self.run_cli("search", "fresh finding")
        self.assertEqual(searched.returncode, 0, searched.stderr)
        self.assertIn("[Fresh]", searched.stdout)
        self.assertIn("[finding]", searched.stdout)

        fetched = self.run_cli("get", "1")
        self.assertEqual(fetched.returncode, 0, fetched.stderr)
        self.assertIn("Fresh finding", fetched.stdout)
        self.assertIn("[Untrusted episodic memory]", fetched.stdout)
        self.assertIn("Source:", fetched.stdout)
        self.assertIn("Recorded:", fetched.stdout)

    def test_reads_sync_external_and_deleted_episodes(self) -> None:
        added = self.run_cli("add", "--title", "Deleted episode")
        self.assertEqual(added.returncode, 0, added.stderr)
        generated = next((self.project_root / ".ai/memory/episodes").glob("*.md"))

        external = self.project_root / ".ai/memory/episodes/external.md"
        external.write_text(
            "# External episode\n\nFeature: sync\n\nexternal marker\n",
            encoding="utf-8",
        )
        generated.unlink()

        searched = self.run_cli("search", "external marker")
        self.assertEqual(searched.returncode, 0, searched.stderr)
        self.assertIn("[Untrusted episodic memory]", searched.stdout)
        self.assertIn("External episode", searched.stdout)
        self.assertIn("source: .ai/memory/episodes/external.md", searched.stdout)
        self.assertIn("recorded:", searched.stdout)
        self.assertNotIn("Deleted episode", searched.stdout)

        recent = self.run_cli("recent")
        self.assertEqual(recent.returncode, 0, recent.stderr)
        self.assertIn("[Untrusted episodic memory]", recent.stdout)
        self.assertIn("External episode", recent.stdout)
        self.assertNotIn("Deleted episode", recent.stdout)

        missing = self.run_cli("get", "1")
        self.assertEqual(missing.returncode, 1)
        self.assertIn("Memory not found", missing.stderr)

    @unittest.skipUnless(
        os.name == "posix" and hasattr(os, "geteuid") and os.geteuid() != 0,
        "requires POSIX file permissions as a non-root user",
    )
    def test_unreadable_episode_reports_concise_error(self) -> None:
        added = self.run_cli("add", "--title", "Unreadable episode")
        self.assertEqual(added.returncode, 0, added.stderr)
        episode = next((self.project_root / ".ai/memory/episodes").glob("*.md"))
        original_mode = episode.stat().st_mode & 0o777
        episode.chmod(0)
        try:
            result = self.run_cli("search", "unreadable")
        finally:
            episode.chmod(original_mode)

        self.assertEqual(result.returncode, 2)
        self.assertNotIn("Traceback", result.stderr)
        self.assertIn("filesystem error", result.stderr)

    @unittest.skipUnless(hasattr(os, "symlink"), "requires symlink support")
    def test_rejects_storage_symlink_outside_project_root(self) -> None:
        external_root = self.project_root.parent / f"{self.project_root.name}-external"
        self.addCleanup(external_root.rmdir)
        external_root.mkdir()
        os.symlink(
            external_root,
            self.project_root / ".ai",
            target_is_directory=True,
        )

        result = self.run_cli("init")

        self.assertEqual(result.returncode, 2)
        self.assertNotIn("Traceback", result.stderr)
        self.assertIn("path error", result.stderr)
        self.assertFalse((external_root / "memory").exists())

    @unittest.skipUnless(hasattr(os, "symlink"), "requires symlink support")
    def test_rejects_symlinked_episode_files(self) -> None:
        initialized = self.run_cli("init")
        self.assertEqual(initialized.returncode, 0, initialized.stderr)

        private_file = self.project_root / "private.md"
        private_file.write_text(
            "# Private file\n\nsecret sentinel\n",
            encoding="utf-8",
        )
        os.symlink(
            private_file,
            self.project_root / ".ai/memory/episodes/leaked.md",
        )

        result = self.run_cli("search", "secret sentinel")

        self.assertEqual(result.returncode, 2)
        self.assertNotIn("Traceback", result.stderr)
        self.assertIn("path error", result.stderr)
        self.assertNotIn("secret sentinel", result.stdout)

    def test_rejects_oversized_episode_source(self) -> None:
        initialized = self.run_cli("init")
        self.assertEqual(initialized.returncode, 0, initialized.stderr)

        episode = self.project_root / ".ai/memory/episodes/too-large.md"
        episode.write_bytes(b"# Too large\n\n" + b"x" * (256 * 1024))

        result = self.run_cli("search", "too large")

        self.assertEqual(result.returncode, 2)
        self.assertNotIn("Traceback", result.stderr)
        self.assertIn("episode exceeds", result.stderr)

    def test_concurrent_adds_complete_without_losing_episodes(self) -> None:
        titles = [f"Concurrent episode {index}" for index in range(8)]
        with concurrent.futures.ThreadPoolExecutor(max_workers=4) as executor:
            results = list(executor.map(self.add_concurrent_title, titles))

        for result in results:
            self.assertEqual(result.returncode, 0, result.stderr)

        recent = self.run_cli("recent", "--limit", "20")
        self.assertEqual(recent.returncode, 0, recent.stderr)
        for title in titles:
            self.assertIn(title, recent.stdout)

    def test_rebuilds_index_after_database_is_moved_aside(self) -> None:
        added = self.run_cli("add", "--title", "Recoverable episode")
        self.assertEqual(added.returncode, 0, added.stderr)

        memory_dir = self.project_root / ".ai/memory"
        database = memory_dir / "memory.sqlite"
        database_backup = memory_dir / "memory.sqlite.conflicted"
        shutil.move(database, database_backup)

        initialized = self.run_cli("init")
        self.assertEqual(initialized.returncode, 0, initialized.stderr)
        reindexed = self.run_cli("reindex")
        self.assertEqual(reindexed.returncode, 0, reindexed.stderr)

        searched = self.run_cli("search", "recoverable")
        self.assertEqual(searched.returncode, 0, searched.stderr)
        self.assertIn("Recoverable episode", searched.stdout)

    def test_missing_fts5_reports_prerequisite_error(self) -> None:
        con = sqlite3.connect(":memory:")
        try:
            try:
                con.execute(
                    "CREATE VIRTUAL TABLE fts5_probe USING fts5(content)"
                )
            except sqlite3.OperationalError as exc:
                self.assertIn("fts5", str(exc).lower())
                result = self.run_cli("init")
                self.assertEqual(result.returncode, 2)
                self.assertIn("SQLite FTS5 support is required", result.stderr)
            else:
                self.skipTest("SQLite FTS5 is available")
        finally:
            con.close()

    def test_reindex_preserves_id_and_creation_time(self) -> None:
        added = self.run_cli("add", "--title", "Stable episode")
        self.assertEqual(added.returncode, 0, added.stderr)

        before = self.run_cli("recent")
        self.assertEqual(before.returncode, 0, before.stderr)

        reindexed = self.run_cli("reindex")
        self.assertEqual(reindexed.returncode, 0, reindexed.stderr)

        after = self.run_cli("recent")
        self.assertEqual(after.returncode, 0, after.stderr)
        self.assertEqual(after.stdout, before.stdout)

    def test_relocated_project_keeps_existing_memory_id(self) -> None:
        original_root = self.project_root / "original"
        relocated_root = self.project_root / "relocated"
        original_root.mkdir()
        relocated_root.mkdir()

        added = self.run_cli_from(
            original_root,
            "add",
            "--title",
            "Portable episode",
        )
        self.assertEqual(added.returncode, 0, added.stderr)
        before = self.run_cli_from(original_root, "recent")
        self.assertEqual(before.returncode, 0, before.stderr)

        shutil.copytree(original_root / ".ai", relocated_root / ".ai")

        after = self.run_cli_from(relocated_root, "recent")
        self.assertEqual(after.returncode, 0, after.stderr)
        self.assertEqual(after.stdout.splitlines()[1], before.stdout.splitlines()[1])
        self.assertIn(".ai/memory/episodes/", after.stdout)
        self.assertNotIn(str(original_root), after.stdout)

        fetched = self.run_cli_from(relocated_root, "get", "1")
        self.assertEqual(fetched.returncode, 0, fetched.stderr)
        self.assertIn("Portable episode", fetched.stdout)

    def test_reindex_repairs_missing_fts_rows(self) -> None:
        added = self.run_cli(
            "add",
            "--title",
            "Repairable episode",
            "--outcome",
            "searchable repair marker",
        )
        self.assertEqual(added.returncode, 0, added.stderr)

        con = sqlite3.connect(self.project_root / ".ai/memory/memory.sqlite")
        try:
            con.execute("DELETE FROM memories_fts")
            con.commit()
        finally:
            con.close()

        before = self.run_cli("search", "repair marker")
        self.assertEqual(before.returncode, 0, before.stderr)
        self.assertEqual(before.stdout, "[Untrusted episodic memory]\n")

        reindexed = self.run_cli("reindex")
        self.assertEqual(reindexed.returncode, 0, reindexed.stderr)

        after = self.run_cli("search", "repair marker")
        self.assertEqual(after.returncode, 0, after.stderr)
        self.assertIn("Repairable episode", after.stdout)

    def test_verify_detects_missing_fts_rows(self) -> None:
        added = self.run_cli(
            "add",
            "--title",
            "Integrity episode",
            "--outcome",
            "integrity marker",
        )
        self.assertEqual(added.returncode, 0, added.stderr)

        con = sqlite3.connect(self.project_root / ".ai/memory/memory.sqlite")
        try:
            con.execute("DELETE FROM memories_fts")
            con.commit()
        finally:
            con.close()

        result = self.run_cli("verify")

        self.assertEqual(result.returncode, 2)
        self.assertNotIn("Traceback", result.stderr)
        self.assertIn("database error", result.stderr)

    def test_invalid_episode_encoding_reports_concise_error(self) -> None:
        added = self.run_cli("add", "--title", "Unreadable episode")
        self.assertEqual(added.returncode, 0, added.stderr)

        episode = next((self.project_root / ".ai/memory/episodes").glob("*.md"))
        episode.write_bytes(b"# Unreadable episode\n\xff")

        result = self.run_cli("search", "unreadable")
        self.assertEqual(result.returncode, 2)
        self.assertNotIn("Traceback", result.stderr)
        self.assertIn("episode file is not valid UTF-8", result.stderr)

    def test_corrupt_database_reports_concise_error(self) -> None:
        memory_dir = self.project_root / ".ai/memory"
        memory_dir.mkdir(parents=True)
        (memory_dir / "memory.sqlite").write_bytes(b"not a SQLite database")

        result = self.run_cli("init")
        self.assertEqual(result.returncode, 2)
        self.assertNotIn("Traceback", result.stderr)
        self.assertIn("database error", result.stderr)

    def test_result_limits_are_positive_and_bounded(self) -> None:
        for arguments in (
            ("search", "anything", "--limit", "0"),
            ("search", "anything", "--limit", "21"),
            ("recent", "--limit", "-1"),
        ):
            result = self.run_cli(*arguments)
            self.assertEqual(result.returncode, 2, result.stdout)
            self.assertIn("limit must be between 1 and 20", result.stderr)

    def test_add_rejects_multiline_or_oversized_metadata(self) -> None:
        for arguments, message in (
            (("--title", "bad\ntitle"), "must be a single line"),
            (("--title", "Valid title", "--feature", "x" * 513), "feature exceeds"),
        ):
            result = self.run_cli("add", *arguments)
            self.assertEqual(result.returncode, 2, result.stdout)
            self.assertIn(message, result.stderr)

    def test_add_generates_session_capsule_template(self) -> None:
        added = self.run_cli("add", "--title", "Session capsule")
        self.assertEqual(added.returncode, 0, added.stderr)

        episode = next((self.project_root / ".ai/memory/episodes").glob("*.md"))
        episode_text = episode.read_text(encoding="utf-8")
        for heading in (
            "## Context",
            "## Goal",
            "## Why",
            "## Outcome",
            "## Current State",
            "## Important Findings",
            "## Decisions",
            "## Failed Approaches",
            "## Validation",
            "## Open Questions",
            "## Next Steps",
            "## Relevant Files",
        ):
            self.assertIn(heading, episode_text)

    def test_add_uses_timestamped_episode_filename(self) -> None:
        added = self.run_cli("add", "--title", "Timestamped episode")
        self.assertEqual(added.returncode, 0, added.stderr)

        episode = next((self.project_root / ".ai/memory/episodes").glob("*.md"))
        self.assertRegex(episode.name, r"^\d{14}-timestamped-episode\.md$")

    def test_add_rejects_filename_that_exceeds_portable_limit(self) -> None:
        result = self.run_cli("add", "--title", "x" * 512)

        self.assertEqual(result.returncode, 2, result.stdout)
        self.assertIn("filename exceeds 240 characters", result.stderr)

    def test_search_rejects_oversized_query(self) -> None:
        result = self.run_cli("search", "x" * 513)

        self.assertEqual(result.returncode, 2, result.stdout)
        self.assertIn("search query exceeds 512 characters", result.stderr)

    def test_search_treats_punctuation_as_plain_text(self) -> None:
        added = self.run_cli("add", "--title", "Agent-memory hardening")
        self.assertEqual(added.returncode, 0, added.stderr)

        searched = self.run_cli("search", "agent-memory hardening")
        self.assertEqual(searched.returncode, 0, searched.stderr)
        self.assertIn("Agent-memory hardening", searched.stdout)

        invalid = self.run_cli("search", "...")
        self.assertEqual(invalid.returncode, 2, invalid.stdout)
        self.assertNotIn("Traceback", invalid.stderr)
        self.assertIn("search query must contain", invalid.stderr)

    def test_get_bounds_large_episode_output(self) -> None:
        added = self.run_cli(
            "add",
            "--title",
            "Large episode",
            "--outcome",
            "x" * 13_000,
        )
        self.assertEqual(added.returncode, 0, added.stderr)

        fetched = self.run_cli("get", "1")
        self.assertEqual(fetched.returncode, 0, fetched.stderr)
        self.assertLessEqual(len(fetched.stdout), 12_300)
        self.assertIn("truncated", fetched.stderr)


if __name__ == "__main__":
    unittest.main()
