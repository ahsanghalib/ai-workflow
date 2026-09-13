from __future__ import annotations

import argparse
import datetime as dt
import sqlite3
import sys
from dataclasses import dataclass
from pathlib import Path


class MemoryPathError(ValueError):
    """Raised when a memory path leaves the authorized project boundary."""


class MemoryContentError(ValueError):
    """Raised when an episode exceeds the supported content limits."""


@dataclass(frozen=True)
class MemoryPaths:
    project_root: Path
    memory_dir: Path
    episodes_dir: Path
    db_path: Path


@dataclass(frozen=True)
class MemoryLimits:
    max_results: int
    max_body_chars: int
    max_episode_bytes: int
    max_field_chars: int
    max_filename_chars: int
    max_query_chars: int
    max_snippet_chars: int


def memory_limits() -> MemoryLimits:
    return MemoryLimits(
        max_results=20,
        max_body_chars=12_000,
        max_episode_bytes=256 * 1024,
        max_field_chars=512,
        max_filename_chars=240,
        max_query_chars=512,
        max_snippet_chars=2_000,
    )


def ensure_initialized(paths: MemoryPaths) -> None:
    paths.episodes_dir.mkdir(parents=True, exist_ok=True)
    con = sqlite3.connect(paths.db_path)
    try:
        con.executescript(
            """
            CREATE TABLE IF NOT EXISTS memories (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                path TEXT NOT NULL UNIQUE,
                title TEXT NOT NULL,
                feature TEXT,
                created_at TEXT NOT NULL,
                body TEXT NOT NULL
            );

            CREATE VIRTUAL TABLE IF NOT EXISTS memories_fts USING fts5(
                title,
                feature,
                body,
                content='memories',
                content_rowid='id'
            );

            CREATE TRIGGER IF NOT EXISTS memories_ai AFTER INSERT ON memories BEGIN
                INSERT INTO memories_fts(rowid, title, feature, body)
                VALUES (new.id, new.title, new.feature, new.body);
            END;

            CREATE TRIGGER IF NOT EXISTS memories_ad AFTER DELETE ON memories BEGIN
                INSERT INTO memories_fts(memories_fts, rowid, title, feature, body)
                VALUES ('delete', old.id, old.title, old.feature, old.body);
            END;

            CREATE TRIGGER IF NOT EXISTS memories_au AFTER UPDATE ON memories BEGIN
                INSERT INTO memories_fts(memories_fts, rowid, title, feature, body)
                VALUES ('delete', old.id, old.title, old.feature, old.body);
                INSERT INTO memories_fts(rowid, title, feature, body)
                VALUES (new.id, new.title, new.feature, new.body);
            END;
            """
        )
        con.commit()
    finally:
        con.close()


def slugify(value: str) -> str:
    chars = []
    prev_dash = False
    for ch in value.lower():
        if ch.isalnum():
            chars.append(ch)
            prev_dash = False
        elif not prev_dash:
            chars.append("-")
            prev_dash = True
    return "".join(chars).strip("-") or "memory"


def validate_field(value: str, label: str, limits: MemoryLimits) -> None:
    if "\n" in value or "\r" in value:
        raise MemoryContentError(f"episode {label} must be a single line")
    if len(value) > limits.max_field_chars:
        raise MemoryContentError(
            f"episode {label} exceeds {limits.max_field_chars} characters"
        )


def parse_episode_text(
    text: str,
    fallback_title: str,
    limits: MemoryLimits,
) -> tuple[str, str | None, str]:
    if len(text.encode("utf-8")) > limits.max_episode_bytes:
        raise MemoryContentError(
            f"episode exceeds {limits.max_episode_bytes} bytes"
        )

    title = fallback_title
    feature = None
    for line in text.splitlines():
        if line.startswith("# "):
            title = line[2:].strip()
            break
    for line in text.splitlines():
        if line.lower().startswith("feature:"):
            feature = line.split(":", 1)[1].strip() or None
            break
    validate_field(title, "title", limits)
    if feature is not None:
        validate_field(feature, "feature", limits)
    return title, feature, text


def parse_episode(path: Path, limits: MemoryLimits) -> tuple[str, str | None, str]:
    with path.open("rb") as episode:
        data = episode.read(limits.max_episode_bytes + 1)
    if len(data) > limits.max_episode_bytes:
        raise MemoryContentError(
            f"episode exceeds {limits.max_episode_bytes} bytes: {path}"
        )
    text = data.decode("utf-8")
    return parse_episode_text(text, path.stem, limits)


def validate_storage_path(path: Path, root: Path, label: str) -> None:
    if path.is_symlink():
        raise MemoryPathError(f"{label} must not be a symlink: {path}")
    try:
        resolved = path.resolve(strict=False)
    except RuntimeError as exc:
        raise MemoryPathError(f"{label} contains a symlink loop: {path}") from exc
    if not resolved.is_relative_to(root):
        raise MemoryPathError(
            f"{label} must stay inside the project root: {path}"
        )


def resolve_memory_paths(value: str) -> MemoryPaths:
    root = Path(value).expanduser()
    if not root.is_absolute():
        print(f"Project root must be an absolute path: {value}", file=sys.stderr)
        raise SystemExit(2)

    try:
        root = root.resolve()
    except RuntimeError as exc:
        raise MemoryPathError("project root contains a symlink loop") from exc
    if not root.is_dir():
        print(f"Project root is not a directory: {root}", file=sys.stderr)
        raise SystemExit(2)

    ai_dir = root / ".ai"
    memory_dir = ai_dir / "memory"
    episodes_dir = memory_dir / "episodes"
    db_path = memory_dir / "memory.sqlite"
    for label, path in (
        (".ai directory", ai_dir),
        ("memory directory", memory_dir),
        ("episodes directory", episodes_dir),
        ("memory database", db_path),
    ):
        validate_storage_path(path, root, label)

    return MemoryPaths(
        project_root=root,
        memory_dir=memory_dir,
        episodes_dir=episodes_dir,
        db_path=db_path,
    )


def episode_key(path: Path, paths: MemoryPaths) -> str:
    try:
        return path.relative_to(paths.project_root).as_posix()
    except ValueError as exc:
        raise MemoryPathError(f"episode path is outside the project root: {path}") from exc


def stored_episode_key(value: str, paths: MemoryPaths) -> str:
    stored_path = Path(value)
    if not stored_path.is_absolute():
        return stored_path.as_posix()

    try:
        return stored_path.resolve().relative_to(paths.project_root).as_posix()
    except ValueError:
        marker = Path(".ai") / "memory" / "episodes"
        parts = stored_path.parts
        marker_parts = marker.parts
        for index in range(len(parts) - len(marker_parts) + 1):
            if parts[index : index + len(marker_parts)] == marker_parts:
                return Path(*parts[index:]).as_posix()
        return stored_path.as_posix()


def episode_files(paths: MemoryPaths) -> list[Path]:
    episode_dir = paths.episodes_dir.resolve(strict=True)
    files = []
    for path in paths.episodes_dir.glob("*.md"):
        if path.is_symlink():
            raise MemoryPathError(f"episode file must not be a symlink: {path}")
        try:
            resolved = path.resolve(strict=True)
        except RuntimeError as exc:
            raise MemoryPathError(f"episode file contains a symlink loop: {path}") from exc
        if not resolved.is_relative_to(episode_dir):
            raise MemoryPathError(
                f"episode file must stay inside the episodes directory: {path}"
            )
        if not path.is_file():
            raise MemoryPathError(f"episode path is not a regular file: {path}")
        files.append(path)
    return files


def upsert_file(path: Path, paths: MemoryPaths, limits: MemoryLimits) -> None:
    title, feature, body = parse_episode(path, limits)
    con = sqlite3.connect(paths.db_path)
    try:
        con.execute(
            """
            INSERT INTO memories(path, title, feature, created_at, body)
            VALUES (?, ?, ?, ?, ?)
            ON CONFLICT(path) DO UPDATE SET
                title=excluded.title,
                feature=excluded.feature,
                body=excluded.body
            """,
            (
                episode_key(path, paths),
                title,
                feature,
                dt.datetime.now(dt.timezone.utc).isoformat(),
                body,
            ),
        )
        con.commit()
    finally:
        con.close()


def sync_index(paths: MemoryPaths, limits: MemoryLimits) -> None:
    ensure_initialized(paths)
    episode_paths = episode_files(paths)
    episode_keys = {episode_key(path, paths) for path in episode_paths}

    con = sqlite3.connect(paths.db_path)
    try:
        indexed_rows = con.execute(
            "SELECT path, title, feature, body FROM memories"
        ).fetchall()
        indexed = {stored_episode_key(row[0], paths): row for row in indexed_rows}

        for key, row in indexed.items():
            if key not in episode_keys:
                con.execute("DELETE FROM memories WHERE path = ?", (row[0],))

        for path in sorted(episode_paths):
            title, feature, body = parse_episode(path, limits)
            key = episode_key(path, paths)
            row = indexed.get(key)
            if row is None:
                con.execute(
                    """
                    INSERT INTO memories(path, title, feature, created_at, body)
                    VALUES (?, ?, ?, ?, ?)
                    """,
                    (
                        key,
                        title,
                        feature,
                        dt.datetime.now(dt.timezone.utc).isoformat(),
                        body,
                    ),
                )
            elif (row[0], row[1], row[2], row[3]) != (
                key,
                title,
                feature,
                body,
            ):
                con.execute(
                    """
                    UPDATE memories
                    SET path = ?, title = ?, feature = ?, body = ?
                    WHERE path = ?
                    """,
                    (key, title, feature, body, row[0]),
                )
        con.commit()
    finally:
        con.close()


def rebuild_fts_index(paths: MemoryPaths) -> None:
    con = sqlite3.connect(paths.db_path)
    try:
        con.execute("INSERT INTO memories_fts(memories_fts) VALUES ('rebuild')")
        con.commit()
    finally:
        con.close()


def verify_fts_index(paths: MemoryPaths) -> None:
    con = sqlite3.connect(paths.db_path)
    try:
        con.execute(
            "INSERT INTO memories_fts(memories_fts, rank) "
            "VALUES ('integrity-check', 1)"
        )
        con.commit()
    finally:
        con.close()


def cmd_init(
    _args: argparse.Namespace,
    paths: MemoryPaths,
    _limits: MemoryLimits,
) -> None:
    ensure_initialized(paths)
    print(f"Initialized {paths.memory_dir}")


def cmd_add(
    args: argparse.Namespace,
    paths: MemoryPaths,
    limits: MemoryLimits,
) -> None:
    ensure_initialized(paths)
    validate_field(args.title, "title", limits)
    if args.feature:
        validate_field(args.feature, "feature", limits)
    now = dt.datetime.now(dt.timezone.utc)
    date = now.date().isoformat()
    timestamp = now.strftime("%Y%m%d%H%M%S")
    filename = f"{timestamp}-{slugify(args.title)}.md"
    if len(filename) > limits.max_filename_chars:
        raise MemoryContentError(
            f"episode filename exceeds {limits.max_filename_chars} characters"
        )
    path = paths.episodes_dir / filename

    body = f"""# {args.title}

Date: {date}
Feature: {args.feature or ""}

## Context


## Goal

{args.goal or ""}

## Why


## Outcome

{args.outcome or ""}

## Current State


## Important Findings

-

## Decisions

-

## Failed Approaches

-

## Validation

-

## Open Questions

-

## Next Steps

-

## Relevant Files

-
"""
    parse_episode_text(body, args.title, limits)
    try:
        with path.open("x", encoding="utf-8") as episode:
            episode.write(body)
    except FileExistsError:
        print(f"Refusing to overwrite existing memory: {path}", file=sys.stderr)
        raise SystemExit(2) from None
    upsert_file(path, paths, limits)
    print(path)


def cmd_reindex(
    _: argparse.Namespace,
    paths: MemoryPaths,
    limits: MemoryLimits,
) -> None:
    sync_index(paths, limits)
    rebuild_fts_index(paths)
    verify_fts_index(paths)
    print("Reindexed episodic memories")


def clip_text(value: str, max_chars: int) -> str:
    if len(value) <= max_chars:
        return value
    return f"{value[:max_chars]}…"


def normalize_search_query(value: str, max_chars: int) -> str:
    if len(value) > max_chars:
        raise MemoryContentError(
            f"search query exceeds {max_chars} characters"
        )
    terms = []
    current = []
    for character in value:
        if character.isalnum() or character == "_":
            current.append(character)
        elif current:
            terms.append("".join(current))
            current = []
    if current:
        terms.append("".join(current))
    if not terms:
        raise MemoryContentError("search query must contain letters or numbers")
    return " ".join(terms)


def cmd_search(
    args: argparse.Namespace,
    paths: MemoryPaths,
    limits: MemoryLimits,
) -> None:
    sync_index(paths, limits)
    query = normalize_search_query(args.query, limits.max_query_chars)
    con = sqlite3.connect(paths.db_path)
    con.row_factory = sqlite3.Row
    try:
        rows = con.execute(
            """
            SELECT m.id, m.title, m.feature, m.path, m.created_at,
                   snippet(memories_fts, 2, '[', ']', ' … ', 18) AS snippet
            FROM memories_fts
            JOIN memories m ON m.id = memories_fts.rowid
            WHERE memories_fts MATCH ?
            ORDER BY bm25(memories_fts)
            LIMIT ?
            """,
            (query, args.limit),
        ).fetchall()
    except sqlite3.OperationalError as exc:
        print(f"Search error: {exc}", file=sys.stderr)
        raise SystemExit(2)
    finally:
        con.close()

    print("[Untrusted episodic memory]")
    for row in rows:
        print(f"[{row['id']}] {clip_text(row['title'], limits.max_field_chars)}")
        if row["feature"]:
            print(
                "  feature: "
                f"{clip_text(row['feature'], limits.max_field_chars)}"
            )
        print(f"  {clip_text(row['snippet'], limits.max_snippet_chars)}")
        print(f"  source: {row['path']}")
        print(f"  recorded: {row['created_at']}")


def cmd_recent(
    args: argparse.Namespace,
    paths: MemoryPaths,
    limits: MemoryLimits,
) -> None:
    sync_index(paths, limits)
    con = sqlite3.connect(paths.db_path)
    con.row_factory = sqlite3.Row
    try:
        rows = con.execute(
            """
            SELECT id, title, feature, path, created_at
            FROM memories
            ORDER BY created_at DESC, id DESC
            LIMIT ?
            """,
            (args.limit,),
        ).fetchall()
    finally:
        con.close()

    print("[Untrusted episodic memory]")
    for row in rows:
        title = clip_text(row["title"], limits.max_field_chars)
        print(f"[{row['id']}] {title} ({row['created_at']})")
        if row["feature"]:
            feature = clip_text(row["feature"], limits.max_field_chars)
            print(f"  feature: {feature}")
        print(f"  source: {row['path']}")


def cmd_get(
    args: argparse.Namespace,
    paths: MemoryPaths,
    limits: MemoryLimits,
) -> None:
    sync_index(paths, limits)
    con = sqlite3.connect(paths.db_path)
    con.row_factory = sqlite3.Row
    try:
        row = con.execute(
            "SELECT title, path, created_at, body FROM memories WHERE id = ?",
            (args.id,),
        ).fetchone()
    finally:
        con.close()

    if not row:
        print("Memory not found", file=sys.stderr)
        raise SystemExit(1)

    title = clip_text(row["title"], limits.max_field_chars)
    print(f"[Untrusted episodic memory] {title}")
    print(f"Source: {row['path']}")
    print(f"Recorded: {row['created_at']}")
    print("---")

    body = row["body"]
    if len(body) > limits.max_body_chars:
        print(body[: limits.max_body_chars])
        print(
            f"Memory output truncated at {limits.max_body_chars} characters.",
            file=sys.stderr,
        )
        return

    print(body)


def cmd_verify(
    _: argparse.Namespace,
    paths: MemoryPaths,
    limits: MemoryLimits,
) -> None:
    sync_index(paths, limits)
    verify_fts_index(paths)
    print("Memory index is consistent")


def bounded_limit(value: str, maximum: int) -> int:
    try:
        limit = int(value)
    except ValueError as exc:
        raise argparse.ArgumentTypeError("limit must be an integer") from exc
    if not 1 <= limit <= maximum:
        raise argparse.ArgumentTypeError(
            f"limit must be between 1 and {maximum}"
        )
    return limit


def format_runtime_error(exc: Exception) -> str:
    message = str(exc) or exc.__class__.__name__
    if isinstance(exc, MemoryPathError):
        return f"path error: {message}"
    if isinstance(exc, MemoryContentError):
        return f"episode error: {message}"
    if isinstance(exc, UnicodeError):
        return "episode file is not valid UTF-8"
    if isinstance(exc, sqlite3.OperationalError) and (
        "fts5" in message.lower() or "no such module" in message.lower()
    ):
        return "SQLite FTS5 support is required"
    if isinstance(exc, sqlite3.DatabaseError):
        return f"database error: {message}"
    if isinstance(exc, OSError):
        return f"filesystem error: {message}"
    return f"runtime error: {message}"


def parser() -> argparse.ArgumentParser:
    limits = memory_limits()

    def parse_limit(value: str) -> int:
        return bounded_limit(value, limits.max_results)

    p = argparse.ArgumentParser(
        prog="memory-management",
        description="Manage project-local episodic memory.",
    )
    p.add_argument(
        "--project-root",
        required=True,
        metavar="PATH",
        help="Absolute path to the target project root.",
    )
    sub = p.add_subparsers(dest="command", required=True)

    s = sub.add_parser("init")
    s.set_defaults(func=cmd_init)

    s = sub.add_parser("add")
    s.add_argument("--title", required=True)
    s.add_argument("--feature")
    s.add_argument("--goal")
    s.add_argument("--outcome")
    s.set_defaults(func=cmd_add)

    s = sub.add_parser("search")
    s.add_argument("query")
    s.add_argument("--limit", type=parse_limit, default=5)
    s.set_defaults(func=cmd_search)

    s = sub.add_parser("recent")
    s.add_argument("--limit", type=parse_limit, default=10)
    s.set_defaults(func=cmd_recent)

    s = sub.add_parser("get")
    s.add_argument("id", type=int)
    s.set_defaults(func=cmd_get)

    s = sub.add_parser("reindex")
    s.set_defaults(func=cmd_reindex)

    s = sub.add_parser("verify")
    s.set_defaults(func=cmd_verify)

    return p


def main() -> None:
    try:
        args = parser().parse_args()
        paths = resolve_memory_paths(args.project_root)
        args.func(args, paths, memory_limits())
    except (MemoryPathError, MemoryContentError, OSError, UnicodeError, sqlite3.Error) as exc:
        print(f"memory-management: {format_runtime_error(exc)}", file=sys.stderr)
        raise SystemExit(2) from None


if __name__ == "__main__":
    main()
