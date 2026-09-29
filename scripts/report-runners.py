#!/usr/bin/env python3
"""Merge discovery matrix, job states and probe results into a report.

Env: MATRIX (json), JOBS (jobs.json path), PROBES (dir with probe-*.json),
     REPORT_MD, REPORT_JSON
"""
import glob
import json
import os

matrix = json.loads(os.environ["MATRIX"])["include"]
jobs = {j["label"]: j for j in json.load(open(os.environ.get("JOBS", "jobs.json"), encoding="utf-8"))}

probes = {}
for path in glob.glob(os.path.join(os.environ.get("PROBES", "probes"), "**", "*.json"), recursive=True):
    try:
        data = json.load(open(path, encoding="utf-8"))
        probes[data["label"]] = data
    except Exception:  # noqa: BLE001
        pass

rows = []
for entry in matrix:
    label = entry["label"]
    job = jobs.get(label, {})
    probe = probes.get(label)
    if probe:
        state = "available"
    elif job.get("status") != "completed":
        state = "unavailable (no runner picked up the job)"
    elif job.get("conclusion") == "cancelled":
        state = "cancelled"
    elif not job.get("runner_name"):
        state = "unavailable (job rejected)"
    else:
        state = f"failed ({job.get('conclusion')})"
    rows.append({**entry, "state": state, "job": job, "probe": probe})


def cell(v):
    return "-" if v in (None, "", []) else str(v).replace("|", "\\|")


available = [r for r in rows if r["probe"]]
unavailable = [r for r in rows if not r["probe"]]

md = ["# GitHub-hosted runner availability", ""]
md.append(f"Checked **{len(rows)}** labels: **{len(available)}** usable, **{len(unavailable)}** not usable.")
md.append("")
md.append("## Usable runners")
md.append("")
md.append("| Label | Status | OS | Arch | CPU | Cores | RAM (GB) | Disk total/free (GB) | Image version | KVM | GPU |")
md.append("|---|---|---|---|---|---|---|---|---|---|---|")
for r in available:
    p = r["probe"]
    md.append(
        "| `{}` | {} | {} | {} | {} | {} | {} | {}/{} | {} | {} | {} |".format(
            r["label"],
            cell(r["status"]),
            cell(p.get("os")),
            cell(p.get("runner_arch") or p.get("machine")),
            cell(p.get("cpu_model")),
            cell(p.get("cpu_count")),
            cell(p.get("memory_gb")),
            cell(p.get("disk_total_gb")),
            cell(p.get("disk_free_gb")),
            cell(p.get("image_version")),
            "yes" if p.get("kvm") else "no",
            cell(p.get("gpu")),
        )
    )
md.append("")
if unavailable:
    md.append("## Not usable")
    md.append("")
    md.append("| Label | Image | Status | Result |")
    md.append("|---|---|---|---|")
    for r in unavailable:
        md.append(f"| `{r['label']}` | {cell(r['image'])} | {cell(r['status'])} | {r['state']} |")
    md.append("")

md.append("## Preinstalled tools")
md.append("")
for r in available:
    tools = r["probe"].get("tools") or {}
    md.append(f"<details><summary><code>{r['label']}</code></summary>")
    md.append("")
    md.append("| Tool | Version |")
    md.append("|---|---|")
    for name, ver in sorted(tools.items()):
        md.append(f"| {name} | {cell(ver)} |")
    md.append("")
    md.append("</details>")
    md.append("")

usable_labels = [r["label"] for r in available]
md.append("## `runs-on` options you can use")
md.append("")
md.append("```yaml")
md.append("options:")
for label in usable_labels:
    md.append(f"  - {label}")
md.append("```")

with open(os.environ.get("REPORT_MD", "report.md"), "w", encoding="utf-8") as fh:
    fh.write("\n".join(md) + "\n")

with open(os.environ.get("REPORT_JSON", "report.json"), "w", encoding="utf-8") as fh:
    json.dump(
        [{k: v for k, v in r.items() if k != "job"} | {"job_url": r["job"].get("html_url")} for r in rows],
        fh,
        indent=2,
    )

print("\n".join(md))
