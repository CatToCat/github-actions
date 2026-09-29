# GitHub-hosted runner availability

Checked **20** labels: **20** usable, **0** not usable.

## Usable runners

| Label | Status | OS | Arch | CPU | Cores | RAM (GB) | Disk total/free (GB) | Image version | KVM | GPU |
|---|---|---|---|---|---|---|---|---|---|---|
| `ubuntu-26.04` | ga | Ubuntu 26.04.1 LTS | X64 | AMD EPYC 7763 64-Core Processor | 4 | 15.6 | 144.3/91.4 | 20260920.143.1 | yes | - |
| `ubuntu-26.04-arm` | ga | Ubuntu 26.04.1 LTS | ARM64 | Architecture:                            aarch64 | 4 | 15.6 | 144.3/111.3 | 20260920.129.1 | no | - |
| `ubuntu-latest` | ga | Ubuntu 24.04.5 LTS | X64 | AMD EPYC 7763 64-Core Processor | 4 | 15.6 | 144.3/86.0 | 20260920.314.1 | yes | - |
| `ubuntu-24.04` | ga | Ubuntu 24.04.5 LTS | X64 | AMD EPYC 9V45 96-Core Processor | 4 | 15.6 | 144.3/86.0 | 20260920.314.1 | yes | - |
| `ubuntu-24.04-arm` | ga | Ubuntu 24.04.5 LTS | ARM64 | Architecture:                            aarch64 | 4 | 15.6 | 144.3/107.8 | 20260920.129.1 | no | - |
| `ubuntu-22.04` | ga | Ubuntu 22.04.5 LTS | X64 | AMD EPYC 7763 64-Core Processor | 4 | 15.6 | 145.2/86.2 | 20260920.303.1 | yes | - |
| `ubuntu-22.04-arm` | ga | Ubuntu 22.04.5 LTS | ARM64 | Architecture:                            aarch64 | 4 | 15.6 | 145.2/110.5 | 20260920.137.1 | no | - |
| `ubuntu-slim` | ga | Ubuntu 24.04.5 LTS | X64 | AMD EPYC 7763 64-Core Processor | 1 | 4.8 | 49.2/46.6 | - | no | - |
| `xcode-27` | preview | macOS 27.0 | ARM64 | Apple M1 (Virtual) | 3 | 7.0 | 144.5/38.4 | 20260921.0210.1 | no | - |
| `macos-26-intel` | ga | macOS 26.6.1 | X64 | Intel(R) Core(TM) i7-8700B CPU @ 3.20GHz | 4 | 14.0 | 324.7/136.8 | 20260824.0517.1 | no | - |
| `macos-latest` | ga | macOS 26.6.2 | ARM64 | Apple M1 (Virtual) | 3 | 7.0 | 319.5/95.6 | 20260907.0351.1 | no | - |
| `macos-26` | ga | macOS 26.6.2 | ARM64 | Apple M1 (Virtual) | 3 | 7.0 | 319.5/95.5 | 20260907.0351.1 | no | - |
| `macos-15-intel` | ga | macOS 15.7.9 | X64 | Intel(R) Core(TM) i7-8700B CPU @ 3.20GHz | 4 | 14.0 | 324.7/108.0 | 20260824.0482.1 | no | - |
| `macos-15` | ga | macOS 15.7.9 | ARM64 | Apple M1 (Virtual) | 3 | 7.0 | 319.5/42.8 | 20260907.0337.1 | no | - |
| `windows-latest` | ga | Windows 2025Server (10.0.26100) | X64 | AMD EPYC 9V45 96-Core Processor | 4 | 16.0 | 220.0/219.9 | 20260922.246.2 | no | - |
| `windows-2025` | ga | Windows 2025Server (10.0.26100) | X64 | AMD EPYC 7763 64-Core Processor | 4 | 16.0 | 150.0/147.0 | 20260922.246.2 | no | - |
| `windows-2025-vs2026` | ga | Windows 2025Server (10.0.26100) | X64 | AMD EPYC 7763 64-Core Processor | 4 | 16.0 | 150.0/147.0 | 20260922.246.2 | no | - |
| `windows-2022` | ga | Windows 2022Server (10.0.20348) | X64 | AMD EPYC 9V74 80-Core Processor | 4 | 16.0 | 220.0/219.9 | 20260920.314.1 | no | - |
| `windows-11-arm` | ga | Windows 11 (10.0.26200) | ARM64 | Cobalt 100 | 4 | 16.0 | 255.4/125.7 | 20260920.164.1 | no | - |
| `windows-11-vs2026-arm` | ga | Windows 11 (10.0.26200) | ARM64 | Cobalt 100 | 4 | 16.0 | 255.4/125.7 | 20260920.164.1 | no | - |

## Preinstalled tools

<details><summary><code>ubuntu-26.04</code></summary>

| Tool | Version |
|---|---|
| clang | Ubuntu clang version 21.1.8 (6ubuntu1) |
| docker | Docker version 29.4.2, build 055a478 |
| dotnet | 10.0.401 |
| gcc | gcc (Ubuntu 15.2.0-16ubuntu1) 15.2.0 |
| git | git version 2.55.0 |
| go | go version go1.26.8 linux/amd64 |
| java | openjdk version "25.0.4.1" 2026-08-18 LTS |
| node | v24.21.0 |
| pwsh | PowerShell 7.6.6 |
| python | Python 3.14.4 |
| rustc | rustc 1.98.1 (48a229cea 2026-09-01) |

</details>

<details><summary><code>ubuntu-26.04-arm</code></summary>

| Tool | Version |
|---|---|
| clang | Ubuntu clang version 21.1.8 (6ubuntu1) |
| docker | Docker version 29.4.2, build 055a478 |
| dotnet | 10.0.401 |
| gcc | gcc (Ubuntu 15.2.0-16ubuntu1) 15.2.0 |
| git | git version 2.55.0 |
| go | go version go1.26.8 linux/arm64 |
| java | openjdk version "25.0.4.1" 2026-08-18 LTS |
| node | v24.21.0 |
| pwsh | PowerShell 7.6.6 |
| python | Python 3.14.4 |
| rustc | rustc 1.98.1 (48a229cea 2026-09-01) |

</details>

<details><summary><code>ubuntu-latest</code></summary>

| Tool | Version |
|---|---|
| clang | Ubuntu clang version 18.1.3 (1ubuntu1) |
| docker | Docker version 28.0.4, build b8034c0 |
| dotnet | 10.0.401 |
| gcc | gcc (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0 |
| git | git version 2.55.0 |
| go | go version go1.24.13 linux/amd64 |
| java | openjdk version "17.0.20.1" 2026-08-18 |
| node | v22.23.2 |
| pwsh | PowerShell 7.6.6 |
| python | Python 3.12.3 |
| rustc | rustc 1.98.1 (48a229cea 2026-09-01) |

</details>

<details><summary><code>ubuntu-24.04</code></summary>

| Tool | Version |
|---|---|
| clang | Ubuntu clang version 18.1.3 (1ubuntu1) |
| docker | Docker version 28.0.4, build b8034c0 |
| dotnet | 10.0.401 |
| gcc | gcc (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0 |
| git | git version 2.55.0 |
| go | go version go1.24.13 linux/amd64 |
| java | openjdk version "17.0.20.1" 2026-08-18 |
| node | v22.23.2 |
| pwsh | PowerShell 7.6.6 |
| python | Python 3.12.3 |
| rustc | rustc 1.98.1 (48a229cea 2026-09-01) |

</details>

<details><summary><code>ubuntu-24.04-arm</code></summary>

| Tool | Version |
|---|---|
| clang | Ubuntu clang version 18.1.3 (1ubuntu1) |
| docker | Docker version 28.0.4, build b8034c0 |
| dotnet | 10.0.401 |
| gcc | gcc (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0 |
| git | git version 2.55.0 |
| go | go version go1.24.13 linux/arm64 |
| java | openjdk version "17.0.20.1" 2026-08-18 |
| node | v22.23.2 |
| pwsh | PowerShell 7.6.6 |
| python | Python 3.12.3 |
| rustc | rustc 1.98.1 (48a229cea 2026-09-01) |

</details>

<details><summary><code>ubuntu-22.04</code></summary>

| Tool | Version |
|---|---|
| clang | Ubuntu clang version 14.0.0-1ubuntu1.1 |
| docker | Docker version 28.0.4, build b8034c0 |
| dotnet | 10.0.401 |
| gcc | gcc (Ubuntu 11.4.0-1ubuntu1~22.04.3) 11.4.0 |
| git | git version 2.55.0 |
| go | go version go1.24.13 linux/amd64 |
| java | openjdk version "11.0.32.1" 2026-08-18 |
| node | v22.23.2 |
| pwsh | PowerShell 7.6.6 |
| python | Python 3.10.12 |
| rustc | rustc 1.98.1 (48a229cea 2026-09-01) |

</details>

<details><summary><code>ubuntu-22.04-arm</code></summary>

| Tool | Version |
|---|---|
| clang | Ubuntu clang version 14.0.0-1ubuntu1.1 |
| docker | Docker version 28.0.4, build b8034c0 |
| dotnet | 10.0.401 |
| gcc | gcc (Ubuntu 11.4.0-1ubuntu1~22.04.3) 11.4.0 |
| git | git version 2.55.0 |
| go | go version go1.24.13 linux/arm64 |
| java | openjdk version "11.0.32.1" 2026-08-18 |
| node | v22.23.2 |
| pwsh | PowerShell 7.6.6 |
| python | Python 3.10.12 |
| rustc | rustc 1.98.1 (48a229cea 2026-09-01) |

</details>

<details><summary><code>ubuntu-slim</code></summary>

| Tool | Version |
|---|---|
| docker | Docker version 29.8.1, build 4a63305 |
| gcc | gcc (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0 |
| git | git version 2.55.0 |
| node | v24.21.0 |
| pwsh | PowerShell 7.6.6 |
| python | Python 3.12.3 |

</details>

<details><summary><code>xcode-27</code></summary>

| Tool | Version |
|---|---|
| brew | Homebrew 7.0.4 |
| clang | Apple clang version 21.0.0 (clang-2100.3.34.2) |
| dotnet | 10.0.401 |
| gcc | Apple clang version 21.0.0 (clang-2100.3.34.2) |
| git | git version 2.55.0 |
| java | openjdk version "21.0.12.1" 2026-08-18 LTS |
| node | v24.21.0 |
| pwsh | PowerShell 7.6.6 |
| python | Python 3.14.7 |
| rustc | rustc 1.98.1 (48a229cea 2026-09-01) |
| xcodebuild | Xcode 27.0 |

</details>

<details><summary><code>macos-26-intel</code></summary>

| Tool | Version |
|---|---|
| brew | Homebrew 6.0.18 |
| clang | Apple clang version 21.0.0 (clang-2100.1.1.101) |
| dotnet | 10.0.400 |
| gcc | Apple clang version 21.0.0 (clang-2100.1.1.101) |
| git | git version 2.55.0 |
| java | openjdk version "21.0.12.1" 2026-08-18 LTS |
| node | v24.19.0 |
| pwsh | PowerShell 7.6.4 |
| python | Python 3.14.7 |
| rustc | rustc 1.98.0 (88d9e12ae 2026-08-18) |
| xcodebuild | Xcode 26.6 |

</details>

<details><summary><code>macos-latest</code></summary>

| Tool | Version |
|---|---|
| brew | Homebrew 6.0.22 |
| clang | Apple clang version 21.0.0 (clang-2100.1.1.101) |
| dotnet | 10.0.400 |
| gcc | Apple clang version 21.0.0 (clang-2100.1.1.101) |
| git | git version 2.55.0 |
| java | openjdk version "21.0.12.1" 2026-08-18 LTS |
| node | v24.20.0 |
| pwsh | PowerShell 7.6.5 |
| python | Python 3.14.7 |
| rustc | rustc 1.98.1 (48a229cea 2026-09-01) |
| xcodebuild | Xcode 26.6 |

</details>

<details><summary><code>macos-26</code></summary>

| Tool | Version |
|---|---|
| brew | Homebrew 6.0.22 |
| clang | Apple clang version 21.0.0 (clang-2100.1.1.101) |
| dotnet | 10.0.400 |
| gcc | Apple clang version 21.0.0 (clang-2100.1.1.101) |
| git | git version 2.55.0 |
| java | openjdk version "21.0.12.1" 2026-08-18 LTS |
| node | v24.20.0 |
| pwsh | PowerShell 7.6.5 |
| python | Python 3.14.7 |
| rustc | rustc 1.98.1 (48a229cea 2026-09-01) |
| xcodebuild | Xcode 26.6 |

</details>

<details><summary><code>macos-15-intel</code></summary>

| Tool | Version |
|---|---|
| brew | Homebrew 6.0.18 |
| clang | Apple clang version 17.0.0 (clang-1700.0.13.5) |
| dotnet | 10.0.400 |
| gcc | Apple clang version 17.0.0 (clang-1700.0.13.5) |
| git | git version 2.55.0 |
| java | openjdk version "21.0.12.1" 2026-08-18 LTS |
| node | v22.23.2 |
| pwsh | PowerShell 7.6.4 |
| python | Python 3.14.7 |
| rustc | rustc 1.98.0 (88d9e12ae 2026-08-18) |
| xcodebuild | Xcode 16.4 |

</details>

<details><summary><code>macos-15</code></summary>

| Tool | Version |
|---|---|
| brew | Homebrew 6.0.22 |
| clang | Apple clang version 17.0.0 (clang-1700.0.13.5) |
| dotnet | 10.0.400 |
| gcc | Apple clang version 17.0.0 (clang-1700.0.13.5) |
| git | git version 2.55.0 |
| java | openjdk version "21.0.12.1" 2026-08-18 LTS |
| node | v22.23.2 |
| pwsh | PowerShell 7.6.5 |
| python | Python 3.14.7 |
| rustc | rustc 1.98.1 (48a229cea 2026-09-01) |
| xcodebuild | Xcode 16.4 |

</details>

<details><summary><code>windows-latest</code></summary>

| Tool | Version |
|---|---|
| clang | clang version 20.1.8 |
| docker | Docker version 29.7.2, build a7dcaa6 |
| dotnet | 10.0.401 |
| gcc | gcc.EXE (x86_64-posix-seh-rev1, Built by MinGW-Builds project) 15.2.0 |
| git | git version 2.55.0.windows.5 |
| go | go version go1.24.13 windows/amd64 |
| java | openjdk version "17.0.20.1" 2026-08-18 |
| node | v22.23.2 |
| pwsh | PowerShell 7.6.6 |
| python | Python 3.12.10 |
| rustc | rustc 1.98.1 (48a229cea 2026-09-01) |

</details>

<details><summary><code>windows-2025</code></summary>

| Tool | Version |
|---|---|
| clang | clang version 20.1.8 |
| docker | Docker version 29.7.2, build a7dcaa6 |
| dotnet | 10.0.401 |
| gcc | gcc.EXE (x86_64-posix-seh-rev1, Built by MinGW-Builds project) 15.2.0 |
| git | git version 2.55.0.windows.5 |
| go | go version go1.24.13 windows/amd64 |
| java | openjdk version "17.0.20.1" 2026-08-18 |
| node | v22.23.2 |
| pwsh | PowerShell 7.6.6 |
| python | Python 3.12.10 |
| rustc | rustc 1.98.1 (48a229cea 2026-09-01) |

</details>

<details><summary><code>windows-2025-vs2026</code></summary>

| Tool | Version |
|---|---|
| clang | clang version 20.1.8 |
| docker | Docker version 29.7.2, build a7dcaa6 |
| dotnet | 10.0.401 |
| gcc | gcc.EXE (x86_64-posix-seh-rev1, Built by MinGW-Builds project) 15.2.0 |
| git | git version 2.55.0.windows.5 |
| go | go version go1.24.13 windows/amd64 |
| java | openjdk version "17.0.20.1" 2026-08-18 |
| node | v22.23.2 |
| pwsh | PowerShell 7.6.6 |
| python | Python 3.12.10 |
| rustc | rustc 1.98.1 (48a229cea 2026-09-01) |

</details>

<details><summary><code>windows-2022</code></summary>

| Tool | Version |
|---|---|
| clang | clang version 20.1.8 |
| docker | Docker version 29.7.2, build a7dcaa6 |
| dotnet | 10.0.401 |
| gcc | gcc.EXE (x86_64-posix-seh-rev2, Built by MinGW-Builds project) 14.2.0 |
| git | git version 2.55.0.windows.5 |
| go | go version go1.24.13 windows/amd64 |
| java | openjdk version "1.8.0_504" |
| node | v22.23.2 |
| pwsh | PowerShell 7.6.6 |
| python | Python 3.12.10 |
| rustc | rustc 1.98.1 (48a229cea 2026-09-01) |

</details>

<details><summary><code>windows-11-arm</code></summary>

| Tool | Version |
|---|---|
| clang | clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1) |
| dotnet | 10.0.401 |
| gcc | gcc.EXE (x86_64-posix-seh-rev2, Built by MinGW-Builds project) 14.2.0 |
| git | git version 2.55.0.windows.5 |
| go | go version go1.24.13 windows/arm64 |
| java | openjdk version "21.0.12.1" 2026-08-18 LTS |
| node | v24.21.0 |
| pwsh | PowerShell 7.6.6 |
| python | Python 3.13.15 |
| rustc | rustc 1.98.1 (48a229cea 2026-09-01) |

</details>

<details><summary><code>windows-11-vs2026-arm</code></summary>

| Tool | Version |
|---|---|
| clang | clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1) |
| dotnet | 10.0.401 |
| gcc | gcc.EXE (x86_64-posix-seh-rev2, Built by MinGW-Builds project) 14.2.0 |
| git | git version 2.55.0.windows.5 |
| go | go version go1.24.13 windows/arm64 |
| java | openjdk version "21.0.12.1" 2026-08-18 LTS |
| node | v24.21.0 |
| pwsh | PowerShell 7.6.6 |
| python | Python 3.13.15 |
| rustc | rustc 1.98.1 (48a229cea 2026-09-01) |

</details>

## `runs-on` options you can use

```yaml
options:
  - ubuntu-26.04
  - ubuntu-26.04-arm
  - ubuntu-latest
  - ubuntu-24.04
  - ubuntu-24.04-arm
  - ubuntu-22.04
  - ubuntu-22.04-arm
  - ubuntu-slim
  - xcode-27
  - macos-26-intel
  - macos-latest
  - macos-26
  - macos-15-intel
  - macos-15
  - windows-latest
  - windows-2025
  - windows-2025-vs2026
  - windows-2022
  - windows-11-arm
  - windows-11-vs2026-arm
```
