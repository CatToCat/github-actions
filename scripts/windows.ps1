param(
    [string]$Duration = "30"
)

Write-Host "================================"
Write-Host "Windows OpenVSCode Server"
Write-Host "================================"

$PORT = 3000

# ----------------------------
# Install dependencies
# ----------------------------
if (!(Get-Command cloudflared -ErrorAction SilentlyContinue)) {
    choco install cloudflared -y
}

if (!(Get-Command wget -ErrorAction SilentlyContinue)) {
    choco install wget -y
}

# ----------------------------
# Download OpenVSCode Server
# ----------------------------
Write-Host "Downloading OpenVSCode Server..."

Invoke-WebRequest `
  -Uri "https://github.com/gitpod-io/openvscode-server/releases/latest/download/openvscode-server-win32-x64.zip" `
  -OutFile "vscode.zip"

Expand-Archive -Path "vscode.zip" -DestinationPath "." -Force

$VSDir = Get-ChildItem -Directory | Where-Object { $_.Name -like "openvscode*" } | Select-Object -First 1

# ----------------------------
# Start VS Code Web Server
# ----------------------------
Write-Host "Starting OpenVSCode Server..."

Start-Process `
  -FilePath "$VSDir\bin\openvscode-server.exe" `
  -ArgumentList "--port $PORT --host 0.0.0.0" `
  -NoNewWindow

Start-Sleep 5

# ----------------------------
# Start Cloudflare Tunnel (IMPORTANT FIXED)
# ----------------------------
Write-Host "Starting Cloudflare Tunnel..."

$cfLog = "$PWD\cf.log"

Start-Process `
  -FilePath "cloudflared" `
  -ArgumentList "tunnel --url http://localhost:$PORT" `
  -RedirectStandardOutput $cfLog `
  -RedirectStandardError $cfLog `
  -NoNewWindow

Start-Sleep 8

# ----------------------------
# Extract URL
# ----------------------------
$url = (Get-Content $cfLog | Select-String -Pattern "https://.*trycloudflare.com" | Select-Object -First 1)

Write-Host ""
Write-Host "================================"
Write-Host "Web IDE Ready"
Write-Host "================================"

if ($url) {
    Write-Host "URL: $($url.Matches.Value)"
} else {
    Write-Host "URL not ready yet, check cf.log"
}

# ----------------------------
# Keep alive
# ----------------------------
$seconds = [int]$Duration * 60
$start = Get-Date

Write-Host "Keep alive: $Duration minutes"

while ($true) {
    $elapsed = (Get-Date) - $start
    if ($elapsed.TotalSeconds -gt $seconds) {
        break
    }

    Write-Host "Running... $([int]$elapsed.TotalMinutes)/$Duration min"
    Start-Sleep 60
}