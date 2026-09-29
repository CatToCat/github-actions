#!/usr/bin/env python3
"""Build a probe matrix from the official actions/runner-images README.

Env inputs:
  LABELS             comma separated labels, overrides discovery when set
  INCLUDE_LARGER     "true" to keep -large / -xlarge labels (paid, org only)
  INCLUDE_DEPRECATED "true" to keep deprecated images
"""
import json
import os
import re
import sys
import urllib.request

README_URL = "https://raw.githubusercontent.com/actions/runner-images/main/README.md"

FALLBACK = [
    ("ubuntu-slim", "Ubuntu Slim", "x64", "ga"),
    ("ubuntu-latest", "Ubuntu 24.04", "x64", "ga"),
    ("ubuntu-26.04", "Ubuntu 26.04", "x64", "ga"),
    ("ubuntu-24.04", "Ubuntu 24.04", "x64", "ga"),
    ("ubuntu-22.04", "Ubuntu 22.04", "x64", "ga"),
    ("ubuntu-26.04-arm", "Ubuntu 26.04 Arm64", "arm64", "ga"),
    ("ubuntu-24.04-arm", "Ubuntu 24.04 Arm64", "arm64", "ga"),
    ("ubuntu-22.04-arm", "Ubuntu 22.04 Arm64", "arm64", "ga"),
    ("macos-latest", "macOS 26 Arm64", "arm64", "ga"),
    ("macos-26", "macOS 26 Arm64", "arm64", "ga"),
    ("macos-15", "macOS 15 Arm64", "arm64", "ga"),
    ("macos-26-intel", "macOS 26", "x64", "ga"),
    ("macos-15-intel", "macOS 15", "x64", "ga"),
    ("windows-latest", "Windows Server 2025", "x64", "ga"),
    ("windows-2025", "Windows Server 2025", "x64", "ga"),
    ("windows-2022", "Windows Server 2022", "x64", "ga"),
    ("windows-11-arm", "Windows 11 Arm64", "arm64", "ga"),
]


def truthy(name, default="false"):
    return os.environ.get(name, default).strip().lower() == "true"


def parse_readme(text):
    rows = []
    for line in text.splitlines():
        if not line.startswith("|") or "`" not in line:
            continue
        cells = [c.strip() for c in line.strip().strip("|").split("|")]
        if len(cells) < 3:
            continue
        image_cell, arch, label_cell = cells[0], cells[1], cells[2]
        labels = re.findall(r"`([^`]+)`", label_cell)
        if not labels or arch not in ("x64", "arm64"):
            continue
        lowered = image_cell.lower()
        if "deprecated" in lowered:
            status = "deprecated"
        elif "preview" in lowered or "beta" in lowered:
            status = "preview"
        else:
            status = "ga"
        name = image_cell.split("<br>")[0]
        name = re.sub(r"\[!\[[^\]]*\]\([^)]*\)\]\([^)]*\)", "", name).strip()
        for label in labels:
            rows.append((label, name, arch, status))
    return rows


def fetch_readme(retries=3):
    last = None
    for _ in range(retries):
        try:
            with urllib.request.urlopen(README_URL, timeout=30) as resp:
                return resp.read().decode("utf-8")
        except Exception as exc:  # noqa: BLE001
            last = exc
    raise last


def main():
    source = "readme"
    try:
        rows = parse_readme(fetch_readme())
        if not rows:
            raise ValueError("no rows parsed")
    except Exception as exc:  # noqa: BLE001
        print(f"::warning::README discovery failed ({exc}), using fallback list")
        rows, source = FALLBACK, "fallback"

    known = {r[0]: r for r in rows}

    manual = [l.strip() for l in os.environ.get("LABELS", "").split(",") if l.strip()]
    if manual:
        rows = [known.get(l, (l, "", "", "manual")) for l in manual]
        source = "manual"
    else:
        if not truthy("INCLUDE_LARGER"):
            rows = [r for r in rows if not re.search(r"-(x)?large$", r[0])]
        if not truthy("INCLUDE_DEPRECATED", "true"):
            rows = [r for r in rows if r[3] != "deprecated"]

    seen, include = set(), []
    for label, name, arch, status in rows:
        if label in seen:
            continue
        seen.add(label)
        include.append({"label": label, "image": name, "arch": arch, "status": status})

    matrix = json.dumps({"include": include}, separators=(",", ":"))
    print(f"source={source} count={len(include)}")
    print(json.dumps(include, indent=2))

    out = os.environ.get("GITHUB_OUTPUT")
    if out:
        with open(out, "a", encoding="utf-8") as fh:
            fh.write(f"matrix={matrix}\n")
            fh.write(f"source={source}\n")
    return 0


if __name__ == "__main__":
    sys.exit(main())
