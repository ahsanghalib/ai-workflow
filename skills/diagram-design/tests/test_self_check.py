import importlib.util
from pathlib import Path
import tempfile
import unittest

SCRIPT = Path(__file__).parents[1] / "scripts" / "self_check.py"
spec = importlib.util.spec_from_file_location("diagram_self_check", SCRIPT)
checker = importlib.util.module_from_spec(spec)
assert spec and spec.loader
spec.loader.exec_module(checker)


class RemoteReferenceTests(unittest.TestCase):
    def verify_source(self, source: str) -> list[str]:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "diagram.html"
            path.write_text(source, encoding="utf-8")
            return checker.verify(path)

    def test_rejects_meta_refresh_redirect(self) -> None:
        errors = self.verify_source(
            '<meta http-equiv="refresh" content="0;url=https://example.invalid/">'
        )
        self.assertTrue(any("refresh" in error for error in errors), errors)

    def test_rejects_remote_srcset_candidate_after_data_uri(self) -> None:
        errors = self.verify_source(
            '<img srcset="data:image/png;base64,AA== 1x, '
            'https://example.invalid/pixel 2x">'
        )
        self.assertTrue(any("srcset" in error for error in errors), errors)
