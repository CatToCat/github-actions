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
Write-Host "Installing Wetty (with logs)..."

$env:NPM_CONFIG_LOGLEVEL = "verbose"

npm install -g wetty --verbose 2>&1 | ForEach-Object {
    Write-Host $_
}

# -----------------------------
# Verify Wetty
# -----------------------------
$wettyCmd = Get-Command wetty -ErrorAction SilentlyContinue

if (!$wettyCmd) {
    Write-Host "ERROR: Wetty not installed"
    exit 1
}

# -----------------------------
# Start Wetty (IMPORTANT FIX)
# Use cmd.exe instead of PowerShell (fix disconnect issue)
# -----------------------------
Write-Host "Starting Wetty on port 3000..."

Start-Process -NoNewWindow -FilePath "cmd.exe" `
    -ArgumentList "/c wetty --port 3000 --command cmd.exe"

Start-Sleep 8

# -----------------------------
# Check Wetty
# -----------------------------
$portCheck = netstat -ano | findstr ":3000"

if (!$portCheck) {
    Write-Host "ERROR: Wetty NOT running"
    netstat -ano
    exit 1
}

Write-Host "Wetty running on port 3000"

# -----------------------------
# Start Cloudflared (non-blocking)
# -----------------------------
Write-Host "Starting Cloudflare tunnel..."

$cfLog = "$PWD\cf.log"

Start-Process -NoNewWindow -FilePath "cloudflared" `
    -ArgumentList "tunnel --url http://localhost:3000" `
    -RedirectStandardOutput $cfLog `
    -RedirectStandardError $cfLog

Start-Sleep 8

# -----------------------------
# Extract Cloudflare URL
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
    Write-Host "URL not ready yet. Check cf.log"
}

# -----------------------------
# Keep Alive (DO NOT BLOCK other steps)
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