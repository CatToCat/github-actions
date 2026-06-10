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
# IMPORTANT FIX: run cloudflared directly
# -----------------------------
Write-Host "Starting Cloudflare tunnel..."

$logFile = "$PWD\cf.log"

# ❗关键：直接运行，不要 Start-Process
cmd /c "cloudflared tunnel --url http://localhost:7681 > cf.log 2>&1"

# -----------------------------
# Extract URL
# -----------------------------
Write-Host ""
Write-Host "Checking tunnel URL..."

if (Test-Path $logFile) {

    Get-Content $logFile | ForEach-Object { Write-Host $_ }

    $url = Select-String -Path $logFile `
        -Pattern "https://[a-zA-Z0-9.-]*trycloudflare.com" |
        Select-Object -First 1

    Write-Host ""
    Write-Host "================================"
    Write-Host "Windows Web Server Ready"
    Write-Host "================================"

    if ($url) {
        Write-Host "Public URL:"
        Write-Host $url.Matches.Value
    } else {
        Write-Host "No URL detected yet"
    }

} else {
    Write-Host "cf.log not created - cloudflared failed"
}