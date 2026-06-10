Write-Host "================================"
Write-Host "Windows Web Terminal (Stable)"
Write-Host "================================"

# -----------------------------
# Install Node.js
# -----------------------------
if (!(Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Node.js..."
    choco install nodejs -y
}

$env:Path += ";C:\Program Files\nodejs\"

# -----------------------------
# Install cloudflared
# -----------------------------
if (!(Get-Command cloudflared -ErrorAction SilentlyContinue)) {
    Write-Host "Installing cloudflared..."
    choco install cloudflared -y
}

# -----------------------------
# Install Wetty
# -----------------------------
Write-Host "Installing Wetty..."

npm install -g wetty --verbose 2>&1 | ForEach-Object {
    Write-Host $_
}

# -----------------------------
# Start Wetty (IMPORTANT FIX)
# -----------------------------
Write-Host "Starting Wetty on port 3000..."

Start-Process -NoNewWindow -FilePath "cmd.exe" `
    -ArgumentList "/c wetty --port 3000 --command cmd.exe"

Start-Sleep 8

# -----------------------------
# Check Wetty
# -----------------------------
netstat -ano | findstr ":3000"

Write-Host "Wetty running on port 3000"

# -----------------------------
# Start Cloudflared (FIXED VERSION)
# -----------------------------
Write-Host "Starting Cloudflare tunnel..."

$cfLog = "$PWD\cf.log"

# IMPORTANT: DO NOT use Start-Process redirect (Windows bug-prone)
cmd /c "cloudflared tunnel --url http://localhost:3000" 2>&1 |
    Tee-Object -FilePath $cfLog | ForEach-Object {
        Write-Host $_
    }

# -----------------------------
# Extract URL
# -----------------------------
Write-Host ""
Write-Host "================================"
Write-Host "Cloudflare Public URL"
Write-Host "================================"

$url = Select-String -Path $cfLog -Pattern "https://[a-zA-Z0-9.-]*trycloudflare.com" |
       Select-Object -First 1

if ($url) {
    Write-Host $url.Line
} else {
    Write-Host "URL not detected yet"
}

# -----------------------------
# Keep Alive
# -----------------------------
Write-Host ""
Write-Host "Keep alive started..."

$minutes = 30
$end = (Get-Date).AddMinutes($minutes)

while ((Get-Date) -lt $end) {
    Write-Host ("Running... {0}" -f (Get-Date))
    Start-Sleep 300
}

Write-Host "Done"