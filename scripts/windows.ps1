Write-Host "================================"
Write-Host "Windows Web Terminal (Wetty)"
Write-Host "================================"

# =============================
# Install Node.js
# =============================
if (!(Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Node.js..."
    choco install nodejs -y
}

# refresh PATH (IMPORTANT for Actions)
$env:Path += ";C:\Program Files\nodejs\"

# =============================
# Install cloudflared
# =============================
if (!(Get-Command cloudflared -ErrorAction SilentlyContinue)) {
    Write-Host "Installing cloudflared..."
    choco install cloudflared -y
}

# =============================
# Install Wetty (LIVE LOGS)
# =============================
Write-Host "Installing Wetty..."

$env:NPM_CONFIG_PROGRESS = "true"
$env:NPM_CONFIG_LOGLEVEL = "verbose"

npm install -g wetty --verbose 2>&1 | ForEach-Object {
    Write-Host $_
}

# =============================
# Verify Wetty
# =============================
$wettyCmd = Get-Command wetty -ErrorAction SilentlyContinue

if (!$wettyCmd) {
    Write-Host "ERROR: Wetty not found in PATH"
    npm list -g --depth=0
    exit 1
}

# =============================
# Start Wetty
# =============================
Write-Host "Starting Wetty on port 3000..."

Start-Process -NoNewWindow -FilePath "cmd.exe" -ArgumentList "/c wetty --port 3000 --command powershell.exe"

Start-Sleep 8

# =============================
# Check port 3000
# =============================
$portCheck = netstat -ano | findstr ":3000"

if ($portCheck) {
    Write-Host "================================"
    Write-Host "Wetty is running on port 3000"
    Write-Host "================================"
} else {
    Write-Host "ERROR: Wetty failed to start"
    netstat -ano
    exit 1
}

# =============================
# Start Cloudflare Tunnel
# =============================
Write-Host "================================"
Write-Host "Starting Cloudflare tunnel..."
Write-Host "================================"

& cloudflared tunnel --url http://localhost:3000