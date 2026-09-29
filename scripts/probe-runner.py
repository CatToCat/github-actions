#!/usr/bin/env python3
"""Collect hardware / image details of the current runner into a JSON file.

Usage: probe-runner.py <label> <output.json>
"""
import json
import os
import platform
import shutil
import subprocess
import sys

TOOLS = {
    "git": ["git", "--version"],
    "docker": ["docker", "--version"],
    "node": ["node", "--version"],
    "python": [sys.executable, "--version"],
    "java": ["java", "-version"],
    "go": ["go", "version"],
    "gcc": ["gcc", "--version"],
    "clang": ["clang", "--version"],
    "dotnet": ["dotnet", "--version"],
    "rustc": ["rustc", "--version"],
    "pwsh": ["pwsh", "--version"],
    "brew": ["brew", "--version"],
    "xcodebuild": ["xcodebuild", "-version"],
}


def run(cmd, timeout=20):
    try:
        exe = shutil.which(cmd[0]) or cmd[0]
        res = subprocess.run([exe] + cmd[1:], capture_output=True, text=True, timeout=timeout)
        out = (res.stdout or res.stderr).strip()
        return out.splitlines()[0].strip() if out else None
    except Exception:  # noqa: BLE001
        return None


def cpu_model():
    system = platform.system()
    if system == "Linux":
        try:
            with open("/proc/cpuinfo", encoding="utf-8") as fh:
                for line in fh:
                    if line.lower().startswith(("model name", "hardware", "processor\t: arm")):
                        return line.split(":", 1)[1].strip()
        except OSError:
            pass
        out = run(["lscpu"])
        return out
    if system == "Darwin":
        return run(["sysctl", "-n", "machdep.cpu.brand_string"])
    if system == "Windows":
        try:
            import winreg

            key = winreg.OpenKey(
                winreg.HKEY_LOCAL_MACHINE, r"HARDWARE\DESCRIPTION\System\CentralProcessor\0"
            )
            return winreg.QueryValueEx(key, "ProcessorNameString")[0].strip()
        except Exception:  # noqa: BLE001
            return platform.processor()
    return platform.processor()


def memory_gb():
    system = platform.system()
    try:
        if system == "Linux":
            limit = None
            for path in ("/sys/fs/cgroup/memory.max", "/sys/fs/cgroup/memory/memory.limit_in_bytes"):
                if os.path.exists(path):
                    raw = open(path, encoding="utf-8").read().strip()
                    if raw.isdigit() and int(raw) < 1 << 50:
                        limit = int(raw)
            with open("/proc/meminfo", encoding="utf-8") as fh:
                for line in fh:
                    if line.startswith("MemTotal"):
                        total = int(line.split()[1]) * 1024
                        return round(min(total, limit or total) / 1024**3, 1)
        if system == "Darwin":
            return round(int(run(["sysctl", "-n", "hw.memsize"])) / 1024**3, 1)
        if system == "Windows":
            import ctypes

            class MemStatus(ctypes.Structure):
                _fields_ = [
                    ("dwLength", ctypes.c_ulong),
                    ("dwMemoryLoad", ctypes.c_ulong),
                    ("ullTotalPhys", ctypes.c_ulonglong),
                    ("ullAvailPhys", ctypes.c_ulonglong),
                    ("ullTotalPageFile", ctypes.c_ulonglong),
                    ("ullAvailPageFile", ctypes.c_ulonglong),
                    ("ullTotalVirtual", ctypes.c_ulonglong),
                    ("ullAvailVirtual", ctypes.c_ulonglong),
                    ("ullAvailExtendedVirtual", ctypes.c_ulonglong),
                ]

            stat = MemStatus()
            stat.dwLength = ctypes.sizeof(MemStatus)
            ctypes.windll.kernel32.GlobalMemoryStatusEx(ctypes.byref(stat))
            return round(stat.ullTotalPhys / 1024**3, 1)
    except Exception:  # noqa: BLE001
        pass
    return None


def os_name():
    system = platform.system()
    if system == "Linux":
        try:
            info = {}
            with open("/etc/os-release", encoding="utf-8") as fh:
                for line in fh:
                    if "=" in line:
                        k, v = line.rstrip().split("=", 1)
                        info[k] = v.strip('"')
            return info.get("PRETTY_NAME")
        except OSError:
            pass
    if system == "Darwin":
        return f"macOS {platform.mac_ver()[0]}"
    if system == "Windows":
        return f"Windows {platform.release()} ({platform.version()})"
    return platform.platform()


def gpu():
    return run(["nvidia-smi", "--query-gpu=name,memory.total", "--format=csv,noheader"])


def main():
    label, output = sys.argv[1], sys.argv[2]
    work = os.environ.get("GITHUB_WORKSPACE") or os.getcwd()
    disk = shutil.disk_usage(work)
    data = {
        "label": label,
        "ok": True,
        "os": os_name(),
        "runner_os": os.environ.get("RUNNER_OS"),
        "runner_arch": os.environ.get("RUNNER_ARCH"),
        "machine": platform.machine(),
        "kernel": platform.release(),
        "image_os": os.environ.get("ImageOS"),
        "image_version": os.environ.get("ImageVersion"),
        "runner_name": os.environ.get("RUNNER_NAME"),
        "runner_environment": os.environ.get("RUNNER_ENVIRONMENT"),
        "cpu_model": cpu_model(),
        "cpu_count": os.cpu_count(),
        "memory_gb": memory_gb(),
        "disk_total_gb": round(disk.total / 1024**3, 1),
        "disk_free_gb": round(disk.free / 1024**3, 1),
        "gpu": gpu(),
        "kvm": os.path.exists("/dev/kvm"),
        "sudo": bool(shutil.which("sudo")) and platform.system() != "Windows",
        "in_container": os.path.exists("/.dockerenv") or os.path.exists("/run/.containerenv"),
        "tools": {name: run(cmd) for name, cmd in TOOLS.items() if shutil.which(cmd[0]) or cmd[0] == sys.executable},
    }
    with open(output, "w", encoding="utf-8") as fh:
        json.dump(data, fh, indent=2)
    print(json.dumps(data, indent=2))


if __name__ == "__main__":
    main()
