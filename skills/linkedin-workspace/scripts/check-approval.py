#!/usr/bin/env python3
"""Check local LinkedIn content approval evidence before a proposed action.

This is an offline consistency check, not an authorization system. Input JSON
can be forged; callers must obtain approval through a trusted workflow and
must independently authorize any external action.
"""

import hashlib
import json
import sys


def _unique_object(pairs):
    result = {}
    for key, value in pairs:
        if key in result:
            raise ValueError(f"duplicate JSON key: {key}")
        result[key] = value
    return result


def check(data):
    reasons = []
    if not isinstance(data, dict):
        return ["input must be a JSON object"]

    content = data.get("content")
    approval = data.get("approval")
    assets = data.get("visual_assets")
    if not isinstance(content, dict):
        return ["content must be an object"]
    if not isinstance(approval, dict):
        reasons.append("approval evidence is required")
    if not isinstance(assets, list):
        reasons.append("visual_assets must be an array")
        assets = []

    content_id = content.get("Content ID")
    revision = content.get("Revision")
    digest = content.get("Content Hash")
    body = content.get("Final Post Text")
    if not isinstance(content_id, str) or not content_id:
        reasons.append("content Content ID must be a non-empty string")
    if type(revision) is not int or revision < 1:
        reasons.append("content Revision must be a positive integer")
    if not isinstance(body, str):
        reasons.append("Final Post Text must be a string")
    if not isinstance(digest, str) or len(digest) != 64 or any(
        char not in "0123456789abcdef" for char in digest
    ):
        reasons.append("Content Hash must be a lowercase SHA-256 hex digest")
    elif isinstance(body, str):
        actual = hashlib.sha256(body.encode("utf-8")).hexdigest()
        if digest != actual:
            reasons.append("Content Hash does not match exact Final Post Text")

    if content.get("Approval") != "approved":
        reasons.append("content Approval must be approved")

    if isinstance(approval, dict):
        if approval.get("approved") is not True:
            reasons.append("approval evidence must explicitly set approved=true")
        if approval.get("Content ID") != content_id:
            reasons.append("approval Content ID does not match content")
        if type(approval.get("Revision")) is not int or approval.get("Revision") != revision:
            reasons.append("approval Revision does not match content")
        if approval.get("Content Hash") != digest:
            reasons.append("approval Content Hash does not match content")

    visual_status = content.get("Visual Status")
    visual_type = content.get("Visual Type")
    if visual_status == "not_needed":
        if visual_type != "none":
            reasons.append("Visual Type must be none when Visual Status is not_needed")
    elif visual_status != "ready":
        reasons.append("a required visual must have Visual Status ready")
    elif not isinstance(visual_type, str) or visual_type not in {"image", "document"}:
        reasons.append("ready visual must have Visual Type image or document")
    else:
        matching = [
            asset for asset in assets
            if isinstance(asset, dict)
            and asset.get("Content ID") == content_id
            and asset.get("Type") == visual_type
            and asset.get("Source Hash") == digest
            and asset.get("QA Status") == "verified"
            and asset.get("Approved") == "yes"
        ]
        if not matching:
            reasons.append("no approved, verified visual asset matches content ID, type, and hash")

    return reasons


def main():
    try:
        data = json.load(sys.stdin, object_pairs_hook=_unique_object)
        reasons = check(data)
    except (json.JSONDecodeError, UnicodeDecodeError, ValueError) as error:
        reasons = [f"invalid JSON input: {error}"]

    decision = "denied" if reasons else "allowed"
    print(json.dumps({"decision": decision, "reasons": reasons}, separators=(",", ":")))
    return 1 if reasons else 0


if __name__ == "__main__":
    raise SystemExit(main())
