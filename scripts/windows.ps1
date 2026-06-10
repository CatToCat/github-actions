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
# FIXED Cloudflared (IMPORTANT)
# -----------------------------
Write-Host "Starting Cloudflare tunnel..."

# ✔ 关键点：直接运行 + pipeline capture
$logFile = "$PWD\cf.log"

Start-Process -NoNewWindow `
    -FilePath "cloudflared" `
    -ArgumentList "tunnel --url http://localhost:7681" `
    -RedirectStandardOutput $logFile `
    -RedirectStandardError $logFile

Start-Sleep 8

# -----------------------------
# Extract URL (robust)
# -----------------------------
Write-Host ""
Write-Host "Checking tunnel status..."

if (Test-Path $logFile) {

    Get-Content $logFile | ForEach-Object { Write-Host $_ }

    $url = Select-String -Path $logFile `
        -Pattern "https://[a-zA-Z0-9.-]*trycloudflare.com" `
        -AllMatches | Select-Object -First 1

    Write-Host ""
    Write-Host "================================"
    Write-Host "Windows Web Server Ready"
    Write-Host "================================"

    if ($url) {
        Write-Host "Public URL:"
        Write-Host $url.Matches.Value
    } else {
        Write-Host "URL not ready yet (cloudflared still initializing)"
    }

} else {
    Write-Host "ERROR: cloudflared did not start"
}