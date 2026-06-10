Write-Host "================================"
Write-Host "Windows Web Terminal (Wetty)"
Write-Host "================================"

# -----------------------------
# Install Node.js
# -----------------------------
if (!(Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Node.js..."
    choco install nodejs -y
}

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
if (!(Get-Command wetty -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Wetty..."
    npm install -g wetty
}

# -----------------------------
# Start Wetty (PowerShell terminal)
# -----------------------------
Write-Host "Starting Wetty on port 3000..."

Start-Process wetty -ArgumentList "--port 3000 --command powershell.exe"

Start-Sleep 5

# -----------------------------
# Start Cloudflare Tunnel
# -----------------------------
Write-Host "Starting Cloudflare tunnel..."

& cloudflared tunnel --url http://localhost:3000