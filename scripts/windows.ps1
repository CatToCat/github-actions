param(
    [string]$Duration = "30"
)

Write-Host "================================"
Write-Host "Windows OpenVSCode Server (FIXED)"
Write-Host "================================"

$PORT = 3000

# ----------------------------
# Install dependencies
# ----------------------------
if (!(Get-Command cloudflared -ErrorAction SilentlyContinue)) {
    choco install cloudflared -y
}

# ----------------------------
# FIX: stable version download (IMPORTANT)
# ----------------------------
$version = "1.94.0"

$url = "https://github.com/gitpod-io/openvscode-server/releases/download/openvscode-server-v$version/openvscode-server-v$version-win32-x64.tar.gz"

Write-Host "Downloading OpenVSCode Server: $version"

Invoke-WebRequest -Uri $url -OutFile "vscode.tar.gz"

if (!(Test-Path "vscode.tar.gz")) {
    throw "Download failed - vscode.tar.gz not found"
}

# ----------------------------
# Extract
# ----------------------------
tar -xzf vscode.tar.gz

$dir = Get-ChildItem -Directory | Where-Object { $_.Name -like "openvscode*" } | Select-Object -First 1

if (!$dir) {
    throw "OpenVSCode Server folder not found"
}

# ----------------------------
# Start server
# ----------------------------
Write-Host "Starting OpenVSCode Server..."

Start-Process `
    -FilePath "$dir\bin\openvscode-server.exe" `
    -ArgumentList "--port $PORT --host 0.0.0.0" `
    -NoNewWindow

Start-Sleep 5

# ----------------------------
# Cloudflared FIX (no redirect conflict)
# ----------------------------
Write-Host "Starting Cloudflare tunnel..."

$cfLog = "$PWD\cf.log"

Start-Process `
    -FilePath "cloudflared" `
    -ArgumentList "tunnel --url http://localhost:$PORT" `
    -RedirectStandardOutput $cfLog `
    -RedirectStandardError $cfLog `
    -NoNewWindow

Start-Sleep 10

# ----------------------------
# Extract URL
# ----------------------------
$url = Select-String -Path $cfLog -Pattern "https://.*trycloudflare.com" | Select-Object -First 1

Write-Host ""
Write-Host "================================"
Write-Host "WEB IDE READY"
Write-Host "================================"

if ($url) {
    Write-Host "URL: $($url.Matches.Value)"
} else {
    Write-Host "URL not ready, check cf.log"
}

# ----------------------------
# Keep alive
# ----------------------------
$seconds = [int]$Duration * 60
$start = Get-Date

Write-Host "Keep alive: $Duration minutes"

while ($true) {
    if (((Get-Date) - $start).TotalSeconds -gt $seconds) {
        break
    }

    Write-Host "Running... $([int](((Get-Date) - $start).TotalMinutes)) / $Duration"
    Start-Sleep 60
}