#!/usr/bin/env python3
"""Wait for probe jobs of the current run, then record their final state.

Jobs whose label is not available to this account stay "queued" forever,
so after QUEUE_TIMEOUT minutes any still-queued job is treated as unavailable.

Env: GITHUB_TOKEN, GITHUB_REPOSITORY, GITHUB_RUN_ID, GITHUB_RUN_ATTEMPT,
     QUEUE_TIMEOUT (minutes), JOB_PREFIX, OUTPUT (json path)
"""
import json
import os
import time
import urllib.request

API = os.environ.get("GITHUB_API_URL", "https://api.github.com")
REPO = os.environ["GITHUB_REPOSITORY"]
RUN_ID = os.environ["GITHUB_RUN_ID"]
ATTEMPT = os.environ.get("GITHUB_RUN_ATTEMPT", "1")
TOKEN = os.environ["GITHUB_TOKEN"]
PREFIX = os.environ.get("JOB_PREFIX", "probe ")
TIMEOUT = float(os.environ.get("QUEUE_TIMEOUT", "5")) * 60
OUTPUT = os.environ.get("OUTPUT", "jobs.json")


def list_jobs():
    jobs, page = [], 1
    while True:
        url = f"{API}/repos/{REPO}/actions/runs/{RUN_ID}/attempts/{ATTEMPT}/jobs?per_page=100&page={page}"
        req = urllib.request.Request(
            url,
            headers={
                "Authorization": f"Bearer {TOKEN}",
                "Accept": "application/vnd.github+json",
                "X-GitHub-Api-Version": "2022-11-28",
            },
        )
        with urllib.request.urlopen(req, timeout=30) as resp:
            data = json.load(resp)
        jobs += data.get("jobs", [])
        if len(jobs) >= data.get("total_count", 0) or not data.get("jobs"):
            return jobs
        page += 1


def main():
    start = time.time()
    while True:
        probes = [j for j in list_jobs() if j["name"].startswith(PREFIX)]
        queued = [j for j in probes if j["status"] in ("queued", "waiting", "pending", "requested")]
        running = [j for j in probes if j["status"] == "in_progress"]
        elapsed = time.time() - start
        print(
            f"[{int(elapsed)}s] total={len(probes)} queued={len(queued)} "
            f"running={len(running)} done={len(probes) - len(queued) - len(running)}"
        )
        if probes and not queued and not running:
            break
        if not running and elapsed > TIMEOUT:
            print(f"Queue timeout reached, {len(queued)} job(s) never got a runner")
            break
        time.sleep(20)

    result = []
    for j in probes:
        result.append(
            {
                "label": j["name"][len(PREFIX):].strip(),
                "status": j["status"],
                "conclusion": j.get("conclusion"),
                "runner_name": j.get("runner_name"),
                "labels": j.get("labels"),
                "started_at": j.get("started_at"),
                "html_url": j.get("html_url"),
            }
        )
    with open(OUTPUT, "w", encoding="utf-8") as fh:
        json.dump(result, fh, indent=2)
    pending = sum(1 for r in result if r["status"] != "completed")
    gh_out = os.environ.get("GITHUB_OUTPUT")
    if gh_out:
        with open(gh_out, "a", encoding="utf-8") as fh:
            fh.write(f"pending={pending}\n")


if __name__ == "__main__":
    main()
