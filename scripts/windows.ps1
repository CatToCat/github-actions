Write-Host "================================"
Write-Host "Windows Web Server Mode"
Write-Host "================================"

# Install Python
if (!(Get-Command python -ErrorAction SilentlyContinue)) {
    choco install python -y
}

# Install cloudflared
if (!(Get-Command cloudflared -ErrorAction SilentlyContinue)) {
    choco install cloudflared -y
}

# Create page
@"
<html>
<head><title>Windows Runner</title></head>
<body>
<h1>Windows Runner Active</h1>
<p>Time: $(Get-Date)</p>
</body>
</html>
"@ | Out-File index.html -Encoding utf8

# Start HTTP server
Start-Process python -ArgumentList "-m http.server 7681"

Start-Sleep 3

# FIXED cloudflared (IMPORTANT)
Write-Host "Starting Cloudflare tunnel..."

$logFile = "$PWD\cf.log"

& cloudflared tunnel --url http://localhost:7681 2>&1 | Tee-Object -FilePath $logFile