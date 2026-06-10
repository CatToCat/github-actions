Write-Host "================================"
Write-Host "Windows Web Server Mode"
Write-Host "================================"

# -----------------------------
# Install Python
# -----------------------------
if (!(Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Python..."
    choco install python -y
}

# -----------------------------
# Install cloudflared
# -----------------------------
if (!(Get-Command cloudflared -ErrorAction SilentlyContinue)) {
    Write-Host "Installing cloudflared..."
    choco install cloudflared -y
}

# -----------------------------
# Create web page
# -----------------------------
$indexPath = "$PWD\index.html"

@"
<html>
<head>
  <title>Windows Runner</title>
</head>
<body>
  <h1>Windows Runner Active</h1>
  <p>Time: $(Get-Date)</p>
</body>
</html>
"@ | Out-File -Encoding utf8 $indexPath

# -----------------------------
# Start HTTP server
# -----------------------------
Write-Host "Starting HTTP server..."

Start-Process python -ArgumentList "-m http.server 7681"

Start-Sleep 3

# -----------------------------
# Start Cloudflared (FIXED)
# -----------------------------
Write-Host "Starting Cloudflare tunnel..."

$logFile = "$PWD\cf.log"

# ✔ 正确方式：直接运行 + Tee-Object
Start-Process powershell -ArgumentList @"
cloudflared tunnel --url http://localhost:7681 | Tee-Object -FilePath $logFile
"@

Start-Sleep 10

# -----------------------------
# Extract URL
# -----------------------------
Write-Host ""
Write-Host "Checking tunnel URL..."

if (Test-Path $logFile) {

    $url = Select-String -Path $logFile `
        -Pattern "https://[a-zA-Z0-9.-]*trycloudflare.com" |
        Select-Object -First 1

    Write-Host "================================"
    Write-Host "Windows Web Server Ready"
    Write-Host "================================"

    if ($url) {
        Write-Host "Public URL:"
        Write-Host $url.Matches.Value
    } else {
        Write-Host "Tunnel not ready yet:"
        Get-Content $logFile
    }

} else {
    Write-Host "Cloudflared log not created"
}