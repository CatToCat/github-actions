Write-Host "================================"
Write-Host "Windows Web Server Mode"
Write-Host "================================"

# -----------------------------
# Install Python (if missing)
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
# Create a simple web page
# -----------------------------
$indexPath = "$PWD\index.html"

@"
<html>
<head>
  <title>GitHub Actions Windows Runner</title>
</head>
<body>
  <h1>Windows Runner Active</h1>
  <p>Status: Running via GitHub Actions</p>
  <p>Time: $(Get-Date)</p>
</body>
</html>
"@ | Out-File -Encoding utf8 $indexPath

# -----------------------------
# Start HTTP server
# -----------------------------
Write-Host "Starting Python HTTP server on port 7681..."

Start-Process python -ArgumentList "-m http.server 7681"

Start-Sleep 3

# -----------------------------
# Start Cloudflared tunnel
# -----------------------------
Write-Host "Starting Cloudflare tunnel..."

Start-Process cloudflared -ArgumentList "tunnel --url http://localhost:7681"

Start-Sleep 10

Write-Host ""
Write-Host "================================"
Write-Host "Windows Web Server Ready"
Write-Host "Open Cloudflare URL above"
Write-Host "================================"