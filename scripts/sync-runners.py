#!/usr/bin/env python3
"""Save usable runners from a check-runners report.

Usage: sync-runners.py --report report.json [--out runners/runners.json]

web_terminal_labels lists the runners Web Terminal accepts
(Linux / macOS full VMs; ubuntu-slim is a container with a 15 minute limit).
"""
import argparse
import json
import os
from datetime import datetime, timezone

SHELL_OS = ("Linux", "macOS")


def load_usable(report_path):
    rows = json.load(open(report_path, encoding="utf-8"))
    usable = []
    for r in rows:
        p = r.get("probe")
        if not p:
            continue
        usable.append(
            {
                "label": r["label"],
                "image": r.get("image"),
                "status": r.get("status"),
                "os": p.get("os"),
                "runner_os": p.get("runner_os"),
                "arch": p.get("runner_arch") or p.get("machine"),
                "cpu_model": p.get("cpu_model"),
                "cpu_count": p.get("cpu_count"),
                "memory_gb": p.get("memory_gb"),
                "disk_total_gb": p.get("disk_total_gb"),
                "disk_free_gb": p.get("disk_free_gb"),
                "image_version": p.get("image_version"),
                "kvm": p.get("kvm"),
                "gpu": p.get("gpu"),
                "in_container": p.get("in_container"),
                "tools": p.get("tools") or {},
            }
        )
    return usable


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--report", required=True)
    parser.add_argument("--out", default="runners/runners.json")
    args = parser.parse_args()

    usable = load_usable(args.report)
    if not usable:
        raise SystemExit("No usable runners in report, refusing to overwrite")

    run_url = None
    if os.environ.get("GITHUB_RUN_ID"):
        run_url = "{}/{}/actions/runs/{}".format(
            os.environ.get("GITHUB_SERVER_URL", "https://github.com"),
            os.environ.get("GITHUB_REPOSITORY"),
            os.environ["GITHUB_RUN_ID"],
        )

    data = {
        "updated_at": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "source_run": run_url,
        "web_terminal_labels": [
            r["label"] for r in usable if r["runner_os"] in SHELL_OS and not r["in_container"]
        ],
        "runners": usable,
    }
    os.makedirs(os.path.dirname(args.out) or ".", exist_ok=True)
    with open(args.out, "w", encoding="utf-8", newline="\n") as fh:
        json.dump(data, fh, indent=2, ensure_ascii=False)
        fh.write("\n")
    print(f"Saved {len(usable)} usable runners to {args.out}")
    print("Web Terminal labels: " + ", ".join(data["web_terminal_labels"]))


if __name__ == "__main__":
    main()
